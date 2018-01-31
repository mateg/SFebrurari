//
//  BetaSignInVC.swift
//  Sverigespelet
//
//  Created by Lucas Otterling on 28/11/2017.
//  Copyright © 2017 Lucas Otterling. All rights reserved.
//

import UIKit
import Pastel
import MessageUI

class BetaSignInVC: UIViewController, MFMailComposeViewControllerDelegate {

    //this VC enables the beta-user to login -> will be removed from the actual version
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var noNameBtn: UIButton!
    @IBOutlet weak var signInBtn: UIButton!
    var username = String()
    var namesArray = [ //has to take notice of letter capitaliztion
        //the användarnamn of the beta-users => all info (emails, name) is added in a google sheet/google form
        "KNUGEN",
        "IBRAHIMOVIC",
        "BJÖRN BORG",
        "INGVAR KAMPRAD",
        "SVENNIS",
        "PETER FORSBERG",
        "INGEMAR STENMARK",
        "MIKAEL PERSBRANDT",
        "BENNY ANDERSSON",
        "FREDRIK REINFELDT",
        "DROTTNING SILVIA",
        "CAROLA",
        "LILL-BABS",
        "MARGOT WALLSTRÖM",
        "ANJA PÄRSON",
        "ANDERS SVENSSON",
        "THOMAS RAVELLI",
        "ANDREAS ISAKSSON",
        "KIM KÄLLSTRÖM",
        "OLOF MELLBERG",
        "HENRIK LARSSON",
        "JO WALDNER",
        "DOLPH LUNDGREN",
        "PETER STORMARE",
        "STELLAN SKARSGÅRD",
        "ALEXANDER SKARSGÅRD",
        "KUNGEN",
        "ZLATAN",
        "MARIE FREDRIKSSON",
        "MAX MARTIN",
        "PER GESSLE",
        "ANNIKA SÖRENSTAM",
        "AVICII",
        "PEWDIEPIE",
        "ROBYN",
        "HENRIK LUNDQVIST",
        "KJELL BERGQVIST",
        "PERNILLA WAHLGREN",
        "HÅKAN HELLSTRÖM",
        "KAJSA BERGQVIST",
        "BLEKINGE",
        "BOHUSLÄN",
        "DALARNA",
        "DALSLAND",
        "GOTLAND",
        "GÄSTRIKLAND",
        "HALLAND",
        "HÄLSINGLAND",
        "HÄRJEDALEN",
        "JÄMTLAND",
        "LAPPLAND",
        "MEDELPAD",
        "NORRBOTTEN",
        "NÄRKE",
        "SKÅNE",
        "SMÅLAND",
        "SÖDERMANLAND",
        "UPPLAND",
        "VÄRMLAND",
        "VÄSTERBOTTEN",
        "VÄSTERGÖTLAND",
        "VÄSTMANLAND",
        "ÅNGERMANLAND",
        "ÖLAND",
        "ÖSTERGÖTLAND",
        "ALINGSÅS",
        "ARBOGA",
        "ARVIKA",
        "ASKERSUND",
        "AVASKÄR",
        "AVESTA",
        "BODEN",
        "BOLLNÄS",
        "BORGHOLM",
        "BORLÄNGE",
        "BORÅS",
        "BROO",
        "BRÄTTE",
        "BÅSTAD",
        "DJURSHOLM",
        "EKSJÖ",
        "ELLEHOLM",
        "ENKÖPING",
        "ESKILSTUNA",
        "ESLÖV",
        "FAGERSTA",
        "FALKENBERG",
        "FALKÖPING",
        "FALSTERBO",
        "FALUN",
        "FILIPSTAD",
        "FLEN",
        "GAMLA LÖDÖSE",
        "GETAKÄRR",
        "GRÄNNA",
        "GÄVLE",
        "GÖTEBORG",
        "HAGFORS",
        "HALMSTAD",
        "HAPARANDA",
        "HEDEMORA",
        "HELSINGBORG",
        "HJO",
        "HUDIKSVALL",
        "HUSKVARNA",
        "HÄRNÖSAND",
        "HÄSSLEHOLM",
        "HÄSTHOLMEN",
        "HÖGANÄS",
        "JÄRLE",
        "JÖNKÖPING",
        "KALMAR",
        "KARLSHAMN",
        "KARLSKOGA",
        "KARLSKRONA",
        "KARLSTAD",
        "KATRINEHOLM",
        "KIRUNA",
        "KONGAHÄLLA",
        "KRAMFORS",
        "KRISTIANOPEL",
        "KRISTIANSTAD",
        "KRISTINEHAMN",
        "KUMLA",
        "KUNGSBACKA",
        "KUNGÄLV",
        "KÖPING",
        "LAHOLM",
        "LANDSKRONA",
        "LIDINGÖ",
        "LIDKÖPING",
        "LINDESBERG",
        "LINKÖPING",
        "LJUNGBY",
        "LOMMA",
        "LUDVIKA",
        "LULEÅ",
        "LUND",
        "LUNTERTUN",
        "LYCKSELE",
        "LYCKÅ",
        "LYSEKIL",
        "LÖDÖSE",
        "MALMÖ",
        "MARIEFRED",
        "MARIESTAD",
        "MARSTRAND",
        "MJÖLBY",
        "MOTALA",
        "MÖLNDAL",
        "MÖNSTERÅS",
        "NACKA",
        "NORA",
        "NORRKÖPING",
        "NORRTÄLJE",
        "NYA LIDKÖPING",
        "NYA LÖDÖSE",
        "NYBRO",
        "NYKÖPING",
        "NYNÄSHAMN",
        "NÄSSJÖ",
        "OSKARSHAMN",
        "OXELÖSUND",
        "PITEÅ",
        "RONNEBY",
        "SALA",
        "SANDVIKEN",
        "SIGTUNA",
        "SIMRISHAMN",
        "SKANÖR",
        "SKARA",
        "SKELLEFTEÅ",
        "SKÄNNINGE",
        "SKÖVDE",
        "SOLLEFTEÅ",
        "SOLNA",
        "STOCKHOLM",
        "STRÄNGNÄS",
        "STRÖMSTAD",
        "SUNDBYBERG",
        "SUNDSVALL",
        "SÄFFLE",
        "SÄTER",
        "SÄVSJÖ",
        "SÖDERHAMN",
        "SÖDERKÖPING",
        "SÖDERTÄLJE",
        "SÖLVESBORG",
        "TIDAHOLM",
        "TORGET",
        "TORSHÄLLA",
        "TRANÅS",
        "TRELLEBORG",
        "TROLLHÄTTAN",
        "TROSA",
        "TUMATHORP",
        "UDDEVALLA",
        "ULRICEHAMN",
        "UMEÅ",
        "UPPSALA",
        "VADSTENA",
        "VARBERG",
        "VAXHOLM",
        "VETLANDA",
        "VIMMERBY",
        "VISBY",
        "VÄNERSBORG",
        "VÄRNAMO",
        "VÄSTERVIK",
        "VÄSTERÅS",
        "VÄXJÖ",
        "YSTAD",
        "ÅHUS",
        "ÅMÅL",
        "ÄLVSBORG",
        "ÄNGELHOLM",
        "ÖJEBYN",
        "ÖREBRO",
        "ÖREGRUND",
        "ÖRNSKÖLDSVIK",
        "ÖSTERSUND",
        "ÖSTHAMMAR",
        "OSCAR LINNER",
        "ALEXANDER PÄRLEROS",
        "LENNHAMMER",
    
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //SET-UP
        infoLabel.layer.cornerRadius = 20
        textField.layer.cornerRadius = 20
        textField.layer.borderColor = UIColor().SwedenYellow().cgColor
        noNameBtn.layer.cornerRadius = 20
        signInBtn.layer.cornerRadius = 20
        
        //dissmiss keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BetaSignInVC.dismissKeyboard))
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        
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

    }
    
