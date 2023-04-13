//
//  GenerateImageWithInitials.swift
//  myContacts
//
//  Created by konstantine on 13.04.23.
//

import UIKit

func generateImageWithInitials(image: UIImageView ,initials: String) -> UIImage {
    let width = image.frame.width
    let height = image.frame.height
    let frame = CGRect(x: 0, y: 0, width: width, height: height)
    let imageView = UIImageView(frame: frame)
    imageView.contentMode = .center
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = frame.size.width / 2
    imageView.layer.backgroundColor = CGColor(red: 60/255, green: 60/255, blue: 60/255, alpha: 1)
    let initialsLabel = UILabel(frame: frame)
    initialsLabel.text = initials
    initialsLabel.textAlignment = .center
    initialsLabel.textColor = UIColor.white
    initialsLabel.font = UIFont.systemFont(ofSize: height / 2)
    imageView.addSubview(initialsLabel)
    return imageView.asImage()
}
