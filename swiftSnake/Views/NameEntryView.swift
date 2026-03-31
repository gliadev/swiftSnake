//
//  NameEntryView.swift
//  swiftSnake
//
//  Created by Adolfo on 20/5/25.
//

import SwiftUI
import SwiftData

struct NameEntryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var gameModel: SnakeGameModel
    @State private var playerName: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Nueva puntuación: \(gameModel.score)")
                .font(.title2)
                .bold()
                .accessibilityAddTraits(.isHeader)

            TextField("Tu nombre", text: $playerName)
                .textFieldStyle(.roundedBorder)
                .padding()
                .accessibilityLabel("Nombre del jugador")
                .accessibilityHint("Escribe tu nombre para guardar la puntuación")

            Button("Guardar") {
                if !playerName.isEmpty {
                    let record = ScoreRecord(
                        name: playerName,
                        score: gameModel.score,
                        duration: gameModel.elapsedTime,
                        date: Date()
                    )

                    modelContext.insert(record)

                    do {
                        try modelContext.save()
                        dismiss()
                    } catch {
                        print("Error al guardar en SwiftData: \(error)")
                    }
                }
            }
            .padding()
            .background(playerName.isEmpty ? Color.gray.opacity(0.5) : Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)
            .disabled(playerName.isEmpty)
            .accessibilityLabel("Guardar puntuación")
            .accessibilityHint(playerName.isEmpty
                ? "Escribe tu nombre primero para habilitar este botón"
                : "Guarda tu puntuación de \(gameModel.score) puntos")
        }
        .padding()
    }
}
