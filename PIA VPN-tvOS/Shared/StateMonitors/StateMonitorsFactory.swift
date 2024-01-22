//
//  StateMonitorsFactory.swift
//  PIA VPN-tvOS
//
//  Created by Said Rehouni on 19/1/24.
//  Copyright © 2024 Private Internet Access Inc. All rights reserved.
//

import Foundation
import PIALibrary

class StateMonitorsFactory {
    static func makeUserAuthenticationStatusMonitor() -> UserAuthenticationStatusMonitorType {
        UserAuthenticationStatusMonitor(currentStatus: Client.providers.accountProvider.isLoggedIn ? .loggedIn : .loggedOut,
                                        notificationCenter: NotificationCenter.default)
    }
    
    static func makeVPNStatusMonitor() -> VPNStatusMonitorType {
        guard let defaultVPNProvider = Client.providers.vpnProvider as? DefaultVPNProvider else {
            fatalError("Incorrect vpn provider type")
        }
        
        return VPNStatusMonitor(vpnStatusProvider: defaultVPNProvider,
                                notificationCenter: NotificationCenter.default)
    }
}
