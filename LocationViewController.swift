//
//  LocationViewController.swift
//  PuttPuttScoreCard
//
//  Created by Patrick Horton on 10/7/20.
//  Copyright © 2020 Patrick Horton. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController, UITextFieldDelegate {
    let BUTTON_BACKGROUND_COLOR = UIColor(red: 0/255, green: 255/255, blue: 206/255, alpha: 1.0)
    let BUTTON_BORDER_COLOR = UIColor.black.cgColor
    
    var city = ""
    var phoneNumber = ""
    var phoneForMethod = ""
    var email = ""
    var address = ""
    
    var gameInProgress = false
    
    @IBOutlet weak var locationTF: UITextField!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var welcomeToLabel: UILabel!
    @IBOutlet weak var golfNStuffLabel: UILabel!
    var myString:NSString = "Golf N' Stuff!"
    var myMutableString = NSMutableAttributedString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.snapshotView(afterScreenUpdates: true)
        // Do any additional setup after loading the view.
        loadGame()
        
        locationTF.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissTF))
        
        self.view.addGestureRecognizer(tapGesture)
        
        nextButton.backgroundColor = BUTTON_BACKGROUND_COLOR
        nextButton.layer.borderColor = BUTTON_BORDER_COLOR
        nextButton.layer.cornerRadius = 20
        nextButton.layer.masksToBounds = true
        nextButton.layer.borderWidth = 2
        
        // Create a string that we can mutate for different colors
        myMutableString = NSMutableAttributedString(string:myString as String)
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 245/255, green: 255/255, blue: 5/255, alpha: 1), range: NSRange(location:0, length: 4))
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 255/255, green: 168/255, blue: 5/255, alpha: 1), range: NSRange(location: 5, length: 2))
        
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 245/255, green: 255/255, blue: 5/255, alpha: 1), range: NSRange(location:8, length: 6))
        
        
        var yourBackImage = UIImage(named: "BackButton")
        yourBackImage = yourBackImage?.withRenderingMode(.alwaysOriginal)
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
      //  }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        locationTF.becomeFirstResponder()
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.alpha = 1.0
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        // Set the location
        if locationTF.text != "" {
            city = locationTF.text!
            
            // Send the user to enter # of players
            performSegue(withIdentifier: "goToHowManyPlayers", sender: self)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is HowManyPlayersViewController
        {
            // save the city
            saveGame()
        }
        
        if segue.destination is ScoreCardViewController
        {
            let scoreCardVC = segue.destination as? ScoreCardViewController
            scoreCardVC?.gameInProgress = true
        }
    }
    
    func loadGame() {
        let defaults = UserDefaults.standard

        // Load the additionProgress Values
        if let actualGameInProgress = defaults.value(forKey: "gameInProgress") as? Bool {
            gameInProgress = actualGameInProgress
        }
    }
    
    func saveGame() {
        let defaults = UserDefaults.standard
        
        // Save the luckyCounter Value
         defaults.set(city, forKey: "city")
        
        // Save the luckyCounter Value
        defaults.set(1, forKey: "parkNameViewed")
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        locationTF.resignFirstResponder()
        return true
    }
    
    @objc func dismissTF() {
        locationTF.resignFirstResponder()
    }

}
