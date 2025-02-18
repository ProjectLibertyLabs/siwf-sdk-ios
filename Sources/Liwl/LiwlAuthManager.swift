//
//  LiwlAuthManager.swift
//
//
//  Created by Claire Olmstead on 2/12/25.
//

import Foundation

public class LiwlAuthManager {
    public static let shared = LiwlAuthManager()
    private init() {}

    var signInCompletion: ((Result<User, Error>) -> Void)?
    
    public func startSignInProcess() {
        // Simulate sign-in process
        print("Starting Liwl Sign-In Process...")
        
        // Simulate success after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let user = User(id: "12345", name: "Claire")
            self.signInCompletion?(.success(user))
        }
    }
    
    public func handleSignInCallback(url: URL) -> Bool {
        print("Handling callback URL: \(url)")
        return true
    }
}
