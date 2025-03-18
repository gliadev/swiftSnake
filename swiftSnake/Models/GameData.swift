//
//  GameData.swift
//  swiftSnake
//
//  Created by Adolfo on 18/3/25.
//  Mi modelo para guardar datos

import Foundation
import SwiftData


@Model
class GameData {
    var highScore: Int
    var lastScore: Int
    var lastPlayed: Date
    
    init(highScore: Int = 0, lastScore: Int = 0, lastPlayed: Date = Date()) {
        self.highScore = highScore
        self.lastScore = lastScore
        self.lastPlayed = lastPlayed
    }
}
