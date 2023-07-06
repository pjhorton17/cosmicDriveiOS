//
//  MainMenuViewController.swift
//  PuttPuttScoreCard
//
//  Created by Patrick Horton on 10/7/20.
//  Copyright © 2020 Patrick Horton. All rights reserved.
//

import UIKit
import StoreKit
import AppTrackingTransparency

enum AppStoreReviewManager {
  static func requestReviewIfAppropriate() {
    SKStoreReviewController.requestReview()
  }
}

class MainMenuViewController: UIViewController {
    
    let BUTTON_BACKGROUND_COLOR = UIColor(red: 0/255, green: 255/255, blue: 206/255, alpha: 1.0)
    let BUTTON_BORDER_COLOR = UIColor.black.cgColor

   // @IBOutlet weak var achievementsButton: UIButton!
    var cityChosen = ""
      
    var gameInProgress = false
    var newGameTapped = false

    // Menu Buttons
    @IBOutlet weak var playGolfButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var scoreHistoryButton: UIButton!
    @IBOutlet weak var rateUsButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    // NewGame Confirmation View & Buttons
    @IBOutlet weak var newGameConfirmationView: UIView!
    @IBOutlet weak var newGameSelectionView: UIView!
    
    @IBOutlet weak var noNewGameButton: UIButton!
    @IBOutlet weak var yesNewGameButton: UIButton!
    
    override func viewDidLoad() {
           super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
           self.view.snapshotView(afterScreenUpdates: true)
           newGameConfirmationView.backgroundColor = UIColor(red: 70/255, green: 70/255, blue: 70/255, alpha: 0.75)
           newGameConfirmationView.alpha = 0
        
           
           loadGame()
           
           // Set the playGolf button to look cool
           playGolfButton.layer.cornerRadius = 20
           playGolfButton.layer.masksToBounds = true
           playGolfButton.layer.borderColor = BUTTON_BORDER_COLOR
           playGolfButton.layer.borderWidth = 2
           playGolfButton.backgroundColor = BUTTON_BACKGROUND_COLOR
           
           continueButton.layer.cornerRadius = 20
           continueButton.layer.masksToBounds = true
           continueButton.layer.borderColor = BUTTON_BORDER_COLOR
           continueButton.layer.borderWidth = 2
           continueButton.backgroundColor = BUTTON_BACKGROUND_COLOR
           
           if gameInProgress == false {
               continueButton.isEnabled = false
               continueButton.setTitleColor(.systemGray, for: .disabled)
           }
           
           else {
               continueButton.isEnabled = true
           }
           
           
           // Set the scoreHistory button to look cool
           scoreHistoryButton.layer.cornerRadius = 20
           scoreHistoryButton.layer.masksToBounds = true
           scoreHistoryButton.layer.borderColor = BUTTON_BORDER_COLOR
           scoreHistoryButton.layer.borderWidth = 2
           scoreHistoryButton.backgroundColor = BUTTON_BACKGROUND_COLOR
           
           // Set the scoreHistory button to look cool
           rateUsButton.layer.cornerRadius = 20
           rateUsButton.layer.masksToBounds = true
           rateUsButton.layer.borderColor = BUTTON_BORDER_COLOR
           rateUsButton.layer.borderWidth = 2
           rateUsButton.backgroundColor = BUTTON_BACKGROUND_COLOR
        
           // Set the scoreHistory button to look cool
           shareButton.layer.cornerRadius = 20
           shareButton.layer.masksToBounds = true
           shareButton.layer.borderColor = BUTTON_BORDER_COLOR
           shareButton.layer.borderWidth = 2
           shareButton.backgroundColor = BUTTON_BACKGROUND_COLOR
        
          /* Set the scoreHistory button to look cool
          achievementsButton.layer.cornerRadius = 20
          achievementsButton.layer.masksToBounds = true
          achievementsButton.layer.borderColor = BUTTON_BORDER_COLOR
          achievementsButton.layer.borderWidth = 2
          achievementsButton.backgroundColor = BUTTON_BACKGROUND_COLOR */
        
        // Set the scoreHistory button to look cool
        noNewGameButton.layer.cornerRadius = 20
        noNewGameButton.layer.masksToBounds = true
        noNewGameButton.layer.borderColor = BUTTON_BORDER_COLOR
        noNewGameButton.layer.borderWidth = 2
        noNewGameButton.backgroundColor = BUTTON_BACKGROUND_COLOR
        
        // Set the scoreHistory button to look cool
        yesNewGameButton.layer.cornerRadius = 20
        yesNewGameButton.layer.masksToBounds = true
        yesNewGameButton.layer.borderColor = BUTTON_BORDER_COLOR
        yesNewGameButton.layer.borderWidth = 2
        yesNewGameButton.backgroundColor = BUTTON_BACKGROUND_COLOR
        
        // Update newGameSelectionView
        newGameSelectionView.layer.cornerRadius = 30
       }
    
