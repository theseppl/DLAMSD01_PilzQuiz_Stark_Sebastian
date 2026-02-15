//
//  QuizViewController.swift
//  PilzQuiz
//
//  Created by Sebastian Stark on 02.02.26.
//

import UIKit

// ViewController für das Quiz.
// Zeigt Pilzbilder, stellt Fragen zu verschiedenen Eigenschaften (Name, Latein, Gattung, Giftigkeit)
// Bietet vier Antwortmöglichkeiten pro Frage.
// Die Fragen werden dynamisch aus einer festen Pilzliste generiert, abhängig von den gewählten Fragetypen.
class QuizViewController: BackgroundViewController {
    
    // MARK: - Variablen und Konstanten
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var questionAnswerLabel: UILabel!
    
    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    @IBOutlet weak var answerButton3: UIButton!
    @IBOutlet weak var answerButton4: UIButton!
    // Array aller Antwort-Buttons für einfaches Styling und Zugriff
    fileprivate var answerButtonArray: [UIButton] = []
    
    // Feste Liste aller Pilze
    fileprivate let fixedMushroomList: [Mushroom] = MushroomData.all
    
    // Dynamisch generierte Fragenliste
    fileprivate var questions: [QuizQuestion] = []
    
    // Aktuelle Position im Quiz
    fileprivate var currentIndex = 0
    
    // Zähler für richtige Antworten
    fileprivate var correctAnswerCount = 0
    
    // Booleans für mögliche Fragetypen
    var askName = true
    var askLatinName = false
    var askGenus = false
    var askToxicity = false
    
    // Mögliche Eigenschaften, die abgefragt werden können
    enum QuestionType {
        case name
        case latin
        case genus
        case toxicity
    }
    
    // Struktur für eine einzelne Quizfrage
    struct QuizQuestion {
        let mushroom: Mushroom
        let type: QuestionType
    }
    
    // Aktueller Fragetyp (wird bei jeder Frage gesetzt)
    fileprivate var currentQuestionType: QuestionType = .name
    
