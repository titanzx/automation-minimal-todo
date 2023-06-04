*** Settings ***
Resource    ../common/common.robot
*** Variables ***
${create.btnCreate}          id=com.avjindersinghsekhon.minimaltodo:id/makeToDoFloatingActionButton
${create.txtTitle}           id=com.avjindersinghsekhon.minimaltodo:id/userToDoEditText
${create.tglReminder}        id=com.avjindersinghsekhon.minimaltodo:id/toDoHasDateSwitchCompat
${create.frame}              class=android.widget.ListView
${create.frameTimePicker}    id=com.avjindersinghsekhon.minimaltodo:id/time_picker
${create.lblDate}            id=com.avjindersinghsekhon.minimaltodo:id/newTodoDateEditText
${create.lblTime}            id=com.avjindersinghsekhon.minimaltodo:id/newTodoTimeEditText
${create.lblDay}             id=com.avjindersinghsekhon.minimaltodo:id/date_picker_day
${create.lblYear}            id=com.avjindersinghsekhon.minimaltodo:id/date_picker_year
${create.lblCustom}          accessibility_id=CUSTOM_TEXT
${create.lblHour}            id=com.avjindersinghsekhon.minimaltodo:id/hours
${create.lblMinute}          id=com.avjindersinghsekhon.minimaltodo:id/minutes
${create.lblAMPM}            id=com.avjindersinghsekhon.minimaltodo:id/ampm_label
${create.btnOk}              id=com.avjindersinghsekhon.minimaltodo:id/ok
${create.lblError}           id=com.avjindersinghsekhon.minimaltodo:id/newToDoDateTimeReminderTextView

*** Keywords ***
Todo List Page Should Be Visible
    Wait Until Element Is Ready    ${create.txtTitle}

Tap Reminder Toggle
    Tap Element When Ready         ${create.tglReminder}

Tap Create Button
    Tap Element When Ready         ${create.btnCreate}

Input Title
    [Arguments]    ${title}
    Input Element When Ready       ${create.txtTitle}    ${title}

Set Reminder Date Time
    [Arguments]    ${dateTime}    ${swipeYear}="up"    ${swipeDay}="up"
    Tap Date Label
    Tap Year Label
    Find And Tap Year    ${dateTime}    ${swipeYear}
    Find And Tap Day     ${dateTime}    ${swipeDay}
    Tap Ok Button
    Tap Time Label
    Find And Tap Time      ${dateTime}    type='hour'
    Find And Tap Time      ${dateTime}
    Tap AM/PM              ${dateTime}
    Tap Ok Button

Tap Date Label
    Tap Element When Ready         ${create.lblDate}

Tap Year Label
    Tap Element When Ready         ${create.lblYear}

Find And Tap Year
    [Arguments]    ${dateTime}    ${swipe}="up"
    ${currentDateTime}           Get Current Date Time
    ${currentDateTime}           Convert Date         ${currentDateTime}    result_format=datetime
    ${currentYear}               Convert To String    ${currentDateTime.year}
    ${dateTime}                  Convert Date         ${dateTime}    result_format=datetime
    ${year}                      Convert To String    ${dateTime.year}
    IF    '${currentYear}' == '${year}'
        ${yearLocator}               Replace String       ${create.lblCustom}    CUSTOM_TEXT    ${year}${SPACE}selected
    ELSE
        ${yearLocator}               Replace String       ${create.lblCustom}    CUSTOM_TEXT    ${year}
    END
    IF    ${swipe} == "down"
        Find Top Element In Frame    ${create.frame}      ${yearLocator}
    ELSE
        Find Element In Frame    ${create.frame}      ${yearLocator}
    END
    Tap Element When Ready       ${yearLocator}

Tap Day Label
    Tap Element When Ready         ${create.lblDay}

