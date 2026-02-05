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
    case score
}

class FlashCardViewController: UIViewController, UITextFieldDelegate {

    let fixedElementList = ["Apfeltäubling", "Beutelstäubling", "Fliegenpilz", "Karbol-Champignon", "Duftender Klumpfuß", "Dünnstieliger Helmkreisling", "Eichenmilchling", "Fleischfarbener Hallimasch", "Gemeiner Steinpilz", "Anistäubling"]
    //Array als Variable um Zufallsgenerator zu ermöglichen
    var elementList: [String] = []
    var currentElementIndex = 0

    var state: State = .question
    var answerIsCorrect = false
    var correctAnswerCount = 0
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var showAnswerButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBAction func showAnswer(_ sender: Any) {
        state = .answer
        updateUI()
    }
    
    @IBAction func next(_ sender: Any) {
        currentElementIndex += 1
        if currentElementIndex >= elementList.count {
            currentElementIndex = 0
        }
        
        state = .question
        updateUI()
    }
    
    //Startet eine neue Flash-Card-Session
    func setupFlashCards() {
        elementList = fixedElementList
        state = .question
        currentElementIndex = 0
    }

    // Single Point of Entry für alle UI-Anpassungen
    // Nur sie darf andere UI-Anpassungsmethoden aufrufen
    func updateUI() {
        let elementName = elementList[currentElementIndex]
        let image = UIImage(named: elementName)
        imageView.image = image
         
        //Buttons
        showAnswerButton.isHidden = false
        nextButton.isEnabled = true
        nextButton.setTitle("Next Element", for: .normal)

        if state == .answer {
            answerLabel.text = elementName
        } else {
            answerLabel.text = "?"
        }
    }
    
    /*
    //Updated die UI im FlashCard-Modus
    func updateFlashCardUI(elementName: String) {
        // Textfeld und Tastatur ausblenden
        textField.isHidden = true
        textField.resignFirstResponder()
        
        //Buttons
        showAnswerButton.isHidden = false
        nextButton.isEnabled = true
        nextButton.setTitle("Next Element", for: .normal)

        if state == .answer {
            answerLabel.text = elementName
        } else {
            answerLabel.text = "?"
        }
    }
    
    //Updated die UI im Quiz-Modus
    //Parameter eigentlich nicht in Nutzung
    func updateQuizUI(elementName: String) {
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
        if currentElementIndex == elementList.count - 1 {
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
                answerLabel.text = "❌\nCorrect Answer: " + elementName
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
//        mode = .flashCard
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        setupFlashCards()
        updateUI()
    }
}

