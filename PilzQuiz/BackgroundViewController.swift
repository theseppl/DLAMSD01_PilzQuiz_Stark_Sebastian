//
//  BackgroundViewController.swift
//  PilzQuiz
//
//  Created by Sebastian Stark on 06.02.26.
//

//import Foundation
import UIKit

class BackgroundViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackgroundImage()
    }

    func addBackgroundImage() {
        let backgroundImage = UIImageView(frame: view.bounds)
        backgroundImage.image = UIImage(named: "Hintergrundbild")
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.clipsToBounds = true
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false

        view.insertSubview(backgroundImage, at: 0)

        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
