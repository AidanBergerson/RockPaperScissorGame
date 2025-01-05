//
//  ContentView.swift
//  RockPaperScissor
//
//  Created by Aidan Bergerson on 12/13/24.
//

import SwiftUI


struct ContentView: View {
    @State private var choices = ["Rock", "Paper", "Scissors"]
    @State private var rounds = 0
    var computerChoice = Int.random(in: 0...2)
    var toWin: String {
        if choices[computerChoice] == "Rock" {
            return "Paper"
        } else if choices[computerChoice] == "Paper" {
            return "Scissors"
        } else {
            return "Rock"
        }
    }
    
    @State private var alertPresented = false
    @State private var alertTitle: String = ""
    @State private var wasCorrect = false
    @State private var score = 0
    @State private(set) var highScore = 0
    @State private var hasEnded = false
    
    var body: some View {
        VStack {
            Spacer()
            // MARK: Header Text
            Text("Rock Paper Scissors")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundStyle(.indigo)
                .padding(.bottom, 20)
            
            // MARK: High Score
            Text("The High Score is \(highScore)")
                .font(.headline).fontWeight(.semibold)
            
            // MARK: Choice Buttons
            HStack(spacing: 25) {
                ForEach(choices, id: \.self) { choice in
                    Button {
                        let userChoice = choice
                        playGame(userChoice)
                    } label: {
                        HStack {
                            Text(choice)
                        }
                    }
                }
                .foregroundStyle(.white).fontWeight(.semibold)
                .frame(maxWidth: .infinity / 3).frame(height: 30)
                .background(Color.teal)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .shadow(radius: 2, x: 2, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.blue, lineWidth: 2)
                        .opacity(0.2)
                )
                
            }
            .padding(.vertical, 30)
            
            // MARK: Current Score
            VStack(alignment: .center) {
                Text("Your current score is")
                    .font(.subheadline)
                Text("\(score)")
                    .font(.largeTitle)
            }
            Spacer()
            Spacer()
        }
        .padding(.horizontal, 10)
        // MARK: Alert for Choice Picked
        .alert(alertTitle, isPresented: $alertPresented) {
            Button("Next", action: nextQuestion)
        } message: {
            if wasCorrect == true {
                Text("You score is \(score), The computer chose \(choices[computerChoice])")
            } else {
                Text("Try Again! The computer chose \(choices[computerChoice])")
            }
        }
        // MARK: Alert for Game Over
        .alert("Game Over", isPresented: $hasEnded) {
            Button("Play Again?", action: gameOver)
        } message: {
            if wasCorrect == true {
                Text("Correct! Your final score is \(score). Do you want to play again?")
            } else {
                Text("Wrong! Your final score was \(score). Do you want to play again?")
            }
        }
    }
    // MARK: Game Logic
    func playGame(_ user: String) {
        rounds += 1
        if user == toWin {
            alertTitle = "Correct!"
            wasCorrect = true
            score += 1
        } else if user == choices[computerChoice] {
            alertTitle = "Draw!"
        } else {
            alertTitle = "Incorrect!"
            wasCorrect = false
        }
        
        if rounds == 10 {
            hasEnded = true
        } else {
            alertPresented = true
        }
    }
    
    // MARK: Shuffles the Choices
    func nextQuestion() {
        choices.shuffle()
    }
    
    // MARK: Logic to Handle New Game and Scores
    func gameOver() {
        nextQuestion()
        rounds = 0
        if score > highScore {
            highScore = score
        }
        score = 0
    }
}

#Preview {
    ContentView()
}
