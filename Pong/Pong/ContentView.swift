//
//  ContentView.swift
//  Pong
//
//  Created by Deepi Pryor on 8/10/23.
//
import SwiftUI

struct ContentView: View {
    @State private var paddlePosition: CGFloat = UIScreen.main.bounds.width / 2
    @State private var ballPosition: CGPoint = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
    @State private var ballVelocity: CGPoint = CGPoint(x: 7, y: 7)
    @State private var isGameOver: Bool = false
    @State private var score: Int = 0
    
    let paddleWidth: CGFloat = 80
    let paddleHeight: CGFloat = 15
    let ballSize: CGFloat = 20
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                Rectangle()
                    .frame(width: paddleWidth, height: paddleHeight)
                    .position(x: paddlePosition, y: geometry.size.height - paddleHeight / 2)
                    .foregroundColor(.red)
                
                Circle()
                    .frame(width: ballSize, height: ballSize)
                    .position(ballPosition)
                    .foregroundColor(.blue)
                
                Text("Score: \(score)")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
            }
            .onAppear() {
                let timer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { _ in
                    if !isGameOver {
                        updateBallPosition(geometry)
                    }
                }
                RunLoop.current.add(timer, forMode: .common)
            }
            .gesture(DragGesture()
                .onChanged { value in
                    paddlePosition = min(max(value.location.x, paddleWidth / 2), geometry.size.width - paddleWidth / 2)
                }
            )
            
            if isGameOver {
                VStack {
                    Spacer()
                    
                    Text("Game Over")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding()
                    
                    Text("Final Score: \(score)")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                    
                    Button("Reset") {
                        resetGame()
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding()
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.7))
            }
        }
    }
    
    private func updateBallPosition(_ geometry: GeometryProxy) {
        ballPosition.x += ballVelocity.x
        ballPosition.y += ballVelocity.y
        
        if ballPosition.x <= ballSize / 2 || ballPosition.x >= geometry.size.width - ballSize / 2 {
            ballVelocity.x *= -1
        }
        
        if ballPosition.y <= ballSize / 2 {
            ballVelocity.y *= -1
        }
        
        if ballPosition.y >= geometry.size.height {
            // Ball left the screen
            isGameOver = true
        }
        
        if ballPosition.y >= geometry.size.height - paddleHeight - ballSize / 2 {
            if ballPosition.x >= paddlePosition - paddleWidth / 2 && ballPosition.x <= paddlePosition + paddleWidth / 2 {
                ballVelocity.y *= -1
                score += 1 // Increment the score when ball hits the paddle
            } else {
                // Game over logic
                isGameOver = true
            }
        }
    }
    
    private func resetGame() {
        ballPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: ballSize / 2) // Reset ball to the top
        ballVelocity = CGPoint(x: 7, y: 7)
        isGameOver = false
        score = 0 // Reset the score
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
