//
//  ScoreCardViewController.swift
//  PuttPuttScoreCard
//
//  Created by Patrick Horton on 10/7/20.
//  Copyright © 2020 Patrick Horton. All rights reserved.

import UIKit

protocol ScoreCardViewControllerDelegate {
    
}

class ScoreCardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    let BUTTON_BACKGROUND_COLOR = UIColor(red: 0/255, green: 255/255, blue: 206/255, alpha: 1.0)
    let BUTTON_BORDER_COLOR = UIColor.black.cgColor
    let NUMBER_OF_HOLES = 10
    var SCORECARD_TABLEVIEW_WIDTH = Int()

      //  @IBOutlet weak var adView: GADBannerView!
        var winningPlayer = ""
        var winningScore = 0
    
        @IBOutlet weak var areYouSureLabel: UILabel!
        var sure = false
        
        var delegate: ScoreCardViewControllerDelegate?
        @IBOutlet weak var backToMainMenu: UIButton!
        @IBAction func backToMainTapped(_ sender: Any) {
            // switch root view controllers
            
            if self.navigationController != nil {
                let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                
                for aViewController in viewControllers {
                    if aViewController is MainMenuViewController {
                        self.navigationController!.popToViewController(aViewController, animated: true)
                    }
                }
            }
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if tableView == scoreCardTableView {
            return numberOfPlayers + 1
            }
            
            if tableView == rankingTableView {
                return numberOfPlayers
            }
            return 0
        }
        
    let holeImageNames = ["American_Savings_Bank", "KTM", "HG_Mortgage", "Krave_Marketing", "Bayview_MiniPutt", "Accel", "UFC", "HB_Homes", "Farmers_Insurance", "Pitch_Sports_Bar", "Kaneohe_Bay", "Kidz_Art"]
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            if tableView == scoreCardTableView {
            if indexPath.row == 0 {
            // Get a prototype cell
            let holeNumberCell = tableView.dequeueReusableCell(withIdentifier: "holeNumberCell")!
                tableView.rowHeight = 60
                // WAS: 45
                
                let holeNumberStackview  = holeNumberCell.viewWithTag(1) as! UIStackView
                holeNumberStackview.axis = .horizontal

            // Add 18 labels
            for i in 1...NUMBER_OF_HOLES {
                
                    //let verticalSV  = holeNumberCell.viewWithTag(2) as! UIStackView
                    let verticalSV = UIStackView()
                    verticalSV.axis = .vertical
                    
                    let roundNumberLabel = UILabel()
                  
    
                roundNumberLabel.text = "Round \(i)"
                roundNumberLabel.backgroundColor = UIColor.black
                roundNumberLabel.font = UIFont(name: "Copperplate", size: 18)
                roundNumberLabel.textColor = UIColor.red
                roundNumberLabel.textAlignment = .center

                roundNumberLabel.layer.borderColor = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1.0).cgColor
                roundNumberLabel.layer.borderWidth = 1
                    
                   
                    // Add the image & title to the vSV
                    verticalSV.addArrangedSubview(roundNumberLabel)
                    
                    // Add this to the sv
                    holeNumberStackview.addArrangedSubview(verticalSV)
            }
               
            return holeNumberCell
            }

            else {
                let playerScoreCell = tableView.dequeueReusableCell(withIdentifier: "scoreCell")!
                tableView.rowHeight = 40
                let playerScoreStackView = playerScoreCell.viewWithTag(1) as! UIStackView
               
                let widthConstraint = NSLayoutConstraint(item: playerScoreStackView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: (CGFloat(SCORECARD_TABLEVIEW_WIDTH)))
               // 1290 + 36
                playerScoreStackView.addConstraint(widthConstraint)
                // Add a button? for each player
                for i in 1...NUMBER_OF_HOLES {
                    let scoreButton = ScoreButton()
                    scoreButton.layer.borderWidth = 1
                    scoreButton.titleLabel?.textAlignment = .center
                    scoreButton.layer.borderColor = UIColor(red: 112/225, green: 112/225, blue: 112/225, alpha: 1.0).cgColor
                    scoreButton.backgroundColor = BUTTON_BACKGROUND_COLOR
                    scoreButton.playerNumber = indexPath.row
                    scoreButton.holeNumber = i
                    scoreButton.setTitleColor(.black, for: .normal)
                    scoreButton.titleLabel?.font = UIFont(name: "ChalkboardSE-Light", size: 25)
                    
                    // FOR BEN (Changed 0 to 9)
                    if scoreArray[indexPath.row - 1][i - 1] == 9 {
                        scoreButton.setTitle(nil, for: .normal)
                    }
                    else {
                        scoreButton.setTitle("\(scoreArray[indexPath.row - 1][i - 1])", for: .normal)
                        
                        if scoreButton.titleLabel?.text == nil {
                            scoreButton.backgroundColor = BUTTON_BACKGROUND_COLOR
                        }
                        
                        else if scoreButton.titleLabel?.text == "0" {
                            scoreButton.backgroundColor = UIColor(red: 216/255, green: 100/255, blue: 100/255, alpha: 1.0)
                            
                        }
                        
                        else if scoreButton.titleLabel?.text == "1" {
                            scoreButton.backgroundColor = UIColor(red: 202/255, green: 157/255, blue: 255/255, alpha: 1.0)
                        }
                        
                        else if scoreButton.titleLabel?.text == "2" {
                            scoreButton.backgroundColor = UIColor(red: 136/255, green: 177/255, blue: 255/255, alpha: 1.0)
                        }
                        
                        else if scoreButton.titleLabel?.text == "3" {
                             scoreButton.backgroundColor = UIColor(red: 189/255, green: 255/255, blue: 173/255, alpha: 1.0)
                        }
                        
                        else if scoreButton.titleLabel?.text == "4" {
                            scoreButton.backgroundColor = UIColor(red: 232/255, green: 222/255, blue: 98/255, alpha: 1.0)
                        }
                        
                        else if scoreButton.titleLabel?.text == "5" {
                            scoreButton.backgroundColor = UIColor(red: 255/255, green: 173/255, blue: 121/255, alpha: 1.0)
                        }
                        
                        else if scoreButton.titleLabel?.text == "6" {
                            scoreButton.backgroundColor = UIColor(red: 216/255, green: 100/255, blue: 100/255, alpha: 1.0)
                        }
                        
                        else {
                            scoreButton.backgroundColor = UIColor.black
                            scoreButton.setTitleColor(UIColor.white, for: .normal)
                        }
                    }
                    
                    let gestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(scoreCellTapped(gestureRecognizer:)))
                    
                    scoreButton.addGestureRecognizer(gestureRecognizer)

                    
                    playerScoreStackView.addArrangedSubview(scoreButton)
                }
                updateSVAxis(xPosition: xValue)
                return playerScoreCell
            }
        }
            if tableView == rankingTableView {
                tableView.rowHeight = 35
                
                let rankingCell = tableView.dequeueReusableCell(withIdentifier: "rankingCell")!
                let positionLabel = rankingCell.viewWithTag(1) as! UILabel
                let playerLabel = rankingCell.viewWithTag(2) as! UILabel
                let scoreLabel = rankingCell.viewWithTag(3) as! UILabel
                let strokesBehindLabel = rankingCell.viewWithTag(4) as! UILabel
                
                positionLabel.layer.borderColor = UIColor.black.cgColor
                positionLabel.layer.borderWidth = 1
                positionLabel.backgroundColor = UIColor(red: 165/255, green: 255/255, blue: 154/255, alpha: 1)
                positionLabel.textColor = UIColor.black
                
                playerLabel.layer.borderColor = UIColor.black.cgColor
                playerLabel.layer.borderWidth = 1
                playerLabel.backgroundColor = UIColor(red: 165/255, green: 255/255, blue: 154/255, alpha: 1)
                playerLabel.textColor = UIColor.black
                
                scoreLabel.layer.borderColor = UIColor.black.cgColor
                scoreLabel.layer.borderWidth = 1
                scoreLabel.backgroundColor = UIColor(red: 165/255, green: 255/255, blue: 154/255, alpha: 1)
                scoreLabel.textColor = UIColor.black
                
                strokesBehindLabel.layer.borderColor = UIColor.black.cgColor
                strokesBehindLabel.layer.borderWidth = 1
                strokesBehindLabel.backgroundColor = UIColor(red: 165/255, green: 255/255, blue: 154/255, alpha: 1)
                strokesBehindLabel.textColor = UIColor.black
                
                if newPlayerRanking.count != 0 {

                    if gameOver == true {
                    let fullString = NSMutableAttributedString()
                    
                        // create our NSTextAttachment
                        let image1Attachment = NSTextAttachment()
                        // wrap the attachment in its own attributed string so we can append it
                        let image1String = NSAttributedString(attachment: image1Attachment)

                        if (indexPath.row + 1) == 1{
                            var image = UIImage(named: "Gold")
                            image = resizeImage(image: image!, targetSize: CGSize(width:30.0, height:30.0))
                            image1Attachment.image = image
                            
                            // add the NSTextAttachment wrapper to our full string, then add some more text.
                            fullString.append(image1String)
                            // draw the result in a label
                            positionLabel.attributedText = fullString
                            playerLabel.text = playerNamesArray[newPlayerRanking[indexPath.row]]
                            //winningPlayer = playerLabel.text!
                            
                            
                        }
                        else if (indexPath.row + 1) == 2 {
                            var image = UIImage(named: "Silver")
                            image = resizeImage(image: image!, targetSize: CGSize(width:30.0, height:30.0))
                            image1Attachment.image = image
                            // add the NSTextAttachment wrapper to our full string, then add some more text.
                            fullString.append(image1String)
                            // draw the result in a label
                            positionLabel.attributedText = fullString
                            playerLabel.text = playerNamesArray[newPlayerRanking[indexPath.row]]
                        }
                        
                        else if (indexPath.row + 1) == 3 {
                            var image = UIImage(named: "Bronze")
                            image = resizeImage(image: image!, targetSize: CGSize(width:30.0, height:30.0))
                            image1Attachment.image = image
                            // add the NSTextAttachment wrapper to our full string, then add some more text.
                            fullString.append(image1String)
                            // draw the result in a label
                            positionLabel.attributedText = fullString
                            playerLabel.text = playerNamesArray[newPlayerRanking[indexPath.row]]
                        }
                        else {
                            if indexPath.row + 1 == 1 {
                                positionLabel.text = "\(indexPath.row + 1)st"
                            }
                            else if indexPath.row + 1 == 2 {
                                positionLabel.text = "\(indexPath.row + 1)nd"
                            }
                            else if indexPath.row + 1 == 3{
                                positionLabel.text = "\(indexPath.row + 1)rd"
                            }
                            else {
                                 positionLabel.text = "\(indexPath.row + 1)th"
                            }
                        
                            playerLabel.text = playerNamesArray[newPlayerRanking[indexPath.row]]
                        }
                    }
                         
                    else {
                             if indexPath.row + 1 == 1 {
                                 positionLabel.text = "\(indexPath.row + 1)st"
                             }
                             else if indexPath.row + 1 == 2 {
                                 positionLabel.text = "\(indexPath.row + 1)nd"
                             }
                             else if indexPath.row + 1 == 3{
                                 positionLabel.text = "\(indexPath.row + 1)rd"
                             }
                             else {
                                  positionLabel.text = "\(indexPath.row + 1)th"
                             }
                             playerLabel.text = playerNamesArray[newPlayerRanking[indexPath.row]]
                         }
                // Grab the total score label
                let label = totalScoreSV.arrangedSubviews[newPlayerRanking[indexPath.row]] as! UILabel
                    if label.text == "" {
                        scoreLabel.text = "-"
                    }
                    else {
                        scoreLabel.text = label.text
                        if indexPath.row == 0 {
                            //winningScore = scoreLabel.text!
                        }
                    }
                    var ps = 0
                    var sb = 0
                    if indexPath.row == 0 {
                        strokesBehindLabel.text = "-"
                    }
                    
                    else {
                        // get player score
                        if scoreLabel.text == "-" {
                            ps = 0
                        }
                        else {
                            ps = Int(scoreLabel.text!)!
                        }
                        // get the lable of the fist player
                        let first = totalScoreSV.arrangedSubviews[newPlayerRanking[0]] as! UILabel
                        var fs = 0
                        if first.text == "" {
                            fs = 0
                        }
                        else {
                            fs = Int(first.text!)!
                        }
                        
                        sb = fs - ps
                        
                        if sb == 0 {
                            strokesBehindLabel.text = "-"
                        }
                        else {
                            strokesBehindLabel.text = "\(sb)"
                        }
                    }
                
                return rankingCell
                    
                }
                    
                if newPlayerRanking.count == 0 {
                    positionLabel.text = "\(indexPath.row + 1)"
                    playerLabel.text = "\(playerNamesArray[indexPath.row])"
                    let label = totalScoreSV.arrangedSubviews[indexPath.row] as! UILabel
                    scoreLabel.text = "\(label.text!)"
                    strokesBehindLabel.text = "-"
                
                    return rankingCell
                }
                
            }
            // should never get here...
                return UITableViewCell()
    }
        
        func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
            let size = image.size

            let widthRatio  = targetSize.width  / size.width
            let heightRatio = targetSize.height / size.height

            // Figure out what our orientation is, and use that to form the rectangle
            var newSize: CGSize
            if(widthRatio > heightRatio) {
                newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
            } else {
                newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
            }

            // This is the rect that we've calculated out and this is what is actually used below
            let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

            // Actually do the resizing to the rect using the ImageContext stuff
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            image.draw(in: rect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return newImage!
        }
        
        @IBOutlet weak var rankingViewSV: UIStackView!
        
        @objc func scoreCellTapped(gestureRecognizer: UITapGestureRecognizer) {
        let button = gestureRecognizer.view as! ScoreButton
        playerNum = button.playerNumber
        holeNum = button.holeNumber
        cellBeingUpdated = gestureRecognizer.view as! ScoreButton
       
            // Check if there is a value already
            if cellBeingUpdated.titleLabel?.text == nil || cellBeingUpdated.titleLabel?.text == " " {
                backToMainMenu.alpha = 0
                promptScoreEntry()
            }
                
            else {
                // Ask the user if they want to overwrite the value
                promptUpdateConfirmation()
            }
        }
        
        func promptUpdateConfirmation() {
            backToMainMenu.alpha = 0
            newGameButton.alpha = 0
            viewRankingButton.alpha = 0
            scoreUpdateConfirmationView.alpha = 1
        }
        
        func promptScoreEntry() {
            // Promt UIView of all scores
            enterScoreView.alpha = 1
            newGameButton.alpha = 0
            viewRankingButton.alpha = 0
            
            // Set the reminder label
            reminderLabel.text = "  Round \(holeNum): \(playerNamesArray[playerNum - 1])"
        }
        
        @IBOutlet weak var viewRankingButton: UIButton!
        @IBOutlet weak var newGameButton: UIButton!
        @IBOutlet weak var scoreCardTableView: UITableView!
        
        @IBOutlet weak var tableViewScrollView: UIScrollView!
        
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var playerNameSV: UIStackView!
        @IBOutlet weak var totalScoreSV: UIStackView!
        @IBOutlet weak var scoreCardLabel: UILabel!
        
        @IBOutlet weak var totalLabel: UILabel!
        
        var playerTextField:UITextField?

        @IBOutlet weak var enterScoreView: UIView!
        @IBOutlet weak var scoreViewMini: UIView!
    @IBOutlet weak var reminderLabel: UILabel!
    @IBOutlet weak var clearScoreButton: UIButton!
 //   @IBOutlet weak var ouchButton: UIButton!
    
        @IBOutlet weak var score1Button: UIButton!
        @IBOutlet weak var score2Button: UIButton!
        @IBOutlet weak var score3Button: UIButton!
        @IBOutlet weak var score4Button: UIButton!
        @IBOutlet weak var score5Button: UIButton!
        @IBOutlet weak var score6Button: UIButton!
        var playerNum = 0
        var holeNum = 0
        var cellBeingUpdated = ScoreButton()
        
        var numberOfPlayers = 0
        var scoreArray = [[Int]]()
        var playerNamesArray = [String]()
        var currentPlayerRanking = [Int]()
        @IBOutlet weak var mainRankingSV: UIStackView!
        @IBOutlet weak var viewRankingView: UIView!
        @IBOutlet weak var positionLabel: UILabel!
        @IBOutlet weak var strokesBehindLabel: UILabel!
        @IBOutlet weak var scoreLabel: UILabel!
        @IBOutlet weak var playerLabel: UILabel!
        @IBOutlet weak var rankingTableView: UITableView!
        var newPlayerRanking = [Int]()
        @IBOutlet weak var scoreUpdateConfirmationView: UIView!
        @IBOutlet weak var scoreUpdateOptionView: UIView!
        
        @IBOutlet weak var noButton: UIButton!
        @IBOutlet weak var yesButton: UIButton!
        var city = ""
        var xValue = 0
        
        var gameInProgress = false
        
        @IBOutlet weak var newGameConfirmationView: UIView!
        @IBOutlet weak var newGameSelectionView: UIView!
        @IBOutlet weak var noNewGameButton: UIButton!
        @IBOutlet weak var yesNewGameButton: UIButton!
        @IBAction func noNewGameTapped(_ sender: Any) {
            if sure == false {
                newGameConfirmationView.alpha = 0
            }
            
            else {
                // TODO: Clear current scorecard from memory
                gameInProgress = false
                saveGame()
                
                // Navigate user to city selection screen
                 self.navigationController?.popToRootViewController(animated: true)
            }
        }
        
        @IBOutlet weak var gameDoneConfirmationView: UIView!
        @IBOutlet weak var gameDoneSelectionView: UIView!
        @IBOutlet weak var gameNotDoneButton: UIButton!
        @IBOutlet weak var gameIsDoneButton: UIButton!
        
        @IBOutlet weak var doneButton: UIButton!
        @IBAction func doneTapped(_ sender: Any) {

            self.navigationController?.popToRootViewController(animated: true)
        }
        
        
        @IBAction func gameNotFinishedTapped(_ sender: Any) {
            gameDoneConfirmationView.alpha = 0
            backToMainMenu.alpha = 1
            newGameButton.alpha = 1
            viewRankingButton.alpha = 1
        }
        @IBAction func gameFinishedTapped(_ sender: Any) {
            
            // Take user to final scoreboard
            presentFinalScore()
            
            // Save the game to the user's history
            saveToHistory()
        }
        
        @objc func showRankingTapped(gestureRecognizer: UILongPressGestureRecognizer) {
            updatePlayerRanking()
            rankingTableView.reloadData()
            
            if gestureRecognizer.state == UIGestureRecognizer.State.began {
                viewRankingView.alpha = 1
            }
            else if gestureRecognizer.state == UIGestureRecognizer.State.ended {
                viewRankingView.alpha = 0
            }
        }
        func updatePlayerRanking() {
            var tempArray = [[Int]]()
            newPlayerRanking.removeAll()
            for i in 1...numberOfPlayers {
                let label = totalScoreSV.arrangedSubviews[i - 1] as! UILabel
                var totalScore = Int(label.text!)
                if totalScore == nil {
                    totalScore = 0
                }
                else {
                    totalScore = Int(label.text!)
                }
                label.tag = i
                
                tempArray.append([totalScore!, i])
            }
            
            // Now, sort through and update the current rankings array
            let sortedArray = tempArray.sorted(by: {$0[0] > $1[0] })
            print("\(sortedArray)")
            
            // Now, update the new player ranking
            for i in 1...numberOfPlayers {
                newPlayerRanking.append((sortedArray[i - 1][1]) - 1)
            }
            print("\(newPlayerRanking)")
            
            if gameOver == true {
                winningScore = sortedArray[0][0]
                print("\(winningScore)")
                let winningPlayerNum = sortedArray[0][1]
                winningPlayer = playerNamesArray[winningPlayerNum - 1]
                print("\(winningPlayer)")
            }
            
        }
        func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
            return true
        }
        
        func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
            let item = playerNamesArray[sourceIndexPath.row]
            playerNamesArray.remove(at: sourceIndexPath.row)
            playerNamesArray.insert(item, at: destinationIndexPath.row)
        }
        override func viewWillAppear(_ animated: Bool) {
            
        }
        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.snapshotView(afterScreenUpdates: true)
            self.navigationItem.setHidesBackButton(true, animated: true)
            self.navigationController?.navigationBar.alpha = 0
            
            // Determine the tableview width (160 per image)
            SCORECARD_TABLEVIEW_WIDTH = NUMBER_OF_HOLES * 100

            // make the 7+ button invisible
            //ouchButton.alpha = 0
            //score6Button.alpha = 0
            
            
            doneButton.alpha = 0
            if gameInProgress == true {
                loadGame()
                
                scoreCardTableView.reloadData()
                
                rankingTableView.reloadData()
                
                 // Set the scrollview to the new x-position (moves to the right)
                tableViewScrollView.setContentOffset(CGPoint(x: xValue, y: 0), animated: true) // CHANGED
        
            }
            // load game history
            loadGameHistory()
            
            // Set the size of the scorecard tableview
            let widthConstraint = NSLayoutConstraint(item: scoreCardTableView!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: CGFloat(SCORECARD_TABLEVIEW_WIDTH))
            scoreCardTableView.addConstraint(widthConstraint)
            //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Turf")!)
            scoreUpdateConfirmationView.alpha = 0
            scoreUpdateConfirmationView.backgroundColor = UIColor(red: 70/255, green: 70/255, blue: 70/255, alpha: 0.75)
            scoreUpdateOptionView.layer.cornerRadius = 49
            scoreUpdateOptionView.layer.borderColor = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1).cgColor
            scoreUpdateOptionView.layer.borderWidth = 1
            noButton.layer.cornerRadius = 20
            noButton.backgroundColor = BUTTON_BACKGROUND_COLOR
            noButton.titleLabel?.textColor = UIColor.black
            noButton.layer.borderColor = BUTTON_BORDER_COLOR
            noButton.layer.borderWidth = 1
            
            yesButton.layer.cornerRadius = 20
            yesButton.layer.borderColor = BUTTON_BORDER_COLOR
            yesButton.backgroundColor = BUTTON_BACKGROUND_COLOR
            yesButton.titleLabel?.textColor = UIColor.black
            yesButton.layer.borderWidth = 1
            
            doneButton.layer.cornerRadius = 20
            doneButton.layer.borderColor = BUTTON_BORDER_COLOR
            doneButton.backgroundColor = BUTTON_BACKGROUND_COLOR
            doneButton.titleLabel?.textColor = UIColor.black
            doneButton.layer.borderWidth = 1
            
            newGameConfirmationView.backgroundColor = UIColor(red: 70/255, green: 70/255, blue: 70/255, alpha: 0.75)
            newGameConfirmationView.alpha = 0
            
            newGameSelectionView.layer.cornerRadius = 49
            newGameSelectionView.layer.borderColor = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1).cgColor
            newGameSelectionView.layer.borderWidth = 1
            
            noNewGameButton.layer.cornerRadius = 20
            noNewGameButton.backgroundColor = BUTTON_BACKGROUND_COLOR
            noNewGameButton.layer.borderColor = BUTTON_BORDER_COLOR
            noNewGameButton.titleLabel?.textColor = UIColor.black
            noNewGameButton.layer.borderWidth = 1
            
            yesNewGameButton.layer.cornerRadius = 20
            yesNewGameButton.layer.borderColor = BUTTON_BORDER_COLOR
            yesNewGameButton.backgroundColor = BUTTON_BACKGROUND_COLOR
            yesNewGameButton.titleLabel?.textColor = UIColor.black
            yesNewGameButton.layer.borderWidth = 1
            
            gameDoneConfirmationView.backgroundColor = UIColor(red: 70/255, green: 70/255, blue: 70/255, alpha: 0.75)
            gameDoneConfirmationView.alpha = 0
            gameDoneSelectionView.layer.cornerRadius = 49
            gameDoneSelectionView.layer.borderColor = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1).cgColor
            gameDoneSelectionView.layer.borderWidth = 1
            
            gameNotDoneButton.layer.cornerRadius = 20
            gameNotDoneButton.backgroundColor = BUTTON_BACKGROUND_COLOR
            gameNotDoneButton.layer.borderColor = BUTTON_BORDER_COLOR
            gameNotDoneButton.titleLabel?.textColor = UIColor.black
            gameNotDoneButton.layer.borderWidth = 1
            gameNotDoneButton.titleLabel?.numberOfLines = 0
            gameNotDoneButton.titleLabel?.textAlignment = .center
            
            gameIsDoneButton.layer.cornerRadius = 20
            gameIsDoneButton.backgroundColor = BUTTON_BACKGROUND_COLOR
            gameIsDoneButton.layer.borderColor = BUTTON_BORDER_COLOR
            gameIsDoneButton.titleLabel?.textColor = UIColor.black
            gameIsDoneButton.layer.borderWidth = 1
            gameIsDoneButton.titleLabel?.numberOfLines = 0
            gameIsDoneButton.titleLabel?.textAlignment = .center
            
            
            // Set the scorecard label to look cool
            scoreCardLabel.backgroundColor = UIColor(red: 255/255, green: 87/255, blue: 87/255 , alpha: 1)
            scoreCardLabel.layer.cornerRadius = 20
            scoreCardLabel.layer.masksToBounds = true
            
            // Set the totalScore label to look cool
            totalLabel.backgroundColor = UIColor(red: 255/255, green: 177/255, blue: 98/255, alpha: 1)
            totalLabel.textColor = UIColor.black
            totalLabel.layer.borderWidth = 1
            totalLabel.layer.borderColor = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1).cgColor
            
            // Set the viewRankingButton to look cool
            viewRankingButton.layer.cornerRadius = 20
            viewRankingButton.layer.masksToBounds = true
            viewRankingButton.layer.borderColor = BUTTON_BORDER_COLOR
            viewRankingButton.layer.borderWidth = 2
            viewRankingButton.backgroundColor = BUTTON_BACKGROUND_COLOR
            viewRankingButton.titleLabel?.textColor = UIColor.black
            
            // Set the newGameButton to look cool
            newGameButton.layer.cornerRadius = 20
            newGameButton.layer.masksToBounds = true
            newGameButton.layer.borderColor = BUTTON_BORDER_COLOR
            newGameButton.backgroundColor = BUTTON_BACKGROUND_COLOR
            newGameButton.titleLabel?.textColor = UIColor.black
            newGameButton.layer.borderWidth = 2
            newGameButton.titleLabel?.numberOfLines = 0
            newGameButton.titleLabel?.textAlignment = .center
            
            // Set the scoreviewmini to look cool
            scoreViewMini.layer.cornerRadius = 20
            
            // Set the reminder label to be curved on top right
            reminderLabel.layer.cornerRadius = 18
            reminderLabel.layer.maskedCorners = .layerMaxXMinYCorner
            reminderLabel.clearsContextBeforeDrawing = true
            reminderLabel.clipsToBounds = true
            reminderLabel.autoresizesSubviews = true
            
            scoreCardTableView.delegate = self
            scoreCardTableView.dataSource = self
            
            rankingTableView.delegate = self
            rankingTableView.dataSource = self
            let ScrollViewHeightConstraint = NSLayoutConstraint(item: tableViewScrollView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: CGFloat((numberOfPlayers) * 40) + 60)
            tableViewScrollView.addConstraint(ScrollViewHeightConstraint)
            
            let playerNameSVHeightConstraint = NSLayoutConstraint(item: playerNameSV!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: CGFloat(numberOfPlayers * 40))
            playerNameSV.addConstraint(playerNameSVHeightConstraint)
            
            let rankingTableViewHeightConstraint = NSLayoutConstraint(item: rankingTableView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: CGFloat((numberOfPlayers) * 35))
            rankingTableView.addConstraint(rankingTableViewHeightConstraint)
            
            // Add a textfield for each player
            
            for i in 1...numberOfPlayers {
                let playerTextField = createPlayerTextField(playerNumber: i)
                if gameInProgress == false {
                    playerNamesArray.append(playerTextField.text!)
                }
                playerNameSV.addArrangedSubview(playerTextField)
                    
                if gameInProgress == true {
                    playerTextField.text = playerNamesArray[i - 1]
                }
            }
            // Set up the totalscoreSV
            let totalScoreSVHeightConstraint = NSLayoutConstraint(item: totalScoreSV!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: CGFloat(numberOfPlayers * 40))
            totalScoreSV.addConstraint(totalScoreSVHeightConstraint)
            
            // Add a label for each player
            for _ in 1...numberOfPlayers {
                let playerTotalLabel = UILabel()
                playerTotalLabel.backgroundColor = UIColor(red: 255/255, green: 211/255, blue: 173/255, alpha: 1.0)
                playerTotalLabel.layer.borderColor = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1.0).cgColor
                playerTotalLabel.font = UIFont(name: "ChalkboardSE-Bold", size: 25)
                playerTotalLabel.layer.borderWidth = 1
                playerTotalLabel.textAlignment = .center
                playerTotalLabel.textColor = UIColor.black
                playerTotalLabel.text = ""
                totalScoreSV.addArrangedSubview(playerTotalLabel)
            }
            // For each player, create an array that holds their scores
            if gameInProgress == false {
                for _ in 1...numberOfPlayers {
                    var playerScoreArray = [Int]()
                    for _ in 1...NUMBER_OF_HOLES {
                        // FOR BEN (Changed 0 to 9)
                        playerScoreArray.append(9)
                    }
                    scoreArray.append(playerScoreArray)
                }
            }
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissTF))
            
            self.view.addGestureRecognizer(tapGesture)
            
            // Set the enterScoreView alpha to 0
            enterScoreView.alpha = 0
            enterScoreView.backgroundColor = UIColor(red: 70/255, green: 70/255, blue: 70/255, alpha: 0.75)
            
            // Set the clearScore button to look cool
            clearScoreButton.layer.cornerRadius = 20
            clearScoreButton.layer.masksToBounds = true
            clearScoreButton.layer.borderColor = BUTTON_BORDER_COLOR
            clearScoreButton.backgroundColor = BUTTON_BACKGROUND_COLOR
            clearScoreButton.layer.borderWidth = 2
            
            // Set the 7+ button to look cool
            //ouchButton.layer.cornerRadius = 20
           // ouchButton.layer.masksToBounds = true
            //ouchButton.layer.borderColor = BUTTON_BORDER_COLOR
           // ouchButton.backgroundColor = BUTTON_BACKGROUND_COLOR
           // ouchButton.layer.borderWidth = 2
            
            // Set the back button to look cool
            backButton.layer.cornerRadius = 30
            backButton.layer.masksToBounds = true
            backButton.layer.borderColor = BUTTON_BORDER_COLOR
            backButton.backgroundColor = BUTTON_BACKGROUND_COLOR
            backButton.layer.borderWidth = 2
            
            // Set the backToMain button to look cool
            backToMainMenu.layer.cornerRadius = 20
            backToMainMenu.layer.masksToBounds = true
            backToMainMenu.layer.borderColor = BUTTON_BORDER_COLOR
            backToMainMenu.backgroundColor = BUTTON_BACKGROUND_COLOR
            backToMainMenu.titleLabel?.textColor = UIColor.black
            backToMainMenu.layer.borderWidth = 2
            
            // Set the + button to look cool
            plusButton.layer.cornerRadius = 35
            plusButton.layer.masksToBounds = true
            plusButton.layer.borderColor = BUTTON_BORDER_COLOR
            plusButton.backgroundColor = BUTTON_BACKGROUND_COLOR
            plusButton.layer.borderWidth = 2
            
            // Set the - button to look cool
            minusButton.layer.cornerRadius = 35
            minusButton.layer.masksToBounds = true
            minusButton.layer.borderColor = BUTTON_BORDER_COLOR
            minusButton.backgroundColor = BUTTON_BACKGROUND_COLOR
            minusButton.layer.borderWidth = 2
            
            // set the button colors
            setGolfButtonColors()
            
            // add the gesture recognizer to the viewRankingTapped button
            let gestureRecognizer3 = UILongPressGestureRecognizer.init(target: self, action: #selector(showRankingTapped(gestureRecognizer:)))
            gestureRecognizer3.minimumPressDuration = 0.01
            viewRankingButton.addGestureRecognizer(gestureRecognizer3)
            viewRankingView.backgroundColor = UIColor(red: 70/255, green: 70/255, blue: 70/255, alpha: 0.75)         
            viewRankingView.alpha = 0
            
            positionLabel.layer.borderColor = UIColor.black.cgColor
            positionLabel.layer.borderWidth = 1
            positionLabel.backgroundColor = UIColor(red: 1/255, green: 72/255, blue: 15/255, alpha: 1)
            
            playerLabel.layer.borderColor = UIColor.black.cgColor
            playerLabel.backgroundColor = UIColor(red: 1/255, green: 72/255, blue: 15/255, alpha: 1)
            playerLabel.layer.borderWidth = 1
            
            scoreLabel.layer.borderColor = UIColor.black.cgColor
            scoreLabel.backgroundColor = UIColor(red: 1/255, green: 72/255, blue: 15/255, alpha: 1)
            scoreLabel.layer.borderWidth = 1
            
            strokesBehindLabel.layer.borderColor = UIColor.black.cgColor
            strokesBehindLabel.backgroundColor = UIColor(red: 1/255, green: 72/255, blue: 15/255, alpha: 1)
            strokesBehindLabel.layer.borderWidth = 1
            
            if gameInProgress == true {
                computeTotalScore()
            }
            
            gameInProgress = true
            saveGame()
        }
    
        
        
        func setGolfButtonColors() {
           
            let gestureRecognizer1 = UITapGestureRecognizer.init(target: self, action: #selector(scoreValueTapped(gestureRecognizer:)))
            var score1 = UIImage(named: "score0")
            score1 = score1?.withRenderingMode(.alwaysOriginal)
            
            score1Button.setImage(score1, for: .normal)
            score1Button.imageView?.contentMode = .scaleAspectFit
            score1Button.layer.cornerRadius = score1Button.frame.size.width / 2;
            score1Button.clipsToBounds = true
            score1Button.tag = 1
            score1Button.addGestureRecognizer(gestureRecognizer1)
            
            let gestureRecognizer2 = UITapGestureRecognizer.init(target: self, action: #selector(scoreValueTapped(gestureRecognizer:)))
            var score2 = UIImage(named: "score-1")
            score2 = score2?.withRenderingMode(.alwaysOriginal)
            
            score2Button.setImage(score2, for: .normal)
            score2Button.imageView?.contentMode = .scaleAspectFit
            score2Button.layer.cornerRadius = score2Button.frame.size.width / 2;
            score2Button.clipsToBounds = true
            score2Button.tag = 2
            score2Button.addGestureRecognizer(gestureRecognizer2)
            
            let gestureRecognizer3 = UITapGestureRecognizer.init(target: self, action: #selector(scoreValueTapped(gestureRecognizer:)))
            var score3 = UIImage(named: "score-2")
            score3 = score3?.withRenderingMode(.alwaysOriginal)
            
            score3Button.setImage(score3, for: .normal)
            score3Button.imageView?.contentMode = .scaleAspectFit
            score3Button.layer.cornerRadius = score3Button.frame.size.width / 2;
            score3Button.clipsToBounds = true
            score3Button.tag = 3
            score3Button.addGestureRecognizer(gestureRecognizer3)
            
            let gestureRecognizer4 = UITapGestureRecognizer.init(target: self, action: #selector(scoreValueTapped(gestureRecognizer:)))
            var score4 = UIImage(named: "score-3")
            score4 = score4?.withRenderingMode(.alwaysOriginal)
            
            score4Button.setImage(score4, for: .normal)
            score4Button.imageView?.contentMode = .scaleAspectFit
            score4Button.layer.cornerRadius = score4Button.frame.size.width / 2;
            score4Button.clipsToBounds = true
            score4Button.tag = 4
            score4Button.addGestureRecognizer(gestureRecognizer4)
            
            let gestureRecognizer5 = UITapGestureRecognizer.init(target: self, action: #selector(scoreValueTapped(gestureRecognizer:)))
            var score5 = UIImage(named: "score-5")
            score5 = score5?.withRenderingMode(.alwaysOriginal)
            
            //score5Button.setImage(score5, for: .normal)
           // score5Button.imageView?.contentMode = .scaleAspectFit
            //score5Button.layer.cornerRadius = score5Button.frame.size.width / 2;
           // score5Button.clipsToBounds = true
           // score5Button.tag = 5
           // score5Button.addGestureRecognizer(gestureRecognizer5)
            
            let gestureRecognizer6 = UITapGestureRecognizer.init(target: self, action: #selector(scoreValueTapped(gestureRecognizer:)))
            var score6 = UIImage(named: "score-6")
            score6 = score6?.withRenderingMode(.alwaysOriginal)
            
            //score6Button.setImage(score6, for: .normal)
            //score6Button.imageView?.contentMode = .scaleAspectFit
           // score6Button.layer.cornerRadius = score6Button.frame.size.width / 2;
            //score6Button.clipsToBounds = true
            //score6Button.tag = 6
            //score6Button.addGestureRecognizer(gestureRecognizer6)
        }

        @objc func scoreValueTapped(gestureRecognizer: UITapGestureRecognizer) {
            let button = gestureRecognizer.view as! UIButton
            var value = button.tag - 1
            
            // Assign the value to the appropriate cell
            cellBeingUpdated.setTitle("\(value)", for: .normal)
            cellBeingUpdated.setTitleColor(UIColor.black, for: .normal)
            
            if value == 0 {
                cellBeingUpdated.backgroundColor = UIColor(red: 216/255, green: 100/255, blue: 100/255, alpha: 1.0)
            }
            
            if value == 1 {
                cellBeingUpdated.backgroundColor = UIColor(red: 202/255, green: 157/255, blue: 255/255, alpha: 1.0)
            }
            
            else if value == 2 {
                cellBeingUpdated.backgroundColor = UIColor(red: 136/255, green: 177/255, blue: 255/255, alpha: 1.0)
            }
            
            else if value == 3 {
                 cellBeingUpdated.backgroundColor = UIColor(red: 189/255, green: 255/255, blue: 173/255, alpha: 1.0)
            }
            
            else if value == 4 {
                cellBeingUpdated.backgroundColor = UIColor(red: 232/255, green: 222/255, blue: 98/255, alpha: 1.0)
            }
            
            else if value == 5 {
                cellBeingUpdated.backgroundColor = UIColor(red: 255/255, green: 173/255, blue: 121/255, alpha: 1.0)
            }
            
            else if value == 6 {
                cellBeingUpdated.backgroundColor = UIColor(red: 216/255, green: 100/255, blue: 100/255, alpha: 1.0)
            }
            
            print("player \(playerNum) got a \(value) on hole \(holeNum)")
            
            // Add this score to the total
            computeTotalScore(playerNumber: playerNum, holeNumber: holeNum, score: value)
            
            // Dismiss the enterscoreview
            enterScoreView.alpha = 0
            
            newGameButton.alpha = 1
            viewRankingButton.alpha = 1
            backToMainMenu.alpha = 1
            
            // Check to see if x-axis needs to move
            updateSVAxis(xPosition: xValue)
            
            // Save the game
            saveGame()
        }
        
        func computeTotalScore(playerNumber: Int, holeNumber: Int, score: Int) {
            // Add the score to the scoreArray
            scoreArray[playerNumber - 1][holeNumber - 1] = score
            
            // Sum the players score
            var totalScore = 0
            
            for i in 0...NUMBER_OF_HOLES - 1 {
                //totalScore = totalScore + scoreArray[playerNumber - 1][i]
                // For ben (added if else clause), was just line above
                if (scoreArray[playerNumber - 1][i] == 9) {
                    // Do nothing
                }
                else {
                    totalScore = totalScore + scoreArray[playerNumber - 1][i]
                }
            }
            
            // Update the total score label
            let label = totalScoreSV.arrangedSubviews[playerNumber - 1] as! UILabel
            
            if (totalScore == 0) {
                label.text = "\(totalScore)"
            }
            else {
                label.text = "\(totalScore)"
            }
        }
        
        func computeTotalScore() {
            var totalScore = 0
            // Populate the totalScore
            for i in 1...numberOfPlayers {
                totalScore = 0
                for j in 0...NUMBER_OF_HOLES - 1 {
                    if (scoreArray[i - 1][j] == 9) {
                        // Do nothing
                    }
                    else {
                        totalScore = totalScore + scoreArray[i - 1][j]
                    }
                }
                
            // Update the total score label
            let label = totalScoreSV.arrangedSubviews[i - 1] as! UILabel
                
                if (totalScore == 0) {
                    label.text = "\(totalScore)"
                }
                else {
                    label.text = "\(totalScore)"
                    
                }
            }
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            playerTextField = textField
            scoreCardTableView.isUserInteractionEnabled = false
            newGameButton.isUserInteractionEnabled = false
            
            if (playerTextField?.text == "Player " + "\(playerTextField!.tag)") {
                playerTextField?.text = ""
                playerTextField?.textColor = UIColor.white
            }
            
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
                if (playerTextField?.text == "") {
                playerTextField?.text = "Player " + "\(playerTextField!.tag)"
                textField.textColor = UIColor.lightGray
            }
            
            // Add the player to the names array
            playerNamesArray[textField.tag - 1] = textField.text!
            if playerNamesArray[textField.tag - 1] != "Player \(textField.tag)" {
                textField.textColor = UIColor.white
            }
            
            saveGame()
        }
        
        @objc func dismissTF() {
            if playerTextField != nil {
                playerTextField!.resignFirstResponder()
                scoreCardTableView.isUserInteractionEnabled = true
                newGameButton.isUserInteractionEnabled = true
            }
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if playerTextField != nil {
                playerTextField!.resignFirstResponder()
                scoreCardTableView.isUserInteractionEnabled = true
                newGameButton.isUserInteractionEnabled = true
            }
            return true
        }
        


        @IBAction func newGameTapped(_ sender: Any) {
            newGameConfirmationView.alpha = 1

                areYouSureLabel.text = "Do you want to end the game early?\n\n(You will have a chance to save your scorecard to your history)"
        }
        
        func createPlayerTextField(playerNumber:Int) -> UITextField {
            let textField = UITextField()
            textField.text = "Player \(playerNumber)"
            textField.textAlignment = .center
            textField.backgroundColor = UIColor(red: 88/255, green: 87/255, blue: 87/255, alpha: 1.0)
            textField.layer.borderColor = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1.0).cgColor
            textField.layer.borderWidth = 1
            textField.textColor = UIColor.lightGray
            textField.font = UIFont(name: "ChalkboardSE-Light", size: 20)
            textField.delegate = self
            textField.tag = playerNumber
            
            let defaults = UserDefaults.standard
            
            if gameInProgress == true {
            if let actualPlayerNamesArray = defaults.value(forKey: "playerNames") as? [String] {
                playerNamesArray = actualPlayerNamesArray
                
                // Now populat the textfield
                textField.text = "\(playerNamesArray[textField.tag - 1])"
                textField.textColor = UIColor.white
            }
            }
            
            return textField
        }
        
        @IBAction func clearScoreTapped(_ sender: Any) {
            cellBeingUpdated.backgroundColor = BUTTON_BACKGROUND_COLOR
            cellBeingUpdated.setTitle(" ", for: .normal)
            
            // Set the score to a "0" and update the total score
            computeTotalScore(playerNumber: playerNum, holeNumber: holeNum, score: 0)
            
            
            enterScoreView.alpha = 0
            newGameButton.alpha = 1
            viewRankingButton.alpha = 1
            backToMainMenu.alpha = 1
            
            // save the "0" that has been updated
            let defaults = UserDefaults.standard
            defaults.set(scoreArray, forKey: "scoreArray")
        }
        
    @IBAction func backTapped(_ sender: Any) {
            enterScoreView.alpha = 0
            newGameButton.alpha = 1
            viewRankingButton.alpha = 1
            backToMainMenu.alpha = 1
        
            plusMinusSV.alpha = 0
            scoreButtonSV.alpha = 1
            clearScoreButton.isHidden = false
            //ouchButton.setTitle("7+", for: .normal)
    }
        
        @IBAction func noTapped(_ sender: Any) {
            backToMainMenu.alpha = 1
            newGameButton.alpha = 1
            viewRankingButton.alpha = 1
            scoreUpdateConfirmationView.alpha = 0
        }
        
        @IBAction func yesTapped(_ sender: Any) {
            backToMainMenu.alpha = 0
            newGameButton.alpha = 0
            viewRankingButton.alpha = 0
            scoreUpdateConfirmationView.alpha = 0
            enterScoreView.alpha = 1
        }
        
        var tracker = 0
        func updateSVAxis(xPosition: Int) {
            self.view.layoutIfNeeded()
            
            // Check to see if all of the players have completed the hole
            for playerScore in scoreArray {
                var tempTracker = tracker
                if tracker == NUMBER_OF_HOLES {
                    tempTracker = tracker - 1
                }
                // for ben changed 0 to 9
                if (playerScore[tempTracker] == 9) {
                    
                    if tracker == NUMBER_OF_HOLES - 1 {
                        
                        let tableviewWidth = SCORECARD_TABLEVIEW_WIDTH
                        let safeAreaWidth = Int(self.view.safeAreaLayoutGuide.layoutFrame.width)
                        // clubs width + total label width
                        let otherImageWidth = Int(100)
                        
                        let finalX = tableviewWidth - (safeAreaWidth - otherImageWidth)
                        
                        //tableViewScrollView.setContentOffset(CGPoint(x:finalX, y:0), animated: true)
                        // For ben, was just line above
                        let rightOffset = CGPoint(x: tableViewScrollView.contentSize.width - tableViewScrollView.bounds.width + tableViewScrollView.contentInset.right, y: 0)
                        tableViewScrollView.setContentOffset(rightOffset, animated: true)
                        
                        
                    }
                    else {
                        // Set the scrollview back to the cells for the players that haven't entered
                        tableViewScrollView.setContentOffset(CGPoint(x: xPosition, y: 0), animated: true)
                    }
                    
                    return
                }
            }
        
            // If you get here, each player has completed the hole
                // Check to see if the game is between hole #2 and hole #16
                    if tracker >= 0 && tracker <= NUMBER_OF_HOLES - 2 {
                        
                        if tracker == NUMBER_OF_HOLES - 2 {
                           
                            let tableviewWidth = SCORECARD_TABLEVIEW_WIDTH
                            let safeAreaWidth = Int(self.view.safeAreaLayoutGuide.layoutFrame.width)
                            // clubs width + total label width
                            let otherImageWidth = Int(160)
                            
                            
                            let finalX = tableviewWidth - (safeAreaWidth - otherImageWidth)
                          
                            //tableViewScrollView.setContentOffset(CGPoint(x:finalX, y:0), animated: true)
                            
                            // For ben (was just line above)
                            let rightOffset = CGPoint(x: tableViewScrollView.contentSize.width - tableViewScrollView.bounds.width + tableViewScrollView.contentInset.right, y: 0)
                            tableViewScrollView.setContentOffset(rightOffset, animated: true)
                            
                        }
                        
                        else {
                        // Add the cells width the x-position of the scrollview
                        xValue = xValue + Int(cellBeingUpdated.frame.size.width + 0.75)
                        
                       //  Set the scrollview to the new x-position (moves to the right)
                        tableViewScrollView.setContentOffset(CGPoint(x: xValue, y: 0), animated: true)
                        }
                        
                    }
                    
            // Make sure the hole # doesn't go past max number of holes
            if tracker < NUMBER_OF_HOLES - 1 {
                // Increment the hole #
                tracker = tracker + 1
                
            }
            
            else if tracker == NUMBER_OF_HOLES - 1 {
                // Prompt to the user that the game is over
                backToMainMenu.alpha = 0
                newGameButton.alpha = 0
                viewRankingButton.alpha = 0
                gameDoneConfirmationView.alpha = 1
            }
        }
        
        func saveGame(){
            let defaults = UserDefaults.standard
            
            // Save the luckyCounter Value
            defaults.set(gameInProgress, forKey: "gameInProgress")
            defaults.set(scoreArray, forKey: "scoreArray")
            defaults.set(playerNamesArray, forKey: "playerNames")
            defaults.set(xValue, forKey: "xPosition")
            defaults.set(tracker, forKey: "tracker")
            defaults.set(1, forKey: "scoreCardViewed")
            
        }
        
        @IBAction func yesNewGameTapped(_ sender: Any) {
            
            if sure == true {
                newGameConfirmationView.alpha = 0
                // Save scorecard to history
                gameOver = true
                updatePlayerRanking()
                saveToHistory()
                
                gameInProgress = false
                saveGame()
                
                // Navigate user to city selection screen
                 self.navigationController?.popToRootViewController(animated: true)
            }
            
            else {
                areYouSureLabel.text = "Do you want to save this scorecard to your history?"
                sure = true
            }
        }
        
        func loadGame() {
            let defaults = UserDefaults.standard

            if let actualGameInProgress = defaults.value(forKey: "gameInProgress") as? Bool {
                if actualGameInProgress == true {
                    // Load the additionProgress Values
                    if let actualNumberOfPlayers = defaults.value(forKey: "numberOfPlayers") as? Int {
                        numberOfPlayers = actualNumberOfPlayers
                    }
                    
                    if let actualScoreArray = defaults.value(forKey: "scoreArray") as? [[Int]] {
                        scoreArray = actualScoreArray
                    }
                    
                    if let actualPlayerNamesArray = defaults.value(forKey: "playerNames") as? [String] {
                        playerNamesArray = actualPlayerNamesArray
                    }
                    
                    if let actualCity = defaults.value(forKey: "city") as? String {
                        city = actualCity
                    }
                    
                    if let actualXPosition = defaults.value(forKey: "xPosition") as? Int {
                        xValue = actualXPosition
                    }
                    
                    if let actualTracker = defaults.value(forKey: "tracker") as? Int {
                        tracker = actualTracker
                    }
                    
                    if let actualyTotalGameHistory = defaults.value(forKey: "gameHistory") as? [[Any]] {
                        totalHistoryArray = actualyTotalGameHistory
                    }
                }
            }
        }
        
        func loadGameHistory() {
            let defaults = UserDefaults.standard
            if let actualyTotalGameHistory = defaults.value(forKey: "gameHistory") as? [[Any]] {
                totalHistoryArray = actualyTotalGameHistory
            }
        }
        
        
        var gameArray = [Any]()
        var totalHistoryArray = [[Any]]()
        func saveToHistory() {
            let defaults = UserDefaults.standard
            
            // Save Date
            let df = DateFormatter()
            df.dateFormat = "MMM d,\nyyyy"
            let now = df.string(from: Date())
            print("\(now)")
            defaults.set(now, forKey: "date")
            defaults.set(false, forKey: "gameInProgress")
            
        // Add to the gameArray
            // Add the date (0)
            let date = defaults.value(forKey: "date") as! String
            gameArray.append(date)
            
            // Add the Location (1)
            //let location = defaults.value(forKey: "city") as! String
            //gameArray.append(location)
            
            // Save Player Names (2)
            let playerNames = playerNamesArray
            gameArray.append(playerNames)
            
            // Save Total Scores (3)
            let scoreArray = defaults.value(forKey: "scoreArray") as! [[Int]]
            gameArray.append(scoreArray)
            
            // save the winning score (4)
            gameArray.append(winningScore)
            print("the winning player is \(winningPlayer)")
            // save the winning player (5)
            gameArray.append(winningPlayer)
            // Save the gameArray
            totalHistoryArray.append(gameArray)
            
            defaults.set(totalHistoryArray, forKey: "gameHistory")
            
            
            // Now, erase all of the current data
            let erasedScoreArray = [[Int]]()
            defaults.set(erasedScoreArray, forKey: "scoreArray")
            
            let erasedPlayers = [String]()
            defaults.set(erasedPlayers, forKey: "playerNames")
            
        }
        var gameOver = false
        
        @IBOutlet weak var clubs: UIImageView!
        func presentFinalScore() {
            gameOver = true
            updatePlayerRanking()
            rankingTableView.reloadData()
            gameDoneConfirmationView.alpha = 0
            newGameButton.alpha = 0
            viewRankingButton.alpha = 0
            scoreCardTableView.alpha = 0
            playerNameSV.alpha = 0
            totalScoreSV.alpha = 0
            clubs.alpha = 0
            scoreCardLabel.alpha = 0
            totalLabel.alpha = 0
            backToMainMenu.alpha = 0
            viewRankingView.alpha = 1.0
            doneButton.alpha = 1.0
            
        }
    
    @IBOutlet weak var ouchSV: UIStackView!
    @IBOutlet weak var scoreButtonSV: UIStackView!
    @IBOutlet weak var plusMinusSV: UIStackView!
    @IBOutlet weak var ouchScoreLabel: UILabel!
    var ouchCounter = 7
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    
   /* @IBAction func ouchTapped(_ sender: Any) {
        if ouchButton.titleLabel!.text == "7+" {
            // Make the slider option come up
            
            // Remove the "Clear Score" Button
            clearScoreButton.isHidden = true
            
            // Remove the Score Buttons
            scoreButtonSV.alpha = 0
            
            // Add the slider
            plusMinusSV.alpha = 1
            
            // Change the button to "Enter"
            ouchButton.setTitle("Enter", for: .normal)

        }
        
        else if ouchButton.titleLabel!.text == "Enter" {
            // Log this score to the user
            cellBeingUpdated.setTitle("\(ouchCounter)", for: .normal)
            cellBeingUpdated.setTitleColor(UIColor.black, for: .normal)
            // Change the color
            if ouchCounter == 1 {
                cellBeingUpdated.backgroundColor = UIColor(red: 202/255, green: 157/255, blue: 255/255, alpha: 1.0)
            }
            
            else if ouchCounter == 2 {
                cellBeingUpdated.backgroundColor = UIColor(red: 136/255, green: 177/255, blue: 255/255, alpha: 1.0)
            }
            
            else if ouchCounter == 3 {
                 cellBeingUpdated.backgroundColor = UIColor(red: 189/255, green: 255/255, blue: 173/255, alpha: 1.0)
            }
            
            else if ouchCounter == 4 {
                cellBeingUpdated.backgroundColor = UIColor(red: 232/255, green: 222/255, blue: 98/255, alpha: 1.0)
            }
            
            else if ouchCounter == 5 {
                cellBeingUpdated.backgroundColor = UIColor(red: 255/255, green: 173/255, blue: 121/255, alpha: 1.0)
            }
            
            else if ouchCounter == 6 {
                cellBeingUpdated.backgroundColor = UIColor(red: 216/255, green: 100/255, blue: 100/255, alpha: 1.0)
            }
            
            else if ouchCounter >= 7 {
                cellBeingUpdated.backgroundColor = UIColor.black
                cellBeingUpdated.setTitleColor(UIColor.white, for: .normal)
                
                // Update the no mercy achievement tracker
                let defaults = UserDefaults.standard
                
                // Save the luckyCounter Value
                defaults.set(true, forKey: "noMercy")
            }
            
            // Add this score to the total
            computeTotalScore(playerNumber: playerNum, holeNumber: holeNum, score: ouchCounter)
            
            // Check to see if x-axis needs to move
            updateSVAxis(xPosition: xValue)
            
            // Change the text back to "7+"
            ouchButton.setTitle("7+", for: .normal)
            
            // Change the ouchcounter back to 7
            ouchCounter = 7
            ouchScoreLabel.text = "\(ouchCounter)"
            
            // Add the clear score button back to SV
            clearScoreButton.isHidden = false
            
            // Add the score buttons back
            scoreButtonSV.alpha = 1
            
            // Remove the plusMinus
            plusMinusSV.alpha = 0
            
            // Dismiss the scoreview
            enterScoreView.alpha = 0
            
            // Put the buttons into view
            newGameButton.alpha = 1
            viewRankingButton.alpha = 1
            backToMainMenu.alpha = 1
            
            // Save the game
            saveGame()
            
            return
        }
    } */
    
    @IBAction func plusTapped(_ sender: Any) {
        // Add to the counter
        if ouchCounter != 99 {
            ouchCounter += 1
            // Set the label to the value of this counter
            ouchScoreLabel.text = "\(ouchCounter)"
        }
    }
    
    @IBAction func minusTapped(_ sender: Any) {
        // Subtract to the counter
        if ouchCounter != 1 {
            ouchCounter -= 1
            // Set the label to the value of this counter
            ouchScoreLabel.text = "\(ouchCounter)"
        }
    }
}
