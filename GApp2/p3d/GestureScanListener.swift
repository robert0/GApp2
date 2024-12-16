//
//  GestureScanningListener.swift
//  GApp
//
//  Created by Robert Talianu
//


/**
 *
 */
public protocol GestureScanListener {

    func gestureStarted()

    func gestureEnded()

    func gestureContinuation()

    func zeroesStarted()

    func zeroesEnded()
}
