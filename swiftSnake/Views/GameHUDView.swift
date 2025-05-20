//
//  GameHUDView.swift
//  swiftSnake
//
//  Created by Adolfo on 19/5/25.
//

import SwiftUI

struct GameHUDView: View {
    @ObservedObject var hudViewModel: GHUDViewModel
    var body: some View {
        HStack {
            Text(hudViewModel.scoreText)
                .font(.headline)
                .foregroundColor(.white)

            Spacer()

            Text(hudViewModel.timeText)
                .font(.headline)
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.black.opacity(0.7))
    }
}

#Preview {
    GameHUDView(hudViewModel: GHUDViewModel())
}
