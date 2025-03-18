//
//  WelcomeView.swift
//  swiftSnake
//
//  Created by Adolfo on 18/3/25.
//

import SwiftUI

struct WelcomeView: View {
    let topScores = [
        ("Adolfo", 150),
        ("Jon", 120),
        ("Carlos", 100),
        ("Patatin", 90),
        ("Patata", 80)
    ]

    var body: some View {
        NavigationStack {  // Agregar NavigationStack para gestionar la navegación
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("SwiftSnake")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .bold()
                    
                    Text("🐍")
                        .font(.system(size: 80)) // Tamaño más grande para el emoji
                    
                    Spacer().frame(height: 40)

                    HStack(spacing: 20) {
                        NavigationLink(destination: GameView()) {  // Usar NavigationLink
                            Text("Jugar")
                                .font(.title)
                                .frame(width: 200, height: 50)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            // Acción para ver el ranking
                        }) {
                            Text("Ranking")
                                .font(.title)
                                .frame(width: 200, height: 50)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }

                    Spacer().frame(height: 40)

                    Text("🏆 Top 5 Puntuaciones")
                        .font(.title2)
                        .foregroundColor(.white)
                        .bold()

                    VStack {
                        ForEach(topScores, id: \.0) { score in
                            Text("\(score.0): \(score.1) puntos")
                                .font(.body)
                                .foregroundColor(.white)
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
