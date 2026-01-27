//
//  ViewController.swift
//  Pilz Quiz
//
//  Created by Sebastian Stark on 27.01.26.
//

import UIKit

class ViewController: UIViewController {
    
    let elementList = ["Carbon", "Gold", "Chlorine", "Sodium"]
    var currentElementIndex = 0
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var answerLabel: UILabel!
    
    func updateElement() {
        let elementName = elementList[currentElementIndex]
        let image = UIImage(named: elementName)
        imageView.image = image
        answerLabel.text = "?"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateElement()
        // Do any additional setup after loading the view.
    }


}

