//
//  StartMenuVC.swift
//  fiveSeconds
//
//  Created by Lucas Otterling on 19/03/2017.
//  Copyright © 2017 Lucas Otterling. All rights reserved.
//

import UIKit
import AVFoundation
import GoogleMobileAds
import SwiftShareBubbles
import Social
import MessageUI
import StoreKit
import Pastel
import FBSDKLoginKit
import Firebase
import FirebaseAuth
import StoreKit
import EggRating
import NotificationBannerSwift

class StartMenuVC: UIViewController, GADBannerViewDelegate, GADInterstitialDelegate, SwiftShareBubblesDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver, FBSDKLoginButtonDelegate, UIPageViewControllerDataSource    {

    var sendMainTypeString = String()
    var mainTypeArray = ["Images", "Game Art", "Orientation Change", "Button Pattern", "Button Tap",  "Button Quick", "Pan Gesture", "KYC", "Core Motion", "Find hidden", "Doesn't fit", "End sentence", "Long Press", "Multiple Tap Button", "Image Collide",  "Swipe Left", "Swipe Gesture", "Swipe Down", "Don't Press", "Blow in Mic"]//"Images", "Game Art", "Orientation Change", "Button Pattern", "Button Tap",  "Button Quick", "Pan Gesture", "KYC", "Core Motion", "Find hidden", "Doesn't fit", "End sentence", "Long Press", "Multiple Tap Button", "Image Collide",  "Swipe Left", "Swipe Gesture", "Swipe Down", "Don't Press", "Blow in Mic"  //out-commented levels: "Numbers", "Add 1", "Run a lap"
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {}
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var menuButton: ActionMenuButton!
    @IBOutlet weak var startBtn: UIButton!
    //var microphoneStatusString = String()
    var interstitialAd : GADInterstitial = GADInterstitial(adUnitID: "ca-app-pub-5276944768850449/4376612618")
    var popAdRandom = String()
    var defaults = UserDefaults.standard
    var reviewRandom = String()
    var FBresult : Any?
    var res = NSDictionary() //Facebook result
//share bubbles
    var bubbles: SwiftShareBubbles?
    var mailID = 11
    var messengerID = 12
    var imessageID = 13
//in-app purchase
    var noAds_id: NSString?;
    var nodAdsProduct = SKProduct()
//notification banner
    var notificationBannerTitle = String()
    var notificationBannerSubtitle = String()
    var leftView = UIImageView(image: #imageLiteral(resourceName: "heart"))
    var pickedBannerRandom = String()
    var pickedBannerTypeRandom = String()
//pageviewcontroller
    var pageViewController: UIPageViewController!
    var pageImages: NSArray! //NSArray(objects: "More Offers 1", "More Offers 2")
    var pageType = String()

    //buttons set-up
    override func viewDidLayoutSubviews() {
        //round
        menuButton.layer.cornerRadius = 0.5 * menuButton.bounds.size.width
        startBtn.layer.cornerRadius = 0.5 * startBtn.bounds.size.width
        startBtn.setTitleColor(UIColor().SwedenYellow(), for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //MARK: Intro pageviewcontroller
        pageImages = NSArray(objects: "pageImage0", "pageImage1", "pageImage2", "pageImage3")
        self.pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageViewController") as! UIPageViewController
        self.pageViewController.dataSource = self
        let startVC = self.viewControllerAtIndex(index: 0) as! IntroViewController
        let viewcontrollers = NSArray(object: startVC)
        
        self.pageViewController.setViewControllers((viewcontrollers as! [UIViewController]), direction: .forward, animated: true, completion: nil)
        
        self.pageViewController.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.pageViewController.view.tintColor = UIColor().SwedenYellow()
        
        //self.addChildViewController(self.pageViewController)
        //self.view.addSubview(self.pageViewController.view) //this line shows the pageviewcontroller
        //self.pageViewController.didMove(toParentViewController: self)
        
        //Check if first time user opens the app
        if (!defaults.bool(forKey: "firstTime")){
            print("first time user opens the app")
            perform(#selector(showFirstTimeVC), with: nil, afterDelay: 0.1)
            defaults.set(true , forKey: "firstTime") //this removes the betaVC
        } else if (defaults.bool(forKey: "firstTime")){
            print("not first time the user opens the app")
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
 
        //check microphone status
       /* let microPhoneStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.audio)
        switch microPhoneStatus {
            
        case .authorized:
         print("Has microphone access")
         microphoneStatusString = "YES"
            
        case .denied, .restricted:
         print("No microphone access granted")
         let deadlineTime = DispatchTime.now() + .seconds(Int(0.1))
         DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            let alert = UIAlertController(title: "Godkänn mikrofonen", message: "För att alla banor ska fungera så måste appen ha tillstånd att använda mikrofonen. Gå till Inställningar ➡️ Integritetsskydd ➡️ Mikrofon ➡️ slå på för Sverigespelet.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
         })
            
        microphoneStatusString = "NO"
        mainTypeArray.removeLast() //the positon of "blow in mic"
            
        case .notDetermined:
            print("Didn't request microphone access yet")
            AVAudioSession.sharedInstance().requestRecordPermission () {
                [unowned self] allowed in
                if allowed {
                    // Microphone allowed, do what you like!
                    self.microphoneStatusString = "YES"
                    print(self.microphoneStatusString, "microphone status")
                    
                } else {
                    // User denied microphone. Tell them off!
                    self.microphoneStatusString = "NO"
                    print(self.microphoneStatusString, "microphone status")
                    self.mainTypeArray.removeLast() //the positon of "blow in mic"

                }}
        }
        print(microphoneStatusString, "microphone status")*/
        print(mainTypeArray, "array")
        
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
            
            interstitialAd = createAndLoadInterstitial()

        }
        
        //Randomizing the game type
        let range: UInt32 = UInt32(mainTypeArray.count)
        let randomNumber = Int(arc4random_uniform(range))
        let pickRandom = mainTypeArray[randomNumber]
        sendMainTypeString = pickRandom
        print("sendTypeString =", sendMainTypeString)
 
        //MARK: Menu buttons
        //settings
        let settings = MenuButton(withRadius: 35){ () -> (Void) in
                print("settings")
                self.performSegue(withIdentifier: "MenuToSettings", sender: UIButton())
            }
        settings.setImage(UIImage(named: "settings"), for: .normal)
        settings.backgroundColor = UIColor().SwedenBlue()
        
        /*
        "icon_home", UIColor(red:0.19, green:0.57, blue:1, alpha:1)),
        ("icon_search", UIColor(red:0.22, green:0.74, blue:0, alpha:1)),
        ("notifications-btn", UIColor(red:0.96, green:0.23, blue:0.21, alpha:1)),
        ("settings-btn", UIColor(red:0.51, green:0.15, blue:1, alpha:1)),
        ("nearby-btn", UIColor(red:1, green:0.39, blue:0, alpha:1)),*/
        
        //leaderboard button / FACEBOOK LOGIN //FREDRIK
        let leaderboard = MenuButton(withRadius: 35){ () -> (Void) in
            print("leaderboard/facebook")
            self.handleCustomFacebookLogin()
            self.refreshNotif()
        }
        leaderboard.setImage(UIImage(named: "leaderboard"), for: .normal)
        leaderboard.backgroundColor = UIColor().SwedenBlue()
        
        /* CREATES BASIC FACEBOOK LOGIN BUTTON
        let loginTest = FBSDKLoginButton()
        view.addSubview(loginTest)
        loginTest.frame = CGRect(x: 10, y: 10, width: 100, height: 40)
        loginTest.delegate = self
        loginTest.readPermissions = ["email", "public_profile"] //decide what info we should read + the basic idea/name 
         */
        
        //share
        let share = MenuButton(withRadius: 35){ () -> (Void) in
            print("share")
            self.bubbles?.show()
        }
        share.setImage(UIImage(named: "share"), for: .normal)
        share.backgroundColor = UIColor().SwedenBlue()
        
        //share bubbles
        bubbles = SwiftShareBubbles(point: CGPoint(x: view.frame.width / 2, y: view.frame.height / 2), radius: 150, in: view)
        bubbles?.showBubbleTypes = [Bubble.twitter, Bubble.facebook, Bubble.whatsapp, Bubble.instagram]
        bubbles?.delegate = self
        
        let mailAttribute = ShareAttirbute(bubbleId: mailID, icon: UIImage(named: "Mail")!, backgroundColor: UIColor(red:0.19, green:0.81, blue:1.00, alpha:1.0))
        let messengerAttribute = ShareAttirbute(bubbleId: messengerID, icon: UIImage(named: "Messenger")!, backgroundColor: UIColor(red:0.19, green:0.42, blue:1.00, alpha:1.0))
        let imessageAttribute = ShareAttirbute(bubbleId: imessageID, icon: UIImage(named: "iMessage")!, backgroundColor: UIColor(red:0.15, green:0.94, blue:0.09, alpha:1.0))
        
        bubbles?.customBubbleAttributes = [mailAttribute, messengerAttribute, imessageAttribute]
        
        //no ads
        let noAds = MenuButton(withRadius: 35){ () -> (Void) in
            print("Remove ads button tapped")
            if (self.defaults.bool(forKey: "AdFreePurchased")){
                print("already removed ads")
                let alert = UIAlertController(title: "Tack! Har du 3 sekunder över?", message: "Du har redan stöttat oss direkt och tagit bort reklamen - tack! Har du 3 sekunder över för att ge oss ett omdöme på App Store? (Det hjälper oss otroligt mycket).", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Nej", style: UIAlertActionStyle.default, handler: nil))
                alert.addAction(UIAlertAction(title: "Självklart!", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in ratingEgg()}))
                self.present(alert, animated: true, completion: nil)
                
                func ratingEgg() {
                if #available(iOS 10.3, *) {
                    // use the feature only available in iOS 10.3 and later
                    SKStoreReviewController.requestReview()
                } else {
                        // rate in app store
                        EggRating.delegate = self
                    EggRating.promptRateUs(in: self)
                    }
                }
                
            } else {
                print("not remove ads yet")
                self.unlockAction()
            }
        }
        noAds.setImage(UIImage(named: "no ads"), for: .normal)
        noAds.backgroundColor = UIColor().SwedenBlue()
        
        menuButton.add(menuButton: settings)
        menuButton.add(menuButton: leaderboard)
        menuButton.add(menuButton: share)
        menuButton.add(menuButton: noAds)
        
        //MARK: Randomize notificationBanner informing of ___
        let bannerRandom = ["1", "2", "3", ]         //"1", "2", "3", "4", "5",
        let bannerRange: UInt32 = UInt32(bannerRandom.count)
        let bannerNumber = Int(arc4random_uniform(bannerRange))
        pickedBannerRandom = bannerRandom[bannerNumber]
        print("notificationBannerRandom", pickedBannerRandom)
        
        //Another randomization deciding which banner to show
        let bannerTypes = ["noAds", "ourStory", "loginFB", "review", "socialMedia"]         //"1", "2", "3", "4", "5",
        let bannerTypesRange: UInt32 = UInt32(bannerTypes.count)
        let bannerTypesNumber = Int(arc4random_uniform(bannerTypesRange))
        pickedBannerTypeRandom = bannerTypes[bannerTypesNumber]
        print("type of random notificationBanner", pickedBannerTypeRandom)
        
        perform(#selector(showRandomNotifiction), with: nil, afterDelay: 0.5)
        
        if (reviewRandom == "1") && (pickedBannerRandom != "1") && (popAdRandom != "1") {
            // rate in app store
            if #available(iOS 10.3, *) {
                // use the feature only available in iOS 10.3 and later
                SKStoreReviewController.requestReview()
            } else {
                // rate in app store
                EggRating.delegate = self
                EggRating.promptRateUs(in: self)
            }
        }

    }//end of viewdidload
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MenuToGame" {
            if let destination = segue.destination as? GameVC {
                
                destination.mainTypeString = sendMainTypeString
                //destination.microphoneStatusString = microphoneStatusString
                
            }
        }
    }//end of prepareforsegue

