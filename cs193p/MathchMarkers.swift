//
//  MathchMarkers.swift
//  cs193p
//
//  Created by Shiro on 12/28/25.
//

import SwiftUI

enum Match {
    case nomatch
    case exact
    case inexact
}

struct MathchMarkers: View {
    var matches: [Match]
    
    var body: some View {
        let rows = (matches.count + 1) / 2
        let columns = 2
        
        VStack(content: {
            ForEach(0..<rows, id: \.self){ row in
                HStack(content: {
                    ForEach(0..<columns, id: \.self) { col in
                        let index = row * columns + col
                        if index < matches.count {
                            matchMarker(peg: index)
                        } else {
                            Circle()
                                .fill(Color.clear)
                                .aspectRatio(1, contentMode: .fit)
                        }
                    }
                })
            }
        })
        
    }
    func matchMarker(peg: Int) -> some View {
        let exactCount: Int = matches.count { $0 == .exact}
        let foundCount: Int = matches.count { $0 != .nomatch}
        return Circle()
            .fill(exactCount > peg ? Color.primary : Color.clear)
            .strokeBorder(foundCount > peg ? Color.primary : Color.clear, lineWidth: 2)
            .aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    MathchMarkers(matches: [.exact, .inexact, .nomatch, .exact])
}
