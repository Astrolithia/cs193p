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
        VStack(content: {
            HStack(content: {
                matchMarker(peg: 0)
                matchMarker(peg: 1)
            })
            HStack(content: {
                matchMarker(peg: 2)
                matchMarker(peg: 3)
            })
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
