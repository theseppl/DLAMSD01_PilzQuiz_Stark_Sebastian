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
    
    @IBAction func showAnswer(_ sender: Any) {
        answerLabel.text = elementList[currentElementIndex]
    }
    
    @IBAction func next(_ sender: Any) {
    }
    
    
    func updateElement() {
        let elementName = elementList[currentElementIndex]
        let image = UIImage(named: elementName)
        imageView.image = image
        answerLabel.text = "?"
    }
    
    override func viewDidLoad() {
        updateElement()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

