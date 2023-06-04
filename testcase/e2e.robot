*** Settings ***
Resource            ../resource/import.robot
Suite Setup         Open Minimaltodo App
Test Teardown       Close Notification Panel
Suite Teardown      Close Application

*** Test Cases ***
Create a new todo item
    [Documentation]    Verify that the user can create a new todo item.
    todoListPage.Todo List Page Should Be Visible
    todoListPage.Tap Create Button
    createPage.Input Title    Todo01
    createPage.Tap Create Button
    todoListPage.Todo List Page Should Be Visible
    todoListPage.Todo Item Should Show And Correct    Todo01

Create a new todo item with reminder
    [Documentation]    Verify that the user can create a new todo item with reminder.
    ${dateTime}    Get Current Date Time
    ${dateTime}    Add Time To Date    ${dateTime}    1188 days   # Add 3 year 3 month
    ${dateTime}    Convert Custom Date Time    ${dateTime}    d=20    h=11    min=45
    todoListPage.Todo List Page Should Be Visible
    todoListPage.Tap Create Button
    createPage.Input Title    Todo02
    createPage.Tap Reminder Toggle
    createPage.Set Reminder Date Time    ${dateTime}
    createPage.Date Label Should Be Correct    ${dateTime}
    createPage.Time Label Should Be Correct    ${dateTime}
    createPage.Tap Create Button
    todoListPage.Todo List Page Should Be Visible
    todoListPage.Todo Item Should Show And Correct    Todo02    dateTime=${dateTime}

Notification should be alert on time
    [Documentation]    Verify that the user can get notification on time.
    ${dateTime}    Get Current Date Time
    todoListPage.Todo List Page Should Be Visible
    todoListPage.Tap Create Button
    createPage.Input Title    Todo03
    createPage.Tap Reminder Toggle
    createPage.Set Reminder Date Time    ${dateTime}
    createPage.Date Label Should Be Correct    ${dateTime}
    createPage.Time Label Should Be Correct    ${dateTime}
    createPage.Tap Create Button
    todoListPage.Todo List Page Should Be Visible
    todoListPage.Todo Item Should Show And Correct    Todo03    dateTime=${dateTime}
    notificationPanel.Notification Should Alert On Time With Title    ${dateTime}    Todo03


Edit todo item
    [Documentation]    Verify that the user can edit a todo item.
    ${dateTime}    Get Current Date Time
    todoListPage.Todo List Page Should Be Visible
    todoListPage.Tap On Todo Item    Todo01
    createPage.Input Title    Todo01Edit
    createPage.Tap Reminder Toggle
    createPage.Tap Create Button
    todoListPage.Todo List Page Should Be Visible
    todoListPage.Todo Item Should Show And Correct    Todo01Edit
    todoListPage.Date And Time Should Show In Todo item    Todo01Edit

Edit todo item and remove reminder
    [Documentation]    Verify that the user can edit a todo item and remove reminder.
    ${dateTime}    Get Current Date Time
    todoListPage.Todo List Page Should Be Visible
    todoListPage.Tap On Todo Item    Todo02
    createPage.Input Title    Todo02Edit
    createPage.Tap Reminder Toggle
    createPage.Tap Create Button
    todoListPage.Todo List Page Should Be Visible
    todoListPage.Todo Item Should Show And Correct    Todo02Edit
    todoListPage.Date And Time Shouldn't Show In Todo item    Todo02Edit

Delete todo item
    [Documentation]    Verify that the user can delete a todo item.
    todoListPage.Todo List Page Should Be Visible
    todoListPage.Swipe To Delete Todo Item    Todo03
    todoListPage.Todo Item Shouldn't Show    Todo03

Undo deleted todo item
    [Documentation]    Verify that the user can undo deleted a todo item
    todoListPage.Todo List Page Should Be Visible
    todoListPage.Swipe To Delete Todo Item    Todo01Edit
    todoListPage.Todo Item Shouldn't Show    Todo01Edit
    todoListPage.Tap Undo
    todoListPage.Todo Item Should Show And Correct    Todo01Edit

Can't create a new todo item without title and with past date-time
    [Documentation]    Verify that the user cannot create a todo item without title and with past date and time.
    ${dateTime}    Get Current Date Time       last5Minute=true
    ${dateTime}    Convert Custom Date Time    ${dateTime}    d=13    y=2020
    todoListPage.Todo List Page Should Be Visible
    ${countBefore}    Count Todo Title
    todoListPage.Tap Create Button
    createPage.Tap Reminder Toggle
    createPage.Set Reminder Date Time    ${dateTime}   swipeYear="down"
    createPage.Date Label Should Be Correct    today
    createPage.Error "The Date You Entered Is In The Past" Should Show
    createPage.Tap Create Button
    todoListPage.Todo List Page Should Be Visible
    todoListPage.Count Todo Title Should Be Equal    ${countBefore}

Can't edit a todo item without title and with past date and time
    [Documentation]    Verify that the user cannot edit a todo item without title and with past date and time.
    ${dateTime}    Get Current Date Time       last5Minute=true
    ${dateTime}    Convert Custom Date Time    ${dateTime}    d=10    y=2019
    todoListPage.Todo List Page Should Be Visible
    todoListPage.Tap On Todo Item    Todo02Edit
    createPAge.Clear Title
    createPage.Tap Reminder Toggle
    createPage.Set Reminder Date Time    ${dateTime}   swipeYear="down"
    createPage.Date Label Should Be Correct    today
    createPage.Error "The Date You Entered Is In The Past" Should Show
    createPage.Tap Create Button
    todoListPage.Todo List Page Should Be Visible
    todoListPage.Todo Item Should Show And Correct    Todo02Edit
    todoListPage.Date And Time Shouldn't Show In Todo item    Todo02Edit