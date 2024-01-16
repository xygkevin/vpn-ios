
import Foundation
import SwiftUI
import PIALibrary

class RootContainerViewModel: ObservableObject {
    enum State {
        case splash
        case notActivated
        case activatedNotOnboarded
        case activated
    }
    
    @Published var state: State = .splash
    @Published internal var isBootstrapped: Bool = false
    
    private let accountProvider: AccountProviderType
    private let notificationCenter: NotificationCenterType
    private let vpnConfigurationAvailability: VPNConfigurationAvailabilityType
    
    init(accountProvider: AccountProviderType, notificationCenter: NotificationCenterType = NotificationCenter.default, vpnConfigurationAvailability: VPNConfigurationAvailabilityType) {
        
        self.accountProvider = accountProvider
        self.notificationCenter = notificationCenter
        self.vpnConfigurationAvailability = vpnConfigurationAvailability
        updateState()
        subscribeToAccountUpdates()
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
    func phaseDidBecomeActive() {
        // Bootstrap PIALibrary preferences and settings
        // TODO: DI this object
        Bootstrapper.shared.bootstrap()
        isBootstrapped = true
        updateState()
    }
    
    private func updateState() {
        guard isBootstrapped else {
            return
        }
        
        let onBoardingVpnProfileInstalled = vpnConfigurationAvailability.get()
        
        switch (accountProvider.isLoggedIn, onBoardingVpnProfileInstalled) {
            // logged in, vpn profile installed
        case (true, true):
            state = .activated
            // logged in, vpn profile not installed
        case (true, false):
            state = .activatedNotOnboarded
            // not logged in, any
        case (false, _):
            state = .notActivated
        }
    }

}

// NotificationCenter subscriptions

extension RootContainerViewModel {
    private func subscribeToAccountUpdates() {
        notificationCenter.addObserver(self, selector: #selector(handleAccountDidLogin), name: .PIAAccountDidLogin, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(handleAccountDidLogout), name: .PIAAccountDidLogout, object: nil)
    }
    
    @objc func handleAccountDidLogin() {
        updateState()
    }
    
    @objc func handleAccountDidLogout() {
        updateState()
    }
}