//
//  GameView.swift
//  swiftSnake
//
//  Created by Adolfo on 18/3/25.
//

import SwiftUI

struct GameView: View {
    @StateObject private var game = SnakeGameModel() // Vincular con el modelo
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
                    }
                }
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
            .onChange(of: game.score) { _, _ in
                hudViewModel.update(score: game.score, elapsedTime: game.elapsedTime)
            }
            .onChange(of: game.elapsedTime) { _, _ in
                hudViewModel.update(score: game.score, elapsedTime: game.elapsedTime)
            }
        }
        .onAppear {
            game.startGame() // Iniciar el juego cuando se carga la vista
            hudViewModel.update(score: game.score, elapsedTime: game.elapsedTime)
        }
        .onChange(of: game.isGameOver) { _, newValue in
            if newValue && game.shouldShowNameEntry() {
                showNameEntryView = true
            }
        }
        .sheet(isPresented: $showNameEntryView) {
            NameEntryView(gameModel: game)
        }
    }
}

#Preview {
    GameView()
}
