//
//  ContentView.swift
//  HangManGame
//
//  Created by Angelos Staboulis on 2/9/25.
//

import SwiftUI

struct ContentView: View {
    @State private var wordToGuess = ""
    @State private var guessedLetters: [String] = []
    @State private var incorrectGuesses = 0
    @State private var gameOver = false
    @State private var gameWon = false
    
    private let maxIncorrectGuesses = 7
    private let words = ["SWIFT", "OBJECTIVEC", "VARIABLE", "XCODE", "APPLE", "MOBILE", "DEBUG"]
    
    // MARK: - Computed Properties
    private var displayWord: String {
        wordToGuess.map { guessedLetters.contains(String($0)) ? String($0) : "_" }.joined(separator: " ")
    }
    
    private var alphabet: [String] {
        (65...90).map { String(UnicodeScalar($0)!) }
    }
    var body: some View {
        VStack(spacing: 20) {
            Text("Hangman")
                .font(.largeTitle)
                .bold()
            
            Text("Incorrect Guesses: \(incorrectGuesses)/\(maxIncorrectGuesses)")
                .foregroundColor(.red)
            
            Text(displayWord)
                .font(.system(size: 36, weight: .bold, design: .monospaced))
                .padding()
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                ForEach(alphabet, id: \.self) { letter in
                    Button(action: {
                        guess(letter)
                    }) {
                        Text(letter)
                            .font(.headline)
                            .frame(width: 40, height: 40)
                            .background(guessedLetters.contains(letter) ? Color.gray : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .disabled(guessedLetters.contains(letter) || gameOver)
                }
            }
            
            if gameOver {
                Text(gameWon ? "🎉 You Won!" : "💀 You Lost!")
                    .font(.title)
                    .padding(.top)
                
                Button("Play Again") {
                    startNewGame()
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
        .onAppear(perform: startNewGame)
    }
    func guess(_ letter: String) {
        guessedLetters.append(letter)
        
        if wordToGuess.contains(letter) {
            let allLettersGuessed = wordToGuess.allSatisfy { guessedLetters.contains(String($0)) }
            if allLettersGuessed {
                gameWon = true
                gameOver = true
            }
        } else {
            incorrectGuesses += 1
            if incorrectGuesses >= maxIncorrectGuesses {
                gameOver = true
            }
        }
    }
    
    func startNewGame() {
        wordToGuess = words.randomElement() ?? "SWIFT"
        guessedLetters = []
        incorrectGuesses = 0
        gameOver = false
        gameWon = false
    }
}

#Preview {
    ContentView()
}
