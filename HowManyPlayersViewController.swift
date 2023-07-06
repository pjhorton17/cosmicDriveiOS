//
//  HowManyPlayersViewController.swift
//  PuttPuttScoreCard
//
//  Created by Patrick Horton on 10/7/20.
//  Copyright © 2020 Patrick Horton. All rights reserved.
//

import UIKit

class HowManyPlayersViewController: UIViewController, ScoreCardViewControllerDelegate {
    let BUTTON_BORDER_COLOR = UIColor.black.cgColor
    let BUTTON_BACKGROUND_COLOR = UIColor(red: 0/255, green: 255/255, blue: 206/255, alpha: 1.0)
    
    var counter = 1
    var numberOfPlayers = 0
    var city = ""
    //@IBOutlet weak var adView: GADBannerView!
        
    // Set a variable to hold the VC
    var scoreCardViewController: ScoreCardViewController?
        
        @IBOutlet weak var mainSV: UIStackView!
        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.snapshotView(afterScreenUpdates: true)
                       
            mainSV.distribution = .fillEqually
            mainSV.spacing = 0
            
            // Create 3 stackviews, each with 2 buttons
            for i in 1...2 {
                
                let horizontalSV = UIStackView()
                horizontalSV.alignment = .center
                horizontalSV.distribution = .fillEqually
                horizontalSV.spacing = 10
                
                
                // Add this to the main SV
                mainSV.addArrangedSubview(horizontalSV)
                
                // Add 3 buttons to the stackview
                if (i == 1) {
                    for _ in 1...3 {
                        let buttonToAdd = HowManyPlayersButton()
                        customizeButton(button: buttonToAdd)
                        
                        horizontalSV.addArrangedSubview(buttonToAdd)
                        // Increment the counter
                        counter += 1
                    }
                }
                else {
                    for j in 1...3 {
                        let buttonToAdd = HowManyPlayersButton()
                        customizeButton(button: buttonToAdd)
                        
                        if (j == 3) {
                            buttonToAdd.isUserInteractionEnabled = false
                            buttonToAdd.alpha = 0
                            
                        }
                        
                        horizontalSV.addArrangedSubview(buttonToAdd)
                        // Increment the counter
                        counter += 1
                    }
                }
                
            }
        
        }
        
        func customizeButton(button:UIButton) {
            button.setTitle("\(counter)", for: .normal)
            button.setTitleColor(UIColor.black, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            button.layer.cornerRadius = 60/2
            button.tag = counter
            button.layer.masksToBounds = true
            button.layer.borderColor = BUTTON_BORDER_COLOR
            button.layer.borderWidth = 2
            button.backgroundColor = BUTTON_BACKGROUND_COLOR
            let heightConstraint = NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 60)
            let widthConstraint = NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 110)

            button.addConstraint(heightConstraint)
            button.addConstraint(widthConstraint)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goToScoreCard))
            button.addGestureRecognizer(tapGesture)
            
            button.setTitleColor(UIColor.gray, for: .highlighted)
        }
        
        @objc func goToScoreCard(gestureRecognizer: UITapGestureRecognizer) {
            let button = gestureRecognizer.view as! HowManyPlayersButton
            numberOfPlayers = button.tag
            performSegue(withIdentifier: "goToScoreCard", sender: self)
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Tell the segue exactly which level is selected (level that was tapped)
            scoreCardViewController = (segue.destination as! ScoreCardViewController)
            
            if segue.destination is ScoreCardViewController
            {
                if let scoreCardVC = scoreCardViewController {
                    scoreCardVC.delegate = self
                    scoreCardVC.numberOfPlayers = numberOfPlayers
                    scoreCardVC.city = city
                    saveGame()
                }
                
            }
        }
        
        func saveGame() {
            let defaults = UserDefaults.standard
            
            // Save the luckyCounter Value
             defaults.set(numberOfPlayers, forKey: "numberOfPlayers")
            
            // Save the luckyCounter Value
            defaults.set(1, forKey: "numPlayersViewed")
                   
        }
}
