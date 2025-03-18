//
//  GameView.swift
//  swiftSnake
//
//  Created by Adolfo on 18/3/25.
//

import SwiftUI

struct GameView: View {
    @StateObject private var game = SnakeGameModel() // Vincular con el modelo

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
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

            // Mostrar "Game Over" si el juego ha terminado
            if game.isGameOver {
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
        .onAppear {
            game.startGame() // Iniciar el juego cuando se carga la vista
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
    }
}

#Preview {
    GameView()
}