    @IBAction func menuButtonPressed(_ sender: AnyObject) {
        menuButton.toggleMenu()
    }
    
    //MARK: interstitialAd
    func createAndLoadInterstitial() -> GADInterstitial {
        
        let interstitialAd = GADInterstitial(adUnitID: "ca-app-pub-5276944768850449/4376612618")
        interstitialAd.delegate = self
        interstitialAd.load(GADRequest())
        return interstitialAd
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        self.interstitialAd = createAndLoadInterstitial()
        print("new interstital loaded")
        
        notificationBannerTitle = "Trött på reklam?"
        notificationBannerSubtitle = "Klicka för att stötta oss direkt istället!"
        //show notificationBanner
        let notificationBanner = NotificationBanner(title: notificationBannerTitle, subtitle: notificationBannerSubtitle, leftView: leftView, style: .info)
        notificationBanner.backgroundColor = UIColor().SwedenYellow()
        notificationBanner.titleLabel?.textColor = UIColor().SwedenBlue()
        notificationBanner.subtitleLabel?.textColor = UIColor().SwedenBlue()
        notificationBanner.onTap = {
            print("after popad notificationBanner tapped")
            self.unlockAction()
        }
        notificationBanner.show()
        //end of show notificationBanner
        
       /* do {
            // This is to unduck others, make other playing sounds go back up in volume
            try AVAudioSession.sharedInstance().setActive(false)
        } catch {
            print("Failed to set AVAudioSession inactive. error=\(error)")
        }*/
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Google Interstitial on return to startmenu
        if (popAdRandom == "1") {
            if self.interstitialAd.isReady {
                
                print("interstitialAd is ready")
                self.interstitialAd.present(fromRootViewController: self)
                
            } else if self.interstitialAd.isReady == false {
                
                let deadlineTime = DispatchTime.now() + .seconds(1)
                DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
                    print("interstitialAd is loading late")
                    self.interstitialAd.present(fromRootViewController: self)
                })
                
            } else {
                
                print("interstitialAd not loaded")
                
            }
        }//end of if statement
    }//end of viewdidappear + interstitialad
    
    // SwiftShareBubblesDelegate
    func bubblesTapped(bubbles: SwiftShareBubbles, bubbleId: Int) {
        
        if let bubble = Bubble(rawValue: bubbleId) {
            print("\(bubble)")
            switch bubble {
            case .facebook:
                let urlString = NSURL(string: "fb://fb")!
                
                if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
                    guard let composer = SLComposeViewController(forServiceType: SLServiceTypeFacebook) else { return }
                    composer.setInitialText("Ladda ner Sverigespelet och försök slå mitt rekord på sverigepoäng😉🇸🇪! Ladda ner appen här bit.ly/Sverigespelet📱")
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
                    composer.setInitialText("Ladda ner Sverigespelet och försök slå mitt rekord på sverigepoäng😉🇸🇪! Ladda ner appen här bit.ly/Sverigespelet📱")
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
                let msg = "Ladda ner Sverigespelet och försök slå mitt rekord på sverigepoäng😉🇸🇪! Ladda ner appen här bit.ly/Sverigespelet📱"
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
                    mailcontroller.setToRecipients(["lucas@sverigespelet.co"])
                    mailcontroller.setSubject("Utmaning - försök att slå mig på Sverigespelet!")
                    mailcontroller.setMessageBody("<html><body><p>Ladda ner Sverigespelet och försök slå mitt rekord på sverigepoäng😉🇸🇪! Ladda ner appen här bit.ly/Sverigespelet📱</p></body></html>", isHTML: true)
                    
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
                    controller.body = "Ladda ner Sverigespelet och försök slå mitt rekord på  sverigepoäng😉🇸🇪! Ladda ner appen här bit.ly/Sverigespelet📱"
                    
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
    
    func bubblesDidHide(bubbles: SwiftShareBubbles) {
    }    //end of share bubbles
    
    //dissmiss imessage controller
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //dissmiss mail controller
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: IN APP PURCHASE / no Ads
    func unlockAction() {
        
        noAds_id = "com.LucasOtterling.fiveSecondsGameFinal.RemoveAds";
        // Adding the observer
        SKPaymentQueue.default().add(self)
        
        print("About to fetch the products");
        
        // Check if user can make payments and then proceed to make the purchase.
        if (SKPaymentQueue.canMakePayments())
        {
            let productID:NSSet = NSSet(object: self.noAds_id!);
            let productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>);
            productsRequest.delegate = self;
            productsRequest.start();
            print("User can make purchases and will fetch products from Apple Store now");
        }else{
            print("User can't make purchases");
        }
        
    }
    
    func buyProduct(product: SKProduct){
        print("Sending the Payment Request to Apple");
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment);
        
    }
    
    func productsRequest (_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        let count : Int = response.products.count
        if (count>0) {
            
            let nodAdsProduct = response.products[0] as SKProduct
            if (nodAdsProduct.productIdentifier as NSString == self.noAds_id ) {
                print(nodAdsProduct.localizedTitle)
                print(nodAdsProduct.localizedDescription)
                print(nodAdsProduct.price)
                buyProduct(product: nodAdsProduct);
            } else {
                print(nodAdsProduct.productIdentifier)
            }
        } else {
            print("nothing to find")
        }
    }
    
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Error Fetching product information", error);
    }
    
    // Allowing for all possible outcomes:
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction])   {
        print("Received Payment Transaction Response from Apple adfree");
        
        for transaction:AnyObject in transactions {
            if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                    
                case .purchased:
                    print("Product Purchase Success")
                    let alert = UIAlertController(title: "Tack", message: "Tack för ditt köp och stöd - det betyder jättemycket.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    present(alert, animated: true, completion: nil)
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    defaults.set(true , forKey: "AdFreePurchased") //todo: se till att detta bara sker för removeads och inte köpa extra liv ! (
                    break;
                    
                case .failed:
                    print("Purchase Failed");
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break;
                    
                case .restored:
                    print("Already Purchased");
                    SKPaymentQueue.default().restoreCompletedTransactions()
                    defaults.set(true , forKey: "AdFreePurchased") //todo: se till att detta bara sker för removeads och inte köpa extra liv ! (
                    break;
                    
                default:
                    break;
                }
            }
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
    
    func handleCustomFacebookLogin() { //FREDRIK
        if(FBSDKAccessToken.current() != nil){
            
            FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start {(connection, result, error) in
                
                if error != nil{
                    print("Failed to start facebook graph request", error as Any)
                    return
                }
                
                self.res = result as! NSDictionary
                facebookID = self.res.object(forKey: "id") as! String
                
                if userTopScore != nil {
                    print(userTopScore!)
                } else {
                    userTopScore = 0
                }
                LeaderboardVC.updateScore(score: userTopScore!, id:self.res.object(forKey: "id") as! String, completion: {
                    //let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "leaderBoardId")
                    //self.present(vc, animated: true, completion: nil)
                    LeaderboardVC.setName(name: self.res.object(forKey: "name") as! String, id:self.res.object(forKey: "id") as! String)
                })
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "leaderBoardId")
                self.present(vc, animated: true, completion: nil)
                
                print(result!) //print out the different crediters of the user
            }
            
        }else{

            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FacebookVC")
            self.present(vc, animated: true, completion: nil)
            
            // Om jag inte är inloggad så kallar jag på loggin och gör samma procedur
            /*print("Facebook not logged in")
            FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) {
                
                (result, error) in
                
                if error != nil {
                    print("Custom Facebook Login failed")
                    return
                }
                
                self.grabEmailAddress()
                
            }*/
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
            
            facebookID = self.res.object(forKey: "id") as! String
            LeaderboardVC.setName(name: self.res.object(forKey: "name") as! String, id: self.res.object(forKey: "id") as! String)
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "leaderBoardId")
            self.present(vc, animated: true, completion: nil)
            
            print(result!) //print out the different crediters of the user
        }
        
    }
    //END OF FACEBOOK LOGIN
    
    //random notification banner
    @objc func showRandomNotifiction() {
        if (pickedBannerRandom == "1") && (popAdRandom != "1") {
            print("going to show notificationBanner")
            
            if (pickedBannerTypeRandom == "noAds") && !defaults.bool(forKey: "AdFreePurchased") && defaults.bool(forKey: "firstTime"){
            
                //show notificationBanner
                print("noAds notificationBanner shown")
                notificationBannerTitle = "Trött på reklam?"
                notificationBannerSubtitle = "Klicka för att stötta oss direkt istället!"
                //default design of notificationBanner
                let notificationBanner = NotificationBanner(title: notificationBannerTitle, subtitle: notificationBannerSubtitle, leftView: leftView, style: .info)
                notificationBanner.backgroundColor = UIColor().SwedenYellow()
                notificationBanner.titleLabel?.textColor = UIColor().SwedenBlue()
                notificationBanner.subtitleLabel?.textColor = UIColor().SwedenBlue()
                notificationBanner.onTap = {
                    print("noAds notificationBanner tapped")
                    self.unlockAction()
                }
                //show notificationBanner
                notificationBanner.show()
                
            } else if !defaults.bool(forKey: "firstTime"){
                
                //show notificationBanner
                print("first time notificationBanner shown")
                notificationBannerTitle = "Välkommen till Sverigspelet"
                notificationBannerSubtitle = ""
                //default design of notificationBanner
                let notificationBanner = NotificationBanner(title: notificationBannerTitle, subtitle: notificationBannerSubtitle, leftView: leftView, style: .info)
                notificationBanner.backgroundColor = UIColor().SwedenYellow()
                notificationBanner.titleLabel?.textColor = UIColor().SwedenBlue()
                notificationBanner.subtitleLabel?.textColor = UIColor().SwedenBlue()
                notificationBanner.onTap = {
                    print("first time notificationBanner tapped")
                }
                //show notificationBanner
                notificationBanner.show()
                
            } else if (pickedBannerTypeRandom == "ourStory") && defaults.bool(forKey: "firstTime") {
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
                    self.performSegue(withIdentifier: "MenuToLucas", sender: UIButton())
                }
                //show notificationBanner
                notificationBanner.show()
            } else if (pickedBannerTypeRandom == "loginFB") && (FBSDKAccessToken.current() != nil) && defaults.bool(forKey: "firstTime") {
                
                //show notificationBanner
                print("loginFB notificationBanner shown")
                notificationBannerTitle = "Se topplistor över de bästa spelarna!"
                notificationBannerSubtitle = "Gå med i Sverigespelets Facebook community!"
                //default design of notificationBanner
                let notificationBanner = NotificationBanner(title: notificationBannerTitle, subtitle: notificationBannerSubtitle, leftView: leftView, style: .info)
                notificationBanner.backgroundColor = UIColor().SwedenYellow()
                notificationBanner.titleLabel?.textColor = UIColor().SwedenBlue()
                notificationBanner.subtitleLabel?.textColor = UIColor().SwedenBlue()
                notificationBanner.onTap = {
                    print("loginFB notificationBanner tapped")
                    self.handleCustomFacebookLogin()
                }
                //show notificationBanner
                notificationBanner.show()
            } else if (pickedBannerTypeRandom == "review") && defaults.bool(forKey: "firstTime") {
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
                        EggRating.promptRateUs(in: self)
                    }
                }
                //show notificationBanner
                notificationBanner.show()
            }
            else if (pickedBannerTypeRandom == "socialMedia") && defaults.bool(forKey: "firstTime") {

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
                    print("socialMedia notificationBanner tapped")
                    
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
                    }
                //show notificationBanner
                notificationBanner.show()
            } else {
                print("no random notificationBanner was shown")
            }//end of second if-statement
            
        }//end of first if-statement
    } //end of Randomize notificationBanner informing of ___
    
    //MARK: - PageViewController Data Source
    func viewControllerAtIndex(index: Int) -> UIViewController{
        
        if  ((self.pageImages.count == 0) || (index >= self.pageImages.count)){
            return IntroViewController()
        }
        
        let vc: IntroViewController = self.storyboard?.instantiateViewController(withIdentifier: "IntroVC") as! IntroViewController
        
        vc.imageFile = self.pageImages[index] as! String
        vc.pageIndex = index
        
        return vc
        
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! IntroViewController
        var index = vc.pageIndex as Int
        
        if (index == 0 || index == NSNotFound){
            return nil
        }
        
        index -= 1
        return self.viewControllerAtIndex(index: index)
        
    }//end of before
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! IntroViewController
        var index = vc.pageIndex as Int
        
        if (index == NSNotFound)
        {
            return nil
        }
        
        index += 1
        
        if (index == self.pageImages.count) {
            
            return nil
        }
        
        return self.viewControllerAtIndex(index: index)
        
    }//end of after
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.pageImages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    } //end of Pageviewcontroller

    @objc func showFirstTimeVC() {
        present(pageViewController, animated: true, completion: nil)
    }
    
    //Random "intresseväckance" notifciation
    func refreshNotif() {
        
        // code from http://stackoverflow.com/questions/6340664/delete-a-particular-local-notification
        
            //Schedule new one
            var userDefinedMessages:[String] = [
                
                "How are you feeling today?",
                "\"Motivation will almost always beat mere talent.\" Tap for extra motivation",
                "\"People often say that motivation doesn’t last. Well, neither does bathing. That’s why we recommend it daily.\" ~ Zig Ziglar. Tap for today’s motivation",
                "\"Without inspiration the best powers of the mind remain dormant. There is a fuel in us which needs to be ignited with sparks.\" Tap to get some sparks",
                "\"The people who are crazy enough to think they can change the world are the ones who do.\" ~ Steve Jobs",
                "\"You can do anything if you have enthusiasm.\" ~ Henry Ford. Tap for extra inspiration",
                "\"Failure is simply the opportunity to begin again, this time more intelligently.\" ~ Henry Ford. Tap for new motivation",
                "\"The mind is everything. What you think you become.\" ~ Buddha. Tap for positive thoughts",
                "\"The real secret of success is enthusiasm.\" ~ Walter Chrysler. Tap for extra inspiration",
                "\"To succeed, you need to find something to hold on to, something to motivate you, something to inspire you.\" Tap for inspiration",
                "\"Be yourself; everyone else is already taken.\" ~ Oscar Wilde. Tap for more quotes",
                "\"You become what you believe.\" ~ Oprah Winfrey. Tap for more inspiration",
                "\"If you're afraid to fail, then you're probably going to fail.\" ~ Kobe Bryant. Tap for a pep-talk",
                "\"The secret of getting ahead is getting started.\" ~ Mark Twain. Tap for instant motivation",
                "\"Don’t count the days, make the days count.\" ~ Muhammad Ali. Tap for more inspiration",
                "\"Life is like riding a bicycle. To keep your balance, you must keep moving.\" ~ Albert Einstein. Tap for more inspiration",
                "\"Logic will get you from A to B. Imagination will take you everywhere.\" ~ Albert Einstein. Tap for inspiration",
                "\"Believe you can and you’re halfway there.\" ~ Theodore Roosevelt. Tap for more inspiration",
                "\"You are never too old to set another goal or to dream a new dream.\" ~ Eleanor Roosevelt. Tap for instant inspiration",
                
                ]
            
            
            //Create date from current date so notifications start being scheduled from current time details here
            let tDate = Date()
            print(tDate)
            let localNotif = UILocalNotification()
            let Range: UInt32 = UInt32(userDefinedMessages.count)
            let RandomNumber = Int(arc4random_uniform(Range))
            let pickRandom = userDefinedMessages[RandomNumber]
            localNotif.alertBody = String(pickRandom)
            localNotif.alertAction = "Open App"
            localNotif.repeatInterval = .second
            localNotif.fireDate = Calendar.current.date(byAdding: .second, value: 3, to: tDate)!
            //set the alert schedule date
            
            let startDate = Calendar.current.date(byAdding: .day, value: 6, to: tDate)!
            print(startDate)
            localNotif.soundName = UILocalNotificationDefaultSoundName
            
        
    }//End of refreshNotif()
    
}//end of class

//EggRating Delegate
extension StartMenuVC: EggRatingDelegate {
    
    func didRate(rating: Double) {
        print("didRate: \(rating)")
    }
    
    func didRateOnAppStore() {
        print("didRateOnAppStore")
    }
    
    func didIgnoreToRate() {
        print("didIgnoreToRate")
    }
    
    func didIgnoreToRateOnAppStore() {
        print("didIgnoreToRateOnAppStore")
    }
}
//https://github.com/kentya6/KYCircularProgress2
