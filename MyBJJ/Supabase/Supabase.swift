//
//  Supabase.swift
//  MyBJJ
//
//  Created by Josh Bourke on 26/8/2024.
//

import Foundation
import Supabase
import SwiftUI


final class AuthService: ObservableObject {
    
    @AppStorage("isUserLoggedIn") var isUserLoggedIn = false
    @AppStorage("userId") var userId = ""
    @AppStorage("userEmail") var userEmail = ""
    
    
    private let auth = SupabaseClient(supabaseURL: EnvironmentKeys.url, supabaseKey: EnvironmentKeys.api).auth
    
    @Published var isAuthenticated = false
    
    init() {
        Task {
            await isUserAuthed()
        }
    }
    

    func isUserAuthed() async {
        do {
            _ = try await auth.session.user
            DispatchQueue.main.async {
                self.isAuthenticated = true
            }
        } catch {
            DispatchQueue.main.async {
                self.isAuthenticated = false
            }
            print("### Error user is not authed \(error)")
        }
    }
    
//    func getUserSession() async throws {
//        let user = try await auth.session
//        isAuthenticated = true
//    }
    
    func signInWithApple(idToken: String, nonce: String) async throws {
        let appleSession = try await auth.signInWithIdToken(credentials: .init(provider: .apple,idToken: idToken, nonce: nonce))
        DispatchQueue.main.async {
            self.isAuthenticated = true
            self.userId = appleSession.user.id.uuidString
            self.userEmail = appleSession.user.email ?? ""
        }
    }
    
    func registerNewUserWithEmail(email: String, password: String) async throws {
      let response = try await auth.signUp(email: email, password: password)
        DispatchQueue.main.async {
            self.isAuthenticated = true
            self.userId = response.user.id.uuidString
            self.userEmail = response.user.email ?? ""
        }
    }
    
    func signIn(email: String, password: String) async throws {
        let session = try await auth.signIn(email: email, password: password)
        DispatchQueue.main.async {
            self.isAuthenticated = true
            self.userId = session.user.id.uuidString
            self.userEmail = session.user.email ?? ""
        }
    }
    
    func signOut() async throws {
        try await auth.signOut()
        DispatchQueue.main.async {
            self.isAuthenticated = false
        }
    }

    func execute(_ query: PostgrestQueryBuilder) {
        Task{
            do{
                _ = try await query.execute()
            } catch {
                print("### Error trying to execute Query \(error)")
            }
        }
        
    }
}
