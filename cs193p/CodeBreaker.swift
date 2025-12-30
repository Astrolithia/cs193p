//
//  CodeBreaker.swift
//  cs193p
//
//  Created by Shiro on 12/29/25.
//

import SwiftUI

typealias Peg = String

struct CodeBreaker {
    var id = UUID()
    
    enum GameMode {
        case color
        case emoji
    }
    
    static let pegCountRange = 3...6
    var mode: GameMode
    var pegCount: Int
    var masterCode: Code
    var guess: Code
    var attempts: [Code] = []
    var pegChoices: [Peg]

    
    static let colorChoices = ["red", "blue", "green", "yellow", "orange", "purple"]
    static let emojiChoices = ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊"]
    
    init(mode: GameMode = .color, pegCount: Int = 4) {
        self.mode = mode
        self.pegCount = pegCount
        self.pegChoices = mode == .color ? Self.colorChoices : Self.emojiChoices
        
        self.masterCode = Code(kind: .master, pegCount: pegCount)
        self.guess = Code(kind: .guess, pegCount: pegCount)
        
        masterCode.randomize(from: pegChoices)
        print(masterCode)
    }
    
    mutating func attemptGuess() {
        var attempt = guess
        let hasEmptyPegs = guess.pegs.contains(Code.missing)
        
        let isDuplicate = attempts.contains(where: { attempt in
            attempt.pegs == guess.pegs
        })
        
        if hasEmptyPegs || isDuplicate {
            return
        }
        attempt.kind = .attempt(guess.match(against: masterCode))
        attempts.append(attempt)
    }
    
    mutating func changeGuessPeg(at index: Int) {
        let existingPeg = guess.pegs[index]
        if let indexOfExistingPegInPegChoices = pegChoices.firstIndex(of: existingPeg) {
            let newPeg = pegChoices[(indexOfExistingPegInPegChoices + 1) % pegChoices.count]
            guess.pegs[index] = newPeg
        } else {
            guess.pegs[index] = pegChoices.first ?? Code.missing
        }
    }
    
    mutating func restart() {
        mode = Bool.random() ? .color : .emoji
        
        pegCount = Int.random(in: Self.pegCountRange)
        
        pegChoices = mode == .color ? Self.colorChoices : Self.emojiChoices
        
        masterCode = Code(kind: .master, pegCount: pegCount)
        guess = Code(kind: .guess, pegCount: pegCount)
        
        attempts = []
        
        masterCode.randomize(from: pegChoices)
        
        print("New game: \(mode), \(pegCount) pegs.")
    }
}


struct Code: Equatable {
    var kind: Kind
    var pegs: [Peg]
    
    static let missing: Peg = ""
    
    init(kind: Kind, pegCount: Int = 4) {
        self.kind = kind
        self.pegs = Array(repeating: Code.missing, count: pegCount)
    }
    
    enum Kind: Equatable {
        case master
        case guess
        case attempt([Match])
        case unknown
    }
    
    mutating func randomize(from pegChoices: [Peg]) {
        for index in pegs.indices {
            pegs[index] = pegChoices.randomElement() ?? Code.missing
        }
    }
    
    var matches: [Match] {
        switch kind {
            case .attempt(let matches): return matches
            default: return []
        }
    }
    
    func match(against otherCode: Code) -> [Match] {
        var results: [Match] = Array(repeating: .nomatch, count: pegs.count)
        var pegsToMatch = otherCode.pegs
        for index in pegs.indices.reversed() {
            if pegsToMatch.count > index, pegsToMatch[index] == pegs[index] {
                results[index] = .exact
                pegsToMatch.remove(at: index)
            }
        }
        for index in pegs.indices {
            if results[index] != .exact {
                if let matchIndex = pegsToMatch.firstIndex(of: pegs[index]) {
                    results[index] = .inexact
                    pegsToMatch.remove(at: matchIndex)
                }
            }
        }
        return results
    }
}
