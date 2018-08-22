//
//  ScoresTableViewController.swift
//  SharkeyEric_4.1
//
//  Created by Eric Sharkey on 8/20/18.
//  Copyright © 2018 Eric Sharkey. All rights reserved.
//

import UIKit
import CoreData

class ScoresTableViewController: UITableViewController {
    
    var managedContext: NSManagedObjectContext!
    var leaderBoardData: NSManagedObject!
    private var dataObj: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.init(red:1.00, green:1.00, blue:0.92, alpha:1.0)
        navigationController?.isNavigationBarHidden = false
        load()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        tableView.rowHeight = 106
        return 1
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "LeaderBoard: Top 10"
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataObj.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "scoreCell", for: indexPath) as? ScoresTableViewCell else {return tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)}
 
        let position = indexPath.row + 1
        cell.positionLabel.text = position.description
        cell.nameLabel.text = dataObj[indexPath.row].value(forKey: "userName") as? String
        let moves = dataObj[indexPath.row].value(forKey: "moves") as? Int
        let date = dataObj[indexPath.row].value(forKey: "date") as? Date
        let time = dataObj[indexPath.row].value(forKey: "time") as? Int
        
        if let t = time {
            let timeMinutes = t / 60 % 60
            let timeSeconds = t % 60
            cell.timeLabel.text = String(format:"%02i:%02i", timeMinutes, timeSeconds)
        } else {
           cell.timeLabel.text = "N/A"
        }

        
         cell.dateLabel.text = date?.description
        cell.movesLabel.text = moves?.description
        return cell
    }

    func load(){
        /* We use Fetch Requests to get the data we want off of the "notepad" */
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "LeaderBoardData")
        let sorty = NSSortDescriptor(key: "time", ascending: true)
        fetchRequest.sortDescriptors = [sorty]
        do{
            let data: [NSManagedObject] = try managedContext.fetch(fetchRequest)
            
            for obj in data {
                dataObj.append(obj)
            }
            
        } catch {
            assertionFailure()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
}
