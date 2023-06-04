*** Settings ***
Library      OperatingSystem
Library      AppiumLibrary
Library      DateTime
Library      String
Resource     ../keyword/common/common.robot
Resource     ./importPage.robot
Resource     ./app/importApp.robot
Variables    ./config/globalConfig.yaml
Variables    ./config/androidConfig.yaml