    override func viewWillAppear(_ animated: Bool) {
        /* Request permission for ads
        ATTrackingManager.requestTrackingAuthorization{status in
            switch status {
            case .notDetermined:
                print("Not Determined")
                break
            case .restricted:
                print("Restricted")
                break
            case .denied:
                print("Denied")
                break
            case .authorized:
                print("Authorized)")
                break
            @unknown default:
                break
                
            }
        } */
        
        loadGame()
        navigationController?.navigationBar.alpha = 1
        if gameInProgress == false {
            continueButton.isEnabled = false
            continueButton.setTitleColor(.systemGray, for: .disabled)
        }
        
        else {
            continueButton.isEnabled = true
        }
    }
       
       @IBAction func noNewGameTapped(_ sender: Any) {
           newGameConfirmationView.alpha = 0
       }
       
       @IBAction func yesNewGameTapped(_ sender: Any) {
           gameInProgress = false
        newGameConfirmationView.alpha = 0
           saveGame()
           performSegue(withIdentifier: "goToHowManyPlayers", sender: self)
       }
    
    @IBAction func rateUsTapped(_ sender: Any) {
           guard let url = URL(string: "itms-apps://itunes.apple.com/app/" + "6449625473") else {
               return
           }
           if #available(iOS 10, *) {
               UIApplication.shared.open(url, options: [:], completionHandler: nil)

           } else {
               UIApplication.shared.openURL(url)
           }
        
        // Save the luckyCounter Value
        let defaults = UserDefaults.standard
        defaults.set(1, forKey: "appRated")
       }
    
    @IBAction func shareTapped(_ sender: UIButton) {
        
        // check if user has facebook
        let textToShare = "Download the Cosmic Drive app here!"
        _ = URL(string: "itms-apps://itunes.apple.com/app/" + "6449625473")
        if let actualWebsiteToShare = URL(string: "itms-apps://itunes.apple.com/app/" + "6449625473") {
            let objectsToShare = [textToShare, actualWebsiteToShare] as [Any]
            let shareViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            shareViewController.popoverPresentationController?.sourceView = sender
            self.present(shareViewController, animated: true, completion: nil)
        }
        
        // Save the luckyCounter Value
        let defaults = UserDefaults.standard
        defaults.set(1, forKey: "appShared")
    }
    
       
     /*  @IBAction func achievementsTapped(_ sender: Any) {
        performSegue(withIdentifier: "goToAchievements", sender: self)
       } */
       
       @IBAction func playGolfTapped(_ sender: Any) {
           newGameTapped = true
           
           if continueButton.isEnabled == true {
               // Ask the user if they are sure they want to abandon their game
               newGameConfirmationView.alpha = 1
           }
               
           else {
               performSegue(withIdentifier: "goToHowManyPlayers", sender: self)
           }
       }
       
       @IBAction func continueTapped(_ sender: Any) {
           // Take player straight to the scoreCard
           newGameTapped = false
           performSegue(withIdentifier: "goToScoreCard", sender: self)
       }
       
       @IBAction func scoreHistoryTapped(_ sender: Any) {
           performSegue(withIdentifier: "goToHistory", sender: self)
       }
       @IBAction func contactUsTapped(_ sender: Any) {
           performSegue(withIdentifier: "goToContacts", sender: self)
       }
       
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
           if segue.destination is ScoreCardViewController {
               let scoreCardVS = segue.destination as? ScoreCardViewController
               scoreCardVS?.gameInProgress = true
           }
       }
       
       func loadGame(){
       let defaults = UserDefaults.standard
           
           // Load the additionProgress Values
           if let actualGameInProgress = defaults.value(forKey: "gameInProgress") as? Bool {
               gameInProgress = actualGameInProgress
           }
       }
       
       func saveGame() {
           let defaults = UserDefaults.standard
           
           // Save the luckyCounter Value
           defaults.set(gameInProgress, forKey: "gameInProgress")
       }
    
   // func presentMediationTestSuite() {
     //   GoogleMobileAdsMediationTestSuite.present(withAppID: "ca-app-pub-5910555078334309~7473450744", on: self, delegate: nil)
 //   }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
       // presentMediationTestSuite()
        
        // Check to see if the user can rate the app
        let defaults = UserDefaults.standard
        
        if let actualGameHistory = defaults.value(forKey: "gameHistory") as? [[Any]] {
            let numberOfGamesCompleted = actualGameHistory.count
            if numberOfGamesCompleted >= 1 {
                AppStoreReviewManager.requestReviewIfAppropriate()
            }
        }
    }
}
