//
//  SnakeGameModel.swift
//  swiftSnake
//
//  Created by Adolfo on 18/3/25.
//

import Foundation
import SwiftUI

// Enum para las direcciones de la serpiente
enum Direction {
    case up, down, left, right
}

// Modelo del juego
class SnakeGameModel: ObservableObject {
    @Published var snakePositions: [CGPoint] = [CGPoint(x: 100, y: 100)]
    @Published var foodPosition: CGPoint = CGPoint(x: 200, y: 200)
    @Published var direction: Direction = .right
    @Published var isGameOver: Bool = false

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
    }

    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { _ in
            self.moveSnake()
        }
    }

    func moveSnake() {
        guard let head = snakePositions.first else { return }
        var newHead = head

        switch direction {
        case .up: newHead.y -= gridSize
        case .down: newHead.y += gridSize
        case .left: newHead.x -= gridSize
        case .right: newHead.x += gridSize
        }

        // Verificar colisiones con los bordes
        if newHead.x < 0 || newHead.x >= screenWidth || newHead.y < 0 || newHead.y >= screenHeight {
            gameOver()
            return
        }

        // Verificar colisión con sí misma
        if snakePositions.contains(newHead) {
            gameOver()
            return
        }

        snakePositions.insert(newHead, at: 0)
        if newHead == foodPosition {
            spawnFood()
        } else {
            snakePositions.removeLast()
        }
    }

    func spawnFood() {
        var newFoodPosition: CGPoint
        repeat {
            newFoodPosition = CGPoint(x: CGFloat.random(in: 0..<screenWidth), y: CGFloat.random(in: 0..<screenHeight))
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
    }
}
