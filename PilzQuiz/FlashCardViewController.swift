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
 //   case score
}
// class FlashCardViewController: UIViewController, UITextFieldDelegate {
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
         
        //Buttons
        /*
        showAnswerButton.isHidden = false
        nextButton.isEnabled = true
        nextButton.setTitle("Nächster Pilz", for: .normal)
         */
         
        if state == .answer {
            answerLabel.text = mushroom.name
            answerLabel2.text = mushroom.latinName +
            "\n" + "Gattung: " + mushroom.genus + "\n" + mushroom.toxicity
        } else {
            answerLabel.text = "Kennst du den Pilz?"
            answerLabel2.text = ""
        }
    }

    func styleButton(_ button: UIButton) {
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.layer.cornerRadius = 14
        button.layer.masksToBounds = false
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.35
        button.layer.shadowOffset = CGSize(width: 5, height: 5)
        button.layer.shadowRadius = 6
    }


    
    /*
    //Updated die UI im FlashCard-Modus
    func updateFlashCardUI(mushroomName: String) {
        // Textfeld und Tastatur ausblenden
        textField.isHidden = true
        textField.resignFirstResponder()
        
        //Buttons
        showAnswerButton.isHidden = false
        nextButton.isEnabled = true
        nextButton.setTitle("Next Element", for: .normal)

        if state == .answer {
            answerLabel.text = mushroomName
        } else {
            answerLabel.text = "?"
        }
    }
    
    //Updated die UI im Quiz-Modus
    //Parameter eigentlich nicht in Nutzung
    func updateQuizUI(mushroomName: String) {
        //Textfeld und Tastatur
        textField.isHidden = false
        switch state {
        case .question:
            textField.isEnabled = true
            textField.text = ""
            textField.becomeFirstResponder()
        case .answer:
            textField.isEnabled = false
            textField.resignFirstResponder()
        case .score:
            textField.isHidden = true
            textField.resignFirstResponder()
        }
        
        //Buttons
        showAnswerButton.isHidden = true
        if currentMushroomIndex == fixedMushroomList.count - 1 {
            nextButton.setTitle("Show Score", for: .normal)
        } else {
            nextButton.setTitle("Next Question", for: .normal)
        }
        
        switch state {
        case .question:
            nextButton.isEnabled = false
        case .answer:
            nextButton.isEnabled = true
        case .score:
            nextButton.isEnabled = false
        }

        // Antwortlabel
        switch state {
        case .question:
            answerLabel.text = ""
        case .answer:
            if answerIsCorrect {
                answerLabel.text = "Richtig"
            } else {
                answerLabel.text = "❌\nCorrect Answer: " + mushroomName
            }
        case .score:
            answerLabel.text = ""
        }
        
        if state == .score {
            displayScoreAlert()
        }
    }
  */
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        setupFlashCards()
        styleButton(showAnswerButton)
        styleButton(nextButton)
        updateUI()
    }
}

