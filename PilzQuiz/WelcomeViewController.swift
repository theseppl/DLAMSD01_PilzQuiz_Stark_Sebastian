//
//  WelcomeViewController.swift
//  PilzQuiz
//
//  Created by Sebastian Stark on 02.02.26.
//

import UIKit

//class WelcomeViewController: UIViewController {
class WelcomeViewController: BackgroundViewController {
    var askName = true
    var askLatinName = false
    var askGenus = false
    var askToxicity = false
    
    @IBOutlet weak var nameSwitch: UISwitch!
    @IBOutlet weak var latinNameSwitch: UISwitch!
    @IBOutlet weak var genusSwitch: UISwitch!
    @IBOutlet weak var toxicitySwitch: UISwitch!
    
    @IBAction func switchChanged(_ sender: UISwitch) {

        // Prüfen, ob ALLE aus sind
        if !nameSwitch.isOn &&
           !latinNameSwitch.isOn &&
           !genusSwitch.isOn &&
           !toxicitySwitch.isOn {

            // Den gerade veränderten Switch wieder einschalten
            sender.setOn(true, animated: true)

            // Optional: kurze Rückmeldung
            let alert = UIAlertController(
                title: "Mindestens eine Option",
                message: "Du musst mindestens eine Eigenschaft auswählen.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let quizVC = segue.destination as? QuizViewController {
            quizVC.askName = nameSwitch.isOn
            quizVC.askLatinName = latinNameSwitch.isOn
            quizVC.askGenus = genusSwitch.isOn
            quizVC.askToxicity = toxicitySwitch.isOn
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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
