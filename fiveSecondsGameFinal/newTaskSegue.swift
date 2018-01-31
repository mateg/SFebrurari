//
//  newTaskSegue.swift
//  fiveSecondsGameFinal
//
//  Created by Lucas Otterling on 01/05/2017.
//  Copyright © 2017 Lucas Otterling. All rights reserved.
//

import UIKit

class newTaskSegue: UIStoryboardSegue {

    override func perform() {
        segue()
    }
    
    func segue() {
        let toNewVC = self.destination
        let fromOldVC = self.source
        
        UIView.animate(withDuration: 0.0, delay: 0, options: .curveEaseInOut, animations: {
            //no animation
        }, completion: { success in
                    fromOldVC.present(toNewVC, animated: false, completion: nil)
        })
    }

    
}
