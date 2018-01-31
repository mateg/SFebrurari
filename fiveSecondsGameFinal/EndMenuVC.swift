//
//  EndMenuVC.swift
//  fiveSeconds
//
//  Created by Lucas Otterling on 19/03/2017.
//  Copyright © 2017 Lucas Otterling. All rights reserved.
//

import UIKit
import GoogleMobileAds
import AVFoundation
import SwiftShareBubbles
import Social
import Photos
import MessageUI
import EggRating
import Pastel
import FBSDKLoginKit
import Firebase
import FirebaseAuth
import NotificationBannerSwift
import StoreKit
import MarqueeLabel

class EndMenuVC: UIViewController, GADBannerViewDelegate, GADRewardBasedVideoAdDelegate, SwiftShareBubblesDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, FBSDKLoginButtonDelegate {

    @IBOutlet weak var scoreNumberLabel: UILabel!
    @IBOutlet weak var timeNumberLabel: UILabel!
    @IBOutlet weak var failsNumberLabel: UILabel!
    @IBOutlet weak var scoreTextLabel: MarqueeLabel!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var starImageView: UIImageView!
    @IBOutlet weak var rewardButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var leaderboardButton: UIButton!
    @IBOutlet weak var statsView: UIView!
    @IBOutlet weak var mainMenuButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var buttonsView: UIView!
    var scoreNumber = Int() //FREDRIK -> detta är spelarens "score" som ska uppdateras till Leaderboarden... men hur? :/
    var timeNumber = Int()
    var failsNumber = Int()
    var microphoneStatusString = String()
    var scoreTextString = String()
    var defaults = UserDefaults.standard //FREDRIK: jag har använt denna för att spara saker om användaren -> vad sägs om att försöka spara spelarens högsta score där för att senare visa den på LeaderboardVD? (bara en idé) 
    var formerMainTypeString = String()
    var formerSpecialTypeString = String()
// The reward-based video ad.
    var adRequestInProgress = false
    var rewardBasedVideo: GADRewardBasedVideoAd?
//share bubbles
    var bubbles: SwiftShareBubbles?
    var mailID = 11
    var messengerID = 12
    var imessageID = 13
//reward button
    var rewardDuration = 2.5
    var rewardDamping = 0.10
    var rewardVelocity = 9.0
    var animationImages = [UIImage]()
    var completeTimer = Timer()
    var rewardUsed = String()
//notification banner
    var notificationBannerTitle = String()
    var notificationBannerSubtitle = String()
    var leftView = UIImageView(image: #imageLiteral(resourceName: "heart"))
    var pickedBannerRandom = String()
    var pickedBannerTypeRandom = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //korrigera i efter score!
        if scoreNumber <= 3 {
            starImageView.image = UIImage(named: "11")
            scoreTextLabel.text = "Det där blev KALKON och inte KANON - bättre kan du😉"
        }else if scoreNumber <= 10 && scoreNumber >= 4 {
            starImageView.image = UIImage(named: "10")
            scoreTextLabel.text = "Varning för 🦌 och inte så höga poäng😬"
        }else if scoreNumber <= 20 && scoreNumber >= 11 {
            starImageView.image = UIImage(named: "9")
            scoreTextLabel.text = "En känd internet svensk 🎥 men mest bland kidsen👶"
        }else if scoreNumber <= 30 && scoreNumber >= 21 {
            starImageView.image = UIImage(named: "8")
            scoreTextLabel.text = "Mittemellan helt enkelt🙃"
        }else if scoreNumber <= 41 && scoreNumber >= 31 {
            starImageView.image = UIImage(named: "7")
            scoreTextLabel.text = "I 🌍 är du en känd svensk. I 🇸🇪 ett känt varuhus😑"
        }else if scoreNumber <= 53 && scoreNumber >= 42 {
            starImageView.image = UIImage(named: "6")
            scoreTextLabel.text = "LAGOM bra/dåligt helt enkelt🤓"
        }else if scoreNumber <= 65 && scoreNumber >= 54 {
            starImageView.image = UIImage(named: "5")
            scoreTextLabel.text = "Nu börjar det likna något - dalahästligt bra🐴"
        }else if scoreNumber <= 77 && scoreNumber >= 66 {
            starImageView.image = UIImage(named: "4")
            scoreTextLabel.text = "URSVENSKEN💪🙌"
        }else if scoreNumber <= 96 && scoreNumber >= 78 {
            starImageView.image = UIImage(named: "3")
            scoreTextLabel.text = "Knugen🤴precis så som han själv stavar det👑"
        }else if scoreNumber <= 120 && scoreNumber >= 97 {
            starImageView.image = UIImage(named: "2")
            scoreTextLabel.text = "Igenkänd och älskad av alla❤️"
        }else if scoreNumber >= 121 {
            starImageView.image = UIImage(named: "1")
            scoreTextLabel.text = "\"Jag kom som en kung, jag lämnade som en legend.\"⚽️"
        }
        
        starImageView.layer.cornerRadius = 10
        scoreTextLabel.type = .leftRight
        print(rewardUsed, "reward in end")

        //change font after device size (ipad or iphone)
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone {
            
            timeNumberLabel.setSizeFont(sizeFont: 25)
            failsNumberLabel.setSizeFont(sizeFont: 25)
            scoreNumberLabel.setSizeFont(sizeFont: 55)
            scoreTextLabel.setSizeFont(sizeFont: 30)
            mainMenuButton.titleLabel?.setSizeFont(sizeFont: 30)
            
        } else if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
            
            timeNumberLabel.setSizeFont(sizeFont: 45)
            failsNumberLabel.setSizeFont(sizeFont: 45)
            scoreNumberLabel.setSizeFont(sizeFont: 150)
            scoreTextLabel.setSizeFont(sizeFont: 60)
            mainMenuButton.titleLabel?.setSizeFont(sizeFont: 50)
            
        }

