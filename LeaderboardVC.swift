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
import Pastel
import SwiftShareBubbles
import Social
import MessageUI
import StoreKit
import GoogleMobileAds
import AVFoundation
import FBSDKLoginKit


class CustomTableViewCell: UITableViewCell {
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
}

extension LeaderboardVC: UITableViewDataSource, SwiftShareBubblesDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, GADBannerViewDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver, FBSDKLoginButtonDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        print(scores[indexPath.row])
        
        // Fredrik. Här fyller jag i vad de värderna i raderna på tabellen ska vara
        if scores[indexPath.row]["name"] != nil {
            cell.nameLabel?.text = (scores[indexPath.row]["name"] as! String)
        } else {
            cell.nameLabel?.text = "Unknown"
        }
        if scores[indexPath.row]["score"] != nil {
            cell.scoreLabel?.text = "\(scores[indexPath.row]["score"] as! Int)"
        } else {
            cell.scoreLabel?.text = "ERROR"
        }
            cell.rankLabel?.text = "#\(indexPath.row + 1)"
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scores.count
    }
    
}

var score:Int?
var name:String?

class LeaderboardVC: UIViewController {
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var rankBarBtn: UIBarButtonItem!
    @IBOutlet weak var scoreBarBtn: UIBarButtonItem!
    @IBOutlet weak var topNavBarItem: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    let leaderboardDB = Database.database().reference().child("leaderboard")
    var scores = Array<Dictionary<String, Any>>()
    var defaults = UserDefaults.standard
    var popAdRandom = String()
    //share bubbles
    var bubbles: SwiftShareBubbles?
    var mailID = 11
    var messengerID = 12
    var imessageID = 13
    //in-app purchase
    var noAds_id: NSString?;
    var nodAdsProduct = SKProduct()
    
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
        
        //set up basic
        self.tableView.dataSource = self
        let image = UIImage(named: "Sverigespelet rounded mini")
        let imageView = UIImageView(image:image)
        self.topNavBarItem.titleView = imageView
        self.rankBarBtn.setTitleTextAttributes([
            NSAttributedStringKey.font : UIFont(name: "YanoneKaffeesatz-Bold", size: 21)!,
            NSAttributedStringKey.foregroundColor : UIColor().SwedenBlue(),
            ], for: .normal)
        rankBarBtn.title = "Rank"
        self.scoreBarBtn.setTitleTextAttributes([
            NSAttributedStringKey.font : UIFont(name: "YanoneKaffeesatz-Bold", size: 21)!,
            NSAttributedStringKey.foregroundColor : UIColor().SwedenBlue(),
            ], for: .normal)
        scoreBarBtn.title = "Sverigepoäng"
        
        
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
        
        // Fredrik. Ladda ner scoresen från databsen
        downloadScores()
        getHighScoreForPlayer(id: facebookID)
        
        //share bubbles
        bubbles = SwiftShareBubbles(point: CGPoint(x: view.frame.width / 2, y: view.frame.height / 2), radius: 150, in: view)
        bubbles?.showBubbleTypes = [Bubble.twitter, Bubble.facebook, Bubble.whatsapp, Bubble.instagram]
        bubbles?.delegate = self
        
        let mailAttribute = ShareAttirbute(bubbleId: mailID, icon: UIImage(named: "Mail")!, backgroundColor: UIColor(red:0.19, green:0.81, blue:1.00, alpha:1.0))
        let messengerAttribute = ShareAttirbute(bubbleId: messengerID, icon: UIImage(named: "Messenger")!, backgroundColor: UIColor(red:0.19, green:0.42, blue:1.00, alpha:1.0))
        let imessageAttribute = ShareAttirbute(bubbleId: imessageID, icon: UIImage(named: "iMessage")!, backgroundColor: UIColor(red:0.15, green:0.94, blue:0.09, alpha:1.0))
        
