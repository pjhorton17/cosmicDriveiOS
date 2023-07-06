//
//  TestViewController.swift
//  PuttPuttScoreCard
//
//  Created by Patrick Horton on 10/22/20.
//  Copyright © 2020 Patrick Horton. All rights reserved.
//

import UIKit

class AchievementsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var achievementTableView: UITableView!
    
    var achievementTitles = ["One is Done!", "Mini-Golf Veteran", "Explorer", "Survey Says?", "Historic Game", "Sharing is Caring", "No Mercy", "Mini-Golf Pro"]
    
    var achievementDescriptions = ["Complete your first mini-golf game", "Complete 5 rounds of mini-golf", "Visit each screen in this app", "Rate this app in the App Store", "Revisit a scorecard from your history", "Share this app with a friend", "A player records a score of 7 or higher ", "Earn all achievements!"]
    
    var achievementProgress = [0, 0, 0, 0, 0, 0, 0, 0]
    var achievementTotal = [1, 5, 6, 1, 1, 1, 1, 7]
   
    var numScreensViewed = 2
    var appRated = 0
    var appShared = 0
    var noMercy = false
    var historicGame = false
    
    var mainMenuViewed = 1
    var achievementsViewed = 1
    var historyViewed = 0
    var parkNameViewed = 0
    var numPlayersViewed = 0
    var scorecardViewed = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Determine the achievement progress
        determineAchievementProgress()

        // Assign tableview delegates & source
        achievementTableView.delegate = self
        achievementTableView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (achievementTitles.count * 2) + 1
    }
    var pageNum = 0
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row % 2 != 0) {
            let historyCell = tableView.dequeueReusableCell(withIdentifier: "achievementCell")!
            tableView.rowHeight = 65
            let titleLabel = historyCell.viewWithTag(1) as! UILabel
            let descriptionLabel = historyCell.viewWithTag(2) as! UILabel
            let progressView = historyCell.viewWithTag(3) as! UIProgressView
            let progressLabel = historyCell.viewWithTag(4) as! UILabel
            let emptyLabel = historyCell.viewWithTag(5) as! UILabel
            
            // Add left border to Title, Description, and progress label
            addLeftBorder(label: titleLabel, borderColor: UIColor.black, borderWidth: 1.0)
            addLeftBorder(label: descriptionLabel, borderColor: UIColor.black, borderWidth: 1.0)
            addLeftBorder(label: progressLabel, borderColor: UIColor.black, borderWidth: 1.0)

            // Add bottom border to Title label & Empty Label
            addBottomBorder(label: titleLabel, borderColor: UIColor.black, borderHeight: 1.0)
            addBottomBorder(label: emptyLabel, borderColor: UIColor.black, borderHeight: 1.0)
            
            // Add right border to empty & Progress label
            addRightBorder(label: emptyLabel, borderColor: UIColor.black, borderWidth: 1.0)
            addRightBorder(label: progressLabel, borderColor: UIColor.black, borderWidth: 1.0)
            
            colorTitleLabel(tL: titleLabel, eL: emptyLabel, dL: descriptionLabel, section: pageNum, row: indexPath.row, pV: progressView)
            let heightConstraint = NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 25)
            titleLabel.addConstraint(heightConstraint)
            
            let hC = NSLayoutConstraint(item: descriptionLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 50)
            descriptionLabel.addConstraint(hC)

                titleLabel.text = achievementTitles[indexPath.row / 2]
                titleLabel.font = UIFont(name: "ArialRoundedMTBold", size: 20)
                descriptionLabel.text = achievementDescriptions[indexPath.row / 2]
                descriptionLabel.font = UIFont(name: "ChalkboardSE-Light", size: 15)
                progressLabel.font = UIFont(name: "ChalkboardSE-Light", size: 15)
            
                if achievementProgress[indexPath.row / 2] == 999 {
                    progressLabel.text = "Complete!"
                    progressView.progress = 1
                }
                else {
                    progressView.progress = (Float(achievementProgress[indexPath.row / 2]) / Float(achievementTotal[indexPath.row / 2]))
                    progressLabel.text = "\(achievementProgress[indexPath.row / 2]) / \(achievementTotal[indexPath.row / 2])"
                }

            return historyCell
        }
        
        else {
            tableView.rowHeight = 3
            let spacerCell = tableView.dequeueReusableCell(withIdentifier: "spacerCell")!
            return spacerCell
        }
    }
    
    func addLeftBorder(label: UILabel, borderColor: UIColor?, borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = borderColor
        border.frame = CGRect(x: 0, y: 0, width: borderWidth, height: label.frame.height)
        border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
        label.addSubview(border)
    }
    
    func addBottomBorder(label: UILabel, borderColor: UIColor?, borderHeight: CGFloat) {
        let border = UIView()
        border.backgroundColor = borderColor
        border.frame = CGRect(x: 0, y: label.frame.height, width: label.frame.width, height: -borderHeight)
        border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        label.addSubview(border)
    }
    
    func addRightBorder(label: UILabel, borderColor: UIColor, borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = borderColor
        border.frame = CGRect(x: label.frame.width, y: 0, width: -borderWidth, height: label.frame.height)
        border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
        label.addSubview(border)
    }
    
    func colorTitleLabel(tL: UILabel, eL: UILabel, dL: UILabel, section: Int, row: Int, pV: UIProgressView) {
        if section == 0 {
            /*BLUE
            achievementsImage.image = UIImage(named: "BlueAchievements")
            tL.backgroundColor = UIColor(red: 0/255, green: 150/255, blue: 199/255, alpha: 1.0)
            eL.backgroundColor = UIColor(red: 0/255, green: 150/255, blue: 199/255, alpha: 1.0)
            dL.backgroundColor = UIColor(red: 72/255, green: 202/255, blue: 228/255, alpha: 1.0)
            pV.progressTintColor = UIColor(red: 0/255, green: 180/255, blue: 216/255, alpha: 1.0) */
            
            //GREEN
           // achievementsImage.image = UIImage(named: "GreenAchievements")
            tL.backgroundColor = UIColor(red: 0/255, green: 255/255, blue: 118/255, alpha: 1.0)
            eL.backgroundColor = UIColor(red: 0/255, green: 255/255, blue: 118/255, alpha: 1.0)
            dL.backgroundColor = UIColor(red: 183/255, green: 255/255, blue: 191/255, alpha: 1.0)
            pV.trackTintColor = UIColor(red: 183/255, green: 255/255, blue: 191/255, alpha: 1.0)
            pV.progressTintColor = UIColor(red: 48/255, green: 250/255, blue: 65/255, alpha: 1.0)
        }
    }
    
    func determineAchievementProgress() {
        let defaults = UserDefaults.standard
        var numberOfGamesCompleted = 0
        
// load the progress for the first game
        if let actualGameHistory = defaults.value(forKey: "gameHistory") as? [[Any]] {
            numberOfGamesCompleted = actualGameHistory.count
        }
        
        if numberOfGamesCompleted >= 1 {
            achievementProgress[0] = 999
        }
        else {
            achievementProgress[0] = numberOfGamesCompleted
        }
        
// load the progress for the five games
        if numberOfGamesCompleted >= 5 {
            achievementProgress[1] = 999
        }
        else {
            achievementProgress[1] = numberOfGamesCompleted
        }
        
// load the progress for explorer
        if let actualHistoryViewed = defaults.value(forKey: "gameHistoryViewed") as? Int {
            historyViewed = actualHistoryViewed
            if historyViewed == 1 {
                numScreensViewed += 1
            }
        }
        if let actualParkViewed = defaults.value(forKey: "parkNameViewed") as? Int {
            parkNameViewed = actualParkViewed
            if parkNameViewed == 1 {
                numScreensViewed += 1
            }
        }
        if let actualNumPlayersViewed = defaults.value(forKey: "numPlayersViewed") as? Int {
            numPlayersViewed = actualNumPlayersViewed
            if numPlayersViewed == 1 {
                numScreensViewed += 1
            }
        }
        if let actualScoreCardViewed = defaults.value(forKey: "scoreCardViewed") as? Int {
            scorecardViewed = actualScoreCardViewed
            if scorecardViewed == 1 {
                numScreensViewed += 1
            }
        }
        
        if numScreensViewed == 6 {
            achievementProgress[2] = 999
        }
        
        else {
            achievementProgress[2] = numScreensViewed
        }
        
// Load the progress for rating app
        if let actualRating = defaults.value(forKey: "appRated") as? Int {
            appRated = actualRating

        }
        
        if appRated == 1 {
            achievementProgress[3] = 999
        }
        
        else {
            achievementProgress[3] = 0
        }
// Load the progress for visiting historic game
        if let actualHistoric = defaults.value(forKey: "historicGame") as? Bool {
            historicGame = actualHistoric
        }
        
        if historicGame == true {
            achievementProgress[4] = 999
        }
        else {
            achievementProgress[4] = 0
        }
        
// load the progress for sharing app
        if let actualShared = defaults.value(forKey: "appShared") as? Int {
            appShared = actualShared
        }
        
        if appShared == 1 {
            achievementProgress[5] = 999
        }
        
        else {
            achievementProgress[5] = 0
        }
        
// load the progress for no mercy
        if let actualNoMercy = defaults.value(forKey: "noMercy") as? Bool {
            noMercy = actualNoMercy
        }
        
        if noMercy == true {
            achievementProgress[6] = 999
        }
        
        else {
            achievementProgress[6] = 0
        }
        
// load the progress for all achievements
        var numOfCompletions = 0
        for i in 0...achievementTitles.count - 1 {
            if achievementProgress[i] == 999 {
                numOfCompletions += 1
            }
        }
        if numOfCompletions == 7 {
            achievementProgress[7] = 999
        }
        
        else {
            achievementProgress[7] = numOfCompletions
        }
    }

}
