//
//  ProfileView.swift
//  MyBJJ
//
//  Created by Josh Bourke on 13/6/2022.
//

import SwiftUI
import CoreData

//This is going to be used to make the new reminders list using coredata
struct LocalReminders {
    var id = UUID()
    var hours: Int
    var mintues: Int
    var dayOfTheWeek: Int
}

//MARK: - THINGS TO DO
//1.
//Need to make a delete user button. The users should be able to delete their accounts and all their data if they want to. Gives them more freedom in what happens with their data
//THIS HAS BEEN ACHEIVED!!!

//2.
//Also might need to set to the user a number for thier belt rank. That way i can save their belt rank to the users id, whilest also logging subs to their belt rank
//Thinking about this one ^ could make a function that takes in a number and returns a beltView.
//I will need to write out all the possible outcomes for the for the beltView
//e.g white, white 1 stripe, white 2 stripe, white 3 stripe and soo on. with all the different combinations of belt.

//Also need to find a way to get more into this view, as in anything I have tried to add recently has been throwing an error.
//FIXED THIS PROBLEM (extracted the view and also grouped everything.)

//3. Wanting to add a background color to the grouping on the profile view kinda like how i have done in fructus.
struct ProfileView: View {
    
    //MARK: - CORE DATA FOR REMINDERS
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var authService: AuthService
    @FetchRequest(entity: UserReminders.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \UserReminders.reminderDay, ascending: true)])
    
    
    var savedReminders: FetchedResults<UserReminders>
    
    //MARK: - PROPERTIES
    @State var hours: Int = 0
    @State var mintues: Int = 0
    @State var dayOfTheWeek: Int = 0

    @State var didTapAddReminders: Bool = false
    @State var didTapDeleteAccountButton: Bool = false
    

    @State var beltRankNumber: Int = 0
    
    //MARK: - APP STORAGE FOR SUPABASE
    @AppStorage("isUserLoggedIn") var isUserLoggedIn = false
    @AppStorage("userId") var userId = ""
    @AppStorage("userEmail") var userEmail = ""
    //MARK: - BODY
    var body: some View {
        ScrollView(showsIndicators: false) {
            profileView
                .background(.thickMaterial)
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .background(colorScheme == .dark ? Color.black: Color(UIColor.secondarySystemBackground))
//                .ignoresSafeArea()
            
            .sheet(isPresented: $didTapAddReminders) {
                NotificationSettingsView(hours: $hours, mintues: $mintues, dayOfTheWeek: $dayOfTheWeek)
            }//: Sheet
            .navigationTitle("Profile")
        }//: Scroll
    }
    
    //MARK: - EXTRACTED VIEWS
    private var profileView: some View {
        VStack{
            Group {
                VStack {
                    HStack {
                        Text("Rank")
                            .font(.title).bold()
                        Spacer()
                        Image(systemName: "figure.stand")
                    }//: HSTACK
                    HStack {
                        Text("Tap to select your Brazilian Jiu jitsu belt rank")
                            .font(.caption)
                            .foregroundColor(.gray)
                        .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                    }//: HSTACK
                    Divider().padding(.vertical,4)
                //MARK: - BELT RANK VIEW
                //This view is just to display the users belt rank. I havent started collecting data based on the belt rank but that is a possibility in the future.
                    BeltViewMenu(beltRankNumber: $beltRankNumber)
                //This beltview menu in the profile view will allow users to change their belt rank. By tapping on the belt in the profile view it will present them with a menu where they can change their belt rank.
                    .contextMenu {
                        Button {
                            print("Change Belt Settings")
                        } label: {
                            Label("Change belt", systemImage: "person")
                        }
                    }
                }//: VSTACK
            }//: BELTVIEW GROUPING
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(UIColor.tertiarySystemBackground).clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous)))
            Spacer()
            Group{
                VStack{
                    HStack {
                        Text("Reminders")
                            .font(.title).bold()
                        Spacer()
                        Image(systemName: "bell")
                    }//: HSTACK
                    HStack {
                        Text("Reminders can be set to help remind you on when you should log your BJJ progress")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                    }//: HSTACK
                    Divider().padding(.vertical,4)
            //MARK: - LIST OF REMINDERS
            //Thinking of using this list to display to the user what reminders they have active at the moment.
                List{
                    ForEach(savedReminders, id:\.self.reminderID) { reminders in
                        ReminderListViewItem(hours: reminders.reminderHours, minutes: reminders.reminderMinutes, dayOfTheWeek: reminders.reminderDay)
                    }
                    .onDelete(perform: removeFromCoreData)
                }//: LIST
                .frame(height: 300)
                .cornerRadius(30)
                .listStyle(.insetGrouped)
                .padding(.bottom)
                //MARK: - ADD REMINDERS - BUTTON
                //This button displays a sheet that the user can then select a time and day of the week they would like to be reminded to log their progress.
                Button{
                    print("Add new notification")
                    didTapAddReminders.toggle()
                } label: {
                    Image(systemName: "bell")
                    Text("Add Reminder")
                }
                .buttonStyle(.borderedProminent)

                }//: VSTACK
            }//: REMINDER GROUP WITH LIST
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(UIColor.tertiarySystemBackground).clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous)))

            //MARK: - REMOVE REMINDERS BUTTON
            //This button below is for removing all of the added reminders that the user has set. It currently only removes all of them not just a specific one.
            //                Button {
            //                    print("Remove all added notifications *Pressed*")
            //                    NotificationManager.instance.cancelAllNotifications()
            //                } label: {
            //                    Image(systemName: "bell.slash")
            //                        .font(.body.bold())
            //                    Text("Delete reminders")
            //                        .fontWeight(.bold)
            //                        .foregroundColor(.white)
            //                }
            //                .buttonStyle(RedRectangleButton())
            //                .frame(width: 220, height: 45)
            //                .padding()
            //THIS IS COMMENTED OUT FOR THE TIME BEING. I would also like this to remove all the saved items in the list above this.
            Group {
                VStack {
                    HStack {
                        Text("Support")
                            .font(.title).bold()
                        Spacer()
                        Image(systemName: "ant")
                    }//: HSTACK
                    HStack{
                        Text("If you come across any bugs or issues with MyBJJ, feel free to send an email through to support.")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                    }//: HSTACK
                    Divider().padding(.vertical,4)
                    //MARK: - MAILTO LINK
                    //This link below should send the user to their default email application. Once they are there it will prefill a support ticket for them as in the subject of the email and the emial address.
                    Button  {
                        print("Feedback button pressed")
                        sendEmailToSupport()
                    } label: {
                        Image(systemName: "ant")
                        Text("Help!")
                            .foregroundColor(.white)
                    }
                    .buttonStyle(.borderedProminent)
                }//: VSTACK
            }//: FEEDBACK GROUP
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(UIColor.tertiarySystemBackground).clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous)))
            Group{
                VStack{
                    HStack {
                        Text("User Options")
                            .font(.title).bold()
                        Spacer()
                        Image(systemName: "person.fill")
                    }//: HSTACK
                    HStack{
                        Text("Log out of MyBJJ, all submissions and progress will be saved to your account.")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                    }//: HSTACK
                    Divider().padding(.vertical,4)

                //MARK: - LOG OUT BUTTON
                //The button below handles the users log out and stops displaying all of the users data.
                Button(role: .destructive) {
                    print("Log out pressed")
                    Task {
                        do{
                            try await authService.signOut()
                        } catch {
                            print("### Error trying to sign the user out. \(error.localizedDescription)")
                        }
                    }
//                    Task{
//                     await supabaseModel.signOut { signOut in
//                            if signOut{
//                               print("### --- Sign Out Successful")
//                                //Setting App Storage properties back to default
//                                isUserLoggedIn = false
//                                userId = ""
//                                userEmail = ""
//                            } else {
//                               print("### --- Failed Sign Out")
//                            }
//                        }
//                    }

                    
                } label: {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                    Text("Log Out")
                        .foregroundColor(.white)
                }
                .buttonStyle(.borderedProminent)

                }//: VSTACK
            }//: LOGOUT GROUPING
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(UIColor.tertiarySystemBackground).clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous)))
        }//: VSTACK
        .padding()

    }//: EXTRACTED PROFILE VIEW.
    
    
    //MARK: - FUNCTIONS
    //MARK: - MAILTO FUNC
    //This function should either open up the mail app or.. It should open the default mail app the user has set on their phone. It will prefill the email section with the support email whilst also filling the subject field with "MyBJJ feeback form"
    func sendEmailToSupport() {
        let mailtoString = "mailto:mybjj.apphelp@gmail.com?subject=MyBJJ Feedback Form".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let mailtoURL = URL(string: mailtoString!)!
        if UIApplication.shared.canOpenURL(mailtoURL) {
            UIApplication.shared.open(mailtoURL, options: [:], completionHandler: nil)
        }
    }
        
    //MARK: - CORE DATA FUNCTIONS
    //Here are the Coredata functions ill be using.
    //1. addItem just creates a new Reminders item and saves it into coredata under Reminders.
    //2. save bascially just saves the changes to coredata
    //3. removeFromCoreData removes an item at a specific offset or index in a list. It will also be removed from coredata.
    func save() throws {
        try self.moc.save()
    }//:SAVE
    
    func removeFromCoreData(at offsets: IndexSet) {
        for index in offsets {
            let storedReminders = savedReminders[index]
            moc.delete(storedReminders)
            NotificationManager.instance.cancelSpecificNotification(notificationID: storedReminders.reminderID.uuidString)
            do{
            try save()
            } catch {
                print("\(error.localizedDescription)")
            }
        }
    }//: REMOVE FROM CORE DATA
    
}

    //MARK: - PREVIEW
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
