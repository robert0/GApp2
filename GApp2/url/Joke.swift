//
//  Joke.swift
//  GApp2
//
//  Created by Robert Talianu
//


import Foundation

struct Joke: Codable, Identifiable {
    let id: Int
    let error: Bool
    let category: String
    let type: String
    let joke: String
}
