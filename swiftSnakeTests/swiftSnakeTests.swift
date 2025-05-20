//
//  swiftSnakeTests.swift
//  swiftSnakeTests
//
//  Created by Adolfo on 18/3/25.
//

import Testing
import Foundation
@testable import swiftSnake

struct swiftSnakeTests {

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }
    
    @Test func scoreRecordEfficiencyShouldBeCorrect() async throws {
            let record = ScoreRecord(name: "Tester", score: 120, duration: 30, date: .now)
            #expect(record.efficiency == 4.0)
        }

        @Test func formatDateShouldReturnString() async throws {
            let viewModel = RankingViewModelPlaceholder()
            let formatted = viewModel.formatDate(Date(timeIntervalSince1970: 0))
            #expect(!formatted.isEmpty)
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