    @IBAction func signInBtnTapped(_ sender: Any) {
        //if användarnamn matches => success
        
        //guard username == textField.text! else {return}
        //might have to guard the optional
        
        username = textField.text!
        
        //check if input in textfield matches username
        if namesArray.contains(username) {
            print("Användarnamn success")
            //dismiss(animated: true, completion: nil)
            performSegue(withIdentifier: "backToIntro", sender: self)
            
        } else {
            print("Användarnamn fail")
            let sendMailErrorAlert = UIAlertController(title:  "Fel användarnamn", message: "Användarnamnet du skrev in stämmer inte. Har du inget personligt användarnamn? Tryck på \"Hur får jag ett användarnamn?\"-knappen. OBS! Använd inte någon annans användarnamn - detta förstör hela syftet med testversionen och kan leda till framtida banning😪", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            sendMailErrorAlert.addAction(ok)
            
            self.present(sendMailErrorAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func noNameBtnTapped(_ sender: Any) {
        //the user wants to request a login -> open email where user can fill in info and send to Lucas
        
        if MFMailComposeViewController.canSendMail() {
            let mailcontroller = MFMailComposeViewController()
            mailcontroller.mailComposeDelegate = self;
            mailcontroller.setToRecipients(["lucas@sverigespelet.co"])
            mailcontroller.setSubject("Användarnamn till Sverigespelet")
            mailcontroller.setMessageBody("<html><body><p>Fyll i uppgifterna nedan och skicka iväg emailet så skickas ditt personliga användarnamn till dig😍 </p> Namn:__________________ </p> Emailaddress:__________________ </p>TACK FÖR ATT DU VILL PROVSPELA SVERIGES ROLIGASTE MOBILSPEL🙌</p> 🇸🇪Varma Sverige hälsningar🇸🇪 </p> Lucas Otterling </p> </p> </p> OBS! Använd inte någon annans användarnamn - detta förstör hela syftet med testversionen och kan leda till framtida banning😪 /p> </p> Glöm inte att följa oss på social medier för roliga updates 👉 @sverigespelet på Instagram, Facebook, Snapchat och Twitter.", isHTML: true)
            
            self.present(mailcontroller, animated: true, completion: nil)
            
        } else {
            
            let sendMailErrorAlert = UIAlertController(title:  "Kunde inte skicka mailet", message: "Din telefon kunde inte skicka e-mailet som krävs för att kunna få ett användarnamn. Var god och kontrollera din e-mail app och försök igen.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            sendMailErrorAlert.addAction(ok)
            
            self.present(sendMailErrorAlert, animated: true, completion: nil)
        }
        
    }
    
    //dissmiss mail controller
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToIntro"{
            if let destination = segue.destination as? IntroViewController {
                destination.dismiss(animated: true, completion: nil)
                print("the user can now play the game")
            }
        }

    }//end of prepare for segue

}
