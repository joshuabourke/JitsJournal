//
//  SignUpLoginScreen.swift
//  MyBJJ
//
//  Created by Josh Bourke on 25/6/2023.
//

import SwiftUI
import AuthenticationServices
import CryptoKit

struct SignUpLoginScreen: View {
    //MARK: - PROPERTIES
    @Environment(\.colorScheme) var colorScheme
    
    @State var moveToLogin: Bool = false
    @State var moveToSignUp: Bool = false
    @State var moveToForgotPassword: Bool = false
    
    @State var loginEmail: String = ""
    @State var loginPassword: String = ""
    
    @State var signUpEmail: String = ""
    @State var signUpPassword: String = ""
    
    @State var userNonce: String?
    
    @EnvironmentObject var authService: AuthService
    //MARK: - BODY
    var body: some View {
        NavigationStack {
            VStack{
                Spacer()
                Text("JITS\nJOURNAL.")
                    .font(.title)
                    .bold()
                Spacer()
                VStack(alignment: .center, spacing: 10){
                    //MARK: - SIGN IN WITH APPLE
                    signinWithAppleButtonView
                    //MARK: - SIGN UP
                    Button {
                        print("Sign up with email")
                        moveToSignUp.toggle()
                    } label: {
                        HStack{
                            Image(systemName: "envelope.fill")
                                .bold()
                            Text("Sign up with email")
                                .bold()
                        }
                        .frame(width: UIScreen.main.bounds.width / 1.3, height: 50)
                        .background(Color(UIColor.tertiarySystemFill))
                        .cornerRadius(8)
                        .navigationDestination(
                            isPresented: $moveToSignUp) {
                                signUpView
                             }
                    }
                    //MARK: - LOGIN
                    Button {
                        print("Log in")
                        moveToLogin.toggle()
                    } label: {
                        HStack{
                            Text("Login")
                                .bold()
                        }//: HSTACK
                        .frame(width: UIScreen.main.bounds.width / 1.3, height: 50)
                        .background(RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 3).foregroundColor(Color(UIColor.tertiarySystemFill)))
                        .cornerRadius(8)
                        .navigationDestination(
                            isPresented: $moveToLogin) {
                                loginView
                             }
                    }
                    //MARK: - FORGOT PASSWORD
                    Button {
                        print("Forgot password")
                        moveToForgotPassword.toggle()
                    } label: {
                        Text("Forgot passsword")
                            .underline()
                    }
                    .navigationDestination(
                        isPresented: $moveToForgotPassword) {
                             Text("Forgot password")
                         }
                }//: Button Vstack


            }//: VSTACK
        }//: NAV
    }
    
    private var signinWithAppleButtonView: some View {
        
        SignInWithAppleButton(.continue) { request in
            let nonce = randomNonceString()
            userNonce = nonce
            request.requestedScopes = [.fullName, .email]
            request.nonce = sha256(nonce)
        } onCompletion: { result in
            switch result {
            case .success(let authResults):
                switch authResults.credential {
                case let appleIDCredential as ASAuthorizationAppleIDCredential:
                    
                    guard let nonce = userNonce else {
                        fatalError("Invalid state: A login callback was received, but no login request was sent.")
                    }
                    guard let appleIDToken = appleIDCredential.identityToken else {
                        fatalError("Invalid state: A login callback was received, but no login request was sent.")
                    }
                    guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                        print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                        return
                    }
                    Task{
                        do {
                            try await authService.signInWithApple(idToken: idTokenString, nonce: nonce)
                        } catch {
                            print("### Error trying to sign in with apple \(error)")
                        }
                    }//: TASK
                default:
                    break
                    }
            default:
                break
                }
        }
        .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
        .frame(width: UIScreen.main.bounds.width / 1.3, height: 50)
        
    }
    
    private var loginView: some View {
        VStack{
            TextField("email", text: $loginEmail)
            TextField("password", text: $loginPassword)
            Button {
                print("Login Button")
                Task{
                    do {
                        try await authService.signIn(email: loginEmail,password: loginPassword)
                    } catch {
                        print("### Error trying to login \(error)")
                    }
                }
            } label: {
                Text("Login")
                    .bold()
            }
            .buttonStyle(.borderedProminent)
        }//: VSTACK
        .navigationTitle("Login")
        .navigationBarTitleDisplayMode(.inline)
        .padding()
    }//: LOGIN VIEW
    
    private var signUpView: some View {
        VStack{
            TextField("email", text: $signUpEmail)
            TextField("password", text: $signUpPassword)
            Button {
                print("Sign up Button")
                Task{
                    do {
                        try await authService.registerNewUserWithEmail(email: signUpEmail,password: signUpPassword)
                        moveToSignUp.toggle()
                    } catch {
                        print("### Error trying to sign up \(error.localizedDescription)")
                    }
                }
            } label: {
                Text("Sign up")
                    .bold()
            }
            .buttonStyle(.borderedProminent)
        }//: VSTACK
        .navigationTitle("Sign up")
        .navigationBarTitleDisplayMode(.inline)
        .padding()
    }//: SIGN UP VIEW
    
    //MARK: - FUNCTIONS
    
    //Hashing function using CryptoKit
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
        }.joined()

        return hashString
    }
    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: Array<Character> =
          Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }
}
    //MARK: - PREVIEW
struct SignUpLoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignUpLoginScreen()
    }
}
