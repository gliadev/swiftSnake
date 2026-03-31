//
//  WelcomeView.swift
//  swiftSnake
//
//  Created by Adolfo on 18/3/25.
//

import SwiftUI
import SwiftData

struct WelcomeView: View {
    @Query(sort: [SortDescriptor<ScoreRecord>(\.score, order: .reverse)]) var topScores: [ScoreRecord]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(spacing: 20) {
                    Text("SwiftSnake")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .bold()
                        .accessibilityAddTraits(.isHeader)

                    Text("🐍")
                        .font(.system(size: 80))
                        .accessibilityHidden(true)

                    Spacer().frame(height: 40)

                    HStack(spacing: 20) {
                        NavigationLink(destination: GameView()) {
                            Text("Jugar")
                                .font(.title)
                                .frame(width: 200, height: 50)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .accessibilityLabel("Jugar")
                        .accessibilityHint("Comienza una nueva partida de Snake")
        // TODO: Mostrar botón Ranking cuando esté funcional
                        /*
                        NavigationLink(destination: RankingView(viewModel: RankingViewModel(from: SnakeGameModel()))) {
                            Text("Ranking")
                                .font(.title)
                                .frame(width: 200, height: 50)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                         */
                    }

                    Spacer().frame(height: 40)

                    Text("🏆 Top 5 Puntuaciones")
                        .font(.title2)
                        .foregroundColor(.white)
                        .bold()
                        .accessibilityAddTraits(.isHeader)
                        .accessibilityLabel("Top 5 Puntuaciones")

                    VStack {
                        if topScores.isEmpty {
                            Text("Sin puntuaciones aún")
                                .font(.body)
                                .foregroundColor(.gray)
                        } else {
                            ForEach(Array(topScores.prefix(5).enumerated()), id: \.element.id) { index, record in
                                Text("\(record.name): \(record.score) puntos")
                                    .font(.body)
                                    .foregroundColor(.white)
                                    .accessibilityLabel("Puesto \(index + 1): \(record.name), \(record.score) puntos")
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview {
    WelcomeView()
}
