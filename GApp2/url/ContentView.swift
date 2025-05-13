//
//  ContentView.swift
//  GApp2
//
//  Created by Robert Talianu
//
import Foundation
import SwiftUICore

struct ContentView: View {
    @State var joke: Joke? 
    
    var body: some View {
        VStack {
            Text("Random Joke")
                .font(.title)
                .fontWeight(.black)
                .foregroundColor(Color.gray)
                .padding(.bottom, 8)
            Text(joke?.joke ?? "Loading joke...")
                .padding(.horizontal, 8)
            
        }.onAppear() {
            JokesApi().getRandomJoke { (joke) in
                self.joke = joke
            }
        }
    }
}
