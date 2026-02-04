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
    
    
    let fixedElementList = ["Apfeltäubling", "Beutelstäubling", "Fliegenpilz", "Karbol-Champignon", "Duftender Klumpfuß", "Dünnstieliger Helmkreisling", "Eichenmilchling", "Fleischfarbener Hallimasch", "Gemeiner Steinpilz", "Anistäubling"]
    var elementList: [String] = []
    var currentElementIndex = 0
    var answerIsCorrect = false
    var correctAnswerCount = 0
    
    
    @IBAction func answerButtonTapped(_ sender: UIButton) {
        guard let title = sender.title(for: .normal) else { return }

        let correctAnswer = elementList[currentElementIndex]

        if title == correctAnswer {
            answerIsCorrect = true
            correctAnswerCount += 1
            print("Richtig")
        } else {
            answerIsCorrect = false
            print("Falsch — richtig wäre: \(correctAnswer)")
        }

        // Nächste Frage laden
        currentElementIndex += 1

        if currentElementIndex >= elementList.count {
            currentElementIndex = 0
            // Hier könntest du später Score anzeigen
        }

        updateUI()
    }

    
    
    
    
    
    func setupQuiz() {
        // Würfelt elementList durcheinander
        elementList = fixedElementList.shuffled()
        
        
        
        currentElementIndex = 0
        correctAnswerCount = 0
        answerIsCorrect = false
    }
    
    func updateUI() {
        let elementName = elementList[currentElementIndex]
        
        let image = UIImage(named: elementName)
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = image
        
        assignAnswers(correctAnswer: elementName)
    }
    
    func assignAnswers(correctAnswer: String) {

        // 1. Alle falschen Antworten bestimmen
        let wrongAnswers = fixedElementList
            .filter { $0 != correctAnswer }
            .shuffled()
            .prefix(3)

        // 2. Richtige + falsche Antworten zusammenführen
        let allFourAnswers = ([correctAnswer] + wrongAnswers).shuffled()

        // 3. Buttons mit Titeln befüllen
        for (index, button) in answerButtonArray.enumerated() {
            button.setTitle(allFourAnswers[index], for: .normal)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
 //       let fixedAnswerButtonArray: [UIButton] = [answerButton1, answerButton2, answerButton3, answerButton4]
        
        answerButtonArray = [answerButton1, answerButton2, answerButton3, answerButton4]
        setupQuiz()
        updateUI()

        // Do any additional setup after loading the view.
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
