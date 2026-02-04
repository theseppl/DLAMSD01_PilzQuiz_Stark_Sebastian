//
//  ViewController.swift
//  Pilz Quiz
//
//  Created by Sebastian Stark on 27.01.26.
//

import UIKit

/*
enum Mode {
    case flashCard
    case quiz
}
*/
 
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
    
    // Das ist eine Property mit eine Property-Observer
    // Jedes mal, wenn sich der Status der Property ändert,
    // wird der didSet-Block abgespielt.
/*
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
 */
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
            // Wenn Modus Quiz ist und das Ende erreicht,
            // wird der Status auf Score gesetzt und die Funktion verlassen.
            /*
            if mode == .quiz {
                state = .score
                updateUI()
                return
            }
             */
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
    
    //Startet eine neue Quiz-Session
    func setupQuiz() {
        state = .question
        // Würfelt elementList durcheinander
        elementList = fixedElementList.shuffled()
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
        
        /*
        let dismissAction = UIAlertAction(title: "OK", style: .default, handler: scoreAlertDismissed(_:))
        */
        
        let dismissAction = UIAlertAction(title: "OK", style: .default)
        
        //Die Aktion wird dem Action-Controller übergeben
        alert.addAction(dismissAction)
        
        // Meldung wird präsentiert
        present(alert, animated: true, completion: nil)
    }
  
    /*
    func scoreAlertDismissed(_ action: UIAlertAction) {
        mode = .flashCard
    }
    */
    
    /*
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
    */
    
    // Single Point of Entry für alle UI-Anpassungen
    // Nur sie darf andere UI-Anpassungsmethoden aufrufen
    func updateUI() {
        let elementName = elementList[currentElementIndex]
        let image = UIImage(named: elementName)
        imageView.image = image
        
        /*
        // Textfeld und Tastatur ausblenden
        textField.isHidden = true
        textField.resignFirstResponder()
        */
         
        //Buttons
        showAnswerButton.isHidden = false
        nextButton.isEnabled = true
        nextButton.setTitle("Next Element", for: .normal)

        if state == .answer {
            answerLabel.text = elementName
        } else {
            answerLabel.text = "?"
        }
        
        /*
        switch mode {
        case .flashCard:
            updateFlashCardUI(elementName: elementName)
        case .quiz:
            updateQuizUI(elementName: elementName)
        }
         */
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