    // MARK: - Funktionen
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Buttons sammeln und stylen
        answerButtonArray = [answerButton1, answerButton2, answerButton3, answerButton4]
        for button in answerButtonArray {
            Style.button(button)
        }
        setupQuiz()
        updateUI()
    }
    
    // Erstellt die Fragenliste basierend auf den gewählten Fragetypen.
    // Jeder Pilz erzeugt bis zu vier Fragen (eine pro Fragentyp).
    fileprivate func setupQuiz() {
        questions = []
        
        for mushroom in fixedMushroomList {
            if askName {
                questions.append(QuizQuestion(mushroom: mushroom, type: .name))
            }
            if askLatinName {
                questions.append(QuizQuestion(mushroom: mushroom, type: .latin))
            }
            if askGenus {
                questions.append(QuizQuestion(mushroom: mushroom, type: .genus))
            }
            if askToxicity {
                questions.append(QuizQuestion(mushroom: mushroom, type: .toxicity))
            }
        }
        
        // Zufällige Reihenfolge der Fragen
        questions.shuffle()
        currentIndex = 0
        correctAnswerCount = 0
    }
    
    // Zeigt die aktuelle Frage und das passende Bild.
    // Setzt den Fragetext und ruft die Antwortlogik auf.
    fileprivate func updateUI() {
        let question = questions[currentIndex]
        let mushroom = question.mushroom
        currentQuestionType = question.type
        
        // Frage formulieren je nach Fragentyp
        questionAnswerLabel.numberOfLines = 0
        switch question.type {
        case .name:
            questionAnswerLabel.text = "Wie heißt diese Pilzsorte?"
        case .latin:
            questionAnswerLabel.text = "Wissenschaftliche Bezeichnung des Pilzes?"
        case .genus:
            questionAnswerLabel.text = "Gattung des Pilzes?"
        case .toxicity:
            questionAnswerLabel.text = "Essbarkeit des Pilzes?"
            
        }
        
        // Bild setzen und stylen
        imageView.image = UIImage(named: mushroom.name)
        Style.image(imageView)
        
        // Antwortmöglichkeiten generieren
        assignAnswers(for: mushroom)
    }
    
    // Erstellt vier Antwortmöglichkeiten (eine richtige, drei falsche).
    // Verhindert Duplikate.
    fileprivate func assignAnswers(for mushroom: Mushroom) {
        
        // Richtige Antwort je nach Fragetyp
        let correctAnswer: String
        switch currentQuestionType {
        case .name: correctAnswer = mushroom.name
        case .latin: correctAnswer = mushroom.latinName
        case .genus: correctAnswer = mushroom.genus
        case .toxicity: correctAnswer = mushroom.toxicity
        }
        
        // Falsche Antworten aus anderen Pilzen sammeln (ohne Duplikate)
        var wrongAnswersSet = Set<String>()
        for m in fixedMushroomList {
            if m.name != mushroom.name {
                switch currentQuestionType {
                case .name: wrongAnswersSet.insert(m.name)
                case .latin: wrongAnswersSet.insert(m.latinName)
                case .genus: wrongAnswersSet.insert(m.genus)
                case .toxicity: wrongAnswersSet.insert(m.toxicity)
                }
            }
        }
        
        // Ggf. richtige Antwort aus Set falscher Antworten entfernen
        wrongAnswersSet.remove(correctAnswer)
        
        // Zufällige Auswahl von bis zu 3 falschen Antworten
        var wrongAnswers = Array(wrongAnswersSet)
        wrongAnswers.shuffle()
        let selectedWrongAnswers = Array(wrongAnswers.prefix(min(3, wrongAnswers.count)))
        
        // Antworten zusammenstellen
        var allFour = [correctAnswer] + selectedWrongAnswers
        allFour.shuffle()
        
        // Buttons beschriften
        for i in 0..<answerButtonArray.count {
            answerButtonArray[i].setTitle(allFour[i], for: .normal)
        }
    }
    
    // Prüft, ob die gewählte Antwort korrekt ist.
    // Gibt Feedback, färbt Button und lädt nach kurzer Pause die nächste Frage.
    @IBAction func answerButtonTapped(_ sender: UIButton) {
        let question = questions[currentIndex]
        let mushroom = question.mushroom
        
        // Richtige Antwort bestimmen
        let correctAnswer: String
        switch question.type {
        case .name: correctAnswer = mushroom.name
        case .latin: correctAnswer = mushroom.latinName
        case .genus: correctAnswer = mushroom.genus
        case .toxicity: correctAnswer = mushroom.toxicity
        }
        
        // Antwort prüfen und Feedback geben
        if sender.title(for: .normal) == correctAnswer {
            correctAnswerCount += 1
            sender.backgroundColor = .systemGreen
            questionAnswerLabel.text = "Richtig. Sehr gut!"
        } else {
            sender.backgroundColor = .systemRed
            questionAnswerLabel.text = "❌ \(correctAnswer)"
        }
        
        // Buttons deaktivieren um doppelte Eingabe zu vermeiden
        answerButtonArray.forEach { $0.isEnabled = false }
        
        // Verzögerung
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.loadNextQuestion()
        }
    }
    
    // Erhöht den Index und zeigt die nächste Frage.
    // Falls das Quiz zu Ende ist, wird das Ergebnis angezeigt.
    fileprivate func loadNextQuestion() {
        currentIndex += 1
        
        // Wenn das Ende der Fragenliste erreicht ist, wird Meldung aufgerufen.
        if currentIndex >= questions.count {
            displayScoreAlert()
            return
        }
        
        // Buttons zurücksetzen
        answerButtonArray.forEach {
            $0.backgroundColor = .systemBlue
            $0.isEnabled = true
        }
        
        updateUI()
    }
    
    // Zeigt eine Alert-Box mit dem Endergebnis.
    // Führt den Nutzer zurück zum Hauptmenü.
    fileprivate func displayScoreAlert() {
        let alert = UIAlertController(
            title: "Quiz beendet",
            message: "Du hast \(correctAnswerCount) von \(questions.count) Fragen richtig beantwortet.",
            preferredStyle: .alert
        )
        
        let dismissAction = UIAlertAction(title: "Zum Hauptmenü", style: .default) { _ in
            self.navigationController?.popToRootViewController(animated: true)
        }
        alert.addAction(dismissAction)
        present(alert, animated: true)
    }
}
