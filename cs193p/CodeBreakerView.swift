//
//  ContentView.swift
//  cs193p
//
//  Created by Shiro on 12/27/25.
//

import SwiftUI

struct CodeBreakerView: View {
    @State var game = CodeBreaker(
        pegChoices: [.brown, .yellow, .orange, .black]
    )
    
    var body: some View {
        VStack {
            HStack(content: {
                Spacer()
                Button("Restart Game") {
                    withAnimation {
                        game.restart()
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)
                .padding([.bottom], 8)
            })
            view(for: game.masterCode)
            ScrollView(content: {
                view(for: game.guess)
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    view(for: game.attempts[index])
                }
                // Restart
                
            })
            
        }
        .padding()
    }
    
    var guessButton: some View {
        Button("Guess") {
            withAnimation{
                game.attemptGuess()
            }
        }
        .font(.system(size: 80))
        .minimumScaleFactor(0.1)
    }
    
    
    
    func view(for code: Code) -> some View {
        HStack {
            ForEach(code.pegs.indices, id: \.self) { index in
                RoundedRectangle(cornerRadius: 10)
                    .overlay {
                        if code.pegs[index] == Code.missing {
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(Color.gray)
                        }
                    }
                    .contentShape(Rectangle())
                    .aspectRatio(1, contentMode: .fit)
                    .foregroundStyle(code.pegs[index])
                    .onTapGesture {
                        if code.kind == .guess {
                            game.changeGuessPeg(at: index)
                        }
                    }
            }
            MathchMarkers(matches: code.matches)
                .overlay{
                    if code.kind == .guess {
                        guessButton
                    }
                }
        }
    }
}

#Preview {
    CodeBreakerView()
}
