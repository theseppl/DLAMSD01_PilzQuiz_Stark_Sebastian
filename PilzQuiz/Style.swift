//
//  StyleButton.swift
//  PilzQuiz
//
//  Created by Sebastian Stark on 07.02.26.
//

import UIKit

// Zentrale Struktur zum Stylen von UI-Komponenten.
// Dient zur Sicherstellung eines einheitlichen Designs innerhalb der App.
struct Style {
    
    // Styling der Button
    static func button(_ button: UIButton) {
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 14
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.layer.shadowOpacity = 0.35
        button.layer.shadowOffset = CGSize(width: 5, height: 5)
        button.layer.shadowRadius = 6
    }
    
    // Styling der Switches
    static func switches(_ mySwitch: UISwitch) {
        mySwitch.onTintColor = UIColor.systemGreen          // Farbe wenn AN
        mySwitch.tintColor = UIColor.systemBlue             // Randfarbe wenn AUS
        mySwitch.backgroundColor = UIColor.systemBlue       // Hintergrundfarbe wenn AUS
        mySwitch.layer.cornerRadius = mySwitch.frame.height / 2
        mySwitch.clipsToBounds = true
    }
    
    // Styling der Bilder
    static func image(_ image: UIImageView) {
        image.layer.cornerRadius = 16
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.layer.borderWidth = 3
        image.layer.borderColor = UIColor.white.withAlphaComponent(0.4).cgColor
        image.layer.cornerRadius = 16
        image.clipsToBounds = true
    }
}

