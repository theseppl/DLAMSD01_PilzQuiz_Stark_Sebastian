//
//  ViewController.swift
//  Pilz Quiz
//
//  Created by Sebastian Stark on 27.01.26.
//

import UIKit

enum Mode {
    case flashCard
    case quiz
}

enum State {
    case question
    case answer
}

class ViewController: UIViewController, UITextFieldDelegate {
    
    let elementList = ["Carbon", "Gold", "Chlorine", "Sodium"]
    var currentElementIndex = 0
    
    // Das ist eine Property mit eine Property-Observer
    // Jedes mal, wenn sich der Status der Property ändert,
    // wird der didSet-Block abgespielt.
    var mode: Mode = .flashCard {
        didSet {
            updateUI()
        }
    }
        
    var state: State = .question
    var answerIsCorrect = false
    var correctAnswerCount = 0
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var modeSelector: UISegmentedControl!
    @IBOutlet weak var textField: UITextField!
    
    
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
    
    @IBAction func switchModes(_ sender: Any) {
        if modeSelector.selectedSegmentIndex == 0 {
            mode = .flashCard
        } else {
            mode = .quiz
        }
    }
    
    //Funktion wird durch Return-Button aufgerufen
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Erhält den Text aus dem Textfeld
        let textFieldContents = textField.text!
        
        // Ermittelt ob der User korrekt geantwortet hat
        // Updated den Quiz-Status
        if textFieldContents.lowercased() == elementList[currentElementIndex].lowercased(){
            answerIsCorrect = true
            correctAnswerCount += 1
        } else {
            answerIsCorrect = false
        }
        
        if answerIsCorrect {
            print("Genau")
        } else {
            print("falsch")
        }
        
        // App soll nun die Antwort anzeigen
        state = .answer
        updateUI()
        return true
    }
    
    
    // Single Point of Entry für alle UI-Anpassungen
    // Nur sie darf andere UI-Anpassungsmethoden aufrufen
    func updateUI() {
        let elementName = elementList[currentElementIndex]
        let image = UIImage(named: elementName)
        imageView.image = image
        
        switch mode {
        case .flashCard:
            updateFlashCardUI(elementName: elementName)
        case .quiz:
            updateQuizUI(elementName: elementName)
        }
    }
    
    //Updated die UI im FlashCard-Modus
    func updateFlashCardUI(elementName: String) {
        if state == .answer {
            answerLabel.text = elementName
        } else {
            answerLabel.text = "?"
        }
    }
    
    //Updated die UI im Quiz-Modus
    //Parameter eigentlich nicht in Nutzung
    func updateQuizUI(elementName: String) {
        switch state {
        case .question:
            answerLabel.text = ""
        case .answer:
            if answerIsCorrect {
                answerLabel.text = "Richtig"
            } else {
                answerLabel.text = "❌"
            }
        }
    }
    
    override func viewDidLoad() {
        updateUI()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