        bubbles?.customBubbleAttributes = [mailAttribute, messengerAttribute, imessageAttribute]
        
    }//end of viewdidload
    
    func getHighScoreForPlayer(id:String) {
        
        Database.database().reference().child("leaderboard").child(id).observeSingleEvent(of: .value) { (snapshot) in
            
            if let dict = snapshot.value as? Dictionary<String,Any> {
                
                print(dict["score"]!)
                print(dict["name"]!)
                
                score = dict["score"] as? Int;
                name = dict["name"] as? String;
                
            }
        }
    }
    
    func downloadScores() {
        
        let leaderboardDB = Database.database().reference().child("leaderboard").queryOrdered(byChild: "score")
        
        leaderboardDB.observeSingleEvent(of: .value, with: { (snapshot) in
            
            //print(snapshot.value)
            
            self.scores.removeAll()
            
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                self.scores.append(rest.value as! [String : Any])

            }
            
            self.scores.reverse()
            self.scores = self.scores.filter({dict in
                
                if (dict["score"] == nil) {
                    return false
                }
                
                return true
                
            })
            
             //self.scores = self.scores.reversed()
            
            //   self.scores = (snapshot.value as? NSDictionary)?.allValues as! Array<Dictionary>
            //  self.scores.reverse()
            
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
    
    static func updateScore(score:Int, id:String, completion: @escaping (() -> Void)) {
        
            Database.database().reference().child("leaderboard").child(id).child("score").observeSingleEvent(of: .value, with: { (snapshot) in
        
                let value = snapshot.value as? Int
                
                if (score > value!) {
             Database.database().reference().child("leaderboard").child(id).child("score").setValue(score, withCompletionBlock: { (error,ref) in
                
                    completion()
                
                    })
                    
                }
                
        })
        
    }

    @IBAction func closeBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func userInfoTapped(_ sender: Any) {
        
        let alertController = YBAlertController(style: .Alert)
        alertController.title = "👤\(name!)"
        alertController.message = "Rekord: \(score!) Sverigepoäng🇸🇪"
        /*alertController.addButton(title: "Ändra användarnamn🗣") {
            //change updateName
            let alert = UIAlertController(title: "Ändra användarnamn🗣", message: "Inte sugen på att ha ditt riktiga namn? Ändra ditt användarnamn här.", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "OK!", style: .default) { (alertAction) in
                let textField = alert.textFields![0] as UITextField
                textField.text = name
                LeaderboardVC.setName(name: name!, id: facebookID)
            }
            alert.addTextField { (textField) in
                textField.placeholder = "Skriv ditt nya användarnamn här."
            }
            let cancel = UIAlertAction(title: "Avbryt", style: .cancel)
            alert.addAction(action)
            alert.addAction(cancel)
            self.present(alert, animated:true, completion: nil)
            
            //LeaderboardVC.setName(name:name, id:facebookID)
         TODO: FUTURE UPDATE
            
        }*/
        alertController.addButton(icon: UIImage(named: "share"), title: "Skryt på sociala medier🏆") {
            self.bubbles?.show()
            alertController.dismiss()
        }
        alertController.addButton(icon: UIImage(named: "signout"),title: "Logga ut") {
            print("Facebook logged in")
            let alert = UIAlertController(title: "Logga ut från Facebook?", message: "Du kommer inte kunna se topplistorna och din spelupplevelse samt kontakt med Sverigespelets sociala media community försämras.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Logga ut", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in
                FBSDKLoginManager().logOut()
                self.dismiss(animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Avbryt", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        alertController.cancelButtonTitle = "OK!"
        
        // show alert
        alertController.show()
    }
    
    // SwiftShareBubblesDelegate
    //share bubbles
    @IBAction func shareBtnTapped(_ sender: Any) {
        bubbles?.show()
    }
    
    func bubblesTapped(bubbles: SwiftShareBubbles, bubbleId: Int) {
        
        if let bubble = Bubble(rawValue: bubbleId) {
            print("\(bubble)")
            switch bubble {
            case .facebook:
                let urlString = NSURL(string: "fb://fb")!
                
                if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
                    guard let composer = SLComposeViewController(forServiceType: SLServiceTypeFacebook) else { return }
                    composer.setInitialText("Ladda ner Sverigespelet och försök slå mitt rekord på \(score!) sverigepoäng😉🇸🇪!")
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
                    composer.setInitialText("Ladda ner Sverigespelet och försök slå mitt rekord på \(score!) sverigepoäng😉🇸🇪!")
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
                let msg = "Ladda ner Sverigespelet och försök slå mitt rekord på \(score!) sverigepoäng😉🇸🇪!"
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
                    mailcontroller.setMessageBody("<html><body><p>Ladda ner Sverigespelet och försök slå mitt rekord på \(score!) sverigepoäng😉🇸🇪!</p></body></html>", isHTML: true)
                    
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
                    controller.body = "Ladda ner Sverigespelet och försök slå mitt rekord på \(score!) sverigepoäng😉🇸🇪!"
                    
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
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("did log out of facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
    }
    
}//end of class
