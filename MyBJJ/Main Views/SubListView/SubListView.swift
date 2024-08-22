//
//  SubListView.swift
//  MyBJJ
//
//  Created by Josh Bourke on 28/4/22.
//

import SwiftUI

struct SubListView: View {
    //MARK: - PROPERTIES

    var subVM = SubViewModel()
    
    //This will open the newSkillView
    @State var isNewBJJItemOpen: Bool = false
    
//    @State var ShouldShowLogOutOptions: Bool = false
//
//    //This is just a switch to choose if the user has selected either Gi or noGi based on true of fale. Nogi if true and gi if false. This will add a differnt item into the list of their recorded submissions.
    @State var noGiOrGiSelection: Bool = true
//    
//    //Showing full screen profile view.
//    @State var showProfileView: Bool = false
//    
//    //Variables for filtering
//    @State private var upperChokeLowerSearchTerm = ""
//    @State private var giOrNoGiSearchTerm = ""
//    @State private var winOrLossSearchTerm = ""
    //Toggles for fitlers.
    
    @AppStorage("isUserLoggedIn") var isUserLoggedIn = false
    @AppStorage("userId") var userId = ""
    //MARK: - BODY
    var body: some View {
        NavigationView {
                //Bottom of ZSTACK!
                VStack {
                    Spacer()
                }//: VSTACK
                .background(.thickMaterial)
                //MARK: - HANDLING WHEN USER TRIES TO ADD SUBMISSION WHEN THEY ARENT SIGNED IN
                .navigationBarTitle("Jits Journal")
                .toolbar(content: {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            isNewBJJItemOpen.toggle()
                        } label: {
                            Image(systemName: "plus")
                                .bold()
                        }
                    }
                })
        }//NAVIGATION
        //MARK: - NEW SKILL SHEET
        //This will open a sheet the user can then log a new completed submission either win or loss.
        .sheet(isPresented: $isNewBJJItemOpen) {
            NewSkillView(isNewSubmissionOpen: $isNewBJJItemOpen, noGiOrGiSelection: $noGiOrGiSelection)
        }
    }//: END OF VIEW
}


//MARK: - PREVIEW
struct SubListView_Previews: PreviewProvider {
    static var previews: some View {
        SubListView()
    }
}
