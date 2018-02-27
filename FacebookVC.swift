//
//  FacebookVC.swift
//  Sverigespelet
//
//  Created by Lucas Otterling on 05/02/2018.
//  Copyright © 2018 Lucas Otterling. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import FirebaseAuth
import Pastel
import NotificationBannerSwift

class FacebookVC: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var noBtn: UIButton!
    @IBOutlet weak var dataUploadLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 0)
        
        imageView.image = UIImage(named: "pageImage2")
        
        yesBtn.tintColor = UIColor().SwedenYellow()
        yesBtn.titleLabel?.textColor = UIColor().SwedenYellow()
        yesBtn.layer.cornerRadius = 20
        noBtn.tintColor = UIColor().SwedenYellow()
        noBtn.titleLabel?.textColor = UIColor().SwedenYellow()
        noBtn.layer.cornerRadius = 20
        dataUploadLabel.setSizeFont(sizeFont: 12)


    }
    @IBAction func noTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func yesTapped(_ sender: Any) {
        // Om jag inte är inloggad så kallar jag på loggin och gör samma procedur
        print("Facebook not logged in")
         FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) {
         
         (result, error) in
         
         if error != nil {
         print("Custom Facebook Login failed")
         return
         }
         self.grabEmailAddress()
         
         }
        dismiss(animated: true) {
        }
    }
    
    //MARK: facebook Login
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("did log out of facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print("facebook error", error)
            return
        }
        print("facebook login successful + send email address to Firebase")
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start {(connection, result, error) in
            
            if error != nil{
                print("Failed to start facebook graph request", error as Any)
                return
            }
            print(result!) //print out the different crediters of the user
        }
    }
    
    func handleCustomFacebookLogin() {
        if(FBSDKAccessToken.current() != nil){
            print("Facebook logged in")
            let alert = UIAlertController(title: "Logga ut från Facebook?😢", message: "Du kommer inte kunna se topplistan och din spelupplevelse samt kontakt med Sverigespelets sociala media community kommer försämras.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Logga ut", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in FBSDKLoginManager().logOut()}))
            self.present(alert, animated: true, completion: nil)
        }else{
            print("Facebook not logged in")
            FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) {
                (result, error) in
                if error != nil {
                    print("Custom Facebook Login failed")
                    return
                }
                self.grabEmailAddress()
            }
        }
    }
    
    func grabEmailAddress() {
        
        //send to firebase
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else {return}
        let userCredentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        Auth.auth().signIn(with: userCredentials) { (user, error) in
            
            if error != nil {
                print("something went wrong with the Facebook User", error ?? "")
                return
            }
            
            print("Successfully logged in with Facebook user in Firebase", user ?? "")
            let notificationBannerTitle = "Välkommen, nu är du inloggad😍"
            let notificationBannerSubtitle = "Klicka på 'Topplista-knappen' igen!"
            let leftView = UIImageView(image: #imageLiteral(resourceName: "heart"))
            //show notificationBanner
            let notificationBanner = NotificationBanner(title: notificationBannerTitle, subtitle: notificationBannerSubtitle, leftView: leftView, style: .info)
            notificationBanner.backgroundColor = UIColor().SwedenYellow()
            notificationBanner.titleLabel?.textColor = UIColor().SwedenBlue()
            notificationBanner.subtitleLabel?.textColor = UIColor().SwedenBlue()
            notificationBanner.onTap = {
                print("notificationBanner tapped")
            }
            notificationBanner.show()
        }
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start {(connection, result, error) in
            
            if error != nil{
                print("Failed to start facebook graph request", error as Any)
                return
            }
            
            let res = result as! NSDictionary
            
            facebookID = res.object(forKey: "id") as! String
            
            if userTopScore != nil {
                print("userTopScore",userTopScore!)
            } else {
                userTopScore = 0
                print("userTopScore",userTopScore!)

            }
            LeaderboardVC.updateScore(score: userTopScore! ,id: res.object(forKey: "id") as! String, completion: {})
            LeaderboardVC.setName(name: res.object(forKey: "name") as! String, id: res.object(forKey: "id") as! String)
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "leaderBoardId")
            self.present(vc, animated: true, completion: nil)
            
            print(result!) //print out the different crediters of the user
        }
    }//END OF FACEBOOK LOGIN
}
