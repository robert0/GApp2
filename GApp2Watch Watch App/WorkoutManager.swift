//
//  WorkoutManager.swift
//  GApp2
//
//  Created by Robert Talianu
//


import HealthKit

class WorkoutManager: NSObject, HKWorkoutSessionDelegate {
    private let healthStore = HKHealthStore()
    private var session: HKWorkoutSession?

    public func startWorkout() {
        let config = HKWorkoutConfiguration()
        config.activityType = .other
        config.locationType = .unknown

        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: config)
            session?.delegate = self
            session?.startActivity(with: Date())
        } catch {
            print("Failed to start workout session: \(error)")
        }
        print("WorkoutManager: Workout session started...")
    }

    public func stopWorkout() {
        session?.end()
        print("WorkoutManager: Workout session stopped...")
    }

    // Implement delegate methods as needed
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        print("WorkoutManager: Workout session changed from \(fromState) to \(toState) at \(date)")
    }
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        print("WorkoutManager: Workout session failed with error: \(error)")
    }
}
