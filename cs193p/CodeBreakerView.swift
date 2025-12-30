//
//  ContentView.swift
//  cs193p
//
//  Created by Shiro on 12/27/25.
//

import SwiftUI

struct CodeBreakerView: View {
    @State var game = CodeBreaker()
    
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
            })
        }
        .id(game.id)
        .padding()
    }
    
    var guessButton: some View {
        Button("Guess") {
            withAnimation{
                game.attemptGuess()
            }
        }
        .font(.system(size: 20))
        .minimumScaleFactor(0.1)
    }
    
    
    func view(for code: Code) -> some View {
        HStack {
            
            ForEach(code.pegs.indices, id: \.self) { index in
                ZStack(content: {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(pegColor(for: code.pegs[index]))
                    pegView(for: code.pegs[index])
                })
                    .contentShape(Rectangle())
                    .aspectRatio(1, contentMode: .fit)
                    .onTapGesture {
                        if code.kind == .guess {
                            game.changeGuessPeg(at: index)
                        }
                    }
            }
            MathchMarkers(matches: code.matches)
            
            if code.kind == .guess {
                guessButton
            }
        }
    }
    
    @ViewBuilder
    func pegView(for peg: Peg) -> some View {
        if peg.isEmpty {
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color.gray, lineWidth: 2)
        } else if game.mode == .emoji {
            Text(peg)
                .font(.system(size: 40))
                .minimumScaleFactor(0.1)
        } else {
            EmptyView()
        }
    }
    
    func pegColor(for peg: Peg) -> Color {
        if game.mode == .emoji || peg.isEmpty {
            return .clear
        }
        
        switch peg {
        case "red": return .red
        case "blue": return .blue
        case "green": return .green
        case "yellow": return .yellow
        case "orange": return .orange
        case "purple": return .purple
        case "brown": return .brown
        case "black": return .black
        default: return .clear
        }
    }
}

#Preview {
    CodeBreakerView()
}
