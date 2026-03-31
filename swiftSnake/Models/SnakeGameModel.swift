//
//  SnakeGameModel.swift
//  swiftSnake
//
//  Created by Adolfo on 18/3/25.
//

import Foundation
import SwiftUI
import SwiftData

// Enum para las direcciones de la serpiente
enum Direction {
    case up, down, left, right
}

// Estructura para un registro de ranking
struct GameRecord: Codable, Identifiable {
    let id: UUID
    let name: String
    let score: Int
    let duration: TimeInterval
    let date: Date

    var efficiency: Double {
        return duration > 0 ? Double(score) / duration : 0
    }
    
    init(id: UUID = UUID(), name: String, score: Int, duration: TimeInterval, date: Date) {
           self.id = id
           self.name = name
           self.score = score
           self.duration = duration
           self.date = date
       }
}

// Modelo del juego
class SnakeGameModel: ObservableObject {
    @Published var snakePositions: [CGPoint] = [CGPoint(x: 100, y: 100)]
    @Published var foodPosition: CGPoint = CGPoint(x: 200, y: 200)
    @Published var direction: Direction = .right
    @Published var isGameOver: Bool = false
    @Published var score: Int = 0
    @Published var elapsedTime: TimeInterval = 0
    @Published var ranking: [GameRecord] = []
    private var startTime: Date?
    private var timeTimer: Timer?

    private var timer: Timer?
    let gridSize: CGFloat = 20
    let screenWidth: CGFloat = 400  // Ajustar según la pantalla real
    let screenHeight: CGFloat = 800 // Ajustar según la pantalla real

    init() {
        startGame()
    }

    func startGame() {
        snakePositions = [CGPoint(x: 100, y: 100)]
        foodPosition = CGPoint(x: 200, y: 200)
        direction = .right
        isGameOver = false
        startTimer()
        score = 0
        elapsedTime = 0
        startTime = Date()
        timeTimer?.invalidate()
        timeTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            guard let start = self.startTime else { return }
            self.elapsedTime = Date().timeIntervalSince(start)
        }
    }

    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { _ in
            self.moveSnake()
        }
    }

    /// Mueve la serpiente en la dirección actual, gestiona colisiones y crecimiento.
    func isClose(_ a: CGPoint, _ b: CGPoint) -> Bool {
        return abs(a.x - b.x) < gridSize / 2 && abs(a.y - b.y) < gridSize / 2
    }

    func moveSnake() {
        guard let head = snakePositions.first else { return }
        var newHead = head

        // Mover en la dirección actual
        switch direction {
        case .up: newHead.y -= gridSize
        case .down: newHead.y += gridSize
        case .left: newHead.x -= gridSize
        case .right: newHead.x += gridSize
        }

        // Verificar colisiones con los bordes
        let margin: CGFloat = 4
        if newHead.x < margin || newHead.x >= screenWidth - margin ||
           newHead.y < margin || newHead.y >= screenHeight - margin {
            gameOver()
            return
        }

        // Verificar colisión con sí misma
        if snakePositions.contains(newHead) {
            gameOver()
            return
        }

        snakePositions.insert(newHead, at: 0)

        if isClose(newHead, foodPosition) {
            score += 10
            spawnFood()
            // no eliminamos la cola para crecer
        } else {
            snakePositions.removeLast()
        }
    }

    /// Genera una nueva posición de comida que no colisione con la serpiente ni esté fuera del grid.
    func spawnFood() {
        var newFoodPosition: CGPoint
        repeat {
            let margin: CGFloat = 4
            let xRange = Int((screenWidth - margin * 2) / gridSize)
            let yRange = Int((screenHeight - margin * 2) / gridSize)

            let x = margin + CGFloat(Int.random(in: 0..<xRange)) * gridSize
            let y = margin + CGFloat(Int.random(in: 0..<yRange)) * gridSize

            newFoodPosition = CGPoint(x: x, y: y)
        } while snakePositions.contains(newFoodPosition)

        foodPosition = newFoodPosition
    }

    func changeDirection(_ newDirection: Direction) {
        // Evitar moverse en dirección opuesta inmediata
        if (direction == .up && newDirection != .down) ||
           (direction == .down && newDirection != .up) ||
           (direction == .left && newDirection != .right) ||
           (direction == .right && newDirection != .left) {
            direction = newDirection
        }
    }

    func gameOver() {
        isGameOver = true
        timer?.invalidate()
        timeTimer?.invalidate()
    }
    
    /// Guarda un nuevo registro en el ranking si entra en el top 10
    func saveToRanking(name: String, modelContext: ModelContext) {
        let record = ScoreRecord(
            name: name,
            score: score,
            duration: elapsedTime,
            date: Date()
        )

        modelContext.insert(record)

        do {
            try modelContext.save()
        } catch {
            print("⚠️ Error al guardar en SwiftData: \(error)")
        }
    }

        
    /// Determina si la puntuación actual merece estar en el top 10
    func shouldShowNameEntry() -> Bool {
        if ranking.count < 10 {
            return true
        }

        guard let lowestTop = ranking.last else {
            return true
        }

        return score > lowestTop.score || (score == lowestTop.score && elapsedTime < lowestTop.duration)
    }
}

