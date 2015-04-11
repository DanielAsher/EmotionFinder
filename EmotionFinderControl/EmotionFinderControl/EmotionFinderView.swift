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
            self.addSubview(label)
            topLevelEmotionLabels[emotion] = label
        }
    }
    
    public override func layoutSubviews() {
        if needsUpdateConstraints() {
            let centreSize = self.centreEmotionLabel.intrinsicContentSize()
            
            layout(centreEmotionLabel, self) { label, view in
                label.center == view.center
                label.width == centreSize.width
                label.height == centreSize.height
            }
            
            var incr = 2 * M_PI / Double(topLevelEmotions.count)

            for (i, (emotion, label)) in enumerate(topLevelEmotionLabels) {
                let size = label.intrinsicContentSize()
                let angle = Double(i) * incr
                layout(centreEmotionLabel, label) { centreLabel, label in
                    label.centerX == centreLabel.centerX + sin(angle) * 75.0
                    label.centerY == centreLabel.centerY + cos(angle) * 75.0

                    label.width == size.width
                    label.height == size.height
                }
            }
        }
    }
}
