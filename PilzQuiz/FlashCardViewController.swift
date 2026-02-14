//
//  ViewController.swift
//  Pilz Quiz
//
//  Created by Sebastian Stark on 27.01.26.
//

import UIKit

/*
 Der FlashCard‑Modus zeigt jeweils einen Pilz.
 Der Nutzer sieht zuerst nur das Bild („question“),
 und kann dann die Lösung einblenden („answer“).
 Danach kann er zur nächsten Karte springen.
 */

enum State {
    case question // Nur das Bild wird gezeigt
    case answer // Bild + Name + Latein + Gattung + Essbarkeit werden gezeigt
}

class FlashCardViewController: BackgroundViewController {
    
    // MARK: - Variablen und Konstanten
    
    // Feste Liste aller Pilze
    fileprivate let fixedMushroomList: [Mushroom] = MushroomData.all
    
    //Array als Variable um Zufallsgenerator zu ermöglichen
    fileprivate var variableMushroomList: [Mushroom] = []
    // Index des aktuell angezeigten Pilzes
    fileprivate var currentMushroomIndex = 0
    
    // Aktueller Zustand der Karte (Frage oder Antwort)
    fileprivate var state: State = .question
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var answerLabel2: UILabel!
    @IBOutlet weak var showAnswerButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - Funktionen
    
    // Zeigt die Lösung zur aktuellen Karte an.
    @IBAction func showAnswer(_ sender: Any) {
        state = .answer
        updateUI()
    }
    
    // Springt zur nächsten Karte.
    // Wenn das Ende erreicht ist, beginnt die Liste wieder von vorne.
    @IBAction func next(_ sender: Any) {
        currentMushroomIndex += 1
        
        // Wenn wir am Ende sind → wieder bei 0 starten
        if currentMushroomIndex >= variableMushroomList.count {
            currentMushroomIndex = 0
        }
        
        state = .question
        updateUI()
    }
    
    // Startet eine neue Flash-Card-Session
    // Die Pilze werden gemischt, damit die Reihenfolge jedes Mal anders ist.
    fileprivate func setupFlashCards() {
        variableMushroomList = fixedMushroomList.shuffled()
        state = .question
        currentMushroomIndex = 0
    }
    
    // Aktualisiert die gesamte Oberfläche basierend auf dem aktuellen Zustand.
    // Zeigt entweder nur das Bild (question) oder alle Infos (answer).
    fileprivate func updateUI() {
        // Aktuellen Pilz holen
        let mushroom = variableMushroomList[currentMushroomIndex]
        let image = UIImage(named: mushroom.name)
        
        // Bild setzen und stylen
        imageView.image = image
        Style.image(imageView)
        
        // Zustand prüfen
        if state == .answer {
            answerLabel.text = mushroom.name
            answerLabel2.text = mushroom.latinName +
            "\n" + "Gattung: " + mushroom.genus + "\n" + mushroom.toxicity
        } else {
            answerLabel.text = "Kennst du den Pilz?"
            answerLabel2.text = ""
        }
    }
    
    // Wird beim ersten Anzeigen des Screens aufgerufen.
    // Initialisiert die Session und styled die Buttons.
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFlashCards()
        Style.button(showAnswerButton)
        Style.button(nextButton)
        updateUI()
    }
}
