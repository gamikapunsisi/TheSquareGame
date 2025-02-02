import SwiftUI

struct ContentView: View {
    @State private var grid: [[GridCell]] = Array(repeating: Array(repeating: GridCell(color: .gray, isRevealed: false), count: 4), count: 4)
    @State private var score: Int = 0
    @State private var targetColors: Set<Color> = []
    @State private var feedback: String = "Memorize the colors and tap matching grids!"
    @State private var gameWon: Bool = false
    @State private var showColors: Bool = true
    private let winningScore = 3
    private let allColors: [Color] = [.red, .blue, .green, .yellow, .orange, .pink, .purple, .cyan]

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

            // 4x4 Grid of squares
            ForEach(0..<4, id: \.self) { row in
                HStack {
                    ForEach(0..<4, id: \.self) { col in
                        let cell = grid[row][col]
                        Rectangle()
                            .fill(cell.isRevealed ? cell.color : .gray)
                            .frame(width: 80, height: 80)
                            .onTapGesture {
                                handleTap(row: row, col: col)
                            }
                            .disabled(gameWon)
                            .animation(.easeInOut(duration: 0.2), value: cell.isRevealed)
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
        .onAppear(perform: setupGame)
    }

    // MARK: - Game Logic

    private func setupGame() {
        DispatchQueue.main.async {
            var colors = allColors.shuffled().prefix(7).map { $0 }
            guard let commonColor = colors.randomElement() else { return }
            
            // Assign 3 common colors and shuffle
            var gridColors = Array(repeating: commonColor, count: 3) + colors.prefix(5)
            gridColors.shuffle()

            var newGrid = [[GridCell]]()
            for row in 0..<4 {
                var newRow = [GridCell]()
                for col in 0..<4 {
                    if !gridColors.isEmpty {
                        newRow.append(GridCell(color: gridColors.removeFirst(), isRevealed: showColors))
                    } else {
                        newRow.append(GridCell(color: .gray, isRevealed: showColors))
                    }
                }
                newGrid.append(newRow)
            }

            grid = newGrid
            targetColors = [commonColor]
            feedback = "Memorize the colors and tap \(targetColors.count) matching grids!"

            // Hide colors after 3 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                showColors = false
                for row in 0..<4 {
                    for col in 0..<4 {
                        grid[row][col].isRevealed = false
                    }
                }
            }
        }
    }

    private func handleTap(row: Int, col: Int) {
        guard !gameWon else { return }

        let tappedColor = grid[row][col].color

        if targetColors.contains(tappedColor) {
            grid[row][col].isRevealed = true
            score += 1
            feedback = "Great! +1 Point 🎉"

            if score >= winningScore {
                gameWon = true
                feedback = "You did it! 🥳"
            }
        } else {
            grid[row][col].isRevealed = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                grid[row][col].isRevealed = false
            }
            score -= 1
            feedback = "Oops! -1 Point 😔 Try again."
        }
    }

    private func resetGame() {
        score = 0
        gameWon = false
        showColors = true
        feedback = "Memorize the colors and tap matching grids!"
        setupGame()
    }
}

// MARK: - Helper Struct

struct GridCell: Identifiable {
    let id = UUID()
    var color: Color
    var isRevealed: Bool
}

#Preview {
    ContentView()
}
