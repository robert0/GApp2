//
//  GestureEvaluationListener.swift
//  GApp
//
//  Created by Robert Talianu
//
/**
 *
 */
public protocol GestureEvaluationListener {

    func gestureEvaluationCompleted( _ gw:GestureWindow, _ status:GestureEvaluationStatus )
}
