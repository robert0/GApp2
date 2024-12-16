//
//  DrawView.swift
//  GApp
//
//  Created by Robert Talianu
//

import UIKit

class DrawView: UIView {
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(2.0)
        context?.setStrokeColor(UIColor.blue.cgColor)
        context?.move(to: CGPoint(x: 0, y: 0))
        context?.addLine(to: CGPoint(x: 20, y: 30))
        context?.strokePath()

        print("in DrawView")
    }
}
