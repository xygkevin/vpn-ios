//
//  GeneralSettingsScreen.swift
//  PIA-VPN_E2E_Tests
//
//  Created by Geneva Parayno on 2/11/23.
//  Copyright © 2023 Private Internet Access Inc. All rights reserved.
//

import XCTest

extension XCUIApplication {
    var connectSiriButton: XCUIElement {
        staticText(with: "'Connect' Siri Shortcut")
    }
    
    var disconnectSiriButton: XCUIElement {
        staticText(with: "'Disconnect' Siri Shortcut")
    }
    
    var serviceCommMessageSwitch: XCUIElement {
        switches(with: "Show Service Communication Messages")
    }
    
    var geoLocatedRegionsSwitch: XCUIElement {
        switches(with: "Show Geo-located Regions")
    }
    
    var resetSettingsButton: XCUIElement {
        staticText(with: "Reset settings to default")
    }
    
    func navigateToGeneralSettings() {
        guard dashboardMenuButton.waitForExistence(timeout: defaultTimeout) else { return }
        dashboardMenuButton.tap()
        
        if settingsButton.waitForExistence(timeout: defaultTimeout) {
            settingsButton.tap()
        }
        
        if generalSettingsButton.waitForExistence(timeout: defaultTimeout) {
            generalSettingsButton.tap()
        }
    }
    
    func enableGeoLocatedRegionSwitch() {
        if ((geoLocatedRegionsSwitch.value as! String) != "1") {
            geoLocatedRegionsSwitch.tap()
        }
    }
    
    func disableGeoLocatedRegionSwitch() {
        if ((geoLocatedRegionsSwitch.value as! String) != "0") {
            geoLocatedRegionsSwitch.tap()
        }
    }
}
