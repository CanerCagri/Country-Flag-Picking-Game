//
//  ViewController.swift
//  CountryFlagPickingGame
//
//  Created by Caner Çağrı on 5.01.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var correctAnswer = 0
    var score = 0
    var previousScores = [Scores]()
    var askedQuestionCount = 0
    
    // 3 CHALLENGE DA OYUNA DAHIL EDILDI ..!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(navCorrectScore))
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        // butonlarin disindaki kenarligi 1
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        // butonlarin kenarliginin rengini  degisti. Main appin backgroundu beyaz oldugu icin beyaz renk iceren bayraklarla kotu gorunuyordu
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor(red: 0.4, green: 0.5, blue: 0.3, alpha: 1.0).cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor

        askQuestion()
        
        
        
        loadSavedData()
        
        
        
    }
    
    func askQuestion(action : UIAlertAction! = nil ) {
        askedQuestionCount += 1
        //rastgele olarak countries arrayindeki stringleri karistiriyor
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = countries[correctAnswer].uppercased()
        title! += "  Score : \(score)"
    }
    
    @IBAction func buttonTaped(_ sender: UIButton) {
        var title : String
     
        // secim yapildikdan sonra gelen uyarilar
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else{
            title = "Wrong. That's the flag of : \(countries[sender.tag].uppercased())"
            score -= 1
        }
        // 10 defa sordurduk ve en sonda final soru oldugunu soyle ve en son skoru gostererek bitirdik
        var ac = UIAlertController(title: title, message: "", preferredStyle: .alert)
        // continue dedikten sonra tekrar askquestion foncunu cagiriyor yani oyun yenileniyor ve oynanmaya devam ediliyor.
        if (askedQuestionCount < 10) {
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        }else if (askedQuestionCount == 10){
            title = "FINAL QUESTION"
            ac.addAction(UIAlertAction(title: title, style: .default, handler: askQuestion))
                
        }else {
            let lastScore = Scores(Score: score)
            previousScores.append(lastScore)
            save()
            title = "GAME IS OVER!"
            ac = UIAlertController(title: title, message: "FINAL SCORE : \(score)", preferredStyle: .alert)
            for (i,i2) in previousScores.enumerated() {
                if score > i2.Score && i + 2 == previousScores.count{
                    let highScore = UIAlertAction(title: "HIGHEST SCORE IN GAME !!! CONGRATS", style: .default)
                    
                    highScore.isEnabled = false
                    ac.addAction(highScore)
                }
                
                
                
            }
            ac.addAction(UIAlertAction(title: "Play Again", style: .default) { [weak self] _ in
                
                self?.score = 0
                self?.askedQuestionCount = 0
                self?.askQuestion()
            })
            loadSavedData()
        }
        
        
        present(ac, animated: true )
    }
    @objc func navCorrectScore() {
        previousScores.removeAll()
        save()
    }
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(previousScores) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "previousScores")
        } else {
            print("Failed to save score")
        }
    }
    func loadSavedData() {
        let defaults = UserDefaults.standard
        
        if let savedScore = defaults.object(forKey: "previousScores") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                previousScores = try jsonDecoder.decode([Scores].self, from: savedScore)
            } catch {
                print("Failed to load Previous Scores")
            }
        }
    }
}

