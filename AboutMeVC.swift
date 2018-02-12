//
//  AboutMeVC.swift
//  fiveSecondsGameFinal
//
//  Created by Lucas Otterling on 24/07/2017.
//  Copyright © 2017 Lucas Otterling. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Pastel

class AboutMeVC: UIViewController, GADBannerViewDelegate {
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var navBar: UINavigationBar!
    var defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        func dismissView(){
            dismiss(animated: true, completion: nil)
        }
        //let exitBarBtn = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: nil)
        //exitBarBtn.tintColor = UIColor(red:0.94, green:0.82, blue:0.36, alpha:1.0)
        //navBar.topItem?.rightBarButtonItem? = exitBarBtn

        followBtn.layer.cornerRadius = 20
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.backgroundColor = UIColor.clear
        
        //Check if product is purchased
        if (defaults.bool(forKey: "AdFreePurchased")){
            print("ads removed")
            
        }else if (!defaults.bool(forKey: "AdFreePurchased")){
            print("ads not removed")
            
            //GoogleAds
            self.bannerView.adUnitID = "ca-app-pub-5276944768850449/1981549417"
            self.bannerView.rootViewController = self
            let request :GADRequest = GADRequest()
            self.bannerView.load(request)
            self.bannerView.delegate = self
            //request.testDevices = [kGADSimulatorID, "6f8d35f6302f21fdf80606b80d9674d9"]
            
        }
        
        //MARK: Pastel
        let pastelView = PastelView(frame: view.bounds)
        // Custom Direction
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight
        // Custom Duration
        pastelView.animationDuration = 2.0
        // Custom Color
        pastelView.setColors([
            
            UIColor().SwedenBlue(),
            UIColor(red:0.02, green:0.36, blue:0.86, alpha:1.0),
            UIColor(red:0.01, green:0.51, blue:1.00, alpha:1.0),
            UIColor(red:0.16, green:0.58, blue:1.00, alpha:1.0),
            //yellow
            UIColor().SwedenYellow()//UIColor(red:0.97, green:0.90, blue:0.11, alpha:1.0),
            
            ])
        
        /*UIColor(red: 156/255, green: 39/255, blue: 176/255, alpha: 1.0),
         UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1.0),
         UIColor(red: 123/255, green: 31/255, blue: 162/255, alpha: 1.0),
         UIColor(red: 32/255, green: 76/255, blue: 255/255, alpha: 1.0),
         UIColor(red: 32/255, green: 158/255, blue: 255/255, alpha: 1.0),
         UIColor(red: 90/255, green: 120/255, blue: 127/255, alpha: 1.0),
         UIColor(red: 58/255, green: 255/255, blue: 217/255, alpha: 1.0)*/
        
        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 0)

        
    }//end of viewdidload

    @IBAction func exitTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }//end of exitTapped

    @IBAction func followBtnTapped(_ sender: UIButton) {
        
        let instaController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let TitleattributedString = NSAttributedString(string: "Följ Lucas på Instagram", attributes: [
            NSAttributedStringKey.font : UIFont(name: "YanoneKaffeesatz-Bold", size: 24)!,
            NSAttributedStringKey.foregroundColor : UIColor.black
            ])
        let MessageattributedString = NSAttributedString(string: "Du kommer att skickas till Lucas Otterlings Instagram profil där du kan följa honom (tar ca 10 sekunder). Tack!", attributes: [
            NSAttributedStringKey.font : UIFont(name: "YanoneKaffeesatz-Regular", size: 20)!,
            NSAttributedStringKey.foregroundColor : UIColor.darkGray
            ])
        
        instaController.setValue(TitleattributedString, forKey: "attributedTitle")
        instaController.setValue(MessageattributedString, forKey: "attributedMessage")
        
        let action = UIAlertAction(title: "OK", style: .default, handler: { (_) in
            let urlString = NSURL(string: "instagram://user?username=lucasotterling")!
            
            if UIApplication.shared.canOpenURL(urlString as URL){
                
                UIApplication.shared.openURL(urlString as URL)
                
            } else {
                let noInstaController = UIAlertController(title: "Misslyckande", message: "Din telefon har inte Instagram appen. Kontrollera Instagram och försök igen nästa gång.", preferredStyle: .alert)
                noInstaController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(noInstaController, animated: true, completion: nil)
            }
        })
        
        let cancel = UIAlertAction(title: "Avbryt", style: .cancel, handler: nil)
        instaController.addAction(action)
        instaController.addAction(cancel)
        self.present(instaController, animated: true, completion: nil)

        }//end of followBtnTapped
    
}//end of class
