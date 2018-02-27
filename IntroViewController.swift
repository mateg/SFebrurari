//
//  IntroViewController.swift
//  Sverigespelet
//
//  Created by Lucas Otterling on 23/11/2017.
//  Copyright © 2017 Lucas Otterling. All rights reserved.
//

import UIKit
import Pastel
import FBSDKLoginKit
import Firebase
import FirebaseAuth

class IntroViewController: UIViewController, FBSDKLoginButtonDelegate {
    // MARK: THIS VC WILL BE SHOWN IN FORM OF A UIPAGEVIEWCONTROLLER THE FIRST TIME THE USER OPENS THE APP
    //https://www.youtube.com/watch?v=8bltsDG2ENQ
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var controlBtn: UIButton!
    @IBAction func unwindToIntro(segue: UIStoryboardSegue) {}
    var pageIndex:Int!
    var imageFile: String!
    var pagesType = String()
    
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
        
        //the pageviewcontroller images
        self.imageView.image = UIImage(named: self.imageFile)
        
        controlBtn.tintColor = UIColor().SwedenYellow()
        controlBtn.titleLabel?.textColor = UIColor().SwedenYellow()
        controlBtn.layer.cornerRadius = 20
        //problem med att byta texten... -> men inget button på första viewn!
        if self.imageView.image == UIImage(named: "pageImage0"){
            //First image
            controlBtn.isHidden = true
        } else if self.imageView.image == UIImage(named: "pageImage0"){
           /* //third image
            let label = UILabel()
            label.text = Ditt högsta rekord kommer att laddas upp till vår topplista.
            label.frame.size.width = controlBtn.frame.size.width
            label.frame.size.height = 15
            label.center.x = controlBtn.frame.minX
            label.center.y = controlBtn.frame.minY - controlBtn.frame.size.height/2
            //animateImageView.backgroundColor = .cyan
            view.addSubview(label)*/
        }
    }
    
    //MARK: The control button (must adapt to which image is shown above.
    @IBAction func controlBtnTapped(_ sender: Any) {
        
        if self.imageView.image == UIImage(named: "pageImage0"){
            //First image
            print("Control tapped at 1st image")
        } else if self.imageView.image == UIImage(named: "pageImage1"){
            //second image
            print("Control tapped at 2nd image")
                //create alertcontroller with follow options
                let alertController = YBAlertController(style: .ActionSheet)
                
                //ask for facebook follow
                alertController.addButton(icon: UIImage(named: "facebook"), title: "Gilla oss på Facebook") {
                    print("Facebook follow")
                    
                    let instaController = UIAlertController(title: "", message: "", preferredStyle: .alert)
                    let TitleattributedString = NSAttributedString(string: "Likea oss på Facebook", attributes: [
                        NSAttributedStringKey.font : UIFont(name: "YanoneKaffeesatz-Bold", size: 24)!,
                        NSAttributedStringKey.foregroundColor : UIColor.black
                        ])
                    let MessageattributedString = NSAttributedString(string: "Du kommer att skickas till vår Facebook sida som du kan gilla (tar ca 10 sekunder). Tack!", attributes: [
                        NSAttributedStringKey.font : UIFont(name: "YanoneKaffeesatz-Regular", size: 20)!,
                        NSAttributedStringKey.foregroundColor : UIColor.darkGray
                        ])
                    
                    instaController.setValue(TitleattributedString, forKey: "attributedTitle")
                    instaController.setValue(MessageattributedString, forKey: "attributedMessage")
                    
                    let action = UIAlertAction(title: "OK", style: .default, handler: { (_) in
                        
                        let urlString = NSURL(string: "fb://profile/1950880881822451")!
                        
                        if UIApplication.shared.canOpenURL(urlString as URL){
                            UIApplication.shared.openURL(urlString as URL)
                            
                        } else if UIApplication.shared.canOpenURL(URL(string: "https://www.facebook.com/sverigespelet")!){
                            //redirect to safari because the user doesn't have facebook
                            UIApplication.shared.openURL(URL(string: "https://www.facebook.com/sverigespelet")!)
                        } else {
                            let noInstaController = UIAlertController(title: "Misslyckande", message: "Din telefon har inte Facebook appen. Kontrollera Facebook och försök igen nästa gång.", preferredStyle: .alert)
                            noInstaController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                            self.present(noInstaController, animated: true, completion: nil)
                        }
                    })
                    
                    let cancel = UIAlertAction(title: "Avbryt", style: .cancel, handler: nil)
                    instaController.addAction(action)
                    instaController.addAction(cancel)
                    self.present(instaController, animated: true, completion: nil)
                    
                }
                
                //ask for snapchat follow
                alertController.addButton(icon: UIImage(named: "Snapchat"), title: "Lägg till oss på Snapchat") {
                    print("Snapchat follow")
                    
                    let instaController = UIAlertController(title: "", message: "", preferredStyle: .alert)
                    let TitleattributedString = NSAttributedString(string: "Följ oss på Snapchat", attributes: [
                        NSAttributedStringKey.font : UIFont(name: "YanoneKaffeesatz-Bold", size: 24)!,
                        NSAttributedStringKey.foregroundColor : UIColor.black
                        ])
                    let MessageattributedString = NSAttributedString(string: "Du kommer att skickas till vår Snapchat där du kan följa oss (tar ca 10 sekunder). Tack!", attributes: [
                        NSAttributedStringKey.font : UIFont(name: "YanoneKaffeesatz-Regular", size: 20)!,
                        NSAttributedStringKey.foregroundColor : UIColor.darkGray
                        ])
                    
                    instaController.setValue(TitleattributedString, forKey: "attributedTitle")
                    instaController.setValue(MessageattributedString, forKey: "attributedMessage")
                    
                    let action = UIAlertAction(title: "OK", style: .default, handler: { (_) in
                        let urlString = URL(string: "snapchat://add/sverigespelet")!
                        
                        if UIApplication.shared.canOpenURL(urlString){
                            
                            UIApplication.shared.openURL(urlString)
                            
                        } else if UIApplication.shared.canOpenURL(URL(string: "https://www.snapchat.com/add/sverigespelet")!){
                            //redirect to safari because the user doesn't have facebook
                            UIApplication.shared.openURL(URL(string: "https://www.snapchat.com/add/sverigespelet")!)
                        } else {
                            let noInstaController = UIAlertController(title: "Misslyckande", message: "Din telefon har inte Snapchat appen. Kontrollera Snapchat och försök igen nästa gång.", preferredStyle: .alert)
                            noInstaController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                            self.present(noInstaController, animated: true, completion: nil)
                        }
                    })
                    
                    let cancel = UIAlertAction(title: "Avbryt", style: .cancel, handler: nil)
                    instaController.addAction(action)
                    instaController.addAction(cancel)
                    self.present(instaController, animated: true, completion: nil)
                    
                }
                
                //ask for instagram follow
                alertController.addButton(icon: UIImage(named: "instagram"), title: "Följ oss på Instagram") {
                    print("Instagram follow")
                    
                    let instaController = UIAlertController(title: "", message: "", preferredStyle: .alert)
                    let TitleattributedString = NSAttributedString(string: "Följ oss på Instagram", attributes: [
                        NSAttributedStringKey.font : UIFont(name: "YanoneKaffeesatz-Bold", size: 24)!,
                        NSAttributedStringKey.foregroundColor : UIColor.black
                        ])
                    let MessageattributedString = NSAttributedString(string: "Du kommer att skickas till vår Instagram profil där du kan följa oss (tar ca 10 sekunder). Tack!", attributes: [
                        NSAttributedStringKey.font : UIFont(name: "YanoneKaffeesatz-Regular", size: 20)!,
                        NSAttributedStringKey.foregroundColor : UIColor.darkGray
                        ])
                    
                    instaController.setValue(TitleattributedString, forKey: "attributedTitle")
                    instaController.setValue(MessageattributedString, forKey: "attributedMessage")
                    
                    let action = UIAlertAction(title: "OK", style: .default, handler: { (_) in
                        let urlString = NSURL(string: "instagram://user?username=sverigespelet")!
                        
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
                    
                }
                
                //ask for twitter follow
                alertController.addButton(icon: UIImage(named: "twitter"), title: "Följ oss på Twitter") {
                    print("Twitter follow")
                    
                    let instaController = UIAlertController(title: "", message: "", preferredStyle: .alert)
                    let TitleattributedString = NSAttributedString(string: "Följ oss på Twitter", attributes: [
                        NSAttributedStringKey.font : UIFont(name: "YanoneKaffeesatz-Bold", size: 24)!,
                        NSAttributedStringKey.foregroundColor : UIColor.black
                        ])
                    let MessageattributedString = NSAttributedString(string: "Du kommer att skickas till vår Twitter profil där du kan följa oss (tar ca 10 sekunder). Tack!", attributes: [
                        NSAttributedStringKey.font : UIFont(name: "YanoneKaffeesatz-Regular", size: 20)!,
                        NSAttributedStringKey.foregroundColor : UIColor.darkGray
                        ])
                    
                    instaController.setValue(TitleattributedString, forKey: "attributedTitle")
                    instaController.setValue(MessageattributedString, forKey: "attributedMessage")
                    
                    let action = UIAlertAction(title: "OK", style: .default, handler: { (_) in
                        let urlString = NSURL(string: "twitter:///user?screen_name=sverigespelet")!
                        
                        if UIApplication.shared.canOpenURL(urlString as URL){
                            
                            UIApplication.shared.openURL(urlString as URL)
                            
                        } else {
                            let noInstaController = UIAlertController(title: "Misslyckande", message: "Din telefon har inte Twitter appen. Kontrollera Twitter och försök igen nästa gång.", preferredStyle: .alert)
                            noInstaController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                            self.present(noInstaController, animated: true, completion: nil)
                        }
                    })
                    
                    let cancel = UIAlertAction(title: "Avbryt", style: .cancel, handler: nil)
                    instaController.addAction(action)
                    instaController.addAction(cancel)
                    self.present(instaController, animated: true, completion: nil)
                    
                }
                
                alertController.touchingOutsideDismiss = false
                alertController.cancelButtonTitle = "Avbryt"
                alertController.title = "Välj vilken platform"
                alertController.show()
                //end of "följ oss på sociala medier"
        } else if self.imageView.image == UIImage(named: "pageImage2"){
            //third image
            print("Control tapped at 3rd image")
            handleCustomFacebookLogin()
        } else if self.imageView.image == UIImage(named: "pageImage3"){
            //fourth image
            print("Control tapped at 4th image")
            print("'First time user opens app'- pageviewcontroller won't be shown again")
            self.dismiss(animated: true, completion: nil)
        }
    
        
    }//end of viewdidload
    
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
            print("Facebook not logged in")
            FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) {
                (result, error) in
                if error != nil {
                    print("Custom Facebook Login failed")
                    return
                }
                self.grabEmailAddress()
        }
            
            //let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FacebookVC")
            //self.present(vc, animated: true, completion: nil)
        
    }
    /* OLD WAY OF LOGIN INTO FB
        if(FBSDKAccessToken.current() != nil){
            print("Facebook logged in")
            let alert = UIAlertController(title: "Logga ut från Facebook?", message: "Detta försämrar din spelupplevelse och kontakt med Sverigespelets sociala media community.", preferredStyle: UIAlertControllerStyle.alert)
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
    }*/
    
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
            
            print(result!) //print out the different crediters of the user
        }
    }//END OF FACEBOOK LOGIN
    
}
