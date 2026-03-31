//
//  GameView.swift
//  swiftSnake
//
//  Created by Adolfo on 18/3/25.
//

import SwiftUI

struct GameView: View {
    @StateObject private var game = SnakeGameModel()
    @StateObject private var hudViewModel = GHUDViewModel()
    @State private var showNameEntryView = false

    var body: some View {
        VStack {
            GameHUDView(hudViewModel: hudViewModel)

            ZStack {
                Rectangle()
                    .fill(Color.black)
                    .border(Color.gray.opacity(0.7), width: 4)
                    .ignoresSafeArea()

                // Dibuja la serpiente
                ForEach(game.snakePositions, id: \.self) { position in
                    Rectangle()
                        .fill(Color.green)
                        .frame(width: 20, height: 20)
                        .position(position)
                }

                // Dibuja la comida
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 20, height: 20)
                    .position(game.foodPosition)

                if game.isGameOver && !showNameEntryView {
                    VStack {
                        Text("GAME OVER")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .padding()

                        Button("Reiniciar") {
                            game.startGame()
                        }
                        .font(.title)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .accessibilityLabel("Reiniciar partida")
                        .accessibilityHint("Comienza una nueva partida de Snake")
                    }
                }
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(gameAccessibilityLabel)
            .accessibilityAction(named: "Mover arriba") {
                game.changeDirection(.up)
            }
            .accessibilityAction(named: "Mover abajo") {
                game.changeDirection(.down)
            }
            .accessibilityAction(named: "Mover izquierda") {
                game.changeDirection(.left)
            }
            .accessibilityAction(named: "Mover derecha") {
                game.changeDirection(.right)
            }
            .gesture(
                DragGesture().onEnded { value in
                    let horizontalAmount = value.translation.width
                    let verticalAmount = value.translation.height

                    if abs(horizontalAmount) > abs(verticalAmount) {
                        game.changeDirection(horizontalAmount > 0 ? .right : .left)
                    } else {
                        game.changeDirection(verticalAmount > 0 ? .down : .up)
                    }
                }
            )
            .onChange(of: game.score) { _, newScore in
                hudViewModel.update(score: newScore, elapsedTime: game.elapsedTime)
                AccessibilityNotification.Announcement(
                    "Puntuación: \(newScore)"
                ).post()
            }
            .onChange(of: game.elapsedTime) { _, _ in
                hudViewModel.update(score: game.score, elapsedTime: game.elapsedTime)
            }
        }
        .onAppear {
            game.startGame()
            hudViewModel.update(score: game.score, elapsedTime: game.elapsedTime)
        }
        .onChange(of: game.isGameOver) { _, newValue in
            if newValue {
                AccessibilityNotification.Announcement(
                    "Fin del juego. Puntuación final: \(game.score)"
                ).post()
                if game.shouldShowNameEntry() {
                    showNameEntryView = true
                }
            }
        }
        .sheet(isPresented: $showNameEntryView) {
            NameEntryView(gameModel: game)
        }
    }

    /// Etiqueta de accesibilidad dinámica para el área de juego
    private var gameAccessibilityLabel: String {
        if game.isGameOver {
            return "Fin del juego. Puntuación: \(game.score). Usa el botón Reiniciar para jugar de nuevo."
        }
        return "Área de juego Snake. Puntuación: \(game.score). Usa acciones personalizadas para cambiar dirección."
    }
}

#Preview {
    GameView()
}
