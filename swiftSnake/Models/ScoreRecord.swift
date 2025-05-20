//
//  GameRecord.swift
//  swiftSnake
//
//  Created by Adolfo on 20/5/25.
//

import Foundation
import SwiftData

@Model
class ScoreRecord {
    var id: UUID = UUID()
    var name: String
    var score: Int
    var duration: TimeInterval
    var date: Date

    var efficiency: Double {
        duration > 0 ? Double(score) / duration : 0
    }

    init(name: String, score: Int, duration: TimeInterval, date: Date) {
        self.name = name
        self.score = score
        self.duration = duration
        self.date = date
    }
}
