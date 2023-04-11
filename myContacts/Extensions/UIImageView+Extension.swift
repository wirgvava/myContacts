//
//  UIImageView+Extension.swift
//  myContacts
//
//  Created by konstantine on 11.04.23.
//

import UIKit

extension UIImageView {
    func applyshadowWithCorner(containerView : UIView, cornerRadious : CGFloat){
        containerView.clipsToBounds = false
        self.layer.masksToBounds = false
        self.layer.cornerRadius = cornerRadious
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowPath = UIBezierPath(roundedRect: self.frame, cornerRadius: cornerRadious).cgPath
        containerView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowRadius = 2.0
        self.clipsToBounds = true
    }
}
