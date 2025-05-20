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
            TextField("Tu nombre", text: $playerName)
                .textFieldStyle(.roundedBorder)
                .padding()

            Button("Guardar") {
                if !playerName.isEmpty {
                    print("💾 Guardando partida: \(playerName), score: \(gameModel.score)")

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
                        print("⚠️ Error al guardar en SwiftData: \(error)")
                    }
                }
            }
            .padding()
            .background(Color.gray)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }
}
