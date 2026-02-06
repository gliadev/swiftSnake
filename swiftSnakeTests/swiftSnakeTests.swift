//
//  swiftSnakeTests.swift
//  swiftSnakeTests
//
//  Created by Adolfo on 18/3/25.
//

import Testing
import Foundation
@testable import swiftSnake

@MainActor
struct swiftSnakeTests {

    @Test func scoreRecordEfficiencyShouldBeCorrect() async throws {
        let record = ScoreRecord(name: "Tester", score: 120, duration: 30, date: .now)
        #expect(record.efficiency == 4.0)
    }

    @Test func scoreRecordEfficiencyZeroDuration() async throws {
        let record = ScoreRecord(name: "Tester", score: 50, duration: 0, date: .now)
        #expect(record.efficiency == 0.0)
    }

    @Test func formatDateShouldReturnString() async throws {
        let viewModel = RankingViewModelPlaceholder()
        let formatted = viewModel.formatDate(Date(timeIntervalSince1970: 0))
        #expect(!formatted.isEmpty)
    }

    @Test func directionChangeBlocksOpposite() async throws {
        let game = SnakeGameModel()
        game.direction = .right
        game.changeDirection(.left) // Opuesto — no debe cambiar
        #expect(game.direction == .right)
        game.changeDirection(.up) // Válido — debe cambiar
        #expect(game.direction == .up)
    }
}

// Mock para pruebas de formato
struct RankingViewModelPlaceholder {
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
