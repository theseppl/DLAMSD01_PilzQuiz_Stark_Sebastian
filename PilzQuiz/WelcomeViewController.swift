//
//  WelcomeViewController.swift
//  PilzQuiz
//
//  Created by Sebastian Stark on 02.02.26.
//

import UIKit

/*
 Der Startbildschirm der App.
 Aufgaben dieses Screens: Auswahl, welche Fragetypen im Quiz abgefragt werden sollen.
 Navigation zum Quiz oder zum FlashCard‑Modus.
 Sicherstellen, dass mindestens eine Quiz‑Kategorie aktiv ist.
 */

class WelcomeViewController: BackgroundViewController {
    
    // MARK: - Variablen
    
    // Diese Variablen speichern die Auswahl des Nutzers.
    // Sie werden beim Übergang zum Quiz an den QuizViewController übergeben
    var askName = true
    var askLatinName = false
    var askGenus = false
    var askToxicity = false
    
    // Buttons für die beiden Modi
    @IBOutlet weak var flashCardsButton: UIButton!
    @IBOutlet weak var quizButton: UIButton!
    
    // Switches für die auswählbaren Fragetypen
    @IBOutlet weak var nameSwitch: UISwitch!
    @IBOutlet weak var latinNameSwitch: UISwitch!
    @IBOutlet weak var genusSwitch: UISwitch!
    @IBOutlet weak var toxicitySwitch: UISwitch!
    
    // MARK: - Funktionen
    
    // Wird ausgelöst, wenn einer der Switches verändert wird.
    // Stellt sicher, dass mindestens ein Fragetyp aktiv bleibt.
    @IBAction func switchChanged(_ sender: UISwitch) {
        
        // Prüfen, ob alle aus sind
        if !nameSwitch.isOn &&
            !latinNameSwitch.isOn &&
            !genusSwitch.isOn &&
            !toxicitySwitch.isOn {
            
            // Den gerade veränderten Switch wieder einschalten
            sender.setOn(true, animated: true)
            
            // Rückmeldung an Nutzer
            let alert = UIAlertController(
                title: "Mindestens eine Option",
                message: "Du musst mindestens eine Eigenschaft auswählen.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    
    // Übergibt die Switch‑Einstellungen an den QuizViewController.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Prüfen, ob das Ziel der Quiz‑Screen ist
        if let quizVC = segue.destination as? QuizViewController {
            
            // Einstellungen übertragen
            quizVC.askName = nameSwitch.isOn
            quizVC.askLatinName = latinNameSwitch.isOn
            quizVC.askGenus = genusSwitch.isOn
            quizVC.askToxicity = toxicitySwitch.isOn
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Buttons im einheitlichen Stil anzeigen
        Style.button(flashCardsButton)
        Style.button(quizButton)
        
        // Alle Switches im einheitlichen Stil anzeigen
        let switchesList: [UISwitch] = [nameSwitch, latinNameSwitch, genusSwitch, toxicitySwitch]
        for mySwitch in switchesList {
            Style.switches(mySwitch)
        }
    }
}
