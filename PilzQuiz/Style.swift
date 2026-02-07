//
//  StyleButton.swift
//  PilzQuiz
//
//  Created by Sebastian Stark on 07.02.26.
//

import UIKit

struct Style {
    static func button(_ button: UIButton) {
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 14
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.layer.shadowOpacity = 0.35
        button.layer.shadowOffset = CGSize(width: 5, height: 5)
        button.layer.shadowRadius = 6
    }
}
