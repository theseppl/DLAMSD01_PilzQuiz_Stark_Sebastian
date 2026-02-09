//
//  Mushroom.swift
//  PilzQuiz
//
//  Created by Sebastian Stark on 05.02.26.
//

import Foundation

// Datenmodell für einen einzelnen Pilz.
struct Mushroom {
    let name: String
    let genus: String
    let latinName: String
    let toxicity: String
}

// Sammlung aller in der App verfügbaren Pilzdaten.
struct MushroomData{
    static let all: [Mushroom] = [
        Mushroom(name: "Apfeltäubling", genus: "Täublinge", latinName: "Russula paludosa", toxicity: "Essbar 1 - sehr guter Speisepilz"),
        Mushroom(name: "Beutelstäubling", genus: "Stäublinge (Staubpilze), Boviste", latinName: "Lycoperdon excipuliforme", toxicity: "Essbar 2 - guter Speisepilz"),
        Mushroom(name: "Duftender Klumpfuß", genus: "Klumpfüße", latinName: "Cortinarius suaveolens", toxicity: "Giftig (tödlich)"),
        Mushroom(name: "Dünnstieliger Helmkreisling", genus: "Helmkreislinge", latinName: "Cudoniella acicularis", toxicity: "Nicht essbar - ungenießbar"),
        Mushroom(name: "Eichenmilchling", genus: "Milchlinge", latinName: "Lactarius quietus", toxicity: "Essbar 3 - guter Mischpilz"),
        Mushroom(name: "Fliegenpilz", genus: "Wulstlinge", latinName: "Amanita muscaria", toxicity: "Giftig"),
        Mushroom(name: "Fleischfarbener Hallimasch", genus: "Hallimasche", latinName: "Armillaria gallica", toxicity: "Essbar 2 - guter Speisepilz"),
        Mushroom(name: "Gemeiner Steinpilz", genus: "Röhrlinge", latinName: "Boletus edulis", toxicity: "Essbar 1 - sehr guter Speisepilz"),
        Mushroom(name: "Karbol-Champignon", genus: "Champignon-Egerlinge", latinName: "Agaricus xanthodermus", toxicity: "Giftig"),
        Mushroom(name: "Anistäubling", genus: "Täublinge", latinName: "Russula fragrantissima", toxicity: "Nicht essbar - ungenießbar")
    ]
}
