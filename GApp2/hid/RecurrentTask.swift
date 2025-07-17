//
//  RecurrentTask.swift
//  GApp2
//
//  Created by Robert Talianu
//


import Foundation

class RecurrentTask {
    var timer: Timer?

    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.performTask()
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }

    func performTask() {
        print("Task executed at \(Date())")
    }
}
