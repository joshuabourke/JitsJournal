//
//  JitJournalListItem.swift
//  MyBJJ
//
//  Created by Josh Bourke on 3/9/2023.
//

import SwiftUI

struct JitJournalListItem: View {
    
    let rowData: JitsJournalRowData
    
    var body: some View {
        if rowData.isSub {
            VStack(alignment: .leading){
                HStack {
                    Image(systemName: "figure.stand")
                        .font(.title)
                    VStack(alignment: .leading) {
                        Text(rowData.submissionName)
                            .font(.title2)
                            .bold()
                        Text(rowData.subArea)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Text("Rank")
                }
            }//: VSTACK
        }
    }
    
    //MARK: - FUNCS

    func checkSubmissionArea() -> (CGFloat, CGFloat) {
        
        var offsetY: CGFloat = 0
        
        var listViewItemSubAreaImageOffsetY: CGFloat = 0
        
        if rowData.subArea == "chokehold" {
            listViewItemSubAreaImageOffsetY = 15
            offsetY = -15
        }
        if rowData.subArea == "upper" {
            listViewItemSubAreaImageOffsetY = 1
            offsetY = -1
        }
        if rowData.subArea == "lower" {
            listViewItemSubAreaImageOffsetY = -17.5
            offsetY = 17.5
        }
        
        return (offsetY, listViewItemSubAreaImageOffsetY)
    }
}

struct JitJournalListItem_Previews: PreviewProvider {
    static var previews: some View {
        JitJournalListItem(rowData: JitsJournalRowData(id: UUID(), user_id: UUID(), isSub: true, subArea: "Upper", submissionName: "Arm Bar", beltRank: 1, isNote: false, note: "", isCompetition: false, hasPhoto: false, winLossOrDraw: "win"))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
