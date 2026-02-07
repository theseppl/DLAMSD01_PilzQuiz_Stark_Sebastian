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
           // styleButton(button)
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
            questionAnswerLabel.text = "Wie heißt dieser Pilzesorte?"
        case .latin:
            questionAnswerLabel.text = "Wissenschaftliche Bezeichnung des Pilzes?"
        case .genus:
            questionAnswerLabel.text = "Gattung des Pilzes?"
        case .toxicity:
            questionAnswerLabel.text = "Essbarkeit des Pilzes?"

        }
        
        // Bild setzen
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: mushroom.name)
        
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
            questionAnswerLabel.text = "❌ \(correctAnswer)."
        }
        
        // Buttons deaktivieren um doppelte Eingabe zu vermeiden
        answerButtonArray.forEach { $0.isEnabled = false }
        
        // Verzögerung
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
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
    
    
    // MARK: - Button Styling
    
    /*
    func styleButton(_ button: UIButton) {
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 14
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.layer.shadowOpacity = 0.35
        button.layer.shadowOffset = CGSize(width: 5, height: 5)
        button.layer.shadowRadius = 6
    }
     
     */
}









/*
import UIKit

//class QuizViewController: UIViewController {
class QuizViewController: BackgroundViewController {
    
    enum QuestionType {
        case name
        case latin
        case genus
        case toxicity
    }
    
    var currentQuestionType: QuestionType = .name
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    @IBOutlet weak var answerButton3: UIButton!
    @IBOutlet weak var answerButton4: UIButton!
    
    var answerButtonArray: [UIButton] = []
    var fourButtonTitles: [String] = []
    
    let fixedMushroomList: [Mushroom] = MushroomData.all
    
    var variableMushroomList: [Mushroom] = []
    var currentMushroomIndex = 0
    var answerIsCorrect = false
    var correctAnswerCount = 0
    
    var askName = true
    var askLatinName = false
    var askGenus = false
    var askToxicity = false
    
    @IBAction func answerButtonTapped(_ sender: UIButton) {
        
        let title = sender.title(for: .normal)!
        let mushroom = variableMushroomList[currentMushroomIndex]
        
        let correctAnswer: String
        
        switch currentQuestionType {
        case .name: correctAnswer = mushroom.name
        case .latin: correctAnswer = mushroom.latinName
        case .genus: correctAnswer = mushroom.genus
        case .toxicity: correctAnswer = mushroom.toxicity
        }
        
        if title == correctAnswer {
            answerIsCorrect = true
            correctAnswerCount += 1
            sender.backgroundColor = .systemGreen
        } else {
            answerIsCorrect = false
            sender.backgroundColor = .systemRed
        }
        
        
        
        
        
        
        
        
        
        
        
        
        /*
         let title = sender.title(for: .normal)
         let correctAnswer = variableMushroomList[currentMushroomIndex].name
         
         if title == correctAnswer {
         answerIsCorrect = true
         correctAnswerCount += 1
         sender.backgroundColor = UIColor.systemGreen
         print("Richtig")
         } else {
         answerIsCorrect = false
         sender.backgroundColor = UIColor.systemRed
         print("Falsch — richtig wäre: \(correctAnswer)")
         }
         */
        // Buttons deaktivieren, um mehrfache Betätigung zu vermeiden.
        answerButtonArray.forEach { $0.isEnabled = false }
        
        // Verzögerung
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            
            // Nächste Frage laden
            self.currentMushroomIndex += 1
            
            if self.currentMushroomIndex >= self.variableMushroomList.count {
                self.currentMushroomIndex = 0
                self.displayScoreAlert()
            }
            
            // Buttons zurücksetzen
            self.answerButtonArray.forEach {
                $0.backgroundColor = UIColor.systemBlue   // deine Standardfarbe
                $0.isEnabled = true
            }
            
            self.updateUI()
        }
    }
    
    func setupQuiz() {
        // Würfelt variableMushroomList durcheinander
        variableMushroomList = fixedMushroomList.shuffled()
        currentMushroomIndex = 0
        correctAnswerCount = 0
        answerIsCorrect = false
    }
    
    func updateUI() {
        let mushroom = variableMushroomList[currentMushroomIndex]
        
        // 1. Liste aller aktivierten Fragetypen erstellen
        var availableTypes: [QuestionType] = []
        
        if askName { availableTypes.append(.name) }
        if askLatinName { availableTypes.append(.latin) }
        if askGenus { availableTypes.append(.genus) }
        if askToxicity { availableTypes.append(.toxicity) }
        
        // 2. Zufällig einen auswählen
        currentQuestionType = availableTypes.randomElement()!
        
        // 3. Bild setzen
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: mushroom.name)
        
        // 4. Antworten generieren
        assignAnswers(for: mushroom)
    }
    
    func assignAnswers(for mushroom: Mushroom) {
        
        let correctAnswer: String
        
        switch currentQuestionType {
        case .name:
            correctAnswer = mushroom.name
        case .latin:
            correctAnswer = mushroom.latinName
        case .genus:
            correctAnswer = mushroom.genus
        case .toxicity:
            correctAnswer = mushroom.toxicity
        }
        
        // Falsche Antworten sammeln als Set um doppelte Antworten zu vermeiden
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

        // Richtige Antwort aus den falschen entfernen
        wrongAnswersSet.remove(correctAnswer)
        
        var wrongAnswers = Array(wrongAnswersSet)
        wrongAnswers.shuffle()

        
        
        
        
        
        
        // Falsche Antworten sammeln
        /*
        var wrongAnswers: [String] = []
        for m in fixedMushroomList {
            if m.name != mushroom.name {   // wichtig: nicht denselben Pilz nehmen
                switch currentQuestionType {
                case .name: wrongAnswers.append(m.name)
                case .latin: wrongAnswers.append(m.latinName)
                case .genus: wrongAnswers.append(m.genus)
                case .toxicity: wrongAnswers.append(m.toxicity)
                }
            }
        }
        wrongAnswers.shuffle()
        */
        
        
        
        let selectedWrongAnswers = Array(wrongAnswers.prefix(3))
        
        var allFour = [correctAnswer] + selectedWrongAnswers
        allFour.shuffle()
        
        for i in 0..<answerButtonArray.count {
            answerButtonArray[i].setTitle(allFour[i], for: .normal)
        }
    }
    
    
    /*
     func updateUI() {
     let mushroom = variableMushroomList[currentMushroomIndex]
     let image = UIImage(named: mushroom.name)
     imageView.layer.cornerRadius = 16
     imageView.clipsToBounds = true
     imageView.contentMode = .scaleAspectFill
     imageView.image = image
     assignAnswers(correctAnswer: mushroom.name)
     }
     */
    
    /*
     func assignAnswers(correctAnswer: String) {
     
     // Falsche Antworten sammeln
     var wrongAnswers: [String] = []
     
     for mushroom in fixedMushroomList {
     if mushroom.name != correctAnswer {
     wrongAnswers.append(mushroom.name)
     }
     }
     
     // wrongAnswers mischen
     for i in 0..<(wrongAnswers.count - 1) {
     let j = Int.random(in: i..<wrongAnswers.count)
     wrongAnswers.swapAt(i, j)
     }
     
     // Die ersten 3 falschen Antworten nehmen
     var selectedWrongAnswers: [String] = []
     for i in 0..<3 {
     selectedWrongAnswers.append(wrongAnswers[i])
     }
     
     // Richtige + falsche Antworten zusammenführen
     var allFourAnswers: [String] = []
     allFourAnswers.append(correctAnswer)
     
     for wrong in selectedWrongAnswers {
     allFourAnswers.append(wrong)
     }
     
     // allFourAnswers mischen
     for i in 0..<(allFourAnswers.count - 1) {
     let j = Int.random(in: i..<allFourAnswers.count)
     allFourAnswers.swapAt(i, j)
     }
     
     // Buttons befüllen
     for i in 0..<answerButtonArray.count {
     answerButtonArray[i].setTitle(allFourAnswers[i], for: .normal)
     }
     }
     */
    
    
    // Zeigt das modale Pop-up zur Anzeige der Punktzahl
    func displayScoreAlert() {
        //Meldung wird erzeugt
        let alert = UIAlertController(title: "Quiz Punktzahl", message: "Deine Punktzahl ist \(correctAnswerCount) von \(variableMushroomList.count).", preferredStyle: .alert)
        
        //Beschreibt den Button des Pop-ups (für Aktion)
        //Callback: Er ruft die Methode scoreAlertDismissed(_:) auf
        let dismissAction = UIAlertAction(title: "Zum Hauptmenü", style: .default, handler: scoreAlertDismissed(_:))
        
        //Die Aktion wird dem Action-Controller übergeben
        alert.addAction(dismissAction)
        
        // Meldung wird präsentiert
        present(alert, animated: true, completion: nil)
    }
    
    // Vom Pop-up zurück zum WelcomeViewController
    func scoreAlertDismissed(_ action: UIAlertAction) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func styleButton(_ button: UIButton) {
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.layer.cornerRadius = 14
        button.layer.masksToBounds = false
        
        button.layer.shadowColor = UIColor.lightGray.cgColor
        //button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.35
        button.layer.shadowOffset = CGSize(width: 5, height: 5)
        button.layer.shadowRadius = 6
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        answerButtonArray = [answerButton1, answerButton2, answerButton3, answerButton4]
        setupQuiz()
        
        for button in answerButtonArray {
            styleButton(button)
        }
        
        updateUI()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
*/
