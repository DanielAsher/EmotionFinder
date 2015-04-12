//
//  EmotionFinderView.swift
//  EmotionFinderControl
//
//  Created by Daniel Asher on 11/04/2015.
//  Copyright (c) 2015 AsherEnterprises. All rights reserved.
//

import UIKit
import Cartography
import Darwin

@IBDesignable
public class EmotionFinderView: UIControl {
    let centreEmotion = "Calm"
    let topLevelEmotions = ["Peaceful", "Mad", "Sad", "Scared", "Joyful", "Powerful"]
    let centreEmotionLabel : LTMorphingLabel
    var topLevelEmotionLabels : [String: LTMorphingLabel] = [:]
    override init(frame: CGRect) {
        centreEmotionLabel = LTMorphingLabel()
        centreEmotionLabel.textAlignment = NSTextAlignment.Center
        super.init(frame: frame)
        setup()
    }
    
    public required init(coder aDecoder: NSCoder) {
        centreEmotionLabel = LTMorphingLabel()
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        centreEmotionLabel.text = centreEmotion
        self.addSubview(centreEmotionLabel)
        for emotion in topLevelEmotions {
            let label = LTMorphingLabel()
            label.text = emotion
            label.textAlignment = NSTextAlignment.Center

            self.addSubview(label)
            topLevelEmotionLabels[emotion] = label
        }
        
        let initialAlpha = CGFloat(0.1)
        let l: AngleGradientLayer = self.layer as! AngleGradientLayer
        let colors: Array<AnyObject> = [
            UIColor(red: 1, green: 0, blue: 0, alpha: initialAlpha).CGColor,
            UIColor(red: 1, green: 1, blue: 0, alpha: initialAlpha).CGColor,
            UIColor(red: 0, green: 1, blue: 0, alpha: initialAlpha).CGColor,
            UIColor(red: 0, green: 1, blue: 1, alpha: initialAlpha).CGColor,
            UIColor(red: 1, green: 0, blue: 1, alpha: initialAlpha).CGColor,
            UIColor(red: 1, green: 0, blue: 0, alpha: initialAlpha).CGColor]
        l.colors = colors
//        l.cornerRadius = CGRectGetWidth(self.bounds) / 2
    }
    
    public override func layoutSubviews() {
        if needsUpdateConstraints() {
            let centreSize = self.centreEmotionLabel.intrinsicContentSize()
            
            layout(centreEmotionLabel, self) { label, view in
                label.center == view.center
                label.width == centreSize.width
                label.height == centreSize.height
            }
            
            var angles: Array<AnyObject> = []
            var incr = 2 * M_PI / Double(topLevelEmotions.count)

            for (i, (emotion, label)) in enumerate(topLevelEmotionLabels) {
                println(emotion)
                let size = label.intrinsicContentSize()
                let angle = Double(i) * incr
                angles.append(angle / 2 * M_PI - 0.5 * M_PI)
                layout(centreEmotionLabel, label) { centreLabel, label in
                    label.centerX == centreLabel.centerX + sin(angle) * 75.0
                    label.centerY == centreLabel.centerY + cos(angle) * 75.0

                    label.width == size.width
                    label.height == size.height
                }
            }
            
            let l: AngleGradientLayer = self.layer as! AngleGradientLayer
           l.locations = angles
        }
    }
    
    override public class func layerClass() -> AnyClass {
        return AngleGradientLayer.self
    }
    
    public override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        return
    }
    
    func distanceBetween(p1: CGPoint, _ p2: CGPoint) -> CGFloat {
        return  CGFloat(hypotf(Float(p1.x - p2.x), Float(p1.y - p2.y)))
    }
    
    public override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        if let touch = touches.first as? UITouch {
            
            let location = touch.locationInView(self)
            let initialAlpha = CGFloat(0.1)
            let startColor = UIColor(red: 0, green: 1, blue: 1, alpha: initialAlpha)
            var colors: Array<AnyObject> = [
                startColor,
                UIColor(red: 1, green: 0, blue: 0, alpha: initialAlpha),
                UIColor(red: 0, green: 0, blue: 1, alpha: initialAlpha),
                UIColor(red: 1, green: 0, blue: 1, alpha: initialAlpha),
                UIColor(red: 1, green: 1, blue: 0, alpha: initialAlpha),
                UIColor(red: 0, green: 1, blue: 0, alpha: initialAlpha),
                startColor,
            ]
            
            for (i, (emotion, label)) in enumerate(topLevelEmotionLabels) {
                let centre = CGPoint(x: label.frame.midX, y: label.frame.midY)
                let distance = distanceBetween(centre, location)
                println("== \(i): \(distance)")

                let c = colors[i] as! UIColor
                var r: CGFloat = 0
                var g: CGFloat = 0
                var b: CGFloat = 0
                var a: CGFloat = 0
                c.getRed(&r, green: &g, blue: &b, alpha: &a)
                let newAlpha = max(a, 1.0 / max(0.2 * distance, 1.0))
                println(newAlpha)
                println()
                colors[i] = UIColor(red: r, green: g, blue: b, alpha: newAlpha).CGColor
            }

            let l: AngleGradientLayer = self.layer as! AngleGradientLayer

            l.setNeedsDisplay()

            l.colors = colors
            println(l.locations)


        }
        return
    }
    public override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        return
    }
    public override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        return
    }
}
