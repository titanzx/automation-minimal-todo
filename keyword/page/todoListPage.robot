*** Settings ***
Resource    ../common/common.robot
*** Variables ***
${todoList.btnCreate}             id=com.avjindersinghsekhon.minimaltodo:id/addToDoItemFAB
${todoList.lblTitle}              xpath=//*[@resource-id = 'com.avjindersinghsekhon.minimaltodo:id/toDoListItemTextview' and @text = 'TITLE_TEXT']
${todoList.lblDateTimeByTitle}    xpath=//*[@resource-id = 'com.avjindersinghsekhon.minimaltodo:id/toDoListItemTextview' and @text = 'TITLE_TEXT']/following-sibling::*[@resource-id = 'com.avjindersinghsekhon.minimaltodo:id/todoListItemTimeTextView']
${todoList.lblDateTime}           id=com.avjindersinghsekhon.minimaltodo:id/todoListItemTimeTextView
${todoList.lblSnackBar}           xpath=//*[@resource-id = 'com.avjindersinghsekhon.minimaltodo:id/snackbar_text' and @text = 'Deleted Todo']
${todoList.lblUndo}               id=com.avjindersinghsekhon.minimaltodo:id/snackbar_action
${todoList.lblCountTitle}         //*[@resource-id = 'com.avjindersinghsekhon.minimaltodo:id/toDoListItemTextview']

*** Keywords ***
Todo List Page Should Be Visible
    Wait Until Element Is Ready    ${todoList.btnCreate}

Tap Create Button
    Tap Element When Ready         ${todoList.btnCreate}

Tap On Todo Item
    [Arguments]    ${title}
    ${lblTitle}               Replace String    ${todoList.lblTitle}    TITLE_TEXT    ${title}
    Tap Element When Ready    ${lblTitle}
    
Date And Time Should Show In Todo item
    [Arguments]    ${title}
    ${lblTitle}                    Replace String    ${todoList.lblDateTimeByTitle}    TITLE_TEXT    ${title}
    Wait Until Element Is Ready    ${lblTitle}
    
Date And Time Shouldn't Show In Todo item
    [Arguments]    ${title}
    ${lblTitle}                    Replace String    ${todoList.lblDateTimeByTitle}    TITLE_TEXT    ${title}
    Wait Until Page Does Not Contain Element    ${lblTitle}

Todo Item Should Show And Correct
    [Arguments]    ${title}    ${dateTime}=empty
    ${lblTitle}                    Replace String       ${todoList.lblTitle}    TITLE_TEXT    ${title}
    Wait Until Element Is Ready    ${lblTitle}
    IF  '${dateTime}' != 'empty'
        ${month}       Convert Date    ${dateTime}    result_format=%b
        ${dayYear}     Convert Date    ${dateTime}    result_format=%d, %Y
        ${dayYear}     Replace String Using Regexp    ${dayYear}    ^0    ${EMPTY}
        ${time}        Convert Date    ${dateTime}    result_format=%I:%M %p
        ${time}        Replace String Using Regexp    ${time}    ^0    ${EMPTY}
        # ${dateTime}    Catenate        SEPARATOR=${SPACE}    ${month}    ${dayYear}
        # ${dateTime}    Catenate        ${dateTime}    ${time}
        ${lblDateTime}                 Replace String    ${todoList.lblDateTimeByTitle}    TITLE_TEXT    ${title}
        Element Should Contain Text    ${lblDateTime}    ${month}
        Element Should Contain Text    ${lblDateTime}    ${dayYear}
        Element Should Contain Text    ${lblDateTime}    ${time}
    END
    
Todo Item Shouldn't Show
    [Arguments]    ${title}
    ${lblTitle}                    Replace String       ${todoList.lblTitle}    TITLE_TEXT    ${title}
    Wait Until Page Does Not Contain Element    ${lblTitle}

Swipe To Delete Todo Item
    [Arguments]    ${title}
    ${lblTitle}                       Replace String       ${todoList.lblTitle}    TITLE_TEXT    ${title}
    Swipe Right In Frame Until End    ${lblTitle}

Page Should Show Message Deleted Todo
    Wait Until Element Is Ready    ${todoList.lblSnackBar}

Tap Undo
    Tap Element When Ready    ${todoList.lblUndo}

Count Todo Title
    ${count}    Get Matching Xpath Count    ${todoList.lblCountTitle}
    [Return]    ${count}

Count Todo Title Should Be Equal
    [Arguments]    ${countBefore}
    ${countAfter}      Get Matching Xpath Count    ${todoList.lblCountTitle}
    Should Be Equal    ${countBefore}    ${countAfter}

Get Date By Title
    [Arguments]    ${title}
    ${lblTitle}    Replace String    ${todoList.lblDateTimeByTitle}    TITLE_TEXT    ${title}
    ${date}        Get Text    ${lblTitle}
    ${date}        Convert Date    ${date}    result_format=%Y-%m-%d %H:%M    date_format=%b %d, %Y %I:%M %p
    [Return]       ${date}