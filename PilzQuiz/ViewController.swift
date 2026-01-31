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
    case score
}

class ViewController: UIViewController, UITextFieldDelegate {
    
    let elementList = ["Carbon", "Gold", "Chlorine", "Sodium"]
    var currentElementIndex = 0
    
    // Das ist eine Property mit eine Property-Observer
    // Jedes mal, wenn sich der Status der Property ändert,
    // wird der didSet-Block abgespielt.
    var mode: Mode = .flashCard {
        didSet {
            switch mode {
            case .flashCard:
                setupFlashCards()
            case .quiz:
                setupQuiz()
            }
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
            // Wenn Modus Quiz ist und das Ende erreicht,
            // wird der Status auf Score gesetzt und die Funktion verlassen.
            if mode == .quiz {
                state = .score
                updateUI()
                return
            }
        }
        state = .question
        updateUI()
    }
    // Funktion welche durch User-Eingabe am Selector den Modus ändert
    @IBAction func switchModes(_ sender: Any) {
        if modeSelector.selectedSegmentIndex == 0 {
            mode = .flashCard
        } else {
            mode = .quiz
        }
    }
    
    //Startet eine neue Flash-Card-Session
    func setupFlashCards() {
        state = .question
        currentElementIndex = 0
    }
    
    //Startet eine neue Quiz-Session
    func setupQuiz() {
        state = .question
        currentElementIndex = 0
        correctAnswerCount = 0
        answerIsCorrect = false
    }
    
    // Zeigt das modale Pop-up zur Anzeige der Punktzahl
    func displayScoreAlert() {
        //Meldung wird erzeugt
        let alert = UIAlertController(title: "Quiz Punktzahl", message: "Deine Punktzahl ist \(correctAnswerCount) von \(elementList.count).", preferredStyle: .alert)
        
        //Beschreibt den Button des Pop-ups (für Aktion)
        //Callback: Er ruft die Methode scoreAlertDismissed(_:) auf
        let dismissAction = UIAlertAction(title: "OK", style: .default, handler: scoreAlertDismissed(_:))
        
        //Die Aktion wird dem Action-Controller übergeben
        alert.addAction(dismissAction)
        
        // Meldung wird präsentiert
        present(alert, animated: true, completion: nil)
    }
    
    func scoreAlertDismissed(_ action: UIAlertAction) {
        mode = .flashCard
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
        // Textfeld und Tastatur ausblenden
        textField.isHidden = true
        textField.resignFirstResponder()
        
        //Kennzeichen zur automatischen Anpassung der SegmentControl (nicht User-Eingabe)
        modeSelector.selectedSegmentIndex = 0
        
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
        
        //Kennzeichen zur automatischen Anpassung der SegmentControl (nicht User-Eingabe)
        modeSelector.selectedSegmentIndex = 1
        
        switch state {
        case .question:
            textField.text = ""
            textField.becomeFirstResponder()
        //Beim Umschalten auf FlashCards verschwindet Textfeld
        case .answer:
            textField.resignFirstResponder()
        case .score:
            textField.isHidden = true
            textField.resignFirstResponder()
        }
        
        // Antwortlabel
        switch state {
        case .question:
            answerLabel.text = ""
        case .answer:
            if answerIsCorrect {
                answerLabel.text = "Richtig"
            } else {
                answerLabel.text = "❌"
            }
        case .score:
            answerLabel.text = ""
        }
        
        if state == .score {
            displayScoreAlert()
        }
    }
    
    override func viewDidLoad() {
        updateUI()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