Find And Tap Day
    [Arguments]    ${dateTime}    ${swipe}="up"
    ${currentDateTime}           Get Current Date Time
    ${currentDateTime}           Convert Date         ${currentDateTime}    result_format=%d %B %Y
    ${currentDate}               Convert To String    ${currentDateTime}
    ${dateTime}                  Convert Date         ${dateTime}  result_format=%d %B %Y
    ${date}                      Convert To String    ${dateTime}
    IF    '${date}' == '${currentDate}'
        ${dateLocator}               Replace String       ${create.lblCustom}    CUSTOM_TEXT    ${date}${SPACE}selected
    ELSE
        ${dateLocator}               Replace String       ${create.lblCustom}    CUSTOM_TEXT    ${date}
    END

    IF    ${swipe} == "down"
        Find Top Element In Frame    ${create.frame}      ${dateLocator}
    ELSE
        Find Element In Frame    ${create.frame}      ${dateLocator}
    END
    Tap Element When Ready       ${dateLocator}

Tap Time Label
    Tap Element When Ready         ${create.lblTime}

Tap Hour Label
    Tap Element When Ready         ${create.lblHour}

Tap Minute Label
    Tap Element When Ready         ${create.lblMinute}

Find And Tap Time
    [Arguments]    ${dateTime}     ${type}='minute'
    ${dateTime}         Convert Date            ${dateTime}  result_format=datetime
    IF    ${type} == 'minute'
        ${timeString}       Convert To String       ${dateTime.minute}
        ${time}             Set Variable            ${dateTime.minute}
    ELSE
        ${dateTime}         Convert Date            ${dateTime}  result_format=%I
        ${dateTime}         Convert To Integer      ${dateTime}
        ${timeString}       Convert To String       ${dateTime}
        ${time}             Set Variable            ${dateTime}
    END
    Wait Until Element Is Ready                 ${create.frameTimePicker}
    ${frameLocation}    Get Element Location    ${create.frameTimePicker}
    ${frameSize}        Get Element Size        ${create.frameTimePicker}
    ${width}            Set Variable            ${frameSize}[width]
    ${width}            Evaluate                ${frameSize}[width]/2
    ${height}           Set Variable            ${frameSize}[height]
    ${height}           Evaluate                ${frameSize}[height]/2
    ${x}                Set Variable            ${frameLocation}[x]
    ${y}                Set Variable            ${frameLocation}[y]
    ${x}                Evaluate                round(${x}+${width})
    ${y}                Evaluate                round(${y}+${height})
    ${y}                Evaluate                ${y}-(${y} * 25 / 100)
    IF    (${time} == 0 and ${type} == 'minute') or (${time} == 12 and ${type} == 'hour')
        Swipe       ${x}    ${y}    ${x}    ${y}
    END
    IF    (${time} == 5 and ${type} == 'minute') or (${time} == 1 and ${type} == 'hour')
        ${y}        Evaluate    round(${y}+(${y} * 2.9 / 100))
        ${x}        Evaluate    round(${x}+(${x} * 22.5 /100))
        Swipe       ${x}    ${y}    ${x}    ${y}
    END
    IF    (${time} == 10 and ${type} == 'minute') or (${time} == 2 and ${type} == 'hour')
        ${y}        Evaluate    round(${y}+(${y} * 12.5 / 100))
        ${x}        Evaluate    round(${x}+(${x} * 38.7 /100))
        Swipe       ${x}    ${y}    ${x}    ${y}
    END
    IF    (${time} == 15 and ${type} == 'minute') or (${time} == 3 and ${type} == 'hour')
        ${y}        Evaluate    round(${y}+(${y} * 26.8 / 100))
        ${x}        Evaluate    round(${x}+(${x} * 45 /100))
        Swipe       ${x}    ${y}    ${x}    ${y}
    END
    IF    (${time} == 20 and ${type} == 'minute') or (${time} == 4 and ${type} == 'hour')
        ${y}        Evaluate    round(${y}+(${y} * 41 / 100))
        ${x}        Evaluate    round(${x}+(${x} * 38.7 /100))
        Swipe       ${x}    ${y}    ${x}    ${y}
    END
    IF    (${time} == 25 and ${type} == 'minute') or (${time} == 5 and ${type} == 'hour')
        ${y}        Evaluate    round(${y}+(${y} * 51.8 / 100))
        ${x}        Evaluate    round(${x}+(${x} * 22.5 /100))
        Swipe       ${x}    ${y}    ${x}    ${y}
    END
    IF    (${time} == 30 and ${type} == 'minute') or (${time} == 6 and ${type} == 'hour')
        ${y}        Evaluate    round(${y}+(${y} * 56.4 / 100))
        Swipe       ${x}    ${y}    ${x}    ${y}
    END
    IF    (${time} == 35 and ${type} == 'minute') or (${time} == 7 and ${type} == 'hour')
        ${y}        Evaluate    round(${y}+(${y} * 52.6 / 100))
        ${x}        Evaluate    round(${x}-(${x} * 22 /100))
        Swipe       ${x}    ${y}    ${x}    ${y}
    END
    IF    (${time} == 40 and ${type} == 'minute') or (${time} == 8 and ${type} == 'hour')
        ${y}        Evaluate    round(${y}+(${y} * 41 / 100))
        ${x}        Evaluate    round(${x}-(${x} * 36.1 /100))
        Swipe       ${x}    ${y}    ${x}    ${y}
    END
    IF    (${time} == 45 and ${type} == 'minute') or (${time} == 9 and ${type} == 'hour')
        ${y}        Evaluate    round(${y}+(${y} * 26 / 100))
        ${x}        Evaluate    round(${x}-(${x} * 43 /100))
        Swipe       ${x}    ${y}    ${x}    ${y}
    END
    IF    (${time} == 50 and ${type} == 'minute') or (${time} == 10 and ${type} == 'hour')
        ${y}        Evaluate    round(${y}+(${y} * 12.8 / 100))
        ${x}        Evaluate    round(${x}-(${x} * 36.6 /100))
        Swipe       ${x}    ${y}    ${x}    ${y}
    END
    IF    (${time} == 55 and ${type} == 'minute') or (${time} == 11 and ${type} == 'hour')
        ${y}        Evaluate    round(${y}+(${y} * 2.3 / 100))
        ${x}        Evaluate    round(${x}-(${x} * 20.7 /100))
        Swipe       ${x}    ${y}    ${x}    ${y}
    END
    IF    ${type} == 'minute'
        Element Should Contain Text    ${create.lblMinute}    ${timeString}
    ELSE
        Element Should Contain Text    ${create.lblHour}    ${timeString}
    END

