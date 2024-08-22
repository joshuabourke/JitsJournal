//
//  SubmissionLibraryList.swift
//  MyBJJ
//
//  Created by Josh Bourke on 23/8/2022.
//

import SwiftUI

struct SubmissionLibraryList: View {
    //MARK: - PROPERTIES
    //These are Arrays that have all of the submissions in the app
    var chokeHolds = ["Rear Naked", "Arm Triangle", "Triangle" ,"Guillotine", "Ezekiel", "Baseball bat", "D'arce", "North South", "Crucifix" ,"Anaconda", "Gogoplata", "Von Fluke", "Bulldog Choke", "Inverted Triangle", "Back Triangle"].sorted()

    var upperBody = ["Arm Bar", "Wrist Lock", "Americana", "Kimura", "Arm Crush"].sorted()

    var lowerBody = ["Straight Leg Lock", "Toe Hold", "Knee Bar" ,"Calf Slicer", "Inside Heel Hook", "Outside Heel Hook"].sorted()
    
    //MARK: - BODY
    var body: some View {
        NavigationView {
            List{
                //MARK: - CHOKEHOLD SECTION
                Section {
                    //This for each is going to make a list item for each of the submissions I have in the Chokehold array of submissions.
                    //Then it is going to use the name of the submission to then switch over the result and change the variables accordingly.
                    ForEach(chokeHolds, id:\.self) { chokehold in
                        NavigationLink(destination: DetailedSubmissionsView(submissionName: chokehold, subArea: "Chokehold")){
                            Text(chokehold)
                                .font(.body.bold())
                        }//: LINK
                    }//: FOREACH
                } header: {
                    Text("Chokehold")
                    let chokeHoldSub = chokeholdSubmission()
                    ListViewItemSubAreaGIImage("giman", widthGi: 20, heightGi: 20, offSetYGi: chokeHoldSub.1)
                        .offset(y:chokeHoldSub.0)
                }
                //MARK: - UPPER BODY SECTION
                Section {
                    //This for each is going to make a list item for each of the submissions I have in the Upper body array of submissions.
                    //Then it is going to use the name of the submission to then switch over the result and change the variables accordingly.
                    ForEach(upperBody, id: \.self) { upperBody in
                        NavigationLink(destination: DetailedSubmissionsView(submissionName: upperBody, subArea: "Chokehold")){
                            Text(upperBody)
                                .font(.body.bold())
                        }//: LINK
                    }//: FOREACH
                } header: {
                    Text("Upper Body")
                        
                    let upperBody = upperBodySubmission()
                    ListViewItemSubAreaGIImage("giman", widthGi: 20, heightGi: 20, offSetYGi: upperBody.1)
                        .offset(y:upperBody.0)

                }
                //MARK: - LOWER BODY SECTION
                Section {
                    //This for each is going to make a list item for each of the submissions I have in the Lower body array of submissions.
                    //Then it is going to use the name of the submission to then switch over the result and change the variables accordingly.
                    ForEach(lowerBody, id:\.self) { lowerBody in
                        NavigationLink(destination: DetailedSubmissionsView(submissionName: lowerBody, subArea: "Chokehold")){
                            Text(lowerBody)
                                .font(.body.bold())
                        }//: LINK
                    }//: FOREACH
                } header: {
                    Text("Lower Body")
                        
                    let lowerBody = lowerBodySubmission()
                    ListViewItemSubAreaGIImage("giman", widthGi: 20, heightGi: 20, offSetYGi: lowerBody.1)
                        .offset(y:lowerBody.0)
                }
            }//: LIST
            .listStyle(.sidebar)
            .navigationTitle("Sub Library")
            .background(.thickMaterial)
        }//: NAVIGATION
    }
    
    //MARK: - FUNCTIONS
    //These are to create the off set of the giman for the section heading
    func chokeholdSubmission() -> (CGFloat, CGFloat) {
        var offsetY: CGFloat = 0
        
        var listViewItemSubAreaImageOffsetY: CGFloat = 0
        
        listViewItemSubAreaImageOffsetY = 15
        offsetY = -5
        
        return (offsetY, listViewItemSubAreaImageOffsetY)
    }
    
    func upperBodySubmission() -> (CGFloat, CGFloat) {
        var offsetY: CGFloat = 0
        
        var listViewItemSubAreaImageOffsetY: CGFloat = 0
        
        listViewItemSubAreaImageOffsetY = 1
        offsetY = -1
        
        return (offsetY, listViewItemSubAreaImageOffsetY)
    }
    
    func lowerBodySubmission() -> (CGFloat, CGFloat) {
        var offsetY: CGFloat = 0
        
        var listViewItemSubAreaImageOffsetY: CGFloat = 0
        
        listViewItemSubAreaImageOffsetY = -17.5
        offsetY = 0
        
        return (offsetY, listViewItemSubAreaImageOffsetY)
    }
    
}
    
    //MARK: - PREVIEW
struct SubmissionLibraryList_Previews: PreviewProvider {
    static var previews: some View {
        SubmissionLibraryList()
    }
}
