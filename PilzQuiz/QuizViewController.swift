//
//  QuizViewController.swift
//  PilzQuiz
//
//  Created by Sebastian Stark on 02.02.26.
//

import UIKit

class QuizViewController: UIViewController {

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
    
    @IBAction func answerButtonTapped(_ sender: UIButton) {
        let title = sender.title(for: .normal)

        let correctAnswer = variableMushroomList[currentMushroomIndex].name

        if title == correctAnswer {
            answerIsCorrect = true
            correctAnswerCount += 1
            print("Richtig")
        } else {
            answerIsCorrect = false
            print("Falsch — richtig wäre: \(correctAnswer)")
        }

        // Nächste Frage laden
        currentMushroomIndex += 1

        if currentMushroomIndex >= variableMushroomList.count {
            currentMushroomIndex = 0
            displayScoreAlert()
        }

        updateUI()
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
        let image = UIImage(named: mushroom.name)
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = image
        assignAnswers(correctAnswer: mushroom.name)
    }

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

    override func viewDidLoad() {
        super.viewDidLoad()
        answerButtonArray = [answerButton1, answerButton2, answerButton3, answerButton4]
        setupQuiz()
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
