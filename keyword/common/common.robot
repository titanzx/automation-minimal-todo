*** Keywords ***
Open Minimaltodo App
    Open Application       ${remoteUrl}
    ...     automationName=${automationName}
    ...       platformName=${platformName}
    ...    platformVersion=${platformVersion}
    ...         deviceName=${deviceName}
    ...               udid=${udid}
    ...          fullReset=${fullReset}
    ...  autoGrantPermissions=${autoAcceptAlerts}
    ...                app=${app}
    Run    adb -s ${udid} shell pm grant android.permission.POST_NOTIFICATIONS

Tap Element When Ready
    [Arguments]    ${locator}
    Wait Until Element Is Ready      ${locator}
    Wait Until Keyword Succeeds      ${retryTime}    ${retryTimeout}    Click Element    ${locator}

Find And Tap Element When Ready
    [Arguments]    ${locator}
    Find Element                     ${locator}
    Tap Element When Ready           ${locator}

Input Element When Ready
    [Arguments]    ${locator}    ${value}
    Tap Element When Ready    ${locator}
    Clear Text                ${locator} 
    Input Text                ${locator}      ${value}

Find Element
    [Arguments]    ${locator}
    FOR    ${i}    IN RANGE    40
        ${elementStatus}             Run Keyword And Return Status      Element Should Be Visible    ${locator}
        IF    '${elementStatus}' == 'False'
            Swipe Up
        END
        Exit For Loop If             '${elementStatus}' == 'True'
    END

Find Element In Frame
    [Arguments]    ${frameLocator}    ${locator}
    # Wait Until Element Is Ready    ${frameLocator}
    FOR    ${i}    IN RANGE    40
        ${elementStatus}             Run Keyword And Return Status      Element Should Be Visible    ${locator}
        IF    '${elementStatus}' == 'False'
            Swipe Up In Frame    ${frameLocator}
        END
        Exit For Loop If             '${elementStatus}' == 'True'
    END

Find Top Element In Frame
    [Arguments]    ${frameLocator}    ${locator}
    # Wait Until Element Is Ready    ${frameLocator}
    FOR    ${i}    IN RANGE    40
        ${elementStatus}             Run Keyword And Return Status      Element Should Be Visible    ${locator}
        IF    '${elementStatus}' == 'False'
            Swipe Down In Frame    ${frameLocator}
        END
        Exit For Loop If             '${elementStatus}' == 'True'
    END

Wait Until Element Is Ready
    [Arguments]    ${locator}
    Wait Until Keyword Succeeds      ${retryTime}    ${retryTimeout}    Element Should Be Visible    ${locator}

Swipe Up
    ${width}       Get Window Width
    ${height}      Get Window Height
    ${width}       Convert To Integer    ${width}
    ${height}      Convert To Integer    ${height}
    ${x}           Evaluate    ${width}/2
    ${y}           Evaluate    ${height}/2
    ${newY}        Evaluate    ${y}-300
    Swipe          ${x}    ${y}    ${x}    ${newY}    2400

Swipe Up In Frame
    [Arguments]    ${frameLocator}
    ${frameSize}   Get Element Location    ${frameLocator}
    ${width}       Set Variable    ${frameSize}[x]
    ${height}      Set Variable    ${frameSize}[y]
    ${width}       Convert To Integer    ${width}
    ${height}      Convert To Integer    ${height}
    ${x}           Evaluate    ${width}+0
    ${y}           Evaluate    ${height}+0
    ${newY}        Evaluate    ${y}-300
    Swipe          ${x}    ${y}    ${x}    ${newY}    2400

Swipe Down In Frame
    [Arguments]    ${frameLocator}
    ${frameSize}   Get Element Location    ${frameLocator}
    ${width}       Set Variable    ${frameSize}[x]
    ${height}      Set Variable    ${frameSize}[y]
    ${width}       Convert To Integer    ${width}
    ${height}      Convert To Integer    ${height}
    ${x}           Evaluate    ${width}+0
    ${y}           Evaluate    ${height}+0
    ${newY}        Evaluate    ${y}+300
    Swipe          ${x}    ${y}    ${x}    ${newY}    2400

Swipe Right In Frame Until End
    [Arguments]    ${frameLocator}
    ${frameSize}   Get Element Location    ${frameLocator}
    ${width}       Set Variable    ${frameSize}[x]
    ${height}      Set Variable    ${frameSize}[y]
    ${width}       Convert To Integer    ${width}
    ${height}      Convert To Integer    ${height}
    ${x}           Evaluate    ${width}+0
    ${y}           Evaluate    ${height}+0
    ${newX}        Evaluate    ${x}+1000
    Swipe          ${x}    ${y}    ${newX}    ${y}    2400

Get Current Date Time
    [Arguments]    ${last5Minute}=false
    ${currentDateTime}    Get Current Date            result_format=%Y-%m-%d %H:%M    exclude_millis=true
    ${currentDateTime}    Convert Custom Date Time    ${currentDateTime}    last5Minute=${last5Minute}
    [Return]              ${currentDateTime}

Convert Custom Date Time
    [Arguments]    ${dateTime}    ${d}=empty    ${m}=empty    ${y}=empty    ${h}=empty    ${min}=empty   ${last5Minute}=false
    ${dateTime}    Convert Date    ${dateTime}  result_format=datetime
    IF    '${d}' == 'empty'
        ${d}    Set Variable    ${dateTime.day}
    END

    IF    '${m}' == 'empty'
        ${m}    Set Variable    ${dateTime.month}
    END

    IF    '${y}' == 'empty'
        ${y}    Set Variable    ${dateTime.year}
    END

    IF    '${h}' == 'empty'
        ${h}    Set Variable    ${dateTime.hour}
    END

    IF    '${min}' == 'empty'
        IF    '${last5Minute}' == 'true'
            ${min}    Evaluate        ${dateTime.minute}-(${dateTime.minute}%5)
            ${min}    Set Variable    ${min}
        ELSE
            ${min}    Evaluate        ${dateTime.minute}+(5-${dateTime.minute})%5
            ${min}    Set Variable    ${min}
        END
    ELSE
        IF    '${last5Minute}' == 'true'
            ${min}    Evaluate        ${min}-(${min}%5)
        ELSE
            ${min}    Evaluate        ${min}+(5-${min})%5
        END
    END
    
    ${newDateTime}    Convert Date    ${y}-${m}-${d} ${h}:${min}    result_format=%Y-%m-%d %H:%M    date_format=%Y-%m-%d %H:%M
    [Return]    ${newDateTime}

Count Between
    [Arguments]    ${time}
    ${startNumber}    Set Variable  5
    ${count}          Set Variable  0
    FOR    ${counter}    IN RANGE   5
        ${timeR}         Evaluate    ${startNumber}+${counter}
        ${count}         Set Variable    ${counter}
        IF    ${time} == ${timeR}  BREAK
    END
    [Return]    ${count}