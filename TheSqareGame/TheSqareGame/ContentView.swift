//
//  ContentView.swift
//  TheSqareGame
//
//  Created by Gamika Punsisi on 2024-12-15.
//
//
//import SwiftUI
//
//struct ContentView: View {
//    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, Gamika!")
//        }
//        .padding()
//    }
//}
//
//#Preview {
//    ContentView()
//}
//

import SwiftUI

struct ContentView: View {
    @State private var grid: [[Bool]] = Array(repeating: Array(repeating: false, count: 3), count: 3) // 3x3 grid
    @State private var score: Int = 0
    @State private var targetRow: Int = Int.random(in: 0..<3)
    @State private var targetCol: Int = Int.random(in: 0..<3)
    @State private var feedback: String = "Tap the red square!"
    @State private var gameWon: Bool = false
    private let winningScore = 4 // Set the score to win

    var body: some View {
        VStack {
            Text("The Square Game")
                .font(.largeTitle)
                .padding()

            Text("Score: \(score)")
                .font(.title2)
                .padding()

            if gameWon {
                Text("🎉 Congratulations! You won! 🎉")
                    .foregroundColor(.green)
                    .font(.headline)
                    .padding()
            } else {
                Text(feedback)
                    .foregroundColor(.blue)
                    .font(.headline)
                    .padding()
            }

            // 3x3 Grid of squares
            ForEach(0..<3, id: \.self) { row in
                HStack {
                    ForEach(0..<3, id: \.self) { col in
                        Rectangle()
                            .fill(grid[row][col] ? Color.green : (row == targetRow && col == targetCol ? Color.red : Color.gray))
                            .frame(width: 100, height: 100) // Box size
                            .onTapGesture {
                                handleTap(row: row, col: col)
                            }
                            .disabled(gameWon) // Disable interaction after winning
                    }
                }
            }
            .padding()

            Button(action: resetGame) {
                Text(gameWon ? "Play Again" : "Reset Game")
                    .padding()
                    .background(gameWon ? Color.green : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
    }

    private func handleTap(row: Int, col: Int) {
        guard !gameWon else { return } // Prevent further interactions after winning

        if row == targetRow && col == targetCol {
            score += 1
            feedback = "Great! +1 Point 🎉"
            grid[row][col] = true
            targetRow = Int.random(in: 0..<3)
            targetCol = Int.random(in: 0..<3)

            // Check if the player has won
            if score >= winningScore {
                gameWon = true
                feedback = "You did it! 🥳"
            }
        } else {
            score -= 1
            feedback = "Oops! -1 Point 😔 Try again."
        }
    }

    private func resetGame() {
        score = 0
        grid = Array(repeating: Array(repeating: false, count: 3), count: 3)
        targetRow = Int.random(in: 0..<3)
        targetCol = Int.random(in: 0..<3)
        feedback = "Tap the red square!"
        gameWon = false
    }
}

#Preview {
    ContentView()
}