        //basic set up
        scoreNumberLabel.text = "\(scoreNumber)"
        timeNumberLabel.text = "\(timeNumber)\nSekunder"
        failsNumberLabel.text = "\(failsNumber)\nFails"
        
        shareButton.layer.cornerRadius = 20
        rewardButton.layer.cornerRadius = 20
        leaderboardButton.layer.cornerRadius = 20
        infoButton.layer.cornerRadius = 10
        mainMenuButton.layer.cornerRadius = 10
        mainMenuButton.setTitleColor(UIColor().SwedenYellow(), for: .normal)
        
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
        
        //google reward video
        rewardBasedVideo = GADRewardBasedVideoAd.sharedInstance()
        rewardBasedVideo?.delegate = self
        loadRewardAd()
        
        //reward button setup
        for i in 1..<6 {
        //    animationImages.append(UIImage(named: "fortsätt spela \(i)")!)
        }
        //rewardButton.setImage(animationImages[0], for: .normal)
      //  rewardButton.imageView!.animationImages = animationImages
     //   rewardButton.imageView!.animationDuration = 3.5
      //  rewardButton.imageView?.animationRepeatCount = 1
        
        
       
        
        if rewardUsed != "Used" {
            print("reward hasn't been used this round")
            animateRewardButton()
       //     rewardButton.imageView?.startAnimating()
        } else {
            print("reward has been used this round")
            rewardButton.isEnabled = false
            shareButton.isHidden = false
            leaderboardButton.isHidden = false
            buttonsView.isHidden = false
            timeNumberLabel.text = "-\nSeconds"
            rewardButton.setImage(animationImages.last, for: .normal)
        }
        
        //share bubbles
        bubbles = SwiftShareBubbles(point: CGPoint(x: view.frame.width / 2, y: view.frame.height / 2), radius: 150, in: view)
        bubbles?.showBubbleTypes = [Bubble.twitter, Bubble.facebook, Bubble.whatsapp, Bubble.instagram]
        bubbles?.delegate = self
        
        let mailAttribute = ShareAttirbute(bubbleId: mailID, icon: UIImage(named: "Mail")!, backgroundColor: UIColor(red:0.19, green:0.81, blue:1.00, alpha:1.0))
        let messengerAttribute = ShareAttirbute(bubbleId: messengerID, icon: UIImage(named: "Messenger")!, backgroundColor: UIColor(red:0.19, green:0.42, blue:1.00, alpha:1.0))
        let imessageAttribute = ShareAttirbute(bubbleId: imessageID, icon: UIImage(named: "iMessage")!, backgroundColor: UIColor(red:0.15, green:0.94, blue:0.09, alpha:1.0))

        bubbles?.customBubbleAttributes = [mailAttribute, messengerAttribute, imessageAttribute]
        
    }//end of viewdidload
    
//MARK: prepareforsegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToStartMenu"{
            if let destination = segue.destination as? StartMenuVC {
   
   //removed levels: "Numbers", "Add 1", "Run a lap",
   var mainTypeArray = ["Images", "Game Art", "Orientation Change", "Button Pattern", "Button Tap",  "Button Quick", "Pan Gesture", "KYC", "Core Motion", "Find hidden", "Doesn't fit", "End sentence", "Long Press", "Multiple Tap Button", "Image Collide",  "Swipe Left", "Swipe Gesture", "Swipe Down", "Don't Press","Blow in Mic"]
   
   if microphoneStatusString == "NO" {
       mainTypeArray.removeLast() //the positon of "blow in mic"
   }
   print(mainTypeArray)

   //randomize interstial on return to startmenu or not
   let popadRandom = ["1", "2", "3", "4", ]         //"1", "2", "3", "4", "5",
   //Randomizing the ad = 1/6 % chance of showing
   let popadRange: UInt32 = UInt32(popadRandom.count)
   let popadRandomNumber = Int(arc4random_uniform(popadRange))
   let popAdRandom = popadRandom[popadRandomNumber]
   print("poppickadrandom", popAdRandom)
   
   //Randomizing the type =
   let range: UInt32 = UInt32(mainTypeArray.count)
   let randomNumber = Int(arc4random_uniform(range))
   let pickRandom = mainTypeArray[randomNumber]
   
   //MARK: Randomize notificationBanner informing of ___
   let bannerRandom = ["1", "2", "3", "4"]         //"1", "2", "3", "4", "5",
   let bannerRange: UInt32 = UInt32(bannerRandom.count)
   let bannerNumber = Int(arc4random_uniform(bannerRange))
   let pickedBannerRandom = bannerRandom[bannerNumber]
   print("notificationBannerRandom", pickedBannerRandom)
   
   //Another randomization deciding which banner to show
   let bannerTypes = ["noAds", "ourStory", "loginFB", "review", "socialMedia"]         //"1", "2", "3", "4", "5",
   let bannerTypesRange: UInt32 = UInt32(bannerTypes.count)
   let bannerTypesNumber = Int(arc4random_uniform(bannerTypesRange))
   let pickedBannerTypeRandom = bannerTypes[bannerTypesNumber]
   print("type of random notificationBanner", pickedBannerTypeRandom)

//MARK: ask for star review
    let reviewRandom = ["1", "2",]         //"1", "2", "3", "4", "5",
    let reviewRange: UInt32 = UInt32(reviewRandom.count)
    let reviewNumber = Int(arc4random_uniform(reviewRange))
    let pickedreviewRandom = reviewRandom[reviewNumber]
    print("reviewRandom", pickedreviewRandom)

   destination.reviewRandom = pickedreviewRandom
   destination.sendMainTypeString = pickRandom
   destination.popAdRandom = popAdRandom
   destination.pickedBannerRandom = pickedBannerRandom
   destination.pickedBannerTypeRandom = pickedBannerTypeRandom
   destination.perform(#selector(destination.showRandomNotifiction), with: nil, afterDelay: 0.2)

   }
            }
        
        if segue.identifier == "backToGame"{
            if let destination = segue.destination as? GameVC {
   
   destination.score = scoreNumber
   destination.fails = failsNumber
   destination.totalTime = timeNumber
   destination.seconds = 4
   destination.answer = ""
   destination.rewardUsed = "Used"
   destination.timerLabel.text = "Ingen stress!"
   destination.timerLabel.setSizeFont(sizeFont: 40)
            }
        }
        }//end of prepareforsegue
    
