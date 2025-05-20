//
//  GHUDViewModel.swift .swift
//  swiftSnake
//
//  Created by Adolfo on 20/5/25.
//

import Foundation


import Foundation

class GHUDViewModel: ObservableObject {
    @Published var scoreText: String = "Puntuación: 0"
    @Published var timeText: String = "Tiempo: 00:00"

    func update(score: Int, elapsedTime: TimeInterval) {
        scoreText = "Puntuación: \(score)"
        timeText = formatTime(elapsedTime)
    }

    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
