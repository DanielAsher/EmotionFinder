//
//  EmotionFinderView.swift
//  EmotionFinderControl
//
//  Created by Daniel Asher on 11/04/2015.
//  Copyright (c) 2015 AsherEnterprises. All rights reserved.
//

import UIKit
import Cartography

@IBDesignable
public class EmotionFinderView: UIControl {
    let centreEmotion = "Calm"
    let topLevelEmotions = ["Peaceful", "Mad", "Sad", "Scared", "Joyful", "Powerful"]
    let centreEmotionLabel : LTMorphingLabel
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
    }
    
    public override func layoutSubviews() {
        if needsUpdateConstraints() {
            let size = self.centreEmotionLabel.intrinsicContentSize()
            
            layout(centreEmotionLabel, self) { label, view in
                label.center == view.center
                label.width == size.width
                label.height == size.height
            }
        }
    }
}