// MARK: GADRewardBasedVideoAdDelegate implementation
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didFailToLoadWithError error: Error) {
        adRequestInProgress = false
        print("Reward based video ad failed to load: \(error.localizedDescription)")
    }
    
    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        adRequestInProgress = false
        print("Reward based video ad is received.")
    }
    
    func rewardBasedVideoAdDidOpen(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Opened reward based video ad.")
    }
    
    func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad started playing.")
    }
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad is closed.")
    }
    
    func rewardBasedVideoAdWillLeaveApplication(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad will leave application.")
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
        print("Reward received with currency")
        performSegue(withIdentifier: "backToGame", sender: self)
    }
    
    func loadRewardAd() {
        if !adRequestInProgress && rewardBasedVideo?.isReady == false {
            //rewardBasedVideo?.load(GADRequest(), withAdUnitID: "ca-app-pub-5276944768850449/9547221816")
            adRequestInProgress = true
            let request = GADRequest()
            GADRewardBasedVideoAd.sharedInstance().load(request, withAdUnitID: "ca-app-pub-3940256099942544/1712485313")
            print("loaded reward Ad")  // test ID ca-app-pub-3940256099942544/1712485313
        }
        
        if rewardBasedVideo?.isReady == true {
            //show button
            animateRewardButton()
            rewardButton.isEnabled = true
            print("reward already loaded from previous view")
        
        }
        
    } //End OF REWARD VIDEO
    
    @IBAction func rewardAdBtnTapped(_ sender: Any) {
        
        let alertController = YBAlertController(style: .ActionSheet)
        
        // watch ad
        alertController.addButton(icon: UIImage(named: "ad video"), title: "Se en reklamvideo (≈30 sec)") {
            print("reward video touched")
            
if self.rewardBasedVideo?.isReady == true {
   self.rewardBasedVideo?.present(fromRootViewController: self)
} else {
   let noController = UIAlertController(title: "Misslyckande", message: "Videon lyckades inte ladda klart. Kontrollera din internetanslutning och försök igen nästa gång.", preferredStyle: .alert)
   noController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
   self.present(noController, animated: true, completion: nil)
            }
        }
        
        // in app purchase
        /*alertController.addButton(icon: UIImage(named: "money"), title: "Köp ett extra liv") {
            print("in app purchase")
         }*/ //TODO: ADD IN BETA VERSION
        
        // rate in app store
        if (!defaults.bool(forKey: "Review Not Done")){
            print("User has not reviewed it")
            alertController.addButton(icon: UIImage(named: "app store"), title: "Betygsätt Sverigespelet") {
   print("5-star review")
       //ask for review
   if #available(iOS 10.3, *) {
       // use the feature only available in iOS 10.3 and later
       SKStoreReviewController.requestReview()
   } else {
       // rate in app store
       EggRating.delegate = self
       EggRating.promptRateUs(viewController: self)
   }
            }
        }
        
        //ask for facebook follow
        if (!defaults.bool(forKey: "Facebook Not Done")){
            print("User has not followed facebook it")
            alertController.addButton(icon: UIImage(named: "facebook"), title: "Gilla oss på Facebook") {
   print("Facebook follow")
   
   let instaController = UIAlertController(title: "", message: "", preferredStyle: .alert)
   let TitleattributedString = NSAttributedString(string: "Likea oss på Facebook", attributes: [
       NSAttributedStringKey.font : UIFont(name: "Helvetica-Bold", size: 24)!,
       NSAttributedStringKey.foregroundColor : UIColor.black
       ])
   let MessageattributedString = NSAttributedString(string: "Du kommer att skickas till vår Facebook sida som du kan gilla (tar ca 10 sekunder). Återvänd sedan till Sverigespelet.", attributes: [
       NSAttributedStringKey.font : UIFont(name: "Helvetica-Bold", size: 20)!,
       NSAttributedStringKey.foregroundColor : UIColor.darkGray
       ])
   
   instaController.setValue(TitleattributedString, forKey: "attributedTitle")
   instaController.setValue(MessageattributedString, forKey: "attributedMessage")
   
   let action = UIAlertAction(title: "OK", style: .default, handler: { (_) in
       let urlString = NSURL(string: "fb://profile/1155761444456364")!
    
       if UIApplication.shared.canOpenURL(urlString as URL){
        
           UIApplication.shared.openURL(urlString as URL)
           self.defaults.set(true , forKey: "Facebook Not Done")
           self.performSegue(withIdentifier: "backToGame", sender: self)
        
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
        }
        
        //ask for instagram follow
        if (!defaults.bool(forKey: "Instagram Not Done")){
            print("User has not followed instagram it")
            alertController.addButton(icon: UIImage(named: "instagram"), title: "Följ oss på Instagram") {
   print("Instagram follow")
    
   let instaController = UIAlertController(title: "", message: "", preferredStyle: .alert)
   let TitleattributedString = NSAttributedString(string: "Följ oss på Instagram", attributes: [
       NSAttributedStringKey.font : UIFont(name: "Helvetica-Bold", size: 24)!,
       NSAttributedStringKey.foregroundColor : UIColor.black
       ])
   let MessageattributedString = NSAttributedString(string: "Du kommer att skickas till vår Instagram profil där du kan följa oss (tar ca 10 sekunder). Återvänd sedan till Sverigespelet.", attributes: [
       NSAttributedStringKey.font : UIFont(name: "Helvetica-Bold", size: 20)!,
       NSAttributedStringKey.foregroundColor : UIColor.darkGray
       ])
   
   instaController.setValue(TitleattributedString, forKey: "attributedTitle")
   instaController.setValue(MessageattributedString, forKey: "attributedMessage")
   
   let action = UIAlertAction(title: "OK", style: .default, handler: { (_) in
       let urlString = NSURL(string: "instagram://user?username=sverigespelet")!
    
       if UIApplication.shared.canOpenURL(urlString as URL){
        
           UIApplication.shared.openURL(urlString as URL)
           self.defaults.set(true , forKey: "Instagram Not Done")
           self.performSegue(withIdentifier: "backToGame", sender: self)
        
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
        }
        
        //ask for twitter follow
        if (!defaults.bool(forKey: "Twitter Not Done")){
            print("User has not followed twitter it")
            alertController.addButton(icon: UIImage(named: "twitter"), title: "Följ oss på Twitter") {
   print("Twitter follow")
   
   let instaController = UIAlertController(title: "", message: "", preferredStyle: .alert)
   let TitleattributedString = NSAttributedString(string: "Följ oss på Twitter", attributes: [
       NSAttributedStringKey.font : UIFont(name: "Helvetica-Bold", size: 24)!,
       NSAttributedStringKey.foregroundColor : UIColor.black
       ])
   let MessageattributedString = NSAttributedString(string: "Du kommer att skickas till vår Twitter profil där du kan följa oss (tar ca 10 sekunder). Återvänd sedan till Sverigespelet.", attributes: [
       NSAttributedStringKey.font : UIFont(name: "Helvetica-Bold", size: 20)!,
       NSAttributedStringKey.foregroundColor : UIColor.darkGray
       ])
   
   instaController.setValue(TitleattributedString, forKey: "attributedTitle")
   instaController.setValue(MessageattributedString, forKey: "attributedMessage")
   
   let action = UIAlertAction(title: "OK", style: .default, handler: { (_) in
       let urlString = NSURL(string: "twitter:///user?screen_name=sverigespelet")!
    
       if UIApplication.shared.canOpenURL(urlString as URL){
        
           UIApplication.shared.openURL(urlString as URL)
           self.defaults.set(true , forKey: "Twitter Not Done")
           self.performSegue(withIdentifier: "backToGame", sender: self)
        
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
        }
        //ask for snapchat follow
        if (!defaults.bool(forKey: "Snapchat Not Done")){
            print("User has not followed snapchat yet")
            alertController.addButton(icon: UIImage(named: "Snapchat"), title: "Lägg till oss på Snapchat") {
   print("snapchat follow")
   
   let instaController = UIAlertController(title: "", message: "", preferredStyle: .alert)
   let TitleattributedString = NSAttributedString(string: "Följ oss på Snapchat", attributes: [
       NSAttributedStringKey.font : UIFont(name: "Helvetica-Bold", size: 24)!,
       NSAttributedStringKey.foregroundColor : UIColor.black
       ])
   let MessageattributedString = NSAttributedString(string: "Du kommer att skickas till vår Snapchat där du kan följa oss (tar ca 10 sekunder). Tack!", attributes: [
       NSAttributedStringKey.font : UIFont(name: "Helvetica-Regular", size: 20)!,
       NSAttributedStringKey.foregroundColor : UIColor.darkGray
       ])
   
   instaController.setValue(TitleattributedString, forKey: "attributedTitle")
   instaController.setValue(MessageattributedString, forKey: "attributedMessage")
   
   let action = UIAlertAction(title: "OK", style: .default, handler: { (_) in
       let urlString = NSURL(string: "https://www.snapchat.com/add/sverigespelet")!
    
       if UIApplication.shared.canOpenURL(urlString as URL){
        
           UIApplication.shared.openURL(urlString as URL)
           self.defaults.set(true , forKey: "Snapchat Not Done")
           self.performSegue(withIdentifier: "backToGame", sender: self)
        
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
        }
    
        alertController.touchingOutsideDismiss = false
        alertController.cancelButtonTitle = "Avbryt"
        alertController.title = "Välj en"
        alertController.show()
    }
    
    func animateRewardButton() {
        rewardButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        UIView.animate(withDuration: rewardDuration,
          delay: 0,
          usingSpringWithDamping: CGFloat(rewardDamping),
          initialSpringVelocity: CGFloat(rewardVelocity),
          options: .allowUserInteraction,
          animations: {
           self.rewardButton.transform = .identity
        },
          completion: { finished in
           print("rewardbutton animation complete + begin timer animation")
           self.completeTimer = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: (#selector(EndMenuVC.noRewardButton)), userInfo: nil, repeats: false)
           self.perform(#selector(self.showRandomNotifiction), with: nil, afterDelay: 0.2)
           
        }
        )
    }
    
    @objc func noRewardButton() {
        print("rewardbutton disappeard -> show the rest of buttons")
        rewardButton.isEnabled = false
        rewardButton.imageView?.stopAnimating()
        rewardButton.setImage(animationImages.last, for: .normal)
        self.shareButton.isHidden = false
        self.leaderboardButton.isHidden = false
        self.buttonsView.isHidden = false

    }
    
//share bubbles
    @IBAction func shareBtnTapped(_ sender: Any) {
        bubbles?.show()
    }
    
//leaderboard / facebook login
    @IBAction func leaderboardBtnTapped(_ sender: Any) {
        
        handleCustomFacebookLogin()
        
       
        
    }
    
    // SwiftShareBubblesDelegate
    func bubblesTapped(bubbles: SwiftShareBubbles, bubbleId: Int) {
        
        if let bubble = Bubble(rawValue: bubbleId) {
            print("\(bubble)")
            switch bubble {
            case .facebook:
   let urlString = NSURL(string: "fb://fb")!
   
   if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
       guard let composer = SLComposeViewController(forServiceType: SLServiceTypeFacebook) else { return }
       composer.setInitialText("Ladda ner Sverigespelet och försök slå mina \(scoreNumber) sverigepoäng😉🇸🇪!")
       composer.add(URL(string: "sverigespelet.co"))
       present(composer, animated: true, completion: nil)
   } else if UIApplication.shared.canOpenURL(urlString as URL){
    
       UIApplication.shared.openURL(urlString as URL)
    
   } else {
       //redirect to safari because the user doesn't have facebook
       UIApplication.shared.openURL(NSURL(string: "http://facebook.com/")! as URL)
   }
   
   break
            case .twitter:
   let urlString = NSURL(string: "twitter://post?message=#")!
   
   if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
       guard let composer = SLComposeViewController(forServiceType: SLServiceTypeTwitter) else { return }
       composer.setInitialText("Ladda ner Sverigespelet och försök slå mina \(scoreNumber) sverigepoäng😉🇸🇪!")
       composer.add(URL(string: "sverigespelet.co"))
       present(composer, animated: true, completion: nil)
   } else if UIApplication.shared.canOpenURL(urlString as URL){
    
       UIApplication.shared.openURL(urlString as URL)
    
   } else {
       //redirect to safari because the user doesn't have facebook
       UIApplication.shared.openURL(NSURL(string: "http://twitter.com/")! as URL)
   }
   
   break
            case .instagram:
   
   let urlString = NSURL(string: "instagram://app)")!
   
   if UIApplication.shared.canOpenURL(urlString as URL){
    
       UIApplication.shared.openURL(urlString as URL)
    
   } else {
       //redirect to safari because the user doesn't have facebook
       UIApplication.shared.openURL(NSURL(string: "http://instagram.com/")! as URL)
   }
   break
            case .whatsapp:
   //whatsApp
   let msg = "Ladda ner Sverigespelet och försök slå mina \(scoreNumber) sverigepoäng😉🇸🇪!"
   let urlStringEncoded = msg.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
   let urlString  = NSURL(string: "whatsapp://send?text=\(urlStringEncoded!)")
   
   if UIApplication.shared.canOpenURL(urlString! as URL) {
       UIApplication.shared.openURL(urlString! as URL)
    
   } else {
       //redirect to safari because the user doesn't have facebook
       UIApplication.shared.openURL(NSURL(string: "http://whatsapp.com/")! as URL)
   }
   break
            default:
   break
            }
        } else {
            //custom case
            if mailID == bubbleId {
   //mail
   if MFMailComposeViewController.canSendMail() {
       let mailcontroller = MFMailComposeViewController()
       mailcontroller.mailComposeDelegate = self;
       mailcontroller.setSubject("Kolla vad jag fick på Sverigespelet!")
       mailcontroller.setMessageBody("<html><body><p>Ladda ner Sverigespelet och försök slå mina \(scoreNumber) sverigepoäng😉🇸🇪!</p></body></html>", isHTML: true)
    
       self.present(mailcontroller, animated: true, completion: nil)
    
   } else {
    
       let sendMailErrorAlert = UIAlertController(title:  "Kunde inte skicka mailet", message: "Din telefon kunde inte skicka e-mailet. Var god och kontrollera din e-mail app och försök igen.", preferredStyle: .alert)
       let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
       sendMailErrorAlert.addAction(ok)
    
       self.present(sendMailErrorAlert, animated: true, completion: nil)
   }
   
   
            } else if messengerID == bubbleId {
   //messenger
   let urlString = NSURL(string: "fb-messenger://compose")!
   
   if UIApplication.shared.canOpenURL(urlString as URL)
   {
       UIApplication.shared.openURL(urlString as URL)
    
   } else {
       //redirect to safari because the user doesn't have facebook
       UIApplication.shared.openURL(NSURL(string: "http://facebook.com/")! as URL)
   }
   
   
            } else if imessageID == bubbleId {
   //iMessage
   if (MFMessageComposeViewController.canSendText()) {
       let controller = MFMessageComposeViewController()
       controller.messageComposeDelegate = self
       controller.body = "Ladda ner Sverigespelet och försök slå mina \(scoreNumber) sverigepoäng😉🇸🇪!"
    
       self.present(controller, animated: true, completion: nil)
    
   } else {
    
       let sendMessageErrorAlert = UIAlertController(title:  "Kunde inte skicka meddelandet", message: "Din telefon kunde inte skicka meddelandet. Var god och kontrollera din iMessage app och försök igen.", preferredStyle: .alert)
       let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
       sendMessageErrorAlert.addAction(ok)
    
       self.present(sendMessageErrorAlert, animated: true, completion: nil)
   }
   
            }
        }
    }
    
    func bubblesDidHide(bubbles: SwiftShareBubbles) {}
    
//end of share bubbles
    
    //dismiss mail controller
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //dismiss imessage controller
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
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
    
    func handleCustomFacebookLogin() { //FREDRIK
        if(FBSDKAccessToken.current() != nil){
            
            FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start {(connection, result, error) in
                
                if error != nil{
                    print("Failed to start facebook graph request", error as Any)
                    return
                }
                
                let res = result as! NSDictionary
 
                
                LeaderboardVC.updateScore(score: self.scoreNumber,id:res.object(forKey: "id") as! String)
                LeaderboardVC.setName(name: res.object(forKey: "name") as! String, id:res.object(forKey: "id") as! String)
                
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "leaderBoardId")
                self.present(vc, animated: true, completion: nil)
                
                print(result!) //print out the different crediters of the user
            }

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
    
    func grabEmailAddress() { //FREDRIK
        
        //send to firebase"
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
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "leaderBoardId")
            self.present(vc, animated: true, completion: nil)
            
            print(result!) //print out the different crediters of the user
        }
        
    }
    //END OF FACEBOOK LOGIN
    
    //random notification banner
    @objc func showRandomNotifiction() {
        if (pickedBannerRandom == "1") {
            print("going to show notificationBanner")
        
            if (pickedBannerTypeRandom == "ourStory") {
   //show notificationBanner
   print("ourStory notificationBanner shown")
   notificationBannerTitle = "Nyfiken på vår historia?"
   notificationBannerSubtitle = "Klicka för att läsa den!"
   //default design of notificationBanner
   let notificationBanner = NotificationBanner(title: notificationBannerTitle, subtitle: notificationBannerSubtitle, leftView: leftView, style: .info)
   notificationBanner.backgroundColor = UIColor().SwedenYellow()
   notificationBanner.titleLabel?.textColor = UIColor().SwedenBlue()
   notificationBanner.subtitleLabel?.textColor = UIColor().SwedenBlue()
   notificationBanner.onTap = {
       print("ourStory notificationBanner tapped")
       self.performSegue(withIdentifier: "EndToLucas", sender: UIButton())
   }
   //show notificationBanner
   notificationBanner.show()
            } else if (pickedBannerTypeRandom == "review") {
   //show notificationBanner
   print("review notificationBanner shown")
   notificationBannerTitle = "Kan du hjälpa oss växa?"
   notificationBannerSubtitle = "Betygsätt oss på App Store!"
   //default design of notificationBanner
   let notificationBanner = NotificationBanner(title: notificationBannerTitle, subtitle: notificationBannerSubtitle, leftView: leftView, style: .info)
   notificationBanner.backgroundColor = UIColor().SwedenYellow()
   notificationBanner.titleLabel?.textColor = UIColor().SwedenBlue()
   notificationBanner.subtitleLabel?.textColor = UIColor().SwedenBlue()
   notificationBanner.onTap = {
       print("review notificationBanner tapped")
       // rate in app store
       if #available(iOS 10.3, *) {
           // use the feature only available in iOS 10.3 and later
           SKStoreReviewController.requestReview()
       } else {
           // rate in app store
           EggRating.delegate = self
           EggRating.promptRateUs(viewController: self)
       }
   }
   //show notificationBanner
   notificationBanner.show()
            } else if (pickedBannerTypeRandom == "socialMedia") {
   //show notificationBanner
   print("socialMedia notificationBanner shown")
   notificationBannerTitle = "Joina oss online!"
   notificationBannerSubtitle = "Klicka för att följa oss på sociala medier."
   //default design of notificationBanner
   let notificationBanner = NotificationBanner(title: notificationBannerTitle, subtitle: notificationBannerSubtitle, leftView: leftView, style: .info)
   notificationBanner.backgroundColor = UIColor().SwedenYellow()
   notificationBanner.titleLabel?.textColor = UIColor().SwedenBlue()
   notificationBanner.subtitleLabel?.textColor = UIColor().SwedenBlue()
   notificationBanner.onTap = {
       print("review notificationBanner tapped")
    
       //create alertcontroller with follow options
       let alertController = YBAlertController(style: .ActionSheet)
    
       //ask for facebook follow
       alertController.addButton(icon: UIImage(named: "facebook"), title: "Gilla oss på Facebook") {
           print("Facebook follow")
        
           let instaController = UIAlertController(title: "", message: "", preferredStyle: .alert)
           let TitleattributedString = NSAttributedString(string: "Likea oss på Facebook", attributes: [
  NSAttributedStringKey.font : UIFont(name: "Helvetica-Bold", size: 24)!,
  NSAttributedStringKey.foregroundColor : UIColor.black
  ])
           let MessageattributedString = NSAttributedString(string: "Du kommer att skickas till vår Facebook sida som du kan gilla (tar ca 10 sekunder). Tack!", attributes: [
  NSAttributedStringKey.font : UIFont(name: "Helvetica-Regular", size: 20)!,
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
  NSAttributedStringKey.font : UIFont(name: "Helvetica-Bold", size: 24)!,
  NSAttributedStringKey.foregroundColor : UIColor.black
  ])
           let MessageattributedString = NSAttributedString(string: "Du kommer att skickas till vår Snapchat där du kan följa oss (tar ca 10 sekunder). Tack!", attributes: [
  NSAttributedStringKey.font : UIFont(name: "Helvetica-Regular", size: 20)!,
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
       alertController.addButton(icon: UIImage(named: "instagram"), title: "Follow us on Instagram") {
           print("Instagram follow")
        
           let instaController = UIAlertController(title: "", message: "", preferredStyle: .alert)
           let TitleattributedString = NSAttributedString(string: "Följ oss på Instagram", attributes: [
  NSAttributedStringKey.font : UIFont(name: "Helvetica-Bold", size: 24)!,
  NSAttributedStringKey.foregroundColor : UIColor.black
  ])
           let MessageattributedString = NSAttributedString(string: "Du kommer att skickas till vår Instagram profil där du kan följa oss (tar ca 10 sekunder). Tack!", attributes: [
  NSAttributedStringKey.font : UIFont(name: "Helvetica-Regular", size: 20)!,
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
       alertController.addButton(icon: UIImage(named: "twitter"), title: "Follow us on Twitter") {
           print("Twitter follow")
        
           let instaController = UIAlertController(title: "", message: "", preferredStyle: .alert)
           let TitleattributedString = NSAttributedString(string: "Följ oss på Twitter", attributes: [
  NSAttributedStringKey.font : UIFont(name: "Helvetica-Bold", size: 24)!,
  NSAttributedStringKey.foregroundColor : UIColor.black
  ])
           let MessageattributedString = NSAttributedString(string: "Du kommer att skickas till vår Twitter profil där du kan följa oss (tar ca 10 sekunder). Tack!", attributes: [
  NSAttributedStringKey.font : UIFont(name: "Helvetica-Regular", size: 20)!,
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
       }  //end of "följ oss på sociala medier"
   //show notificationBanner
   notificationBanner.show()
            
            } else if (pickedBannerTypeRandom == "goodScore") && scoreNumber >= 29 {
   //show notificationBanner
   print("goodScore notificationBanner shown")
   notificationBannerTitle = "WOW! Dags att skryta? 😉"
   notificationBannerSubtitle = "Klicka för att dela dina poäng!"
   //default design of notificationBanner
   let notificationBanner = NotificationBanner(title: notificationBannerTitle, subtitle: notificationBannerSubtitle, leftView: leftView, style: .info)
   notificationBanner.backgroundColor = UIColor().SwedenYellow()
   notificationBanner.titleLabel?.textColor = UIColor().SwedenBlue()
   notificationBanner.subtitleLabel?.textColor = UIColor().SwedenBlue()
   notificationBanner.onTap = {
       print("goodScore notificationBanner tapped")
       self.bubbles?.show()
   }
   //show notificationBanner
   notificationBanner.show()
            } else {
   print("no random notificationBanner was shown")
            }

        }//end of first if-statement
        //end of Randomize notificationBanner informing of ___
    }
    
    @IBAction func infoButtonTapped(_ sender: Any) {
        //info about how to complete the former level which the player failed at
        let alertController = YBAlertController(style: .Alert)

            //all different game types and with specifikation within level
        //"Images", "Game Art", "Orientation Change", "Button Pattern", "Button Tap",  "Button Quick", "Pan Gesture", "KYC", "Core Motion", "Find hidden", "Doesn't fit", "End sentence", "Long Press", "Multiple Tap Button", "Image Collide",  "Swipe Left", "Swipe Gesture", "Swipe Down", "Don't Press", "Blow in Mic"
        if formerMainTypeString == "Images" {
            print("formerMainTypeString = Images")
            if formerSpecialTypeString == "Celebs" {
                alertController.message = "Vem är Zlatan eller Zara Larsson? Tryck på rätt bild!"
            } else if formerSpecialTypeString == "Random" {
                alertController.message = "Vilken logga tillhör Spotify eller vad är Ludvika? Tryck på det rätta svaret!"
            }
        } else if formerMainTypeString == "Game Art" {
            print("formerMainTypeString = Game Art")
            alertController.message = "Vart är Jultomten eller Bamse? Hitta den rätta!"
        } else if formerMainTypeString == "Orientation Change" {
            print("formerMainTypeString = Orientation Change")
            alertController.message = "Rotera 📱 180 grader. OBS! Kontrollera att att skärmlåset INTE är på."
        } else if formerMainTypeString == "Button Pattern" {
            print("formerMainTypeString = Button Pattern")
            alertController.message = "Allt har sin ordning😉! T.ex. 🇸🇪 ▶︎ ⛄️ ▶︎ 🐝 ▶︎ 🚙 = ✅ och 🇸🇪 ▶︎ ⛄️ ▶︎ 🚙 ▶︎ 🐝 = ❌"
        } else if formerMainTypeString == "Button Tap" {
            print("formerMainTypeString = Button Tap")
            alertController.message = "Besegra norrmannen🇳🇴 eller dansken🇩🇰 genom att klicka på skärmen flera gånger!"
        } else if formerMainTypeString == "Button Quick" {
            print("formerMainTypeString = Button Quick")
            alertController.message = "När du trycker så ändrar knappen färg i en halvsekund - skynda dig och få alla knappar att ändra färg samtidigt🎨"
        } else if formerMainTypeString == "Pan Gesture" {
            print("formerMainTypeString = Pan Gesture")
            alertController.message = "Vilket håll pekas det då ☝️👈👉👇? Swipea åt det hållet!"
        } else if formerMainTypeString == "KYC" {
            print("formerMainTypeString = KYC")
            alertController.message = "Öka hastigheten 🖍 genom att trycka på knappen🏎 Få upp en tillräcklig hastighet så att 🇸🇪-flaggan skapas!"
        } else if formerMainTypeString == "Core Motion" {
            print("formerMainTypeString = Core Motion")
            alertController.message = "Få bort ohyran 🐝 genom att skaka telefonen kraftigt åt vänster 👈"
        } else if formerMainTypeString == "Find hidden" {
            print("formerMainTypeString = Find hidden")
            alertController.message = "Vart gömmer sig de svenska färgerna 🇸🇪? Knapparna ändrar färg snabbt så du måste vara vaksam🧐"
        } else if formerMainTypeString == "Doesn't fit" {
            print("formerMainTypeString = Doesn't fit")
            alertController.message = "Vad passar INTE in? Vilken ska bort av de fyra alternativen?🇸🇪"
        } else if formerMainTypeString == "End sentence" {
            print("formerMainTypeString = End sentence")
            alertController.message = "\"Nära skjuter ingen...\" eller vart föddes Zlatan? ❔ Tryck på det rätta svaret för att avsluta meningen."
        } else if formerMainTypeString == "Long Press" {
            print("formerMainTypeString = Long Press")
            if formerSpecialTypeString == "midsommarstang" {
                alertController.message = "Man kan ju inte släppa taget om en midsommarstång! Håll in \" RES💪 \"-knappen och släpp inte taget."
            } else {
                alertController.message = "Man kan ju inte ge upp på ett IKEA-bygge trots hur frustrerande de kan vara! Håll in \" BYGG🔨 \"-knappen och släpp inte taget."
            }
        } else if formerMainTypeString == "Multiple Tap Button" {
            print("formerMainTypeString = Multiple Tap Button")
            if formerSpecialTypeString == "midsommar" {
                alertController.message = "Dansa små grodorna 🐸 genom att trycka på grodan."
            } else if formerSpecialTypeString == "skiing"{
                alertController.message = "Åk de sista metrarna ⛷ och vinn 🥇 för 🇸🇪 genom att trycka på skidåkaren."
            } else if formerSpecialTypeString == "snow"{
                alertController.message = "Skotta snö 🌨 genom att trycka på snöskottaren."
            }
        } else if formerMainTypeString == "Swipe Left" {
            print("formerMainTypeString = Swipe Left")
            alertController.message = "Kläm ut Kalles kaviare eller messmör genom att swipea åt rätt håll👈👉"
        } else if formerMainTypeString == "Swipe Gesture" {
            print("formerMainTypeString = Swipe Gesture")
            alertController.message = "Skär tårtbitarna 🍰 genom att swipea kniven👇"
        } else if formerMainTypeString == "Swipe Down" {
            print("formerMainTypeString = Swipe Down")
            if formerSpecialTypeString == "ost" {
                alertController.message = "Hyvla osten 🧀 genom swipea 👇"
            } else if formerSpecialTypeString == "hissaIda" {
                alertController.message = "Hjälp Emil med att hissa upp Ida i flaggstången genom att swipea 👇"
            }
        } else if formerMainTypeString == "Don't Press" {
            print("formerMainTypeString = Don't Press")
            alertController.message = "Instruktionerna är tydliga - tryck INTE på knappen🇸🇪"
        } else if formerMainTypeString == "Image Collide" {
            print("formerMainTypeString = Image Collide")
            if formerSpecialTypeString == "horse" {
                alertController.message = "Ta tag i svansen och sätt den på Lilla Gubbens rätta ställe🐴"
            } else if formerSpecialTypeString == "zlatan" {
                alertController.message = "Hjälp Zlatan med att få tillbaka sin näsa👃"
            }
        } else if formerMainTypeString == "Blow in Mic" {
            print("formerMainTypeString = Blow in Mic")
            alertController.message = "Få den 🇸🇪-flaggan att fladdra genom att blåsa på skärmen💨"
        }
        
        alertController.messageLabel.textAlignment = .center
        alertController.cancelButtonTitle = "OK!😍"
        alertController.title = "\"Vad ska jag göra!?\""
        alertController.show()
    }//end of infoButtonTapped

}//end of class

//EggRating Delegate
extension EndMenuVC: EggRatingDelegate {
    
    func didRate(rating: Double) {
        print("didRate: \(rating)")
    }
    
    func didRateOnAppStore() {
        print("didRateOnAppStore")
        self.defaults.set(true , forKey: "Review Not Done")
        performSegue(withIdentifier: "backToGame", sender: self)
    }
    
    func didIgnoreToRate() {
        print("didIgnoreToRate")
    }
    
    func didIgnoreToRateOnAppStore() {
        print("didIgnoreToRateOnAppStore")
    }
}//end of eggrating delegate
