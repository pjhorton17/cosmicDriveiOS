//
//  HistoryViewController.swift
//  PuttPuttScoreCard
//
//  Created by Patrick Horton on 10/7/20.
//  Copyright © 2020 Patrick Horton. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  //  @IBOutlet weak var adView: GADBannerView!
    
    var gameHistory: [[Any]]?
    
    @IBOutlet weak var noHistoryLabel: UILabel!
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var historySV: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.snapshotView(afterScreenUpdates: true)
        
        // Check to see if there are any games in history
        if checkHistory() {
            // determine max # of rows
            let maxRows = determineMaxRows()
            
            historySV.alpha = 1.0
            historyTableView.alpha = 1.0
            
            // Load the history
            historyTableView.delegate = self
            historyTableView.dataSource = self
            
            if (50 * gameHistory!.count < maxRows * 50) {
                let heightConstraint = NSLayoutConstraint(item: historyTableView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: CGFloat(50 * (gameHistory!.count)))
                historyTableView.addConstraint(heightConstraint)
            }
            
            else {
                // Put a cap on the height of the tableview
                let heightConstraint = NSLayoutConstraint(item: historyTableView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: CGFloat(maxRows * 50))
                historyTableView.addConstraint(heightConstraint)
            }
            
            noHistoryLabel.alpha = 0
        
            // TOP LEFT CORNER
            dateHeaderLabel.layer.cornerRadius = 20
            dateHeaderLabel.layer.maskedCorners = .layerMinXMinYCorner
            dateHeaderLabel.clearsContextBeforeDrawing = true
            dateHeaderLabel.clipsToBounds = true
            dateHeaderLabel.autoresizesSubviews = true
            
            detailsHeaderLabel.layer.cornerRadius = 20
            detailsHeaderLabel.layer.maskedCorners = .layerMaxXMinYCorner
            detailsHeaderLabel.clearsContextBeforeDrawing = true
            detailsHeaderLabel.clipsToBounds = true
            detailsHeaderLabel.autoresizesSubviews = true
            
        }
        
        else {
            // Present the no history label
            noHistoryLabel.alpha = 1.0
            historySV.alpha = 0
            historyTableView.alpha = 0
        }
        
        saveGame()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.alpha = 1.0
    }
    
    func checkHistory() -> Bool {
        let defaults = UserDefaults.standard

        // Load the additionProgress Values
        if let actualGameHistory = defaults.value(forKey: "gameHistory") as? [[Any]] {
            gameHistory = actualGameHistory
            
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameHistory!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.rowHeight = 50
        
        tableView.indicatorStyle = .black
        
        let historyCell = tableView.dequeueReusableCell(withIdentifier: "historyCell")!
        historyCell.isUserInteractionEnabled = true
        historyCell.backgroundColor = UIColor.systemBlue
        
        // Add the date (0)
        // Add the Location (1)
        // Save Player Names (2)
        // Save Total Scores (3)
        // save the winning score (4)
        // save the winning player (5)
        
        let dateLabel = historyCell.viewWithTag(1) as! UILabel
        //let locationLabel = historyCell.viewWithTag(2) as! UILabel
        let winnerLabel = historyCell.viewWithTag(3) as! UILabel
        let scoreLabel = historyCell.viewWithTag(4) as! UILabel
        let detailsButton = historyCell.viewWithTag(5) as! UIButton
        
        
        if (indexPath.row % 2 == 0) {
            // GREEN
            dateLabel.backgroundColor = UIColor(red: 0/255, green: 255/255, blue: 118/255, alpha: 1.0)
            //locationLabel.backgroundColor = UIColor(red: 0/255, green: 255/255, blue: 118/255, alpha: 1.0)
            winnerLabel.backgroundColor = UIColor(red: 0/255, green: 255/255, blue: 118/255, alpha: 1.0)
            scoreLabel.backgroundColor = UIColor(red: 0/255, green: 255/255, blue: 118/255, alpha: 1.0)
            detailsButton.backgroundColor = UIColor(red: 0/255, green: 255/255, blue: 118/255, alpha: 1.0)
            

        } else {
            // YELLOW
            dateLabel.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 0/255, alpha: 1.0)
            //locationLabel.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 0/255, alpha: 1.0)
            winnerLabel.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 0/255, alpha: 1.0)
            scoreLabel.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 0/255, alpha: 1.0)
            detailsButton.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 0/255, alpha: 1.0)
        }
        
        dateLabel.text = "\(gameHistory![indexPath.row][0])"
        dateLabel.textColor = UIColor.black
        dateLabel.textAlignment = .center
        dateLabel.layer.borderColor = UIColor.black.cgColor
        dateLabel.layer.borderWidth = 1
        
        
        //locationLabel.text = "\(gameHistory![indexPath.row][1])"
        //locationLabel.textColor = UIColor.black
        //locationLabel.textAlignment = .center
        //locationLabel.layer.borderColor = UIColor.black.cgColor
        //locationLabel.layer.borderWidth = 1
        //locationLabel.numberOfLines = 0
        
        winnerLabel.text = "\(gameHistory![indexPath.row][4])"
        winnerLabel.textColor = UIColor.black
        winnerLabel.textAlignment = .center
        winnerLabel.layer.borderColor = UIColor.black.cgColor
        winnerLabel.layer.borderWidth = 1
        winnerLabel.numberOfLines = 0
        
        scoreLabel.text = "\(gameHistory![indexPath.row][3])"
        scoreLabel.textColor = UIColor.black
        scoreLabel.textAlignment = .center
        scoreLabel.layer.borderColor = UIColor.black.cgColor
        scoreLabel.layer.borderWidth = 1
        
        detailsButton.layer.borderColor = UIColor.black.cgColor
        detailsButton.layer.borderWidth = 1
        
        // Set the tag of the button to the current row in the tableview
        detailsButton.tag = indexPath.row
        // Add a gesture recognizer to the button
        let gestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(detailsTapped(gestureRecognizer:)))
        
        detailsButton.addGestureRecognizer(gestureRecognizer)
        
        styleHeaderLabels(label: dateHeaderLabel)
        //styleHeaderLabels(label: locationHeaderLabel)
        styleHeaderLabels(label: winnerHeaderLabel)
        styleHeaderLabels(label: scoreHeaderLabel)
        styleHeaderLabels(label: detailsHeaderLabel)
        
        return historyCell
    }
    
    var cardToDisplay = 0
    @objc func detailsTapped(gestureRecognizer: UITapGestureRecognizer) {
        
        let button = gestureRecognizer.view as! UIButton
        
        // Set the card to display
        cardToDisplay = button.tag
        
        performSegue(withIdentifier: "goToDetails", sender: button)
    }
    @IBOutlet weak var dateHeaderLabel: UILabel!
    @IBOutlet weak var locationHeaderLabel: UILabel!
    @IBOutlet weak var winnerHeaderLabel: UILabel!
    @IBOutlet weak var scoreHeaderLabel: UILabel!
    @IBOutlet weak var detailsHeaderLabel: UILabel!
    
    
    func styleHeaderLabels(label:UILabel) {
        //ORANGE
        label.backgroundColor = UIColor(red: 255/255, green: 165/255, blue: 0/255, alpha: 1)
        label.textAlignment = .center
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1
    }
    
    func determineMaxRows() -> Int {
        var maxRows = 0
        
        // Get the max height of the safe area
        let safeArea = view.safeAreaLayoutGuide
        let safeAreaHeight = Int(safeArea.layoutFrame.size.height)
        
        // Now, determine how much space have for the table view
        var spaceForTableView = safeAreaHeight
        
            // Subtract the height of the "HISTORY" label
            spaceForTableView = spaceForTableView - 50
            
            // Subtract the height of the header label stackview
            spaceForTableView = spaceForTableView - 50
            
            // Subtract the height of the ad banner
            spaceForTableView = spaceForTableView - 50
            
            // Subtract the height of the border
            spaceForTableView = spaceForTableView - 15
        
        // Now, calculate how many COMPLETE rows we can have
        maxRows = Int(spaceForTableView / 50)
        
        // Return 1 less since index of rows starts at 0
        return maxRows - 1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.historyTableView.flashScrollIndicators()
    }
    
    func saveGame() {
              let defaults = UserDefaults.standard
              
              // Save the luckyCounter Value
              defaults.set(1, forKey: "gameHistoryViewed")
          }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is DetailsViewController {
            let detailsVC = segue.destination as? DetailsViewController
            detailsVC?.cardToDisplay = cardToDisplay
            print("\(cardToDisplay)")
            
            // For: [x][y],
            // x = Game to extract data from
            // y = Specific data to extract
            
            // Add the Date (0)
            // Add the Location (1)
            // Save Player Names (2)
            // Save Total Scores (3)
            // save the Winning Score (4)
            // save the Winning Player (5)
            
            // Send the scorecard data to the details VC
                // Send the date
                detailsVC?.date = gameHistory![cardToDisplay][0] as! String
            
                // Send the location
                //detailsVC?.location = gameHistory![cardToDisplay][1] as! String
            //detailsVC?.location = "Halfway-To-Halloween!"
            
                // Send the playerNamesArray
                detailsVC?.playerNameArray = gameHistory![cardToDisplay][1] as! [String]
            
                // Send the totalScoresArray
                detailsVC?.scoreArray = gameHistory![cardToDisplay][2] as! [[Int]]
            
                // Send the winningScore
                detailsVC?.winningScore = gameHistory![cardToDisplay][3] as! Int
                
                // Determine how many holes
                let tempValue = gameHistory![cardToDisplay][2] as! [[Int]]
                detailsVC?.NUMBER_OF_HOLES = tempValue[0].count
        }
    }
}
