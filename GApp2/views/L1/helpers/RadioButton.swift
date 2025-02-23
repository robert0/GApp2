//
//  RadioButton.swift
//  GApp2
//
//  Created by Robert Talianu
//


import SwiftUI
struct RadioButton: View {
    @Binding var checked: Bool    //the variable that determines if its checked
    
    var body: some View {
        Group{
            if checked {
                ZStack{
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 20, height: 20)
                    Circle()
                        .fill(Color.white)
                        .frame(width: 8, height: 8)
                }.onTapGesture {self.checked = false}
            } else {
                Circle()
                    .fill(Color.white)
                    .frame(width: 20, height: 20)
                    .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                    .onTapGesture {self.checked = true}
            }
        }
    }
}
