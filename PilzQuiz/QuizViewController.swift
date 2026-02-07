//
//  QuizViewController.swift
//  PilzQuiz
//
//  Created by Sebastian Stark on 02.02.26.
//

import UIKit

class QuizViewController: BackgroundViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var questionAnswerLabel: UILabel!
    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    @IBOutlet weak var answerButton3: UIButton!
    @IBOutlet weak var answerButton4: UIButton!
    
    // MARK: - Button Array
    var answerButtonArray: [UIButton] = []
    
    // MARK: - Daten
    let fixedMushroomList: [Mushroom] = MushroomData.all
    var questions: [QuizQuestion] = []
    var currentIndex = 0
    var correctAnswerCount = 0
    
    // MARK: - Einstellungen vom WelcomeViewController
    var askName = true
    var askLatinName = false
    var askGenus = false
    var askToxicity = false
    
    // MARK: - Fragetyp
    enum QuestionType {
        case name
        case latin
        case genus
        case toxicity
    }
    
    struct QuizQuestion {
        let mushroom: Mushroom
        let type: QuestionType
    }
    
    var currentQuestionType: QuestionType = .name
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        answerButtonArray = [answerButton1, answerButton2, answerButton3, answerButton4]
        
        for button in answerButtonArray {
            Style.button(button)
        }
        
        setupQuiz()
        updateUI()
    }
    
    // MARK: - Quiz Setup
    func setupQuiz() {
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
        
        questions.shuffle()
        currentIndex = 0
        correctAnswerCount = 0
    }
    
    // MARK: - UI aktualisieren
    func updateUI() {
        let question = questions[currentIndex]
        let mushroom = question.mushroom
        currentQuestionType = question.type
        questionAnswerLabel.numberOfLines = 0
        switch question.type {
        case .name:
            questionAnswerLabel.text = "Wie heißt diese Pilzesorte?"
        case .latin:
            questionAnswerLabel.text = "Wissenschaftliche Bezeichnung des Pilzes?"
        case .genus:
            questionAnswerLabel.text = "Gattung des Pilzes?"
        case .toxicity:
            questionAnswerLabel.text = "Essbarkeit des Pilzes?"

        }
        
        // Bild setzen
        imageView.image = UIImage(named: mushroom.name)
        Style.image(imageView)
        
        assignAnswers(for: mushroom)
    }
    
    // MARK: - Antworten generieren
    func assignAnswers(for mushroom: Mushroom) {
        
        let correctAnswer: String
        
        switch currentQuestionType {
        case .name: correctAnswer = mushroom.name
        case .latin: correctAnswer = mushroom.latinName
        case .genus: correctAnswer = mushroom.genus
        case .toxicity: correctAnswer = mushroom.toxicity
        }
        
        // Falsche Antworten ohne Duplikate
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
        
        // Richtige Antwort entfernen
        wrongAnswersSet.remove(correctAnswer)
        
        var wrongAnswers = Array(wrongAnswersSet)
        wrongAnswers.shuffle()
        
        let selectedWrongAnswers = Array(wrongAnswers.prefix(min(3, wrongAnswers.count)))
        
        var allFour = [correctAnswer] + selectedWrongAnswers
        
        // Falls weniger als 4 Antworten möglich sind
        while allFour.count < 4 {
            allFour.append("—")
        }
        
        allFour.shuffle()
        
        for i in 0..<answerButtonArray.count {
            answerButtonArray[i].setTitle(allFour[i], for: .normal)
        }
    }
    
    // MARK: - Antwort gedrückt
    @IBAction func answerButtonTapped(_ sender: UIButton) {
        
        let question = questions[currentIndex]
        let mushroom = question.mushroom
        
        let correctAnswer: String
        
        switch question.type {
        case .name: correctAnswer = mushroom.name
        case .latin: correctAnswer = mushroom.latinName
        case .genus: correctAnswer = mushroom.genus
        case .toxicity: correctAnswer = mushroom.toxicity
        }
        
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
    
    // MARK: - Nächste Frage
    func loadNextQuestion() {
        currentIndex += 1
        
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
    
    // MARK: - Score Alert
    func displayScoreAlert() {
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
