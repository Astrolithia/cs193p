//
//  ContentView.swift
//  cs193p
//
//  Created by Shiro on 12/27/25.
//

import SwiftUI

struct CodeBreakerView: View {
    let game: CodeBreaker = CodeBreaker(
        masterCode: <#T##Code#>,
        guess: <#T##Code#>,
        attempts: <#T##[Code]#>,
        pegChoices: <#T##[Peg]#>
    )
    
    var body: some View {
        VStack {
                pegs(colors: [.green, .red, .yellow, .blue])
                pegs(colors: [.green, .red, .yellow, .black])
                pegs(colors: [.green, .red, .yellow, .blue])
        }
        .padding()
    }
    func pegs(colors: Array<Color> = [] )-> some View {
        HStack {
            ForEach(colors.indices, id: \.self) { index in
                RoundedRectangle(cornerRadius: 10)
                    .aspectRatio(1, contentMode: .fit)
                    .foregroundStyle(colors[index])
            }
            MathchMarkers(matches: [.exact, .inexact, .nomatch, .exact])
        }
    }
}

#Preview {
    CodeBreakerView()
}
