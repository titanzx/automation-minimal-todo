*** Settings ***
Library    AppiumLibrary
*** Variables ***
${notification.lblTitle}    id=android:id/title
${notification.lblTime}     id=com.android.systemui:id/clock

*** Keywords ***
Notification Should Alert On Time With Title
    [Arguments]    ${dateTime}    ${title}
    ${dateTime}                      Convert Date         ${dateTime}    result_format=%I:%M
    ${dateTime}                      Replace String Using Regexp    ${dateTime}    ^0    ${EMPTY}
    Sleep                            10s
    Open Notifications
    Sleep                            2s
    Wait Until Page Contains         ${dateTime}    300s
    Element Should Contain Text      ${notification.lblTime}     ${dateTime}
    Wait Until Keyword Succeeds      120x    0.5s    Element Should Contain Text    ${notification.lblTitle}    ${title}
    

Close Notification Panel
    ${elementStatus}    Run Keyword And Return Status      Element Should Be Visible    ${notification.lblTime}
    IF    '${elementStatus}' == 'True'
        Press Keycode    4
    END