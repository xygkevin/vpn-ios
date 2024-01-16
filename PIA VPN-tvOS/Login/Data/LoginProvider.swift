//
//  LoginProvider.swift
//  PIA VPN-tvOS
//
//  Created by Said Rehouni on 4/12/23.
//  Copyright © 2023 Private Internet Access Inc. All rights reserved.
//

import Foundation
import PIALibrary

class LoginProvider: LoginProviderType {
    private let accountProvider: AccountProvider
    private let userAccountMapper: UserAccountMapper
    
    init(accountProvider: AccountProvider, userAccountMapper: UserAccountMapper) {
        self.accountProvider = accountProvider
        self.userAccountMapper = userAccountMapper
    }
    
    func login(with credentials: Credentials, completion: @escaping (Result<UserAccount, Error>) -> Void) {
        let pialibraryCredentials = PIALibrary.Credentials(username: credentials.username, password: credentials.password)
        let request = LoginRequest(credentials: pialibraryCredentials)
        
        accountProvider.login(with: request) { [weak self] userAccount, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let userAccount = userAccount else {
                completion(.failure(ClientError.unexpectedReply))
                return
            }
            
            completion(.success(userAccountMapper.map(userAccount: userAccount)))
        }
    }
}