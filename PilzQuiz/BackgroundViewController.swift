//
//  BackgroundViewController.swift
//  PilzQuiz
//
//  Created by Sebastian Stark on 06.02.26.
//

//import Foundation
import UIKit

/*
 Ein gemeinsamer ViewController für alle Screens der App.
 Zweck: Jeder Screen, der von `BackgroundViewController` erbt,
 erhält automatisch ein Hintergrundbild.
 Dadurch muss der Code nicht in jedem ViewController dupliziert werden.
 */

class BackgroundViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackgroundImage()
    }
    
    // Fügt ein Hintergrundbild ein.
    fileprivate func addBackgroundImage() {
        
        // Erstellt ein UIImageView, das den gesamten View‑Bereich abdeckt.
        let backgroundImage = UIImageView(frame: view.bounds)
        backgroundImage.image = UIImage(named: "Hintergrundbild")
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.clipsToBounds = true
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        
        // Das Bild als unterstes Element einfügen
        view.insertSubview(backgroundImage, at: 0)
        
        // Das Bild soll exakt an allen vier Seiten anliegen.
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
