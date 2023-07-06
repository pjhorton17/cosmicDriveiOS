//
//  DetailsViewController.swift
//  PuttPuttScoreCard
//
//  Created by Patrick Horton on 12/1/20.
//  Copyright © 2020 Patrick Horton. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    let BUTTON_BACKGROUND_COLOR = UIColor(red: 0/255, green: 255/255, blue: 206/255, alpha: 1.0)
    let BUTTON_BORDER_COLOR = UIColor.black.cgColor
    var NUMBER_OF_HOLES = Int()
    var SCORECARD_TABLEVIEW_WIDTH = Int()
    
    var cardToDisplay = 0
    var playerNameArray = [String]()
    var holeImageNames = [String]()
    var scoreArray = [[Int]]()
    var winningScore = 0
    var numberOfPlayers = 0
    var date = String()
    var location = String()
    var newPlayerRanking = [Int]()
    
    @IBOutlet weak var scorecardLabel: UILabel!
    @IBOutlet weak var clubsImage: UIImageView!
    @IBOutlet weak var tableScrollView: UIScrollView!
    @IBOutlet weak var scoreCardTableView: UITableView!
    @IBOutlet weak var totalScoreLabel: UILabel!
    @IBOutlet weak var totalScoreStackView: UIStackView!
    @IBOutlet weak var viewRankingView: UIView!
    @IBOutlet weak var mainRankingStackView: UIStackView!
    @IBOutlet weak var rankingTableView: UITableView!
    @IBOutlet weak var playerNameStackView: UIStackView!
    
    @IBOutlet weak var viewRankingButton: UIButton!
    
    @IBOutlet weak var positionHeaderLabel: UILabel!
    @IBOutlet weak var playerHeaderLabel: UILabel!
    @IBOutlet weak var scoreHeaderLabel: UILabel!
    @IBOutlet weak var strokesBehindHeaderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Make sure the correct card is being displayed
        print("The card that I am showing is \(cardToDisplay)")
      
        // Make the UI
        customizeScorecardLabel()
        customizeTotalLabel()
        customizeRankingButton()
        customizeRankingView()
        
        // Determine the number of players to display
        determineNumberOfPlayersAndHoles()
        
        // Set the Delegates, Datasources, and reload the tableviews
        configureTableViews()
        
        // Set the contraints for the scrollviews
        setConstraints()
        
        // Add gestureRecognizer to the viewRanking Button
        dressUpViewRankingButton()
        
        // Configure the viewRankingView to start
        rankingViewToStart()
        
        // Add a textField to each player
        addTextField()
        
        // Get total scores
        computeTotalScore()
        
        // Set the fact that the user has visited a historic game
        historicVisited()
    
    }
    
    func customizeScorecardLabel() {
        // Set the scorecard label to look cool
        scorecardLabel.backgroundColor = UIColor(red: 255/255, green: 87/255, blue: 87/255 , alpha: 1)
        scorecardLabel.numberOfLines = 0
        //scorecardLabel.layer.cornerRadius = 20
        scorecardLabel.layer.masksToBounds = true
        
        // Remove the "\n" from the date string
        removeLineBreak()
        
        // Add the date and location of the card
        scorecardLabel.text = "\(date)"
    }
    
    func removeLineBreak() {
        // trim the string
        //date.trimmingCharacters(in: CharacterSet.newlines)
        // replace occurences within the string
        while let rangeToReplace = date.range(of: "\n") {
            date.replaceSubrange(rangeToReplace, with: " ")
        }
    }
    func customizeTotalLabel() {
        // Set the totalScore label to look cool
        totalScoreLabel.backgroundColor = UIColor(red: 255/255, green: 177/255, blue: 98/255, alpha: 1)
        totalScoreLabel.textColor = UIColor.black
        totalScoreLabel.layer.borderWidth = 1
        totalScoreLabel.layer.borderColor = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1).cgColor
    }
    
    func customizeRankingButton() {
        // Set the viewRankingButton to look cool
        viewRankingButton.layer.cornerRadius = 20
        viewRankingButton.layer.masksToBounds = true
        viewRankingButton.layer.borderColor = BUTTON_BORDER_COLOR
        viewRankingButton.layer.borderWidth = 2
        viewRankingButton.backgroundColor = BUTTON_BACKGROUND_COLOR
        viewRankingButton.titleLabel?.textColor = UIColor.black
    }
    
    func setConstraints() {
        // Set height constraint for the scrollview
        let ScrollViewHeightConstraint = NSLayoutConstraint(item: tableScrollView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: CGFloat((numberOfPlayers) * 40) + 60)
        tableScrollView.addConstraint(ScrollViewHeightConstraint)
        
        // Set the height constraint for the playerNameSV
        let playerNameSVHeightConstraint = NSLayoutConstraint(item: playerNameStackView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: CGFloat(numberOfPlayers * 40))
        playerNameStackView.addConstraint(playerNameSVHeightConstraint)
        
        // Set the height constraint for the rankingTableView
        let rankingTableViewHeightConstraint = NSLayoutConstraint(item: rankingTableView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: CGFloat((numberOfPlayers) * 35))
        rankingTableView.addConstraint(rankingTableViewHeightConstraint)
    }
    func configureTableViews() {
        // Add datasources & delegates
        scoreCardTableView.delegate = self
        rankingTableView.delegate = self
        
        scoreCardTableView.dataSource = self
        rankingTableView.dataSource = self
        
        // Update the tableViews
        scoreCardTableView.reloadData()
        rankingTableView.reloadData()
         // Set the scrollview to the new x-position (moves to the right)
        tableScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
        // Set the size of the scorecard tableview
        let widthConstraint = NSLayoutConstraint(item: scoreCardTableView!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: CGFloat(SCORECARD_TABLEVIEW_WIDTH))
        scoreCardTableView.addConstraint(widthConstraint)
    }
    
    func determineNumberOfPlayersAndHoles() {
    // Determine number of players
        numberOfPlayers = playerNameArray.count
        
    // Determine number of holes
        // 10 holes (version 1)
        if NUMBER_OF_HOLES <= 10 {
            holeImageNames = ["American_Savings_Bank", "KTM", "HG_Mortgage", "Krave_Marketing", "Vacations_Hawaii", "Kalapawai_Market", "UFC", "HB_Homes", "Cutter", "Pitch_Sports_Bar"]
        }
        // 12 holes (version 2)
        else if NUMBER_OF_HOLES > 10 {
            holeImageNames = ["American_Savings_Bank", "KTM", "HG_Mortgage", "Krave_Marketing", "Bayview_MiniPutt", "Accel", "UFC", "HB_Homes", "Farmers_Insurance", "Pitch_Sports_Bar", "Kaneohe_Bay", "Kidz_Art"] }
        
        // Determine the tableview width (160 per image)
        SCORECARD_TABLEVIEW_WIDTH = NUMBER_OF_HOLES * 100
    }
    
    func dressUpViewRankingButton() {
        // add the gesture recognizer to the viewRankingTapped button
        let gestureRecognizer3 = UILongPressGestureRecognizer.init(target: self, action: #selector(showRankingTapped(gestureRecognizer:)))
        gestureRecognizer3.minimumPressDuration = 0.01
        viewRankingButton.addGestureRecognizer(gestureRecognizer3)
    }
    
    func rankingViewToStart() {
        viewRankingView.backgroundColor = UIColor(red: 70/255, green: 70/255, blue: 70/255, alpha: 0.75)
        viewRankingView.alpha = 0
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
            let label = totalScoreStackView.arrangedSubviews[i - 1] as! UILabel
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
        print("The updated score array is: \(sortedArray)")
        
        // Now, update the new player ranking
        for i in 1...numberOfPlayers {
            newPlayerRanking.append((sortedArray[i - 1][1]) - 1)
        }
        print("The updated player ranking is: \(newPlayerRanking)")
        
            winningScore = sortedArray[0][0]
            print("The winning score is \(winningScore)")
    }
    
    func addTextField() {
        // Add a textfield for each player
        for i in 1...numberOfPlayers {
            let playerTextField = createPlayerTextField(playerNumber: i)
            playerNameStackView.addArrangedSubview(playerTextField)
                
                playerTextField.text = playerNameArray[i - 1]
                playerTextField.isUserInteractionEnabled = false
        }
        // Set up the totalscoreSV
        let totalScoreSVHeightConstraint = NSLayoutConstraint(item: totalScoreStackView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: CGFloat(numberOfPlayers * 40))
        totalScoreStackView.addConstraint(totalScoreSVHeightConstraint)
        
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
            totalScoreStackView.addArrangedSubview(playerTotalLabel)
        }

    }
    
    func createPlayerTextField(playerNumber:Int) -> UITextField {
        let textField = UITextField()
        textField.text = "Player \(playerNumber)"
        textField.textAlignment = .center
        textField.backgroundColor = UIColor(red: 88/255, green: 87/255, blue: 87/255, alpha: 1.0)
        textField.layer.borderColor = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1.0).cgColor
        textField.layer.borderWidth = 1
        textField.font = UIFont(name: "ChalkboardSE-Light", size: 20)
        textField.textColor = UIColor.lightGray
        textField.delegate = self
        textField.tag = playerNumber
            
            // Now populat the textfield
            textField.text = "\(playerNameArray[textField.tag - 1])"
            textField.textColor = UIColor.white

        return textField
    }
    
    func computeTotalScore() {
        var totalScore = 0
        // Populate the totalScore
        for i in 1...numberOfPlayers {
            totalScore = 0
            for j in 1...NUMBER_OF_HOLES {
                // totalScore = totalScore + scoreArray[i - 1][j - 1]
                // Added if/else clause for ben (used to only be line above)
                if (scoreArray[i - 1][j - 1] == 9) {
                    // Do nothing
                }
                else {
                    totalScore = totalScore + scoreArray[i - 1][j - 1]
                }
            }
            
        // Update the total score label
        let label = totalScoreStackView.arrangedSubviews[i - 1] as! UILabel
            
            if (totalScore == 0) {
                label.text = "\(totalScore)"
            }
            else {
                label.text = "\(totalScore)"
                
            }
        }
    }
    
    func historicVisited() {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "historicGame")
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
    
    func customizeRankingView() {
        positionHeaderLabel.layer.borderColor = UIColor.black.cgColor
        positionHeaderLabel.layer.borderWidth = 1
        positionHeaderLabel.backgroundColor = UIColor(red: 1/255, green: 72/255, blue: 15/255, alpha: 1)
        
        playerHeaderLabel.layer.borderColor = UIColor.black.cgColor
        playerHeaderLabel.backgroundColor = UIColor(red: 1/255, green: 72/255, blue: 15/255, alpha: 1)
        playerHeaderLabel.layer.borderWidth = 1
        
        scoreHeaderLabel.layer.borderColor = UIColor.black.cgColor
        scoreHeaderLabel.backgroundColor = UIColor(red: 1/255, green: 72/255, blue: 15/255, alpha: 1)
        scoreHeaderLabel.layer.borderWidth = 1
        
        strokesBehindHeaderLabel.layer.borderColor = UIColor.black.cgColor
        strokesBehindHeaderLabel.backgroundColor = UIColor(red: 1/255, green: 72/255, blue: 15/255, alpha: 1)
        strokesBehindHeaderLabel.layer.borderWidth = 1
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

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == scoreCardTableView {
        if indexPath.row == 0 {
        // Get a prototype cell
        let holeNumberCell = tableView.dequeueReusableCell(withIdentifier: "holeNumberCell")!
            tableView.rowHeight = 60
        let holeNumberStackView = holeNumberCell.viewWithTag(1) as! UIStackView
        
        // Add 18 labels
        for i in 1...NUMBER_OF_HOLES {
            let roundNumberLabel = UILabel()
            roundNumberLabel.backgroundColor = UIColor.black
            

            roundNumberLabel.text = "Round \(i)"
            roundNumberLabel.backgroundColor = UIColor.black
            roundNumberLabel.font = UIFont(name: "Copperplate", size: 18)
            roundNumberLabel.textColor = UIColor.red
            roundNumberLabel.textAlignment = .center

            roundNumberLabel.layer.borderColor = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1.0).cgColor
            roundNumberLabel.layer.borderWidth = 1
            
            // Add this to the sv
            holeNumberStackView.addArrangedSubview(roundNumberLabel)
        }
            return holeNumberCell
        }
        else {
            let playerScoreCell = tableView.dequeueReusableCell(withIdentifier: "scoreCell")!
            tableView.rowHeight = 40
            let playerScoreStackView = playerScoreCell.viewWithTag(1) as! UIStackView
           
            let widthConstraint = NSLayoutConstraint(item: playerScoreStackView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: (CGFloat(SCORECARD_TABLEVIEW_WIDTH)))
            playerScoreStackView.addConstraint(widthConstraint)
            // Add a button? for each player
            for i in 1...NUMBER_OF_HOLES {
                let scoreButton = ScoreButton()
                scoreButton.layer.borderWidth = 1
                scoreButton.titleLabel?.textAlignment = .center
                scoreButton.titleLabel?.font = UIFont(name: "ChalkboardSE-Light", size: 25)
                scoreButton.layer.borderColor = UIColor(red: 112/225, green: 112/225, blue: 112/225, alpha: 1.0).cgColor
                scoreButton.backgroundColor = BUTTON_BACKGROUND_COLOR
                scoreButton.playerNumber = indexPath.row
                scoreButton.holeNumber = i
                scoreButton.setTitleColor(.black, for: .normal)
                
                // Changed for Ben (0 to 9)
                if scoreArray[indexPath.row - 1][i - 1] == 9 {
                    scoreButton.setTitle(nil, for: .normal)
                    
                }
                else {
                    scoreButton.setTitle("\(scoreArray[indexPath.row - 1][i - 1])", for: .normal)
                    
                    if scoreButton.titleLabel?.text == nil {
                        scoreButton.backgroundColor = BUTTON_BACKGROUND_COLOR
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
                    
                    // Changed for Ben (6 to 0)
                    else if scoreButton.titleLabel?.text == "0" {
                        scoreButton.backgroundColor = UIColor(red: 216/255, green: 100/255, blue: 100/255, alpha: 1.0)
                    }
                    
                    else {
                        scoreButton.backgroundColor = UIColor.black
                        scoreButton.setTitleColor(UIColor.white, for: .normal)
                    }
                }
                
                playerScoreStackView.addArrangedSubview(scoreButton)
            }
            return playerScoreCell
        }
    }
        else {
         
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
                let fullString = NSMutableAttributedString()
                
                    // create our NSTextAttachment
                    let image1Attachment = NSTextAttachment()
                    // wrap the attachment in its own attributed string so we can append it
                    let image1String = NSAttributedString(attachment: image1Attachment)
                         if indexPath.row + 1 == 1 {
                            var image = UIImage(named: "Gold")
                            image = resizeImage(image: image!, targetSize: CGSize(width:30.0, height:30.0))
                            image1Attachment.image = image
                            
                            // add the NSTextAttachment wrapper to our full string, then add some more text.
                            fullString.append(image1String)
                            // draw the result in a label
                            positionLabel.attributedText = fullString
                            playerLabel.text = playerNameArray[newPlayerRanking[indexPath.row]]
                         }
                         else if indexPath.row + 1 == 2 {
                            var image = UIImage(named: "Silver")
                            image = resizeImage(image: image!, targetSize: CGSize(width:30.0, height:30.0))
                            image1Attachment.image = image
                            // add the NSTextAttachment wrapper to our full string, then add some more text.
                            fullString.append(image1String)
                            // draw the result in a label
                            positionLabel.attributedText = fullString
                            playerLabel.text = playerNameArray[newPlayerRanking[indexPath.row]]
                         }
                         else if indexPath.row + 1 == 3{
                            var image = UIImage(named: "Bronze")
                            image = resizeImage(image: image!, targetSize: CGSize(width:30.0, height:30.0))
                            image1Attachment.image = image
                            // add the NSTextAttachment wrapper to our full string, then add some more text.
                            fullString.append(image1String)
                            // draw the result in a label
                            positionLabel.attributedText = fullString
                            playerLabel.text = playerNameArray[newPlayerRanking[indexPath.row]]
                         }
                         else {
                              positionLabel.text = "\(indexPath.row + 1)th"
                         }
                         playerLabel.text = playerNameArray[newPlayerRanking[indexPath.row]]
            
            // Grab the total score label
            let label = totalScoreStackView.arrangedSubviews[newPlayerRanking[indexPath.row]] as! UILabel
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
                    let first = totalScoreStackView.arrangedSubviews[newPlayerRanking[0]] as! UILabel
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
                playerLabel.text = "\(playerNameArray[indexPath.row])"
                let label = totalScoreStackView.arrangedSubviews[indexPath.row] as! UILabel
                scoreLabel.text = "\(label.text!)"
                strokesBehindLabel.text = "-"
            
                return rankingCell
            }
            
        }
        // should never get here...
            return UITableViewCell()
    }
}
