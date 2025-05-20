//
//  RankingViewModel.swift
//  swiftSnake
//
//  Created by Adolfo on 20/5/25.
//

import Foundation
import SwiftUI

class RankingViewModel: ObservableObject {
    @Published var topRecords: [ScoreRecord] = []

    init(from gameModel: SnakeGameModel) {
        self.topRecords = gameModel.ranking.map {
            ScoreRecord(name: $0.name, score: $0.score, duration: $0.duration, date: $0.date)
        }
    }

    var hasRecords: Bool {
        !topRecords.isEmpty
    }

    func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
