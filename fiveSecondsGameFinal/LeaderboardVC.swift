//
//  LeaderboardVC.swift
//  leaderboard
//
//  Created by Fredrik Bixo on 2018-01-24.
//  Copyright © 2018 Fredrik Bixo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Firebase

extension LeaderboardVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UITableViewCell
        print(scores[indexPath.row])
        
        
        // Fredrik. Här fyller jag i vad de värderna i raderna på tabellen ska vara
        if scores[indexPath.row]["name"] != nil {
        cell.textLabel?.text = scores[indexPath.row]["name"] as! String
        } else {
        cell.textLabel?.text = "Unknown"
        }
        if scores[indexPath.row]["score"] != nil {
            cell.detailTextLabel?.text = "\(scores[indexPath.row]["score"] as! NSInteger)"
        } else {
            cell.detailTextLabel?.text = "0"
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scores.count
    }
    
}


class LeaderboardVC: UIViewController {
    
    var scores = Array<Dictionary<String, Any>>()
    var FBresult : Any?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        
        // Fredrik. Ladda ner scoresen från databsen
        downloadScores()
      
        print(FBresult,"FB user")
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func downloadScores() {
        
        let leaderboardDB = Database.database().reference().child("leaderboard").queryOrdered(byChild: "score").queryLimited(toLast: 100)
        
        leaderboardDB.observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.scores.removeAll()
            
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                self.scores.append(rest.value as! [String : Any])
            }
            
         //   self.scores = (snapshot.value as? NSDictionary)?.allValues as! Array<Dictionary>
         //  self.scores.reverse()
            self.scores = self.scores.filter({dict in
                
                if (dict["score"] == nil) {
                    return false
                }
                
                return true
                
            })
            
            self.tableView.reloadData()
            
        }, withCancel: nil)
        
    }
    
    static func setName(name:String, id:String) {
        
        // Fredrik. Sätt namnet för facebook ID i databasen
        Database.database().reference().child("leaderboard").child(id).child("name").setValue(name, withCompletionBlock: { (error,ref) in
            
            if error == nil {
                
            }
            
        })
        
    }
    
    static func updateScore(score:Int, id:String) {
        
        // Sätt scoren för användaren.
        // Det här kan vara användarens facebook ID eller något annat unikt ID.
        Database.database().reference().child("leaderboard").child(id).child("score").runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            
            let score2 = currentData.value as? Int ?? 0
            if score > score2 {
                currentData.value = score
            }
            
            return TransactionResult.success(withValue: currentData)
            
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }

        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