Tap AM/PM
    [Arguments]    ${dateTime}
    ${dateTime}         Convert Date                     ${dateTime}                    result_format=%p
    ${elementStatus}    Run Keyword And Return Status    Element Should Contain Text    ${create.lblAMPM}    ${dateTime}
    IF    ${elementStatus} == 'False'
        Tap Element When Ready    ${create.lblAMPM}
    END
    Element Should Contain Text      ${create.lblAMPM}    ${dateTime}
    
Date Label Should Be Correct
    [Arguments]    ${dateTime}
    IF    '${dateTime}' == 'today'
        Element Should Contain Text    ${create.lblDate}    Today
    ELSE
        ${currentDateTime}             Get Current Date Time
        ${currentDateTime}             Convert Date         ${currentDateTime}    result_format=%d %b, %Y
        ${dateTime}                    Convert Date         ${dateTime}    result_format=%d %b, %Y
        ${currentDateTime}             Replace String Using Regexp    ${currentDateTime}    ^0    ${EMPTY}
        ${dateTime}                    Replace String Using Regexp    ${dateTime}    ^0    ${EMPTY}
        Element Should Contain Text    ${create.lblDate}    ${dateTime}
    END

Time Label Should Be Correct
    [Arguments]    ${dateTime}
    ${currentDateTime}             Get Current Date Time
    ${currentDateTime}             Convert Date         ${currentDateTime}    result_format=%I:%M %p
    ${dateTime}                    Convert Date         ${dateTime}    result_format=%I:%M %p
    ${currentDateTime}             Replace String Using Regexp    ${currentDateTime}    ^0    ${EMPTY}
    ${dateTime}                    Replace String Using Regexp    ${dateTime}    ^0    ${EMPTY}
    Element Should Contain Text    ${create.lbltime}    ${dateTime}

Error "The Date You Entered Is In The Past" Should Show
    Element Should Contain Text    ${create.lblError}    The date you entered is in the past.

Clear Title
    Input Element When Ready       ${create.txtTitle}    ${EMPTY}

Tap Ok Button
    Tap Element When Ready         ${create.btnOk}