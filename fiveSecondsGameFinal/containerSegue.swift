//
//  containerSegue.swift
//  five-seconds
//
//  Created by Lucas Otterling on 19/03/2017.
//  Copyright © 2017 Lucas Otterling. All rights reserved.
//

import UIKit

class containerSegue: UIStoryboardSegue {
    
    override func perform() {
        segue()
    }
    
    func segue() {
        let toNewVC = self.destination
        let fromOldVC = self.source
        
            let containerView = fromOldVC.view.superview
            let orignalCenter = fromOldVC.view.center
        
            toNewVC.view.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
            toNewVC.view.center = orignalCenter
        

        containerView?.addSubview(toNewVC.view)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
         toNewVC.view.transform = CGAffineTransform.identity
        }, completion: { success in
         fromOldVC.present(toNewVC, animated: false, completion: nil)
        })
    }

}//end of class
