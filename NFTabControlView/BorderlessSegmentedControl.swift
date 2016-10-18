//
//  BorderlessSegmentedControl.swift
//  Nick Fedoroff
//
//  Created by Nick Fedoroff on 10/17/16.
//  Copyright © 2016 Nick Fedoroff. All rights reserved.
//


import UIKit

class BorderlessSegmentedControl: UISegmentedControl {

    override func draw(_ rect: CGRect) {
        removeBorders()
    }
    
    private func removeBorders() {
        let clearImage = imageWithColor(color: .clear)
        setBackgroundImage(clearImage, for: .normal, barMetrics: .default)
        setBackgroundImage(clearImage, for: .selected, barMetrics: .default)
        setDividerImage(clearImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
    
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
    
}
