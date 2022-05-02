//  AnimationViewExtension.swift

import Foundation
import Lottie

extension AnimationView {
    func setUp() {
        guard let superView = self.superview else {return}
        self.frame.size = CGSize(width: superView.frame.width*0.8, height: superView.frame.height * 0.3)
        self.center.x = superView.center.x
        self.center.y = superView.center.y
        self.contentMode = .scaleAspectFit
        self.loopMode = .loop
    }
}
