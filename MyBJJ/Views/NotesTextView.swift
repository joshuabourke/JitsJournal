//
//  NotesTextView.swift
//  MyBJJ
//
//  Created by Josh Bourke on 2/4/2023.
//

import SwiftUI

struct NotesTextView: View {
    //MARK: - PROPERTIES
    
    @Binding var textFieldNotes: String
    
    //MARK: - BODY
    var body: some View {
        VStack{
            HStack{
                Text("Notes")
                    .font(.title)
                    .bold()
                Spacer()
            }//: HSTACK
            TextEditor(text: $textFieldNotes)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .multilineTextAlignment(.leading)
                .lineLimit(0)
                .overlay(
                    VStack{
                        HStack{
                            Text("Write your note here...")
                                .font(.body)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.leading)
                            Spacer()
                            }//: HSTACK
                        Spacer()
                    }//: VSTACK
                        .padding(8)
                        .opacity(textFieldNotes.isEmpty ? 1.0 : 0)
                    )
                .padding()
//                .cornerRadius(10)
//                .shadow(radius: 2)
            Spacer()
        }//: VSTACK
        .padding()
    }
}
    //MARK: - PREVIEW
struct NotesTextView_Previews: PreviewProvider {
    static var previews: some View {
        NotesTextView(textFieldNotes: .constant(""))
    }
}
