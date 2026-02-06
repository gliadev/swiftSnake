//
//  RankingView.swift
//  swiftSnake
//
//  Created by Adolfo on 20/5/25.
//

import SwiftUI

struct RankingView: View {
    @ObservedObject var viewModel: RankingViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🏆 Top 10 Ranking")
                .font(.largeTitle)
                .bold()
                .padding(.top)
                .accessibilityAddTraits(.isHeader)
                .accessibilityLabel("Top 10 Ranking")

            if viewModel.hasRecords {
                List(Array(viewModel.topRecords.prefix(10).enumerated()), id: \.element.id) { index, record in
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(record.name)
                                .font(.headline)
                            Spacer()
                            Text("Puntos: \(record.score)")
                                .font(.subheadline)
                        }
                        HStack {
                            Text("Tiempo: \(viewModel.formatTime(record.duration))")
                            Spacer()
                            Text("Eficiencia: \(String(format: "%.2f", record.efficiency))")
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)

                        Text("Fecha: \(viewModel.formatDate(record.date))")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 4)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Puesto \(index + 1): \(record.name), \(record.score) puntos, tiempo \(viewModel.formatTime(record.duration)), eficiencia \(String(format: "%.2f", record.efficiency))")
                }
                .listStyle(.insetGrouped)
            } else {
                Spacer()
                Text("No hay registros aún.")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                Spacer()
            }
        }
        .padding()
    }
}

#Preview {
    RankingView(viewModel: RankingViewModel(from: SnakeGameModel()))
}
