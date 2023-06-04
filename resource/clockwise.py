import appium
from appium.webdriver.common.touch_action import TouchAction
from AppiumLibrary.locators import ElementFinder

class clockwise():
    def __init__(self):
        self._element_finder = ElementFinder()
    
    def get_current_application(self):
        """Gets the current application by Appium."""
        driver = self._driver
        current_activity = driver.currentActivity()
        current_app_package = driver.currentAppPackage()
        return current_app_package

    def drag_until_element_text_is_show(self, start_x, start_y, end_x, end_y, locator, expected):
        driver = self.get_current_application()
        actual = self._get_text(locator)
        action = TouchAction(driver)
        btx = abs(start_x-end_x)
        bty = abs(start_y-end_y)
        next_x = start_x+(btx/4)
        next_y = start_y+(bty/4)
        action.press(x=start_x, y=start_y)
        action.wait(2000)
        action.perform()
        if expected == actual:
            action.release()
            action.perform()
        action.move_to(x=next_x, y=next_y)
        action.perform()
        if expected == actual:
            action.release()
            action.perform()
        next_x = start_x+(btx/4)
        next_y = start_y+(bty/4)
        action.move_to(x=next_x, y=next_y)
        action.perform()
        if expected == actual:
            action.release()
            action.perform()
        next_x = start_x+(btx/4)
        next_y = start_y+(bty/4)
        action.move_to(x=next_x, y=next_y)
        if expected == actual:
            action.release()
            action.perform()
        else:
            message = "Element '%s' should have contained text '%s' but "\
                    "its text was '%s'." % (locator, expected, actual)
        raise AssertionError(message)