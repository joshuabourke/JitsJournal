//
//  ContentView.swift
//  MyBJJ
//
//  Created by Josh Bourke on 12/4/22.
//

import SwiftUI


struct ContentView: View {
    //I am trying to figure out how to send the user from stats view across into the sub list view and then toggle the login screen.
    //MARK: - PROPERTIES
    @State private var isNewBJJItemOpen: Bool = false
    @State private var winMoreThanZero: Bool = false
    @State private var lossMoreThanZero: Bool = false
    
    //These 2 state var's are used to open the profile view from the stat view.
    @State private var currentTab = 1
    @State private var openProfileView: Bool = false
    //MARK: - UPDATING STAT VIEW (From main view)
//    @StateObject var vm = AddingNewSubViewModel(myBJJUser: .init(data: ["uid" : "bQsUeLnTOXg27Bp06PaUayRXQv82", "email": "josh@gmail.com"]))

    @State var didTapProfileButton: Bool = false
    @State var needsToLogin: Bool = false
    @State var didFinishLoginOrCreateAccount: Bool = false
    
    @AppStorage("isUserLoggedIn") var isUserLoggedIn = false
    
    @EnvironmentObject var authService: AuthService
    
    //MARK: - BODY
    var body: some View {
        Group {
            if authService.isAuthenticated {
                TabView(selection: $currentTab){
                    Group {
                        ProfileView()
                            .tabItem {
                                Text("Profile")
                                Image(systemName: "person.fill")
                            }
                            .tag(0)
                        SubListView()
                            .tabItem {
                                Text("Saved")
                                Image(systemName: "bookmark")
                            }
                            .tag(1)
                        
                        SubmissionLibraryList()
                            .tabItem {
                                Text("Library")
                                Image(systemName: "books.vertical.fill")
                            }
                            .tag(2)
                    }
                    .toolbar(.visible, for: .tabBar)
                    .toolbarBackground(.visible, for: .tabBar)
                }//: TABVIEW
                .onAppear(){
                    //The below code will ask the user to allow notifications. It will also remove the badge from the corner of the app once the user has opened it.
                    NotificationManager.instance.requestAuthorization()
                    UIApplication.shared.applicationIconBadgeNumber = 0
                }
            } else {
                SignUpLoginScreen()
            }
            
        }
    }

}
    //MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
