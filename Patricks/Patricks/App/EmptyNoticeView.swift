//
//  EmptyNoticeView.swift
//  Patricks
//
//  Created by 정상윤 on 2022/01/13.
//

import UIKit

class EmptyNoticeView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let image = UIImageView(image: UIImage(named: "empty-1"))
        image.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        image.center.x = self.center.x
        image.center.y = self.center.y
        image.alpha = 0.75
        
        let message = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        message.text = "Empty!"
        message.font = UIFont(name: "Menlo-Regular", size: 20)
        message.textColor = UIColor.black.withAlphaComponent(0.75)
        message.sizeToFit()
        message.center.x = self.center.x * 1.03
        message.center.y = self.center.y * 1.9
        
        self.addSubview(image)
        self.addSubview(message)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
