//
//  NewSkillView.swift
//  MyBJJ
//
//  Created by Josh Bourke on 13/4/22.
//

import SwiftUI


struct NewSkillView: View {
    //MARK: - PROPERTIES
    var subVM = SubViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var newSubmission: String = ""


//    @StateObject var newSubVM: AddingNewSubViewModel
    
    //MARK: - UPDATING DATA
    @State var fileName: String = ""
    @State var fileItem: Int = 0
    
    //MARK: - WIN/LOSS PICKER
    var pickerWinOrLoss = ["Win", "Loss"]
    //MARK: - SUB PICKER
    var pickerSubmissions = ["Chokehold", "Upper Body", "Lower Body"]
    //MARK: - NOGI OR GI PICKER
    var pickerNoGiOrGi = ["NoGi", "Gi"]
    @State var selectedSub: String = ""
    @State var pickerWinOrLossIndex: String = "Win"
    @State var pickerSelectionIndex: String = "Chokehold"
    @State var pickerGiorNoGiIndex: String = "NoGi"
    
    @Binding var isNewSubmissionOpen: Bool
    
    //This is for the user to select either gi or no gi This will then be passed into the sublistView. Then it will see if either gi or nogi was selected. Then it will add a new list item that will show either gi or no gi.
    @Binding var noGiOrGiSelection: Bool
    
    @State var selectedNewItem: Int = 0
    @State var giOrNogiNewItem: Int = 0
    @State var submissionAreaNewItem: Int = 0
    
    //MARK: - ALERT
    @State var showAlert = false
    @State var addNote: Bool = false
    @State var userNotes: String = ""
    //MARK: - NEW SUBMISSION LISTS(ARRAYS)
    //They where on their own before as kind of a global var. Changing them to be in the actual fine of new sub.
    //Reason being is because I am trying to fix a visual problem where when changing to a different sub type it flickers.
    
    //Add more subs here to expand on the new sub lists.
    var chokeHolds = ["Rear Naked", "Arm Triangle", "Triangle" ,"Guillotine", "Ezekiel", "Baseball bat", "D'arce", "North South", "Crucifix" ,"Anaconda", "Gogoplata", "Von Fluke", "Bulldog Choke", "Inverted Triangle", "Back Triangle"].sorted()

    var upperBody = ["Arm Bar", "Wrist Lock", "Americana", "Kimura", "Arm Crush"].sorted()

    var lowerBody = ["Straight Leg Lock", "Toe Hold", "Knee Bar" ,"Calf Slicer", "Inside Heel Hook", "Outside Heel Hook"].sorted()
    //MARK: - BODY
    var body: some View {
        ScrollView {
            VStack(spacing: 8){
                HStack(){
                    Text(timeString(from: Date()))
                        .bold()
                        .padding(8)
                    Spacer()
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        isNewSubmissionOpen = false
                        print("Close Window")
                    } label: {
                        Image(systemName: "xmark")
                            .bold()
                            .foregroundColor(.gray)
                            .padding(8)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }

                }//: HSTACK
                Button {
                    addNote.toggle()
                } label: {
                    HStack {
                        Text("Add Note")
                            .bold()
                            .foregroundStyle(.gray)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .bold()
                            .foregroundColor(.gray)
                    }//: HSTACK
                    .padding(12)
                    .background(.ultraThinMaterial)
                    .cornerRadius(8)
                }
                .sheet(isPresented: $addNote, content: {
                    NotesTextView(textFieldNotes: $userNotes)
                })
                
                HStack {
                    newItemSelection(compareNumber: $selectedNewItem,selectedItemNumber: 0, title: "Train")
                    newItemSelection(compareNumber: $selectedNewItem,selectedItemNumber: 1, title: "Roll")
                    newItemSelection(compareNumber: $selectedNewItem,selectedItemNumber: 3, title: "Comp")
                }//: HSTACK
                .padding(8)
                .background(.ultraThinMaterial)
                .cornerRadius(8)
                
                HStack {
                    newItemSelection(compareNumber: $giOrNogiNewItem,selectedItemNumber: 0, title: "Gi")
                    newItemSelection(compareNumber: $giOrNogiNewItem,selectedItemNumber: 1, title: "Nogi")
                }//: HSTACK
                .padding(8)
                .background(.ultraThinMaterial)
                .cornerRadius(8)
                
                //MARK: - Area Selection
                HStack {
                    newItemSelection(compareNumber: $submissionAreaNewItem,selectedItemNumber: 0, title: "Chokehold")
                    newItemSelection(compareNumber: $submissionAreaNewItem,selectedItemNumber: 1, title: "Upper Body")
                    newItemSelection(compareNumber: $submissionAreaNewItem,selectedItemNumber: 2, title: "Lower Body")
                }//: HSTACK
                .padding(8)
                .background(.ultraThinMaterial)
                .cornerRadius(8)
                

                List{
                    if pickerSelectionIndex == "Chokehold" {
                        ForEach(chokeHolds, id: \.self) { chokehold in
                            CustomRowSelectionTest(title: chokehold, selectedItem: $selectedSub) { title in
                                print(title)
                            }
                            .padding()
                        }
                    } else if pickerSelectionIndex == "Upper Body"{
                        ForEach(upperBody, id:\.self) { upperbody in
                            CustomRowSelectionTest(title: upperbody, selectedItem: $selectedSub){ title in
                                print(title)
                            }
                            .padding()
                        }
                    } else if pickerSelectionIndex == "Lower Body" {
                        ForEach(lowerBody, id:\.self) { lowerbody in
                            CustomRowSelectionTest(title: lowerbody, selectedItem: $selectedSub) { title in
                                print(title)
                            }
                            .padding()
                        }
                    }
                    
                }
                .cornerRadius(30)
                Spacer()
                //MARK: - ADD BUTTON
                Button (action: {
                    print("ADD Button")
                    
                    if selectedSub == "" {
                        showAlert = true
                    } else {
                    }
                }, label: {
                    HStack {
                        Text("Next")
                            .bold()
                            .foregroundColor(.blue)
                    }//: HSTACK

                        .fontWeight(.bold)
                })
                .font(.title3)
                .foregroundColor(.blue)
                .padding(.horizontal)
                .padding(.vertical, 4)
                .background(.blue.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .alert(isPresented: $showAlert) { () -> Alert in
                        Alert(title: Text("Select A Sub"))
                    }
            }//: VSTACK
            .padding()
        }

    }
    
    //MARK: - SUBVIEW
    private func newItemSelection(compareNumber: Binding<Int>, selectedItemNumber: Int, title: String) -> some View {
        Group {
            Button {
                withAnimation {
                    compareNumber.wrappedValue = selectedItemNumber
                }
            } label: {
                HStack {
                    Text(title)
                        .foregroundColor(.primary)
                        .bold()
                        .minimumScaleFactor(0.2)
                }//: HSTACK
                .padding()
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 8).foregroundColor(compareNumber.wrappedValue == selectedItemNumber ? Color(UIColor.tertiarySystemBackground) : .gray.opacity(0.1)).shadow(color: .black.opacity(0.3), radius: 1))
            }
        }
    }
    
    //MARK: - FUNCTION
    
    func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }


}

    //MARK: - PREVIEW
struct NewSkillView_Previews: PreviewProvider {
    static var previews: some View {
        NewSkillView(isNewSubmissionOpen: .constant(false), noGiOrGiSelection: .constant(false))
    }
}
