//
//  SettingsVC.swift
//  fiveSeconds
//
//  Created by Lucas Otterling on 02/06/2017.
//  Copyright © 2017 Lucas Otterling. All rights reserved.
//

import UIKit
import QuickTableViewController
import GoogleMobileAds
import EggRating
import SwiftShareBubbles
import Social
import MessageUI
import StoreKit

class SettingsVC: QuickTableViewController, GADBannerViewDelegate, SwiftShareBubblesDelegate, MFMailComposeViewControllerDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    //share bubbles
    var bubbles: SwiftShareBubbles?
    var mailID = 11
    var messengerID = 12
    //in-app purchase
    var defaults = UserDefaults.standard
    var noAds_id: NSString?
    var nodAdsProduct = SKProduct()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //share bubbles
        bubbles = SwiftShareBubbles(point: CGPoint(x: view.frame.width / 2, y: view.frame.height / 2), radius: 150, in: view)
        bubbles?.showBubbleTypes = [Bubble.instagram]
        bubbles?.delegate = self
        
        let mailAttribute = ShareAttirbute(bubbleId: mailID, icon: UIImage(named: "Mail")!, backgroundColor: UIColor(red:0.19, green:0.81, blue:1.00, alpha:1.0))
        let messengerAttribute = ShareAttirbute(bubbleId: messengerID, icon: UIImage(named: "Messenger")!, backgroundColor: UIColor(red:0.19, green:0.42, blue:1.00, alpha:1.0))
        
        bubbles?.customBubbleAttributes = [mailAttribute, messengerAttribute]
        
        tableContents = [
            Section(title: "Inställningar", rows: [
                
                TapActionRow(title: "Om Sverigespelet", action: { _ in
                    print("about me tapped")
                    self.performSegue(withIdentifier: "SettingsToAboutMe", sender: UIButton())
                }),
                
                //SwitchRow(title: "Ljudeffekter", switchValue: true, action: { _ in
                  //  self.printValue(SwitchRow as! (Row))
                //}),
                TapActionRow(title: "Återställ tidigare köp", action: { _ in
                    
                    print("restore purchases tapped")
                    // Set up the observer
                    SKPaymentQueue.default().add(self)
                    //Check if user can make payments and then proceed to restore purchase
                    if (SKPaymentQueue.canMakePayments()) {
                        SKPaymentQueue.default().restoreCompletedTransactions()
                        
                        //Alert
                        //Message
                        let sendMailErrorAlert = UIAlertController(title:  "Restored", message: "If you have already purchased products on this Apple ID, they should now have been restored. If not, try purchasing them again (they will restore for free if you're using the same Apple ID).", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        sendMailErrorAlert.addAction(ok)
                        
                        self.present(sendMailErrorAlert, animated: true, completion: nil)
                        
                    } else {
                        
                        //Alert
                        //Message
                        let sendMailErrorAlert = UIAlertController(title:  "OBS!", message: "Something went wrong, please try again later. Do you for example have Wi-Fi?", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        sendMailErrorAlert.addAction(ok)
                        
                        self.present(sendMailErrorAlert, animated: true, completion: nil)
                        
                    }

                }),
                TapActionRow(title: "Kontakt", action: { _ in
                    print("contact us tapped")
                    //share bubbles ->
                    self.bubbles?.show()
                }),
                TapActionRow(title: "Betygsätt oss", action: { _ in
                    print("rate us tapped")
                        // rate in app store
                        EggRating.delegate = self
                    EggRating.promptRateUs(in: self)
                
                }),
                TapActionRow(title: "Följ oss på sociala medier", action: { _ in
                    print("follow us on socia media tapped")
                    
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

                }),
            ]),
            Section(title: "", rows: [
                TapActionRow(title: "Avsluta", action: { _ in
                    print("ok tapped")
                    self.dismiss(animated: true, completion: nil)
                }),
            ]),
            
            Section(title: "", rows: []),
            
            Section(title: "Sverigespelet uses the following third-party libraries", rows: [
                NavigationRow(title: "EggRating", subtitle: .rightAligned("by Somjintana K")),
                NavigationRow(title: "MarqueeLabel", subtitle: .rightAligned("by cbpowell")),
                NavigationRow(title: "SwiftShareBubbles", subtitle: .rightAligned("by bcylin")),
                NavigationRow(title: "QuickTableViewController", subtitle: .rightAligned("by Takeshi Fujiki")),
                NavigationRow(title: "Pastel", subtitle: .rightAligned("by cruisediary")),
                NavigationRow(title: "SnapKit", subtitle: .rightAligned("by SnapKit")),
                NavigationRow(title: "NotificationBannerSwift", subtitle: .rightAligned("by Daltron")),
                NavigationRow(title: "Facebook SDK", subtitle: .rightAligned("by Facebook")),
                NavigationRow(title: "Firebase SDK", subtitle: .rightAligned("by Google")),
                ]),
            
            Section(title: "", rows: []),

            Section(title: "Version 1.0\nCopyright © 2018 Lucas Otterling. All rights reserved.", rows: []),
            Section(title: "", rows: []),
            Section(title: "Please note company or event logos are protected by copyright and/or trademark registration. I believe the use of low-resolution logos and images in this 'just-for-entertainment' game for the use of identification in a positive and informational context may qualify as fair use under United States and European copyright law and may even be seen as free advertising. Any other uses of the logo images elsewhere may be copyrighted infringement. Furthermore, I refer after solution of the logo and images to the appropriate Wikipedia article which serves to explain the brand. If any actor who holds the rights to images/logos doesn't like the usage, please contact me immediately and I'll remove it.", rows: []),
        ]
    
    }//end of viewdidload
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if tableContents[indexPath.section].title == nil {
            // Alter the cells created by QuickTableViewController
        }
        
        return cell
    }
    
    // MARK: - Private Methods
    
    private func printValue(_ sender: Row) {
        if let row = sender as? SwitchRow {
            print("\(row.title) = \(row.switchValue)")
        }
    }
    
    // SwiftShareBubblesDelegate
    func bubblesTapped(bubbles: SwiftShareBubbles, bubbleId: Int) {
        
        if let bubble = Bubble(rawValue: bubbleId) {
            print("\(bubble)")
            switch bubble {
            case .instagram:
                
                let urlString = NSURL(string: "instagram://user?username=sverigespelet")!
                
                if UIApplication.shared.canOpenURL(urlString as URL){
                    
                    UIApplication.shared.openURL(urlString as URL)
                    
                } else {
                    //redirect to safari because the user doesn't have facebook
                    UIApplication.shared.openURL(NSURL(string: "http://instagram.com/")! as URL)
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
                    mailcontroller.setSubject("Kontakt angående Sverigespelet")
                    self.present(mailcontroller, animated: true, completion: nil)
                    
                } else {
                    
                    let sendMailErrorAlert = UIAlertController(title:  "Kunde inte skicka mailet", message: "Din telefon kunde inte skicka e-mailet. Var god och kontrollera din e-mail app och försök igen.", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    sendMailErrorAlert.addAction(ok)
                    
                    self.present(sendMailErrorAlert, animated: true, completion: nil)
                }
                
                
            } else if messengerID == bubbleId {
                //messenger
                let urlString = NSURL(string: "fb-messenger://compose")! //http://m.me/TheQuoteNowApp  fb-messenger://compose
                
                if UIApplication.shared.canOpenURL(urlString as URL)
                {
                    UIApplication.shared.openURL(urlString as URL)
                    
                } else {
                    //redirect to safari because the user doesn't have facebook
                    UIApplication.shared.openURL(NSURL(string: "http://facebook.com/")! as URL)
                }
                
            }
        }
    }
    
    func bubblesDidHide(bubbles: SwiftShareBubbles) {
    }
    
    //end of share bubbles
    
    //dissmiss mail controller
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //dissmiss imessage controller
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
    }
    
    //no Ads
    func unlockAction(_ sender: AnyObject) {
        
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
            print("nothing")
        }
    }
    
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Error Fetching product information");
    }
    
    // Allowing for all possible outcomes:
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction])   {
        print("Received Payment Transaction Response from Apple adfree");
        
        for transaction:AnyObject in transactions {
            if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                    
                case .failed:
                    print("Purchased Failed");
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break;
                    
                case .restored:
                    print("Already Purchased");
                    SKPaymentQueue.default().restoreCompletedTransactions()
                    break;
                    
                default:
                    break;
                }
            }
        }
    }
}

//EggRating Delegate
extension SettingsVC: EggRatingDelegate {
    
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

