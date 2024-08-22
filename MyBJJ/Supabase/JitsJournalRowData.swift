//
//  JitsJournalRowData.swift
//  MyBJJ
//
//  Created by Josh Bourke on 25/6/2023.
//

import Foundation
import SwiftUI


struct JitsJournalRowData: Codable, Hashable {
    
    let id: UUID
    let user_id: UUID
    let isSub: Bool
    let subArea: String
    let submissionName: String
    let beltRank: Int
    let isNote: Bool
    let note: String
    let isCompetition: Bool
    let hasPhoto: Bool
    let winLossOrDraw: String // this is so the user can set win points loss points draw. win sub loss sub
}
