//
//  ViewController.swift
//  Pilz Quiz
//
//  Created by Sebastian Stark on 27.01.26.
//

import UIKit

enum State {
    case question
    case answer
}

class FlashCardViewController: BackgroundViewController {
    
    let fixedMushroomList: [Mushroom] = MushroomData.all
    
    //Array als Variable um Zufallsgenerator zu ermöglichen
    var variableMushroomList: [Mushroom] = []
    var currentMushroomIndex = 0
    
    var state: State = .question
    var answerIsCorrect = false
    var correctAnswerCount = 0
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var answerLabel2: UILabel!
    @IBOutlet weak var showAnswerButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBAction func showAnswer(_ sender: Any) {
        state = .answer
        updateUI()
    }
    
    @IBAction func next(_ sender: Any) {
        currentMushroomIndex += 1
        if currentMushroomIndex >= variableMushroomList.count {
            currentMushroomIndex = 0
        }
        
        state = .question
        updateUI()
    }
    
    //Startet eine neue Flash-Card-Session
    func setupFlashCards() {
        variableMushroomList = fixedMushroomList.shuffled()
        state = .question
        currentMushroomIndex = 0
    }
    
    func updateUI() {
        let mushroom = variableMushroomList[currentMushroomIndex]
        let image = UIImage(named: mushroom.name)
        
        imageView.image = image
        Style.image(imageView)
        
        if state == .answer {
            answerLabel.text = mushroom.name
            answerLabel2.text = mushroom.latinName +
            "\n" + "Gattung: " + mushroom.genus + "\n" + mushroom.toxicity
        } else {
            answerLabel.text = "Kennst du den Pilz?"
            answerLabel2.text = ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFlashCards()
        Style.button(showAnswerButton)
        Style.button(nextButton)
        updateUI()
    }
}
