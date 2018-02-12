//
//  GameVC.swift
//  fiveSeconds
//
//  Created by Lucas Otterling on 19/03/2017.
//  Copyright © 2017 Lucas Otterling. All rights reserved.
//

import UIKit
import CoreMotion
import AVFoundation
import CoreAudio
import GoogleMobileAds
import Pastel
import MarqueeLabel

class GameVC: UIViewController, UITextFieldDelegate, AVAudioRecorderDelegate, GADBannerViewDelegate  {

    //General
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var taskLabel: MarqueeLabel!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var playView: UIView!
    @IBOutlet weak var container: UIView!
    @IBAction func unwindToGame(segue: UIStoryboardSegue) {}
    var mainTypeString = String()
    var specialTypeString = String()
    var pickRandomBtn = String()
    var btnArray = ["leftTopBtn", "rightTopBtn","leftBottomBtn", "rightBottomBtn"]
    var score = Int()
    var answer = String()
    var basicGameType = String()
    @IBOutlet weak var leftTopBtnWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftTopBtnHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightBottomBtnHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightBottomBtnWidthConstraint: NSLayoutConstraint!
    var defaults = UserDefaults.standard
    //Timer
    var seconds = Int() //This variable will hold a starting value of seconds. It could be any amount above 0.
    var timer = Timer()
    var totalTime = Int()
    var totalSeconds = Int()
    var totalButtonTime = Int()
    var fails = Int()
    var isTimerRunning = false //This will be used to make sure only one timer is created at a time.
    //Images
    var answersArray = Array<Any>()
    var firstItem = String()
    var secondItem = String()
    var thirdItem = String()
    var fourthItem = String()
    //Game Art
    var firstCurrentAnimationImages = [UIImage]()
    var secondCurrentAnimationImages = [UIImage]()
    var thirdCurrentAnimationImages = [UIImage]()
    var fourthCurrentAnimationImages = [UIImage]()
    var firstIntForCount = Int()
    var secondIntForCount = Int()
    var thirdIntForCount = Int()
    var fourthIntForCount = Int()
    var firstArray = String()
    var secondArray = String()
    var thirdArray = String()
    var fourthArray = String()
    //numbers
    var numberA = Int()
    var numberB = Int()
    var correctSum = Int()
    var falseSum1 = Int()
    var falseSum2 = Int()
    var falseSum3 = Int()
    //button Tap
    var tapCount = Int()
    var startTapCount = Int()
    var buttonTapNationality = String()
    //button quick/pattern
    var patternArray = ["🇸🇪", "⛄️", "🐝", "🚙", "🐞", "🍄", "🎿", "⛷", "⚽️", "🥛", "🏒", "🍺", "💩", "🏂", "🚣", "🏋️", "🎣", "🏔", "🎅"]
    var colourArray = [UIColor.blue, UIColor(red:0.00, green:0.51, blue:0.68, alpha:1.0), UIColor.yellow, UIColor().SwedenYellow(), UIColor(red:0.95, green:0.80, blue:0.25, alpha:1.0), UIColor(red:1.00, green:0.91, blue:0.02, alpha:1.0), UIColor(red:0.00, green:0.51, blue:0.92, alpha:1.0)]
    var randomColour = UIColor()
    //pan gesture
    @IBOutlet weak var panGestureView: PanGestureView!
    var panImage: UIImageView!
    var panImageset = String()
    var randomColour2 = UIColor()
    var randomColour3 = UIColor()
    var randomColour4 = UIColor()
    //"KYC"
    private var progress: UInt8 = 0
    private var starProgress: KYCircularProgress!
    var lightCount: Int = 0
    var KYCTimer = Timer()
    //Core Motion
    var motionManager = CMMotionManager()
    var motionAnimationImages = [UIImage]()
    var cheerLabel = UILabel()
    //Add 1 
    var inputField : UITextField?
    var startNLabel : UILabel?
    var startNumber = Int()
    var inputNumber = Int()
    //Run a lap
    var runnerImageview = UIImageView()
    var runnerKeyFrameAnimation = CAKeyframeAnimation()
    var runButton = UIButton()
    var randomLaps = Int()
    //Doesn't fit
    var alphaArray = [String]()
    var betaArray = [String]()
    var charlieArray = [String]()
    var allSameArray = [String]()
    var oneSame = String()
    var secondSame = String()
    var thirdSame = String()
    var oneDifferent = String()
    //End sentence
    struct endSentence {
        var question : String
        var correct  : String
        var false1 : String
        var false2 : String
        var false3 : String
        
        init(question : String, correct : String, false1 : String,  false2 : String, false3: String) {
            self.question = question
            self.correct = correct
            self.false1 = false1
            self.false2 = false2
            self.false3 = false3
        }
    }//end of endSentence
    var choosenSentenceStruct = endSentence(question: "", correct: "", false1: "", false2: "", false3: "")
    //Long Press
    var completeTimer = Timer()
    var animateImageView = UIImageView()
    //Image Collide
    var location = CGPoint(x: 0, y: 0)
    var backgroundNose = UIImageView()
    var zlatanHead = UIImageView()
    //Blow in Mic
    var recorder: AVAudioRecorder!
    var levelTimer = Timer()
    var lowPassResults: Double = 0.0
    var microphoneStatusString = String()
    var session = AVAudioSession.sharedInstance()
    //check if reward has been used (happens after view of reward video on end menu)
    var rewardUsed = String()
    
    //https://www.youtube.com/watch?v=dyxqsfrCaeM !!!!!!! följ
    //https://medium.com/ios-os-x-development/build-an-stopwatch-with-swift-3-0-c7040818a10f#.r1cdpfdjw
    //social media buttons https://cocoapods.org/?q=lang%3Aswift%20on%3Aios%20buttons
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        //basic set-up
        print(score)
        print("pre answer", answer)
        totalTimerStart()
        for i in 0..<buttons.count {
            buttons[i].layer.cornerRadius = 40
            buttons[i].setTitleColor(UIColor().SwedenYellow(), for: .normal)
        }
        taskLabel.textColor = UIColor().SwedenYellow()
        scoreLabel.textColor = UIColor().SwedenYellow()
        timerLabel.textColor = UIColor().SwedenYellow()
        taskLabel.type = .leftRight

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
        
        print(rewardUsed, "reward in game")
        //ask the system to start notifying when interface change
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        
        //change font after device size (ipad or iphone)
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone {
            
            //set buttons
            for i in 0..<buttons.count {
                buttons[i].titleLabel?.setSizeFont(sizeFont: 35)
            }
            timerLabel.setSizeFont(sizeFont: 60)
            scoreLabel.setSizeFont(sizeFont: 60)
            taskLabel.setSizeFont(sizeFont: 35)
            taskLabel.numberOfLines = 2

        } else if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
            
            //set buttons
            for i in 0..<buttons.count {
                buttons[i].titleLabel?.setSizeFont(sizeFont: 50)
            }
            timerLabel.setSizeFont(sizeFont: 60)
            scoreLabel.setSizeFont(sizeFont: 60)
            taskLabel.setSizeFont(sizeFont: 50)
            taskLabel.numberOfLines = 2
            
        }

    
        if answer == "correct" {

            self.score += 1;
            seconds = 4
            scoreLabel.text = "\(score)"
            print("yellow flash")
            runTimer()
            
        } else if answer == "false" {
            
            scoreLabel.text = "\(score)"
            runTimer()
            print("red flash")
            self.fails += 1;
            
        } else if answer == "" {
            
            seconds = 4
            runTimer()
            score = 0
            scoreLabel.text = "\(score)"
            
        }
        
        if mainTypeString == "Game Art" {

            //set buttons
            for i in 0..<buttons.count {
                buttons[i].titleLabel?.text = ""
            }
            
            var imageSetArray = [//alla
                
                "Jultomten", "Katten", "Vinterpojken", "surstroming", "Bamse", "Paskmust", "IKEA Grodan"

                ]
            
            //randomize image array
            let firstNumber:Int = Int(arc4random_uniform(UInt32(imageSetArray.count)))
            firstArray = imageSetArray[firstNumber]
            imageSetArray.remove(at: firstNumber)
            let secondNumber:Int = Int(arc4random_uniform(UInt32(imageSetArray.count)))
            secondArray = imageSetArray[secondNumber]
            imageSetArray.remove(at: secondNumber)
            print("2", secondArray)
            let thirdNumber:Int = Int(arc4random_uniform(UInt32(imageSetArray.count)))
            thirdArray = imageSetArray[thirdNumber]
            imageSetArray.remove(at: thirdNumber)
            let fourthNumber:Int = Int(arc4random_uniform(UInt32(imageSetArray.count)))
            fourthArray = imageSetArray[fourthNumber]
            imageSetArray.remove(at: fourthNumber)
            
            if firstArray == "surstroming" || firstArray == "IKEA Grodan" || firstArray == "Paskmust"{
                firstIntForCount = 6
            } else if firstArray == "Katten" {
                firstIntForCount = 8
            } else if firstArray == "Vinterpojken" || firstArray == "Bamse" {
                firstIntForCount = 10
            } else if firstArray == "Jultomten" {
                firstIntForCount = 16
            }//end of if
            
            for i in 0..<firstIntForCount {
                firstCurrentAnimationImages.append(UIImage(named: "\(firstArray)\(i)")!)
            }
            
            buttons[0].setImage(firstCurrentAnimationImages[0], for: .normal)
            buttons[0].imageView!.animationImages = firstCurrentAnimationImages
            buttons[0].imageView!.animationDuration = 1.0
            buttons[0].imageView!.startAnimating()
            
            if secondArray == "surstroming" || secondArray == "IKEA Grodan" || secondArray == "Paskmust"{
                secondIntForCount = 6
            } else if secondArray == "Katten" {
                secondIntForCount = 8
            } else if secondArray == "Vinterpojken" || secondArray == "Bamse"{
                secondIntForCount = 10
            } else if secondArray == "Jultomten" {
                secondIntForCount = 16
            }//end of if
            
            for i in 0..<secondIntForCount {
                
                secondCurrentAnimationImages.append(UIImage(named: "\(secondArray)\(i)")!)
                
            }
            
            buttons[1].setImage(secondCurrentAnimationImages[0], for: .normal)
            buttons[1].imageView!.animationImages = secondCurrentAnimationImages
            buttons[1].imageView!.animationDuration = 1.0
            buttons[1].imageView!.startAnimating()
            
            
            if thirdArray == "surstroming" || thirdArray == "IKEA Grodan" || thirdArray == "Paskmust"{
                thirdIntForCount = 6
            } else if thirdArray == "Katten"  {
                thirdIntForCount = 8
            } else if thirdArray == "Vinterpojken" || thirdArray == "Bamse" {
                thirdIntForCount = 10
            } else if thirdArray == "Jultomten" {
                thirdIntForCount = 16
            }//end of if
            
            for i in 0..<thirdIntForCount {
                
                thirdCurrentAnimationImages.append(UIImage(named: "\(thirdArray)\(i)")!)
                
            }
            
            buttons[2].setImage(thirdCurrentAnimationImages[0], for: .normal)
            buttons[2].imageView!.animationImages = thirdCurrentAnimationImages
            buttons[2].imageView!.animationDuration = 1.0
            buttons[2].imageView!.startAnimating()
            
            if fourthArray == "surstroming" || fourthArray == "IKEA Grodan" || fourthArray == "Paskmust"{
                fourthIntForCount = 6
            }else if fourthArray == "Katten"  {
                fourthIntForCount = 8
            } else if fourthArray == "Vinterpojken" || fourthArray == "Bamse" {
                fourthIntForCount = 10
            } else if fourthArray == "Jultomten" {
                fourthIntForCount = 16
            }//end of if
            
            for i in 0..<fourthIntForCount {
                
                fourthCurrentAnimationImages.append(UIImage(named: "\(fourthArray)\(i)")!)
                
            }
            
            buttons[3].setImage(fourthCurrentAnimationImages[0], for: .normal)
            buttons[3].imageView!.animationImages = fourthCurrentAnimationImages
            buttons[3].imageView!.animationDuration = 1.0
            buttons[3].imageView!.startAnimating()
            
        } else if mainTypeString == "Images" {

            let imageTypeArray = [
                "Celebs", "Random"
            ]
            //randomize image
            let imageTypeInt:Int = Int(arc4random_uniform(UInt32(imageTypeArray.count)))
            specialTypeString = imageTypeArray[imageTypeInt]

            if specialTypeString == "Celebs" {
            
                answersArray = [
                    //Celebrities
                    "Avicii",
                    "Zlatan",
                    "Alexander Parleros",
                    "Petter Egnefors",
                    "Tom Ljungqvist",
                    "Alex Schulman",
                    "Sigge Eklund",
                    "Lucas Simonsson",
                    "Oscar Linner",
                    "JacquesThomasOscar",
                    "Douglas Bergqvist",
                    "Noel Flike",
                    "Zara Larsson",
                    "Nathalie Danielsson",
                    "Theo Haraldsson",
                    "Astrid Lindgren",
                    "Linn Ahlborg",
                    "Jon Olsson",
                    "Bianca Wahlgren Ingrosso",
                    "Kenza",
                    "Vlad Reiser",
                    "Therese Lindgren",
                    "Sampe v2",
                    "Jocke & Jonna",
                    "Samir Badran",
                    "Hedvig Lindahl",
                ]

            } else if specialTypeString == "Random" {
                
                answersArray = [
                    //companies
                    "Spotify", "King", "SF", "Triumf Glass", "Metro", "H&M",
                    //sport clubs
                    "IF Elfsborg", "KSSS", "IK Sirius", "Ludvika",
                    //random:
                    "Kebabpizza", "Polkagris", "Semla", "Kalles Kaviar Kalle", "Zlatan", "Ostmacka", "Pippi", "Skalman", "bamse",
                ]
               
            }
            
            //randomize image
            let firstRandom:Int = Int(arc4random_uniform(UInt32(answersArray.count)))
            firstItem = self.answersArray[firstRandom] as! String
            answersArray.remove(at: firstRandom)
            let secondRandom:Int = Int(arc4random_uniform(UInt32(answersArray.count)))
            secondItem = self.answersArray[secondRandom] as! String
            answersArray.remove(at: secondRandom)
            let thirdRandom:Int = Int(arc4random_uniform(UInt32(answersArray.count)))
            thirdItem = self.answersArray[thirdRandom] as! String
            answersArray.remove(at: thirdRandom)
            let fourthRandom:Int = Int(arc4random_uniform(UInt32(answersArray.count)))
            fourthItem = self.answersArray[fourthRandom] as! String
            
            buttons[0].setImage(UIImage(named: firstItem), for: .normal)
            buttons[1].setImage(UIImage(named: secondItem), for: .normal)
            buttons[2].setImage(UIImage(named: thirdItem), for: .normal)
            buttons[3].setImage(UIImage(named: fourthItem), for: .normal)
            
        } /*
             MARK: THIS LEVEL HAS NOT BEEN INCLUDED IN THE LATEST VERSION
             else if mainTypeString == "Numbers" {
            
            //change tint/background color to match country's e.g. Sweden = blue and yellow

            repeat {
                numberA = Int(arc4random_uniform(10))
            } while numberA == 0
            repeat {
                numberB = Int(arc4random_uniform(10))
            } while numberB == 0
            correctSum = numberA + numberB
            repeat {
                falseSum1 = Int(arc4random_uniform(20))
            } while correctSum == falseSum1
            repeat {
                falseSum2 = Int(arc4random_uniform(20))
            } while correctSum == falseSum2
            repeat {
                falseSum3 = Int(arc4random_uniform(20))
            } while correctSum == falseSum3
 
            taskLabel.text = "\(numberA) + \(numberB) = ?"
            
        }*/ else if mainTypeString == "Orientation Change" {
            
            //add the observer
            NotificationCenter.default.addObserver(self, selector: (#selector(GameVC.orientationChanged(notification:))), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
            
            taskLabel.text = "Vänd 📱 (går ej med på skärmlås)"
            taskLabel.numberOfLines = 2
            leftTopBtnWidthConstraint.constant = 0
            leftTopBtnHeightConstraint.constant = 0
            leftTopBtnWidthConstraint.priority = UILayoutPriority(rawValue: 1000)
            leftTopBtnHeightConstraint.priority = UILayoutPriority(rawValue: 1000)

            //animating images
            for i in 0..<7 {
                motionAnimationImages.append(UIImage(named: "rotate\(i)")!)//"\(direction)\(i)")
            }
            buttons[0].setImage(self.motionAnimationImages[0], for: .normal)
            buttons[0].imageView!.animationImages = motionAnimationImages
            buttons[0].imageView!.animationDuration = 2.5
            buttons[0].imageView!.startAnimating()
            buttons[0].isEnabled = false
            buttons[1].isEnabled = false
            buttons[2].isEnabled = false
            buttons[3].isEnabled = false
            buttons[1].isHidden = true
            buttons[2].isHidden = true
            buttons[3].isHidden = true

        } else if mainTypeString == "Button Tap" {
            
            //randomize int
            tapCount = Int(arc4random_uniform(15)+10)
            startTapCount = tapCount
            
            print("tapCount", tapCount)
            buttonTapUpdate()
            
            //randomize bigger/type
            let bigRandArray = ["Dansk", "Norsk"]
            let bigRange: UInt32 = UInt32(bigRandArray.count)
            let randomNumber = Int(arc4random_uniform(bigRange))
            buttonTapNationality = bigRandArray[randomNumber] //the nationality
            print("buttonTapNationality =", buttonTapNationality)
            
            if buttonTapNationality == "Dansk" {
                taskLabel.text = "Besegra dansken 🇩🇰"
                buttons[0].setBackgroundImage((UIImage(named: "Dansk1")), for: .normal)
                
            } else if buttonTapNationality == "Norsk" {
                taskLabel.text = "Besegra norrmannen 🇳🇴"
                buttons[0].setBackgroundImage((UIImage(named: "Norsk1")), for: .normal)
            }
            leftTopBtnWidthConstraint.constant = 0
            leftTopBtnHeightConstraint.constant = 0
            leftTopBtnWidthConstraint.priority = UILayoutPriority(rawValue: 1000)
            leftTopBtnHeightConstraint.priority = UILayoutPriority(rawValue: 1000)
            
            buttons[1].isEnabled = false
            buttons[2].isEnabled = false
            buttons[3].isEnabled = false
            buttons[1].isHidden = true
            buttons[2].isHidden = true
            buttons[3].isHidden = true
            
        }else if mainTypeString == "Button Pattern" {
            
            //randomize int
            let firstRandom:Int = Int(arc4random_uniform(UInt32(patternArray.count)))
            firstItem = patternArray[firstRandom] 
            patternArray.remove(at: firstRandom)
            let secondRandom:Int = Int(arc4random_uniform(UInt32(patternArray.count)))
            secondItem = patternArray[secondRandom] 
            patternArray.remove(at: secondRandom)
            let thirdRandom:Int = Int(arc4random_uniform(UInt32(patternArray.count)))
            thirdItem = patternArray[thirdRandom] 
            patternArray.remove(at: thirdRandom)
            let fourthRandom:Int = Int(arc4random_uniform(UInt32(patternArray.count)))
            fourthItem = patternArray[fourthRandom]
            
            taskLabel.text = "\(firstItem) ▶︎ \(secondItem) ▶︎ \(thirdItem) ▶︎ \(fourthItem)"
            for i in 0..<buttons.count {
                buttons[i].titleLabel?.setSizeFont(sizeFont: 60)
            }
            
        }else if mainTypeString == "Button Quick" {

            for i in 0..<self.buttons.count {
                buttons[i].backgroundColor = UIColor.white
            }
            
            let chooseColourArray = [UIColor().SwedenYellow(), UIColor().SwedenBlue()]
            let randomColourInt:Int = Int(arc4random_uniform(UInt32(chooseColourArray.count)))
            randomColour = chooseColourArray[randomColourInt]

                var colourName = String()
                if randomColour == UIColor().SwedenYellow() {
                    colourName = "Gula"
                } else if randomColour == UIColor().SwedenBlue() {
                    colourName = "Blåa"
                }
            
            taskLabel.text = "Tryck alla knappar \(colourName.uppercased())"
            
        } else if mainTypeString == "Pan Gesture" {
        
            //https://github.com/arvindhsukumar/PanGestureView
            //see buttom "fileprivate" for functions
            panGestureView.isHidden = false
            self.edgesForExtendedLayout = UIRectEdge()
            setupViews()
            setupActions()
            playView.isHidden = true
            taskLabel.text = ""
            
        } else if mainTypeString == "KYC" {

            configureStarProgress()
            buttons[3].setTitle("Hastighet\n\(lightCount)🖍", for: .normal)
            buttons[3].titleLabel?.numberOfLines = 2
            buttons[3].titleLabel?.textAlignment = .center
            buttons[3].titleLabel?.backgroundColor = UIColor().SwedenBlue()
            buttons[3].titleLabel?.setSizeFont(sizeFont: 50)
            buttons[3].contentMode = .bottomRight
            buttons[3].layer.zPosition = 6;
            //buttons[3].layer.borderColor = UIColor().SwedenYellow().cgColor
            //buttons[3].layer.borderWidth = 2
            //buttons[3].backgroundColor = UIColor().SwedenBlue()
            taskLabel.text = "Öka hastigheten 🖍"
            rightBottomBtnWidthConstraint.constant = 500
            rightBottomBtnHeightConstraint.constant = 300
            
            //incorrect tap attempt
            let touch = UITapGestureRecognizer(target: self, action: #selector(GameVC.swipeIncorrectTouch))
            touch.numberOfTapsRequired = 1
            touch.numberOfTouchesRequired = 1
            buttons[0].addGestureRecognizer(touch)
            
            //enabling right Bottom btn only
           for i in 1..<3 {
                buttons[i].isEnabled = false
                buttons[i].isHidden = true
            }
            
        } else if mainTypeString == "Core Motion" {
            // http://nshipster.com/cmdevicemotion/
        
            //set buttons
            for i in 1..<buttons.count {
                buttons[i].isEnabled = false
                buttons[i].isEnabled = false
                buttons[i].isHidden = true
            }
            //set buttons[0]s constraints
            leftTopBtnWidthConstraint.constant = 0
            leftTopBtnHeightConstraint.constant = 0
            leftTopBtnWidthConstraint.priority = UILayoutPriority(rawValue: 1000)
            leftTopBtnHeightConstraint.priority = UILayoutPriority(rawValue: 1000)
            
            let typeArray = ["myggorna", "getingarna"]
            let range: UInt32 = UInt32(typeArray.count)
            let randomNumber = Int(arc4random_uniform(range))
            let type = typeArray[randomNumber]
            print("type =", type)
            
            if type == "myggorna" {
                for i in 0..<2 {
                    motionAnimationImages.append(UIImage(named: "mosquito-preshake\(i)")!)//"\(direction)\(i)")
                }
            } else if type == "getingarna" {
                for i in 0..<2 {
                    motionAnimationImages.append(UIImage(named: "bee-preshake\(i)")!)//"\(direction)\(i)")
                }
            }
            
            buttons[0].titleLabel?.setSizeFont(sizeFont: 15)
            taskLabel.text = "Skaka bort \(type) åt 👈"
            //cheering label
           /* cheerLabel = UILabel(frame: taskLabel.frame)
            cheerLabel.font =  UIFont(name: "YanoneKaffeesatz-Bold", size: 20)
            cheerLabel.center.y = taskLabel.frame.maxY + (cheerLabel.frame.height/3)
            cheerLabel.center.x = view.center.x
            cheerLabel.textAlignment = .center
            playView.addSubview(cheerLabel)*/
            
            //animating images
            buttons[0].setImage(self.motionAnimationImages[0], for: .normal)
            buttons[0].imageView!.animationImages = motionAnimationImages
            buttons[0].imageView!.animationDuration = 0.6
            buttons[0].imageView!.startAnimating()

            //look after motion
            if motionManager.isDeviceMotionAvailable {
                motionManager.deviceMotionUpdateInterval = 0.02
                motionManager.startDeviceMotionUpdates(to: .main) {
                        [weak self] (data: CMDeviceMotion?, error: Error?) in
                    
                     if let scoreX = data?.userAcceleration.x,
                        scoreX < -2.2 {
                        //the user completes the level
                        if type == "myggorna" {
                            for i in 0..<5 {
                                self?.motionAnimationImages.append(UIImage(named: "mosquito-shake\(i)")!)//"\(direction)\(i)")
                            }
                        } else if type == "getingarna" {
                            for i in 0..<5 {
                                self?.motionAnimationImages.append(UIImage(named: "bee-shake\(i)")!)//"\(direction)\(i)")
                            }
                        }
                            self?.buttons[0].imageView!.animationImages = self?.motionAnimationImages
                            self?.buttons[0].imageView!.animationDuration = 0.7
                            self?.buttons[0].imageView!.animationRepeatCount = 1
                            self?.buttons[0].imageView!.startAnimating()

                            self?.perform(#selector(self?.correctAnswerWithDelay), with: nil, afterDelay: 0.5)
                            self?.motionManager.stopDeviceMotionUpdates()
                        }
                    
                    /* //ATTEMPT AT MAKING AN INTERACTIVE LABEL TO WHEN THE USER SHAKES TO WEAKLY
                        if let lowX = data?.userAcceleration.x,
                            lowX > -2 && lowX < -0.4 {
                            print("too low", lowX)
                            //randomize cheering
                            let cheerArray = ["Harder!😇", "Shake harder!😅", "One more time!🙏", "Try again!😬", "Shake that one more time!👯‍♂️", "You're stronger than that!💪", "Give it another try!💥", "You can shake harder!🙄", "\"Everybody look to the LEFT...\"👈🎶", ]
                            let firstNumber:Int = Int(arc4random_uniform(9))
                            self?.cheerLabel.text = cheerArray[firstNumber]
                            
                            }*/
                    }
            }//end of motionManager
            
        } /*else if mainTypeString == "Add 1" {
            //MARK: THIS LEVEL HAS NOT BEEN INCLUDED IN THE LATEST VERSION --> "Numbers" has been removed from all below levels

            //start number label
            let startNLabel = UILabel(frame: taskLabel.frame)
            startNLabel.center.y = taskLabel.frame.maxY + (startNLabel.frame.height/3)
            startNLabel.center.x = view.center.x
            startNLabel.textAlignment = .center
            view.addSubview(startNLabel)
            startNLabel.text = generateRandom3Number()
            startNumber = Int(startNLabel.text!)!
            
            //input number textField
            inputField = UITextField(frame: taskLabel.frame)
            inputField?.font =  UIFont(name: "YanoneKaffeesatz-Bold", size: 15)
            inputField?.center.y = startNLabel.frame.maxY + ((inputField?.frame.height)!/3)
            inputField?.center.x = view.center.x
            inputField?.textAlignment = .center
            inputField?.layer.borderColor = UIColor.lightGray.cgColor
            inputField?.layer.borderWidth = 3
            inputField?.keyboardType = .numberPad
            inputField?.becomeFirstResponder()
            inputField?.keyboardAppearance = .alert
            view.addSubview(inputField!)
            
            inputField?.addTarget(self, action: #selector(textFieldDidChange(textField:)), for:UIControlEvents.editingChanged)
            taskLabel.text = "Add +1 to every digit"

        }*/
        else if mainTypeString == "Find hidden" {
            
            //randomize background colours
            var correctArray = [UIColor().SwedenYellow(), UIColor().SwedenBlue()]
            let colourInt:Int = Int(arc4random_uniform(UInt32(correctArray.count)))
            randomColour = correctArray[colourInt]
            
            var chooseColourArray = [UIColor.green, UIColor.darkGray, UIColor.purple, UIColor.red, UIColor.brown]
            let randomColourInt2:Int = Int(arc4random_uniform(UInt32(chooseColourArray.count)))
            randomColour2 = chooseColourArray[randomColourInt2]
            chooseColourArray.remove(at: randomColourInt2)
            let randomColourInt3:Int = Int(arc4random_uniform(UInt32(chooseColourArray.count)))
            randomColour3 = chooseColourArray[randomColourInt3]
            chooseColourArray.remove(at: randomColourInt3)
            let randomColourInt4:Int = Int(arc4random_uniform(UInt32(chooseColourArray.count)))
            randomColour4 = chooseColourArray[randomColourInt4]
            
        } /*else if mainTypeString == "Run a lap" {
             //MARK: THIS LEVEL HAS NOT BEEN INCLUDED IN THE LATEST VERSION --> "Numbers" has been removed from all below levels
            
            //a runner (CELEBRITY) who's supposed to run around a circle path and button within the cirlce to similates the speed of the runner.
            
            //add container (presented differently on different devices -> works on all like this, comprimised)
            animateImageView.frame.size.width = buttons[0].frame.width * 1.3
            animateImageView.frame.size.height = buttons[0].frame.height * 1.5
            animateImageView.center.x = buttons[3].frame.minX
            animateImageView.center.y = buttons[3].frame.minY 
            animateImageView.backgroundColor = .cyan
            playView.addSubview(animateImageView)
            
            // add background container
           /* let container = UIView(frame: CGRect(x: playView.center.x, y: playView.center.y, width: playView.frame.width, height: playView.frame.width))
            container.backgroundColor = UIColor(white: 0.8, alpha: 0.7)
            container.autoresizingMask = [UIViewAutoresizing.flexibleLeftMargin, UIViewAutoresizing.flexibleRightMargin, UIViewAutoresizing.flexibleTopMargin, UIViewAutoresizing.flexibleBottomMargin]
            //container.backgroundColor = .cyan
            playView.addSubview(container)*/

            //path for the animation
            let path = UIBezierPath(arcCenter: animateImageView.center, radius: CGFloat((playView.frame.height)/2), startAngle: CGFloat(Double.pi), endAngle: CGFloat(9.5), clockwise: true)
            
            // add the runner image
            runnerImageview = UIImageView(frame: CGRect(x: 0, y: 0, width: buttons[1].frame.width/4, height: buttons[1].frame.height/4))
            runnerImageview.backgroundColor = UIColor.red
            runnerImageview.alpha = 1
            runnerImageview.center.y = animateImageView.center.y
            runnerImageview.center.x = animateImageView.center.x
            animateImageView.addSubview(runnerImageview)
            runnerImageview.layer.zPosition = 1;
            animateImageView.addSubview(runnerImageview)
            
            //add layer "running track"
            let layer = CAShapeLayer()
            layer.path = path.cgPath
            layer.strokeColor = UIColor.brown.cgColor
            layer.lineWidth = runnerImageview.frame.width
            layer.fillColor = UIColor.clear.cgColor
            animateImageView.layer.addSublayer(layer)
            layer.superlayer?.zPosition = 10;
            
            //add button
            runButton = UIButton(frame: CGRect(x: 0, y: 0, width: runnerImageview.frame.width*2, height: runnerImageview.frame.height*2))
            runButton.layer.borderColor = UIColor.lightGray.cgColor
            runButton.layer.borderWidth = 5
            runButton.layer.cornerRadius = 10
            runButton.backgroundColor = UIColor.red
            runButton.center = animateImageView.center
            runButton.addTarget(self, action: #selector(GameVC.runALapButton), for: .touchUpInside)
            animateImageView.addSubview(runButton)
            
            //the animation
            runnerKeyFrameAnimation = CAKeyframeAnimation(keyPath:"position")
            runnerKeyFrameAnimation.path = path.cgPath
            runnerKeyFrameAnimation.duration = 1.0
            runnerKeyFrameAnimation.fillMode = kCAFillModeForwards
            runnerKeyFrameAnimation.isRemovedOnCompletion = false
            
            //randomize the amount of laps
            randomLaps = Int(arc4random_uniform(1)+2)
            taskLabel.text = "Run \(randomLaps) laps"
            
        }*/ else if mainTypeString == "Doesn't fit" {
            
                alphaArray = [
                //swedish images
                    //companies
                    "Spotify", "King", "SF", "Triumf Glass", "Metro", "H&M",
                    //Celebrities
                    "Avicii",
                    "Zlatan",
                    "Alexander Parleros",
                    "Petter Egnefors",
                    "Tom Ljungqvist",
                    "Alex Schulman",
                    "Sigge Eklund",
                    "Lucas Simonsson",
                    "Oscar Linner",
                    "JacquesThomasOscar",
                    "Douglas Bergqvist",
                    "Noel Flike",
                    "Zara Larsson",
                    "Nathalie Danielsson",
                    "Theo Haraldsson",
                    "Astrid Lindgren",
                    "Jacob Öberg",
                    "Linn Ahlborg",
                    "Jon Olsson",
                    "Bianca Wahlgren Ingrosso",
                    "Kenza",
                    "Vlad Reiser",
                    "Therese Lindgren",
                    "Sampe v2",
                    "Jocke & Jonna",
                    "Samir Badran",
                    "Hedvig Lindahl",
                    
                    //sport clubs
                    "IF Elfsborg", "KSSS", "IK Sirius", "Ludvika",
                    //foods
                    "Kebabpizza", "Polkagris", "Semla", "Julmust", "Ostmacka",
                    "bamse",
                ]
                betaArray = [
                //non-swedish images
                    //companies
                    "Airbnb", "Dropbox", "Linkedin", "Pinterest", "Twitter", "Zalando", "Lego", "Telenor",
                    //Celebrities
                    "Albert Einstein", "Beyonce", "Kim Kardashian", "Rihanna", "Emma Watson", "Yoda", "Marilyn Monroe", "Steve Jobs", "Elvis Presley",
                    //sport clubs
                    "Aalborg", "Rosenborg BK", "Fulham",
                    //foods
                    "Pizza", "Sushi",
                ]
            
            let typeArray = ["Not Swedish", "Swedish"]
            let range: UInt32 = UInt32(typeArray.count)
            let randomNumber = Int(arc4random_uniform(range))
            let type = typeArray[randomNumber]
            print("type =", type)
            
            if type == "Swedish" {
                //the player is supposed to press on thing which IS SWEDISH
                taskLabel.text = "Vad ÄR svenskt?"
                
                //3 non-swedish stuff
                let oneRange: UInt32 = UInt32(betaArray.count)
                let oneRandomNumber = Int(arc4random_uniform(oneRange))
                oneSame = betaArray[oneRandomNumber]
                betaArray.remove(at: oneRandomNumber)
                let secondRange: UInt32 = UInt32(betaArray.count)
                let secondRandomNumber = Int(arc4random_uniform(secondRange))
                secondSame = betaArray[secondRandomNumber]
                betaArray.remove(at: secondRandomNumber)
                let thirdRange: UInt32 = UInt32(betaArray.count)
                let thirdRandomNumber = Int(arc4random_uniform(thirdRange))
                thirdSame = betaArray[thirdRandomNumber]
                betaArray.remove(at: thirdRandomNumber)
                
                //1 different
                let differentRange: UInt32 = UInt32(alphaArray.count)
                let differentRandomNumber = Int(arc4random_uniform(differentRange))
                oneDifferent = alphaArray[differentRandomNumber]
                
            } else if type == "Not Swedish" {
                //the player is supposed to press on thing which ISN'T SWEDISH
                taskLabel.text = "Vad är INTE svenskt?"
                
                //3 swedish stuff
                let oneRange: UInt32 = UInt32(alphaArray.count)
                let oneRandomNumber = Int(arc4random_uniform(oneRange))
                oneSame = alphaArray[oneRandomNumber]
                alphaArray.remove(at: oneRandomNumber)
                let secondRange: UInt32 = UInt32(alphaArray.count)
                let secondRandomNumber = Int(arc4random_uniform(secondRange))
                secondSame = alphaArray[secondRandomNumber]
                alphaArray.remove(at: secondRandomNumber)
                let thirdRange: UInt32 = UInt32(alphaArray.count)
                let thirdRandomNumber = Int(arc4random_uniform(thirdRange))
                thirdSame = alphaArray[thirdRandomNumber]
                alphaArray.remove(at: thirdRandomNumber)
                
                //1 different
                let differentRange: UInt32 = UInt32(betaArray.count)
                let differentRandomNumber = Int(arc4random_uniform(differentRange))
                oneDifferent = betaArray[differentRandomNumber]
                
            }
        
        } else if mainTypeString == "End sentence" {
            
            //randomize bigger/type
            let bigRandArray = ["Proverbs", "Location", "Which", "Songs"] //locations? + "Who" (vem gjorde detta/föddes där..etc), "Which" ("vilken tv-kanal sände/vilken kommun är sveriges rikaste")
            let bigRange: UInt32 = UInt32(bigRandArray.count)
            let randomNumber = Int(arc4random_uniform(bigRange))
            let typeRandom = bigRandArray[randomNumber]

            //set bigger/type of questions
            //10 of each in each answersArray
            if typeRandom == "Proverbs" {
            
                answersArray = [
                    endSentence(question: "🗣\"Nära skjuter ingen...\"", correct: "hare", false1: "ekorre", false2: "gubbe", false3: "kanin"),
                    endSentence(question: "🗣\"Alla känner apan, apan känner...\"", correct: "ingen", false1: "Zlatan", false2: "någon", false3: "alla"),
                    endSentence(question: "🗣\"Anfall är bästa...\"", correct: "försvar", false1: "taktiken", false2: "sättet", false3: "turen"),
                    endSentence(question: "🗣\"Ett gott skratt förlänger...\"", correct: "livet", false1: "rasten", false2: "tungan", false3: "stunden"),
                    endSentence(question: "🗣\"Man kan inte lära en gammal hund att...\"", correct: "sitta", false1: "springa", false2: "hoppa", false3: "skratta"),
                    endSentence(question: "🗣\"Ärlighet varar...\"", correct: "längst", false1: "nu", false2: "kortast", false3: "bäst"),
                    endSentence(question: "🗣\"Bara döda fiskar följer...\"", correct: "strömmen", false1: "hästen", false2: "kroken", false3: "gäddan"),
                    endSentence(question: "🗣\"Bättre sent än...\"", correct: "aldrig", false1: "nu", false2: "inget", false3: "tidigt"),
                    endSentence(question: "🗣\"Det finns inget dåligt väder, bara dåliga...\"", correct: "kläder", false1: "humör", false2: "dagar", false3: "ursäkter"),
                    endSentence(question: "🗣\"Genvägar är ofta..\"", correct: "senvägar", false1: "genvägar", false2: "bra", false3: "smarta"),
                ]
            
            } else if typeRandom == "Location" {
                
                answersArray = [
                    endSentence(question: "❔Astrid Lindgren föddes i...", correct: "Småland", false1: "Skåne", false2: "Göteborg", false3: "Stockholm"),
                    endSentence(question: "❔Zlatan föddes i...", correct: "Malmö", false1: "Luleå", false2: "Göteborg", false3: "Halmstad"),
                    endSentence(question: "❔Kent (musikgruppen) kommer från...", correct: "Eskilstuna", false1: "Örebro", false2: "Norrköping", false3: "Stockholm"),
                    endSentence(question: "❔Sveriges första pizzeria öppnas i...", correct: "Stockholm", false1: "Malmö", false2: "Halmstad", false3: "Jönköping"),
                    endSentence(question: "❔Sveriges första motorväg byggdes i...", correct: "Skåne", false1: "Norrland", false2: "Småland", false3: "Gästrikland"),
                    endSentence(question: "❔Sveriges största ö är...", correct: "Gotland", false1: "Öland", false2: "Lidingö", false3: "Hisingen"),
                    endSentence(question: "❔Börje Salming föddes i...", correct: "Kiruna", false1: "Stockholm", false2: "Sundsvall", false3: "Borlänge"),
                    endSentence(question: "❔Första svenska fotbollsmatchen spelades på...", correct: "Heden (Göteborg)", false1: "Råsunda (Stockholm)", false2: "Tunavallen (Eskilstuna)", false3: "Rimnersvallen (Uddevalla)"),
                    endSentence(question: "❔Sveriges första stad var...", correct: "Birka", false1: "Stockholm", false2: "Visby", false3: "Uppåkra"),
                    endSentence(question: "❔Zara Larsson föddes i...", correct: "Stockholm", false1: "Södertälje", false2: "Uppsala", false3: "Örebro"),

                ]
            } else if typeRandom == "Which" {
                
                answersArray = [
                    endSentence(question: "❔\"Let's Dance\" visas på...", correct: "TV4", false1: "SVT1", false2: "Kanal 5", false3: "TV10"),
                    endSentence(question: "❔Herrfotbollslandslaget vann VM-brons år...", correct: "1994", false1: "1958", false2: "2002", false3: "1970"),
                    endSentence(question: "❔Björn Borg vann ... Wimbledon-titlar", correct: "5", false1: "7", false2: "2", false3: "0"),
                    endSentence(question: "❔Sveriges största dagstidning är...", correct: "Metro", false1: "Aftonbladet", false2: "Dagens Nyheter", false3: "Göteborgs-Posten"),
                    endSentence(question: "❔Svenska blev Sveriges officiella språk år...", correct: "2009", false1: "1879", false2: "1450", false3: "1955"),
                    endSentence(question: "❔Julbocken i Gävle som brinner varje år heter...", correct: "Gävlebocken", false1: "Den brinnande julbocken", false2: "Eldbocken", false3: "Sverigebocken"),
                    endSentence(question: "❔Dagen Sverige bytte från vänster- till högertrafik kallades...", correct: "Dagen H", false1: "Domedagen", false2: "Bilkrockdagen", false3: "Tänk efter-dagen"),
                    endSentence(question: "❔Vilket företag hade ett högre värde än Sverige år 2015?", correct: "Apple", false1: "Volvo", false2: "IKEA", false3: "H&M"),
                    endSentence(question: "❔Sveriges dödligaste djur är...", correct: "Getingen", false1: "Björnen", false2: "Räven", false3: "Älgen"),
                    endSentence(question: "❔På engelska översätts \"Lagom\" till...", correct: "Det finns ingen översättning", false1: "Enough", false2: "Perfect", false3: "Just right"),
                    
                ]
            } else if typeRandom == "Songs" {
                
                answersArray = [
                    endSentence(question: "🎶\"Hej tomtegubbar slår i ... och låt det lustiga vara!\"", correct: "glasen", false1: "bordet", false2: "väggen", false3: "gröten"),
                    endSentence(question: "🎶\"Hej hej ...\"", correct: "Monika", false1: "Sanna", false2: "Bertil", false3: "Ebba"),
                    endSentence(question: "🎶\"Ett fel närmare...\"", correct: "rätt", false1: "ljuset", false2: "helheten", false3: "pajen"),
                    endSentence(question: "🎶\"Den som ... han har\"", correct: "spar", false1: "springer", false2: "hoppas", false3: "köper"),
                    endSentence(question: "🎶\"Små grodorna, små grodorna är ... att se\"", correct: "lustiga", false1: "härliga", false2: "roliga", false3: "fina"),
                    endSentence(question: "🎶\"... raskar över isen\"", correct: "Räven", false1: "Björnen", false2: "Haren", false3: "Hästen"),
                    endSentence(question: "🎶\"Den ... nu kommer med lust och fägring stor.\"", correct: "blomstertid", false1: "fina sommaren", false2: "kvällen", false3: "dagen"),
                    endSentence(question: "🎶\"Du gamla du...\"", correct: "fria", false1: "sköna", false2: "fina", false3: "lustiga"),
                    endSentence(question: "🎶\"Sjung om studentens ... dag\"", correct: "lyckliga", false1: "fina", false2: "bästa", false3: "roliga"),
                    endSentence(question: "🎶\"I en ... helikopter ska jag flyga hem till dig\"", correct: "rosa", false1: "blå", false2: "snabb", false3: "fin"),
                ]
            }
            
            //randomize the final struct
            let range: UInt32 = UInt32(answersArray.count)
            let random = Int(arc4random_uniform(range))
            choosenSentenceStruct = answersArray[random] as! GameVC.endSentence
            taskLabel.text = "\(choosenSentenceStruct.question)"
            //taskLabel.text = "❔Dagen Sverige bytte från vänster- till högertrafik kallades..." //longest question
            for i in 0..<buttons.count {
                buttons[i].titleLabel?.setSizeFont(sizeFont: 40)
                buttons[i].titleLabel?.numberOfLines = 3
                buttons[i].titleLabel?.textAlignment = .center
            }
            taskLabel.setSizeFont(sizeFont: 30)
            taskLabel.numberOfLines = 3

        } else if mainTypeString == "Long Press" {
            //Build IKEA möbler
            
            //add container (presented differently on different devices -> works on all like this, comprimised)
            animateImageView.frame.size.width = buttons[0].frame.width * 1.3
            animateImageView.frame.size.height = buttons[0].frame.height * 1.5
            animateImageView.center.x = buttons[3].frame.minX - 60
            animateImageView.center.y = buttons[3].frame.minY - 10
            //animateImageView.backgroundColor = .cyan
            playView.addSubview(animateImageView)
            
            //get the user to "build something through long pressing the button for three sec -> e.g. the ikea
            //leftTopBtnWidthConstraint.constant = 0
            //leftTopBtnHeightConstraint.constant = 0
            //leftTopBtnWidthConstraint.priority = UILayoutPriority(rawValue: 1000)
            //leftTopBtnHeightConstraint.priority = UILayoutPriority(rawValue: 1000)
            buttons[0].isEnabled = false
            buttons[1].isEnabled = false
            buttons[2].isEnabled = false
            //buttons[3].isEnabled = false
            buttons[0].imageView?.contentMode = .topLeft
            buttons[3].contentMode = .bottomRight
            buttons[3].removeTarget(self, action: #selector(GameVC.rightBottomTapped(_:)), for: .touchUpInside)
            
            //animation images
            var imageSetArray = [//alla
                 "treeLeg", "stool", "chair", "table", "midsommarstang",
            ]
            
            //randomize image array
            let firstNumber:Int = Int(arc4random_uniform(UInt32(imageSetArray.count)))
            specialTypeString = imageSetArray[firstNumber]
            
            for i in 0..<6 {
                firstCurrentAnimationImages.append(UIImage(named: "\(specialTypeString)\(i)")!)
            }
            
            //set image
            animateImageView.image = firstCurrentAnimationImages[0]
            animateImageView.animationImages = firstCurrentAnimationImages
            animateImageView.animationDuration = 3.1 //to be equal to 3 sec (the completeTimer)
            
            //add button --> MAKE IT IKEA ICON!
           /* runButton = UIButton(frame: CGRect(x: buttons[3].frame.midX, y: bannerView.frame.minY, width: taskLabel.frame.width/3, height: taskLabel.frame.height/2))
            runButton.layer.cornerRadius = 10
            runButton.layer.borderWidth = 4
            runButton.layer.borderColor = UIColor.brown.cgColor
            runButton.backgroundColor = UIColor.red
            runButton.alpha = 1
            runButton.setTitle("Bygg", for: .normal)
            runButton.center.y = taskLabel.center.y
            let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(GameVC.longPressBuild))
            longGesture.minimumPressDuration = 0.1
            runButton.addGestureRecognizer(longGesture)
            view.addSubview(runButton)*/
            
            if specialTypeString == "midsommarstang" {
                buttons[3].setTitle(" RES💪 ", for: .normal)
                taskLabel.text = "Håll in & RES midsommarstången🇸🇪"
            } else {
                buttons[3].setTitle(" BYGG🔨 ", for: .normal)
                taskLabel.text = "Håll in & BYGG ihop IKEA-möbeln🇸🇪"
            }
            buttons[3].titleLabel?.numberOfLines = 2
            buttons[3].titleLabel?.textAlignment = .center
            buttons[3].titleLabel?.backgroundColor = UIColor().SwedenBlue()
            buttons[3].titleLabel?.setSizeFont(sizeFont: 50)
            buttons[3].contentMode = .bottomRight
            let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(GameVC.longPressBuild))
            longGesture.minimumPressDuration = 0.1
            buttons[3].addGestureRecognizer(longGesture)
            //buttons[3].layer.borderColor = UIColor().SwedenYellow().cgColor
            //buttons[3].layer.borderWidth = 2
            //buttons[3].backgroundColor = UIColor().SwedenBlue()
            rightBottomBtnWidthConstraint.constant = 500
            rightBottomBtnHeightConstraint.constant = 300
            
            //enabling right Bottom btn only
            for i in 0..<3 {
                buttons[i].isEnabled = false
                buttons[i].isHidden = true
            }
            
        } else if mainTypeString == "Multiple Tap Button" {
            
            //get user to tap the button several times to create an animation of "something" happening a certain amount of times to complete
            
            //Set the button
            leftTopBtnWidthConstraint.constant = 0
            leftTopBtnHeightConstraint.constant = 0
            leftTopBtnWidthConstraint.priority = UILayoutPriority(rawValue: 1000)
            leftTopBtnHeightConstraint.priority = UILayoutPriority(rawValue: 1000)
            buttons[1].isEnabled = false
            buttons[2].isEnabled = false
            buttons[3].isEnabled = false
            buttons[0].imageView?.contentMode = .scaleAspectFit
            buttons[0].adjustsImageWhenHighlighted = false
            randomLaps = Int(arc4random_uniform(7)+2)

            //animation images
            var imageSetArray = [//alla
                  "snow", "midsommar", "skiing",
            ]
            //randomize image array
            let firstNumber:Int = Int(arc4random_uniform(UInt32(imageSetArray.count)))
            specialTypeString = imageSetArray[firstNumber]
            
            if specialTypeString == "midsommar" {
                buttons[0].setImage((UIImage(named: "midsommar0")), for: .normal)
                taskLabel.text = "Dansa små grodorna \(randomLaps) gånger🐸"
            } else if specialTypeString == "skiing" {
                buttons[0].setImage((UIImage(named: "skiing0")), for: .normal)
                taskLabel.text = "Åk de \(randomLaps) sista metrarna⛷"
            } else if specialTypeString == "snow" {
                buttons[0].setImage((UIImage(named: "snow0")), for: .normal)
                taskLabel.text = "Skotta snö \(randomLaps) gånger🌨"
            }
            
        } else if mainTypeString == "Swipe Gesture" {
            //get user to pan ("drag") on the button several times to create an animation of "something" happening a certain amount of times to complete
            
            //Set the button
            leftTopBtnWidthConstraint.constant = 0
            leftTopBtnHeightConstraint.constant = 0
            leftTopBtnWidthConstraint.priority = UILayoutPriority(rawValue: 1000)
            leftTopBtnHeightConstraint.priority = UILayoutPriority(rawValue: 1000)
            buttons[1].isHidden = true
            buttons[2].isHidden = true
            buttons[3].isHidden = true
            buttons[0].removeTarget(self, action: #selector(GameVC.leftTopTapped(_:)), for: .touchUpInside)
            buttons[0].adjustsImageWhenHighlighted = false
            buttons[0].imageView?.contentMode = .scaleAspectFit
            
            //animation images
            var imageSetArray = [//alla
                "cake", "smorcake", "jordgubbscake"
            ]
            
            //randomize image array
            let firstNumber:Int = Int(arc4random_uniform(UInt32(imageSetArray.count)))
            firstArray = imageSetArray[firstNumber]
            
            for i in 0..<3 {
                firstCurrentAnimationImages.append(UIImage(named: "\(firstArray)\(i)")!)
            }
            
            buttons[0].setImage(firstCurrentAnimationImages[0], for: .normal)
            buttons[0].imageView!.animationImages = firstCurrentAnimationImages
            buttons[0].imageView!.animationDuration = 0.5
            buttons[0].imageView!.animationRepeatCount = 1
            
            randomLaps = Int(arc4random_uniform(3)+2)
            if firstArray == "cake" {
                taskLabel.text = "Skär \(randomLaps) prinsesstårta-bitar🍰"
            } else if firstArray == "smorcake" {
                taskLabel.text = "Skär \(randomLaps) smörgåstårta-bitar🍰"
            } else if firstArray == "jordgubbscake" {
                taskLabel.text = "Skär \(randomLaps) jordgubbstårta-bitar🍰"
            }
            
            //swipe gesture
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(GameVC.SwipeGesture))
            swipeGesture.direction = .down
            swipeGesture.numberOfTouchesRequired = 1
            buttons[0].addGestureRecognizer(swipeGesture)
            
            //incorrect tap attempt
            let touch = UITapGestureRecognizer(target: self, action: #selector(GameVC.swipeIncorrectTouch))
            touch.numberOfTapsRequired = 2
            touch.numberOfTouchesRequired = 1
            buttons[0].addGestureRecognizer(touch)
            
        }else if mainTypeString == "Image Collide" {
            
            //animation images
            var imageSetArray = [//alla
                "horse", "zlatan",
            ]
            //randomize image array
            let firstNumber:Int = Int(arc4random_uniform(UInt32(imageSetArray.count)))
            specialTypeString = imageSetArray[firstNumber]
            
            // add background container
            zlatanHead.frame.size.width = playView.frame.width*0.8
            zlatanHead.frame.size.height = playView.frame.width*0.8
            //zlatanHead.backgroundColor = .red
            zlatanHead.center.y = playView.frame.minY + zlatanHead.frame.height/2 + taskLabel.frame.height
            zlatanHead.center.x = playView.frame.maxX - zlatanHead.frame.width/2
            zlatanHead.contentMode = .scaleAspectFill
            zlatanHead.layer.zPosition = 4;
            view.addSubview(zlatanHead)
            
            //Randomize zlatan nose location
            let bannerRandom = ["1", "2", "3", "4", "5"]         //"1", "2", "3", "4", "5",
            let bannerRange: UInt32 = UInt32(bannerRandom.count)
            let bannerNumber = Int(arc4random_uniform(bannerRange))
            let pickedBannerRandom = bannerRandom[bannerNumber]
            print("zlatan location = location", pickedBannerRandom)
            
            if (pickedBannerRandom == "1") {
            //zlatan nose image
                runnerImageview = UIImageView(frame: CGRect(x: zlatanHead.frame.minX, y: playView.frame.minY , width: zlatanHead.frame.width/5, height: zlatanHead.frame.width/5))
            } else if (pickedBannerRandom == "2") {
                runnerImageview = UIImageView(frame: CGRect(x: zlatanHead.frame.minX, y: zlatanHead.frame.minY , width: zlatanHead.frame.width/5, height: zlatanHead.frame.width/5))
            } else if (pickedBannerRandom == "3") {
                runnerImageview = UIImageView(frame: CGRect(x: zlatanHead.frame.midX, y: zlatanHead.frame.minY , width: zlatanHead.frame.width/5, height: zlatanHead.frame.width/5))
            } else if (pickedBannerRandom == "4") {
                runnerImageview = UIImageView(frame: CGRect(x: zlatanHead.frame.midX, y: zlatanHead.frame.midY , width: zlatanHead.frame.width/5, height: zlatanHead.frame.width/5))
            } else if (pickedBannerRandom == "5") {
                runnerImageview = UIImageView(frame: CGRect(x: zlatanHead.frame.midX, y: playView.frame.minY , width: zlatanHead.frame.width/5, height: zlatanHead.frame.width/5))
            }
            view.addSubview(runnerImageview)
            runnerImageview.contentMode = .scaleAspectFill
            runnerImageview.layer.zPosition = 5;
            
            if specialTypeString == "horse" {
                zlatanHead.image = UIImage(named: "only horse")
                runnerImageview.image = UIImage(named: "horse tail")
                taskLabel.text = "Sätt svansen på Lilla Gubben 🐴"
            } else if specialTypeString == "zlatan" {
                zlatanHead.image = UIImage(named: "head no nose")
                runnerImageview.image = UIImage(named: "nose")
                taskLabel.text = "Hjälp Zlatans 👃!"
            }
            
            //the view which will collide with the nose
            backgroundNose = UIImageView(frame: CGRect(x: zlatanHead.frame.minX, y: zlatanHead.frame.midY, width: runnerImageview.frame.width/2, height: runnerImageview.frame.height/2))
            //backgroundNose.backgroundColor = UIColor.yellowƒ
            backgroundNose.layer.zPosition = 6;
            //backgroundNose.image = UIImage(named: "nose")
            backgroundNose.contentMode = .scaleAspectFill
            
            for i in 0..<buttons.count {
                buttons[i].isEnabled = false
            }
        } else if mainTypeString == "Blow in Mic" {
            //kompromiss för att den ska funka 100% efter beta-klagomål = nu animeras flaggan oavsett ifall micen lyckas registera blåsningen eller inte
            
            //Set the button
            for i in 0..<buttons.count {
                buttons[i].isEnabled = false
            }
            buttons[1].isHidden = true
            buttons[2].isHidden = true
            buttons[3].isHidden = true
            leftTopBtnWidthConstraint.constant = 0
            leftTopBtnHeightConstraint.constant = 0
            leftTopBtnWidthConstraint.priority = UILayoutPriority(rawValue: 1000)
            leftTopBtnHeightConstraint.priority = UILayoutPriority(rawValue: 1000)
            buttons[0].removeTarget(self, action: #selector(GameVC.leftTopTapped(_:)), for: .touchUpInside)
            buttons[0].adjustsImageWhenHighlighted = false
            buttons[0].imageView?.contentMode = .scaleAspectFit
            
            for i in 1..<13 {
                firstCurrentAnimationImages.append(UIImage(named: "flag\(i)")!)
            }
            
            taskLabel.text = "Blås på skärmen💨"
            print("blow NOT recorded -> but still let user proceed since they most likely have tried to blow in mic")
            perform(#selector(correctAnswerWithDelay), with: nil, afterDelay: 3.0)
            perform(#selector(flagAnimate), with: nil, afterDelay: 2.5)
            
            //cheering label
          /* cheerLabel = UILabel(frame: taskLabel.frame)
            cheerLabel.font = UIFont(name: "YanoneKaffeesatz-Bold", size: 20)
            cheerLabel.center.y = taskLabel.frame.maxY + (cheerLabel.frame.height/3)
            cheerLabel.center.x = view.center.x
            cheerLabel.textAlignment = .center
            playView.addSubview(cheerLabel)*/
            
            buttons[0].setImage(firstCurrentAnimationImages[0], for: .normal)
            buttons[0].imageView!.animationImages = firstCurrentAnimationImages
            buttons[0].imageView!.animationDuration = 0.2
            buttons[0].imageView?.animationRepeatCount = 3
            
            //ha en svensk "waving flag" -> animation som sker när man blåser tillräckligt på skärmen 
            //https://learnappdevelopment.com/uncategorized/how-to-record-sound-with-swift-3-and-ios-10/
            
            //set up the URL for the audio file
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let docsDirect = paths[0]
            let audioUrl = docsDirect.appendingPathComponent("audioFileName.m4a")

            do {
                // 2. configure the session for recording and playback
                try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .mixWithOthers)
                try session.setActive(true)
                //music + recording of audio = check
                //try! session.setCategory(AVAudioSessionCategoryAmbient)

                // 3. set up a high-quality recording session
                let settings = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 44100,
                    AVNumberOfChannelsKey: 2,
                    AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                ]
                // 4. create the audio recording, and assign ourselves as the delegate
                recorder = try AVAudioRecorder(url: audioUrl, settings: settings)
                recorder?.delegate = self
                recorder.isMeteringEnabled = true
                self.levelTimer = Timer.scheduledTimer(timeInterval: 0.15, target: self, selector: #selector(GameVC.levelTimerCallback), userInfo: nil, repeats: true)
                recorder?.record()
            }
            catch _ {
                // failed to record! // error
                print("blow - failed to record microphone!")
            }
            
        } else if mainTypeString == "Swipe Left" {
            
            //get user to pan ("drag") on the button left to change animation for every swipe to create animation of kaviar "blir utklämd"
            
            //Set the button
            leftTopBtnWidthConstraint.constant = 0
            leftTopBtnHeightConstraint.constant = 0
            leftTopBtnWidthConstraint.priority = UILayoutPriority(rawValue: 1000)
            leftTopBtnHeightConstraint.priority = UILayoutPriority(rawValue: 1000)
            buttons[1].isEnabled = false
            buttons[2].isEnabled = false
            buttons[3].isEnabled = false
            buttons[1].isHidden = true
            buttons[2].isHidden = true
            buttons[3].isHidden = true
            buttons[0].removeTarget(self, action: #selector(GameVC.leftTopTapped(_:)), for: .touchUpInside)
            buttons[0].adjustsImageWhenHighlighted = false
            buttons[0].imageView?.contentMode = .scaleAspectFit
            
            //animation images
            var imageSetArray = [//alla
               "rightKaviar", "leftKaviar", "rightmessmor", "messmor"
            ]
            
            //randomize direction of swipe
            let firstNumber:Int = Int(arc4random_uniform(UInt32(imageSetArray.count)))
            firstArray = imageSetArray[firstNumber]
            buttons[0].setBackgroundImage(UIImage (named:"\(firstArray)0"), for: .normal)
            
            if firstArray == "rightKaviar" || firstArray == "leftKaviar" {
                taskLabel.text = "Kläm ut Kalles kaviare!"
                //swipe gesture -> either right or left
                let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(GameVC.leftSwipeGesture))
                if firstArray == "leftKaviar" {
                    swipeGesture.direction = .left
                } else if firstArray == "rightKaviar" {
                    swipeGesture.direction = .right
                }
                swipeGesture.numberOfTouchesRequired = 1
                buttons[0].addGestureRecognizer(swipeGesture)
            } else if firstArray == "rightmessmor" || firstArray == "messmor" {
                taskLabel.text = "Kläm ut messmör!"
                //swipe gesture -> either right or left
                let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(GameVC.leftSwipeGesture))
                if firstArray == "messmor" {
                    swipeGesture.direction = .left
                } else if firstArray == "rightmessmor" {
                    swipeGesture.direction = .right
                }
                swipeGesture.numberOfTouchesRequired = 1
                buttons[0].addGestureRecognizer(swipeGesture)
            }
            
            //incorrect tap attempt
            let touch = UITapGestureRecognizer(target: self, action: #selector(GameVC.swipeIncorrectTouch))
            touch.numberOfTapsRequired = 1
            touch.numberOfTouchesRequired = 1
            buttons[0].addGestureRecognizer(touch)
            
        }else if mainTypeString == "Swipe Down" {
            
            //get user to pan ("drag") on the button left to change animation for every swipe to create animation of "hissa upp ida i flaggstång
            
            //Set the button
            leftTopBtnWidthConstraint.constant = 0
            leftTopBtnHeightConstraint.constant = 0
            leftTopBtnWidthConstraint.priority = UILayoutPriority(rawValue: 1000)
            leftTopBtnHeightConstraint.priority = UILayoutPriority(rawValue: 1000)
            buttons[1].isEnabled = false
            buttons[2].isEnabled = false
            buttons[3].isEnabled = false
            buttons[1].isHidden = true
            buttons[2].isHidden = true
            buttons[3].isHidden = true
            buttons[0].removeTarget(self, action: #selector(GameVC.leftTopTapped(_:)), for: .touchUpInside)
            buttons[0].adjustsImageWhenHighlighted = false
            buttons[0].imageView?.contentMode = .scaleAspectFit
            
            //animation images
            var imageSetArray = [//alla
                "hissaIda", "ost"
            ]
            
            //randomize direction of swipe
            let firstNumber:Int = Int(arc4random_uniform(UInt32(imageSetArray.count)))
            specialTypeString = imageSetArray[firstNumber]
            buttons[0].setBackgroundImage(UIImage (named:"\(specialTypeString)0"), for: .normal)
            
            if specialTypeString == "ost" {
                taskLabel.text = "Hyvla osten🧀"
            } else if specialTypeString == "hissaIda" {
                taskLabel.text = "Hjälp Emil hissa upp Ida🚩"
            }
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(GameVC.leftSwipeGesture))
            swipeGesture.direction = .down
            swipeGesture.numberOfTouchesRequired = 1
            buttons[0].addGestureRecognizer(swipeGesture)
            
            //incorrect tap attempt
            let touch = UITapGestureRecognizer(target: self, action: #selector(GameVC.swipeIncorrectTouch))
            touch.numberOfTapsRequired = 1
            touch.numberOfTouchesRequired = 1
            buttons[0].addGestureRecognizer(touch)
            
        } else if mainTypeString == "Don't Press" {
            //a button is shown and the user fails if he taps the button
            //Set the button
            leftTopBtnWidthConstraint.constant = 0
            leftTopBtnHeightConstraint.constant = 0
            leftTopBtnWidthConstraint.priority = UILayoutPriority(rawValue: 1000)
            leftTopBtnHeightConstraint.priority = UILayoutPriority(rawValue: 1000)
            buttons[1].isEnabled = false
            buttons[2].isEnabled = false
            buttons[3].isEnabled = false
            buttons[1].isHidden = true
            buttons[2].isHidden = true
            buttons[3].isHidden = true
            buttons[0].adjustsImageWhenHighlighted = false
            //buttons[0].imageView?.contentMode = .scaleAspectFill
            buttons[0].setBackgroundImage(UIImage(named: "dontPress"), for: .normal)
            
            perform(#selector(correctAnswerWithDelay), with: nil, afterDelay: 3.2)
            taskLabel.text = ""
            
        }//end of type if
        
        //Randomizing Button =
        let btnRange: UInt32 = UInt32(btnArray.count)
        let randomBtnNumber = Int(arc4random_uniform(btnRange))
        pickRandomBtn = btnArray[randomBtnNumber]
        print("btn", pickRandomBtn)
        
        //set which button is correct
        if pickRandomBtn == "leftTopBtn" {
            
            if mainTypeString == "Images" {
                
                taskLabel.text = "\(firstItem)?"
                basicGameType = "yes"
        
            } else if mainTypeString == "Game Art" {
                
                if firstArray == "surstroming" {
                    taskLabel.text = "Klicka på Surströmmingen"
                } else if firstArray == "Paskmust" {
                    taskLabel.text = "Klicka på Påskmusten"
                } else {
                    taskLabel.text = "Klicka på \(firstArray)"
                }
                basicGameType = "yes"
                
            } /*else if mainTypeString == "Numbers" {
            
                buttons[0].setTitle("\(correctSum)", for: .normal)
                buttons[1].setTitle("\(falseSum1)", for: .normal)
                buttons[2].setTitle("\(falseSum2)", for: .normal)
                buttons[3].setTitle("\(falseSum3)", for: .normal)
                basicGameType = "yes"
            
            }*/ else if mainTypeString == "Button Pattern" {
                
                buttons[0].setTitle(firstItem, for: .normal)
                buttons[1].setTitle(secondItem, for: .normal)
                buttons[2].setTitle(thirdItem, for: .normal)
                buttons[3].setTitle(fourthItem, for: .normal)
            
            } else if mainTypeString == "Find hidden" {
                
                var colourName = String()
                if randomColour == UIColor().SwedenYellow() {
                    colourName = "Gul"
                } else if randomColour == UIColor().SwedenBlue() {
                    colourName = "Blå"
                }
                
                UIView.animate(withDuration: 0.1,
                               animations: {
                                self.buttons[0].backgroundColor = self.randomColour
                                self.buttons[1].backgroundColor = self.randomColour2
                                self.buttons[2].backgroundColor = self.randomColour3
                                self.buttons[3].backgroundColor = self.randomColour4
                                
                },
                               completion: { _ in
                                
                                UIView.animate(withDuration: 1.5, animations: {
                                    for i in 0..<self.buttons.count {
                                        self.buttons[i].backgroundColor = UIColor.white
                                    }
                                    
                                }, completion: { (_) in
                                    for i in 0..<self.buttons.count {
                                        self.buttons[i].setTitle("?", for: .normal)
                                        self.buttons[i].titleLabel?.font = self.buttons[i].titleLabel?.font.withSize(90)
                                    }
                                })
                })
                
                taskLabel.text = "Vilken var \(colourName.uppercased())?"
                basicGameType = "yes"
                
            }else if mainTypeString == "Doesn't fit" {
            
                buttons[0].setBackgroundImage(UIImage (named: (oneDifferent)), for: .normal)
                buttons[1].setBackgroundImage(UIImage (named: (oneSame)), for: .normal)
                buttons[2].setBackgroundImage(UIImage (named: (secondSame)), for: .normal)
                buttons[3].setBackgroundImage(UIImage (named: (thirdSame)), for: .normal)
                basicGameType = "yes"
                
            }else if mainTypeString == "End sentence" {
                
                buttons[0].setTitle(choosenSentenceStruct.correct, for: .normal)
                buttons[1].setTitle(choosenSentenceStruct.false1, for: .normal)
                buttons[2].setTitle(choosenSentenceStruct.false2, for: .normal)
                buttons[3].setTitle(choosenSentenceStruct.false3, for: .normal)
                basicGameType = "yes"
                
            }//end of type if/
            
        } else if pickRandomBtn == "rightTopBtn" {
            
            if mainTypeString == "Images" {

                taskLabel.text = "\(secondItem)?"
                basicGameType = "yes"
                
            }else if mainTypeString == "Game Art" {
                
                if secondArray == "surstroming" {
                    taskLabel.text = "Klicka på Surströmmingen"
                }else if secondArray == "Paskmust" {
                    taskLabel.text = "Klicka på Påskmusten"
                } else {
                    taskLabel.text = "Klicka på \(secondArray)"
                }
                basicGameType = "yes"
                
            }/*else if mainTypeString == "Numbers" {
                
                buttons[0].setTitle("\(falseSum1)", for: .normal)
                buttons[1].setTitle("\(correctSum)", for: .normal)
                buttons[2].setTitle("\(falseSum2)", for: .normal)
                buttons[3].setTitle("\(falseSum3)", for: .normal)
                basicGameType = "yes"
                
            }*/else if mainTypeString == "Button Pattern" {
                
                buttons[0].setTitle(secondItem, for: .normal)
                buttons[1].setTitle(firstItem, for: .normal)
                buttons[2].setTitle(thirdItem, for: .normal)
                buttons[3].setTitle(fourthItem, for: .normal)
                
            }else if mainTypeString == "Find hidden" {
                
                var colourName = String()
                if randomColour == UIColor().SwedenYellow() {
                    colourName = "Gul"
                } else if randomColour == UIColor().SwedenBlue(){
                    colourName = "Blå"
                }
                
                UIView.animate(withDuration: 0.1,
                               animations: {
                                self.buttons[1].backgroundColor = self.randomColour
                                self.buttons[0].backgroundColor = self.randomColour2
                                self.buttons[2].backgroundColor = self.randomColour3
                                self.buttons[3].backgroundColor = self.randomColour4
                                
                },
                               completion: { _ in
                                
                                UIView.animate(withDuration: 1.5, animations: {
                                    for i in 0..<self.buttons.count {
                                        self.buttons[i].backgroundColor = UIColor.white
                                    }
                                    
                                }, completion: { (_) in
                                    for i in 0..<self.buttons.count {
                                        self.buttons[i].setTitle("?", for: .normal)
                                        self.buttons[i].titleLabel?.font = self.buttons[i].titleLabel?.font.withSize(90)
                                    }
                                })
                })
                
                taskLabel.text = "Vilken var \(colourName.uppercased())?"
                basicGameType = "yes"
                
            }else if mainTypeString == "Doesn't fit" {
                
                buttons[0].setBackgroundImage(UIImage (named: (oneSame)), for: .normal)
                buttons[1].setBackgroundImage(UIImage (named: (oneDifferent)), for: .normal)
                buttons[2].setBackgroundImage(UIImage (named: (secondSame)), for: .normal)
                buttons[3].setBackgroundImage(UIImage (named: (thirdSame)), for: .normal)
                basicGameType = "yes"
                
            }else if mainTypeString == "End sentence" {
                
                buttons[0].setTitle(choosenSentenceStruct.false1, for: .normal)
                buttons[1].setTitle(choosenSentenceStruct.correct, for: .normal)
                buttons[2].setTitle(choosenSentenceStruct.false2, for: .normal)
                buttons[3].setTitle(choosenSentenceStruct.false3, for: .normal)
                basicGameType = "yes"
                
            }//end of type if//
            
        } else if pickRandomBtn == "leftBottomBtn" {
            
            if mainTypeString == "Images" {

               taskLabel.text = "\(thirdItem)?"
                basicGameType = "yes"

            }else if mainTypeString == "Game Art" {
                
                if thirdArray == "surstroming" {
                    taskLabel.text = "Klicka på Surströmmingen"
                } else if thirdArray == "Paskmust" {
                    taskLabel.text = "Klicka på Påskmusten"
                }else {
                    taskLabel.text = "Klicka på \(thirdArray)"
                }
                basicGameType = "yes"
                
            }/*else if mainTypeString == "Numbers" {
                
                buttons[0].setTitle("\(falseSum1)", for: .normal)
                buttons[1].setTitle("\(falseSum2)", for: .normal)
                buttons[2].setTitle("\(correctSum)", for: .normal)
                buttons[3].setTitle("\(falseSum3)", for: .normal)
                basicGameType = "yes"
                
            }*/else if mainTypeString == "Button Pattern" {
                
                buttons[0].setTitle(thirdItem, for: .normal)
                buttons[1].setTitle(secondItem, for: .normal)
                buttons[2].setTitle(firstItem, for: .normal)
                buttons[3].setTitle(fourthItem, for: .normal)
                
            }else if mainTypeString == "Find hidden" {
                
                var colourName = String()
                if randomColour == UIColor().SwedenYellow() {
                    colourName = "Gul"
                } else if randomColour == UIColor().SwedenBlue() {
                    colourName = "Blå"
                }
                
                UIView.animate(withDuration: 0.1,
                               animations: {
                                self.buttons[2].backgroundColor = self.randomColour
                                self.buttons[1].backgroundColor = self.randomColour2
                                self.buttons[0].backgroundColor = self.randomColour3
                                self.buttons[3].backgroundColor = self.randomColour4
                                
                },
                               completion: { _ in
                                
                                UIView.animate(withDuration: 1.5, animations: {
                                    for i in 0..<self.buttons.count {
                                        self.buttons[i].backgroundColor = UIColor.white
                                    }
                                    
                                }, completion: { (_) in
                                    for i in 0..<self.buttons.count {
                                        self.buttons[i].setTitle("?", for: .normal)
                                        self.buttons[i].titleLabel?.font = self.buttons[i].titleLabel?.font.withSize(90)
                                    }
                                })
                })
                
                taskLabel.text = "Vilken var \(colourName.uppercased())?"
                basicGameType = "yes"
                
            }else if mainTypeString == "Doesn't fit" {
                
                buttons[0].setBackgroundImage(UIImage (named: (oneSame)), for: .normal)
                buttons[1].setBackgroundImage(UIImage (named: (secondSame)), for: .normal)
                buttons[2].setBackgroundImage(UIImage (named: (oneDifferent)), for: .normal)
                buttons[3].setBackgroundImage(UIImage (named: (thirdSame)), for: .normal)
                basicGameType = "yes"
                
            }else if mainTypeString == "End sentence" {
                
                buttons[0].setTitle(choosenSentenceStruct.false2, for: .normal)
                buttons[1].setTitle(choosenSentenceStruct.false1, for: .normal)
                buttons[2].setTitle(choosenSentenceStruct.correct, for: .normal)
                buttons[3].setTitle(choosenSentenceStruct.false3, for: .normal)
                basicGameType = "yes"
                
            }//end of type if//
            
        } else if pickRandomBtn == "rightBottomBtn" {
            
            if mainTypeString == "Images" {
                
                taskLabel.text = "\(fourthItem)?"
                basicGameType = "yes"
                
            }else if mainTypeString == "Game Art" {
                
                if fourthArray == "surstroming" {
                    taskLabel.text = "Klicka på Surströmmingen"
                } else if fourthArray == "Paskmust" {
                    taskLabel.text = "Klicka på Påskmusten"
                }else {
                    taskLabel.text = "Klicka på \(fourthArray)"
                }
                basicGameType = "yes"

            }/*else if mainTypeString == "Numbers" {
                
                buttons[0].setTitle("\(falseSum1)", for: .normal)
                buttons[1].setTitle("\(falseSum2)", for: .normal)
                buttons[2].setTitle("\(falseSum3)", for: .normal)
                buttons[3].setTitle("\(correctSum)", for: .normal)
                basicGameType = "yes"
                
            }*/else if mainTypeString == "Button Pattern" {
                
                buttons[0].setTitle(fourthItem, for: .normal)
                buttons[1].setTitle(secondItem, for: .normal)
                buttons[2].setTitle(thirdItem, for: .normal)
                buttons[3].setTitle(firstItem, for: .normal)
                
            }else if mainTypeString == "Find hidden" {
                
                var colourName = String()
                if randomColour == UIColor().SwedenYellow() {
                    colourName = "Gul"
                } else if randomColour == UIColor().SwedenBlue() {
                    colourName = "Blå"
                }
                
                UIView.animate(withDuration: 0.1,
                               animations: {
                                self.buttons[3].backgroundColor = self.randomColour
                                self.buttons[1].backgroundColor = self.randomColour2
                                self.buttons[2].backgroundColor = self.randomColour3
                                self.buttons[0].backgroundColor = self.randomColour4
                                
                },
                               completion: { _ in
                                
                                UIView.animate(withDuration: 1.5, animations: {
                                    for i in 0..<self.buttons.count {
                                        self.buttons[i].backgroundColor = UIColor.white
                                    }
                                    
                                }, completion: { (_) in
                                    for i in 0..<self.buttons.count {
                                        self.buttons[i].setTitle("?", for: .normal)
                                        self.buttons[i].titleLabel?.font = self.buttons[i].titleLabel?.font.withSize(90)
                                    }
                                })
                })
                
                taskLabel.text = "Vilken var \(colourName.uppercased())?"
                basicGameType = "yes"
                
            }else if mainTypeString == "Doesn't fit" {
                
                buttons[0].setBackgroundImage(UIImage (named: (oneSame)), for: .normal)
                buttons[1].setBackgroundImage(UIImage (named: (secondSame)), for: .normal)
                buttons[2].setBackgroundImage(UIImage (named: (thirdSame)), for: .normal)
                buttons[3].setBackgroundImage(UIImage (named: (oneDifferent)), for: .normal)
                basicGameType = "yes"
                
            }else if mainTypeString == "End sentence" {
                
                buttons[0].setTitle(choosenSentenceStruct.false3, for: .normal)
                buttons[1].setTitle(choosenSentenceStruct.false1, for: .normal)
                buttons[2].setTitle(choosenSentenceStruct.false2, for: .normal)
                buttons[3].setTitle(choosenSentenceStruct.correct, for: .normal)
                basicGameType = "yes"
                
            }//end of type if//

        }//end of if statments buttons
        
    }//end of viewDidLoad
    
    
//MARK: timer functions
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(GameVC.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        timerLabel.text = "\(seconds)" //This will update the label.
        seconds -= 1     //This will decrement(count down)the seconds.
        
        if seconds <= -1 {
            timer.invalidate()
            performSegue(withIdentifier: "GameToEnd", sender: UIButton())
        }
    }
    
    func totalTimerStart() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(GameVC.updateTotalTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTotalTimer() {
        totalTime = totalSeconds //This will update the label.
        totalSeconds += 1     //This will decrement(count down)the seconds.
    }
    
//MARK: Smått och gott (different funtions)
    //red flash
    func redFlash() {
        if let wnd = self.view {
        
            let view = UIView(frame: wnd.bounds)
            view.backgroundColor = UIColor.red
            view.alpha = 1
        
            wnd.addSubview(view)
            UIView.animate(withDuration: 1, animations: {
                    view.alpha = 0.0
                }, completion: {(finished:Bool) in
                    view.removeFromSuperview()
                })
       }
    }
    
    func popComments() {
        
        if timerLabel.text == "1"{
             //skapa comments som pop upar upp på skärmen när spelare precis likas trycka! https://cocoapods.org/pods/LTMorphingLabel
            print("1 sec left")
        }
    }
    
    func buttonTapUpdate() {
    
        tapCount -= 1
        taskLabel.text = "\(tapCount) gånger till!"
        
        if tapCount <= 0 {
            taskLabel.text = "Länge leve Sverige🇸🇪"
            perform(#selector(correctAnswerWithDelay), with: nil, afterDelay: 0.3)
        }
        
        if tapCount == (startTapCount - startTapCount/6){
            if buttonTapNationality == "Norsk" {
                buttons[0].setBackgroundImage(UIImage(named: "Norsk2"), for: .normal)
            } else if buttonTapNationality == "Dansk" {
                buttons[0].setBackgroundImage(UIImage(named: "Dansk2"), for: .normal)
            }
        }else if tapCount == (startTapCount - startTapCount/4){
            if buttonTapNationality == "Norsk" {
                buttons[0].setBackgroundImage(UIImage(named: "Norsk3"), for: .normal)
            } else if buttonTapNationality == "Dansk" {
                buttons[0].setBackgroundImage(UIImage(named: "Dansk3"), for: .normal)
            }
        }else if tapCount == (startTapCount - startTapCount/2){
            if buttonTapNationality == "Norsk" {
                buttons[0].setBackgroundImage(UIImage(named: "Norsk4"), for: .normal)
            } else if buttonTapNationality == "Dansk" {
                buttons[0].setBackgroundImage(UIImage(named: "Dansk4"), for: .normal)
            }
        }else if tapCount == 1 {
            taskLabel.text = "\(tapCount) gång till!"
            if buttonTapNationality == "Norsk" {
                buttons[0].setBackgroundImage(UIImage(named: "Norsk5"), for: .normal)
            } else if buttonTapNationality == "Dansk" {
                buttons[0].setBackgroundImage(UIImage(named: "Dansk5"), for: .normal)
            }
        }
        
    }
    
    func falseAnswer() {
        
        print("false answer")
        answer = "false"
        redFlash()
        timer.invalidate()
        performSegue(withIdentifier: "newTaskSegue", sender: UIButton())

    }
    
    func correctAnswer() {
        
        print("correct answer")
        answer = "correct"
        timer.invalidate()
        performSegue(withIdentifier: "newTaskSegue", sender: UIButton())
   
    }
    
    @objc func flagAnimate(){ buttons[0].imageView?.startAnimating() }
    
    @objc func correctAnswerWithDelay(){
        if mainTypeString == "Blow in Mic" {
            levelTimer.invalidate()
            recorder.stop()
        }
        
        self.correctAnswer()
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    }
    

//MARK: button actions
    @IBAction func leftTopTapped(_ sender: UIButton) {
        
        if mainTypeString == "Button Tap" {
            
            buttonTapUpdate()
        
        } else if mainTypeString == "Don't Press" {
            
            falseAnswer()
            
        } else if mainTypeString == "Multiple Tap Button" {
            
            if specialTypeString == "midsommar" {

                if buttons[0].imageView?.image == UIImage(named: "midsommar0") {
                    
                    buttons[0].setImage(UIImage(named: "midsommar1"), for: .normal)
                    
                } else if buttons[0].imageView?.image == UIImage(named: "midsommar1")  {
                    
                    buttons[0].setImage(UIImage(named: "midsommar0"), for: .normal)
                    randomLaps -= 1
                    
                    if randomLaps > 1 {
                        taskLabel.text = "\(randomLaps) gånger till🐸"
                    } else if randomLaps <= 1 {
                        taskLabel.text = "\(randomLaps) gång till🐸"
                    }
                    
                }
                
            } else if specialTypeString == "skiing" {
                if buttons[0].imageView?.image == UIImage(named: "skiing0") {

                    buttons[0].setImage(UIImage(named: "skiing1"), for: .normal)
                    
                } else if buttons[0].imageView?.image == UIImage(named: "skiing1")  {
                    
                    buttons[0].setImage(UIImage(named: "skiing0"), for: .normal)
                    randomLaps -= 1
                    taskLabel.text = "\(randomLaps) meter kvar⛷"
                }
                
            }  else if specialTypeString == "snow" {
                if buttons[0].imageView?.image == UIImage(named: "snow0") {
                    
                    buttons[0].setImage(UIImage(named: "snow1"), for: .normal)
                    
                } else if buttons[0].imageView?.image == UIImage(named: "snow1")  {
                    
                    buttons[0].setImage(UIImage(named: "snow0"), for: .normal)
                    randomLaps -= 1
                    taskLabel.text = "\(randomLaps) kvar🌨"
                }
            }
            
            if randomLaps <= 0 {
                perform(#selector(correctAnswerWithDelay), with: nil, afterDelay: 0.3)
                if specialTypeString == "skiing" {
                    taskLabel.text = "🥇🇸🇪GULD🇸🇪🥇"
                } else  if specialTypeString == "snow" {
                    taskLabel.text = "Bra skottat🇸🇪"
                } else  if specialTypeString == "midsommar" {
                    taskLabel.text = "🐸Bra dansat🐸"
                }
            }
            
        } else if pickRandomBtn == "leftTopBtn" && basicGameType == "yes" {
            
            //this is called with all "basic button games" e.g. Images and Game Art
            correctAnswer()
            buttons[0].backgroundColor = UIColor().SwedenYellow()
            
        } else if mainTypeString == "Button Pattern" {
            
            if buttons[0].titleLabel?.text == firstItem {
            
                        buttons[0].backgroundColor = UIColor().SwedenYellow()
            
            } else if buttons[0].titleLabel?.text == secondItem  {
                
                        if buttons[1].backgroundColor == UIColor().SwedenYellow() || buttons[2].backgroundColor == UIColor().SwedenYellow() || buttons[3].backgroundColor == UIColor().SwedenYellow() {
                
                            buttons[0].backgroundColor = UIColor().SwedenYellow()
                        }
                        else {
                            falseAnswer()
                            
                            }
                
            } else if buttons[0].titleLabel?.text == thirdItem {
                    
                        if buttons[1].backgroundColor == UIColor().SwedenYellow() && buttons[2].backgroundColor == UIColor().SwedenYellow() || buttons[2].backgroundColor == UIColor().SwedenYellow() && buttons[3].backgroundColor == UIColor().SwedenYellow() || buttons[1].backgroundColor == UIColor().SwedenYellow() && buttons[3].backgroundColor == UIColor().SwedenYellow() {
                        
                            buttons[0].backgroundColor = UIColor().SwedenYellow()
                        }
                        else {
                            falseAnswer()
                            
                            }

            } else if buttons[0].titleLabel?.text == fourthItem {
                    
                        if buttons[1].backgroundColor == UIColor().SwedenYellow() && buttons[2].backgroundColor == UIColor().SwedenYellow() && buttons[3].backgroundColor == UIColor().SwedenYellow() {
                        
                        correctAnswer()
                        buttons[0].backgroundColor = UIColor().SwedenYellow()
                        
                        } else {
                
                        falseAnswer()
                
                        }
                    }

            } else if mainTypeString == "Button Quick" {
            
            if buttons[1].tintColor == UIColor.clear && buttons[2].tintColor == UIColor.clear && buttons[3].tintColor == UIColor.clear  {
                
                correctAnswer()
                buttons[0].backgroundColor = UIColor().SwedenYellow()
                
            } else {
                
                UIView.animate(withDuration: 0.7,
                               animations: {
                                self.buttons[0].backgroundColor = self.randomColour
                                self.buttons[0].tintColor = UIColor.clear
                                
                                
                },
                               completion: { _ in
                                UIView.animate(withDuration: 0.2) {
                                    self.buttons[0].backgroundColor = UIColor.white
                                    self.buttons[0].tintColor = UIColor.white
                                    
                                }
                })
                
            }
            
        } else {
            
            falseAnswer()
            
        }


    }
    
    @IBAction func rightTopTapped(_ sender: Any) {
        
        if pickRandomBtn == "rightTopBtn" && basicGameType == "yes"  {
            
            correctAnswer()
            buttons[1].backgroundColor = UIColor().SwedenYellow()
            
        } else if mainTypeString == "Button Pattern" {
            
            if buttons[1].titleLabel?.text == firstItem {
                
                buttons[1].backgroundColor = UIColor().SwedenYellow()
                
            } else if buttons[1].titleLabel?.text == secondItem  {
                
                if buttons[0].backgroundColor == UIColor().SwedenYellow() || buttons[2].backgroundColor == UIColor().SwedenYellow() || buttons[3].backgroundColor == UIColor().SwedenYellow() {
                    
                    buttons[1].backgroundColor = UIColor().SwedenYellow()
                }
                else {
                    
                    falseAnswer()
                    
                }
                
            } else if buttons[1].titleLabel?.text == thirdItem {
                
                if buttons[0].backgroundColor == UIColor().SwedenYellow() && buttons[2].backgroundColor == UIColor().SwedenYellow() || buttons[2].backgroundColor == UIColor().SwedenYellow() && buttons[3].backgroundColor == UIColor().SwedenYellow() || buttons[0].backgroundColor == UIColor().SwedenYellow() && buttons[3].backgroundColor == UIColor().SwedenYellow() {
                    
                    buttons[1].backgroundColor = UIColor().SwedenYellow()
                }
                else {
                    
                    falseAnswer()
                    
                }
                
                
            } else if buttons[1].titleLabel?.text == fourthItem {
                
                if buttons[0].backgroundColor == UIColor().SwedenYellow() && buttons[2].backgroundColor == UIColor().SwedenYellow() && buttons[3].backgroundColor == UIColor().SwedenYellow() {
                    
                    correctAnswer()
                    buttons[1].backgroundColor = UIColor().SwedenYellow()
                    
                } else {
                    
                    falseAnswer()
                    
                }
            }
            
        } else if mainTypeString == "Button Quick" {
            
            if buttons[0].tintColor == UIColor.clear && buttons[2].tintColor == UIColor.clear && buttons[3].tintColor == UIColor.clear  {
                
                correctAnswer()
                buttons[1].backgroundColor = UIColor().SwedenYellow()
                
            } else {
                
                UIView.animate(withDuration: 0.7,
                               animations: {
                                self.buttons[1].backgroundColor = self.randomColour
                                self.buttons[1].tintColor = UIColor.clear
                                
                                
                },
                               completion: { _ in
                                UIView.animate(withDuration: 0.2) {
                                    self.buttons[1].backgroundColor = UIColor.white
                                    self.buttons[1].tintColor = UIColor.white
                                    
                                }
                })
                
            }
            
        } else {
            
            falseAnswer()
            
        }

        
    }
    
    @IBAction func leftBottomTapped(_ sender: Any) {
        
        if pickRandomBtn == "leftBottomBtn" && basicGameType == "yes"  {
            
            correctAnswer()
            buttons[2].backgroundColor = UIColor().SwedenYellow()
            
        } else if mainTypeString == "Button Pattern" {
            
            if buttons[2].titleLabel?.text == firstItem {
                
                buttons[2].backgroundColor = UIColor().SwedenYellow()
                
            } else if buttons[2].titleLabel?.text == secondItem  {
                
                if buttons[0].backgroundColor == UIColor().SwedenYellow() || buttons[1].backgroundColor == UIColor().SwedenYellow() || buttons[3].backgroundColor == UIColor().SwedenYellow() {
                    
                    buttons[2].backgroundColor = UIColor().SwedenYellow()
                }
                else {
                    
                    falseAnswer()
                    
                }
                
            } else if buttons[2].titleLabel?.text == thirdItem {
                
                if buttons[1].backgroundColor == UIColor().SwedenYellow() && buttons[0].backgroundColor == UIColor().SwedenYellow() || buttons[0].backgroundColor == UIColor().SwedenYellow() && buttons[3].backgroundColor == UIColor().SwedenYellow() || buttons[1].backgroundColor == UIColor().SwedenYellow() && buttons[3].backgroundColor == UIColor().SwedenYellow() {
                    
                    buttons[2].backgroundColor = UIColor().SwedenYellow()
                }
                else {
                    
                   falseAnswer()
                    
                }
                
                
            } else if buttons[2].titleLabel?.text == fourthItem {
                
                if buttons[1].backgroundColor == UIColor().SwedenYellow() && buttons[0].backgroundColor == UIColor().SwedenYellow() && buttons[3].backgroundColor == UIColor().SwedenYellow() {
                    
                    correctAnswer()
                    buttons[2].backgroundColor = UIColor().SwedenYellow()
                    
                } else {
                    
                    falseAnswer()
                    
                }
            }
            
        } else if mainTypeString == "Button Quick" {
            
            if buttons[1].tintColor == UIColor.clear && buttons[0].tintColor == UIColor.clear && buttons[3].tintColor == UIColor.clear  {
                
                correctAnswer()
                buttons[2].backgroundColor = UIColor().SwedenYellow()
                
            } else {
                
                UIView.animate(withDuration: 0.7,
                               animations: {
                                self.buttons[2].backgroundColor = self.randomColour
                                self.buttons[2].tintColor = UIColor.clear
                                
                                
                },
                               completion: { _ in
                                UIView.animate(withDuration: 0.2) {
                                    self.buttons[2].backgroundColor = UIColor.white
                                    self.buttons[2].tintColor = UIColor.white
                                    
                                }
                })
                
            }
            
        } else {
            
            falseAnswer()
            
        }

        
    }
    
    @IBAction func rightBottomTapped(_ sender: Any) {
        
        if pickRandomBtn == "rightBottomBtn" && basicGameType == "yes"  {
            
            correctAnswer()
            buttons[3].backgroundColor = UIColor().SwedenYellow()
            
        } else if mainTypeString == "Button Pattern" {
            
            if buttons[3].titleLabel?.text == firstItem {
                
                buttons[3].backgroundColor = UIColor().SwedenYellow()
                
            } else if buttons[3].titleLabel?.text == secondItem  {
                
                if buttons[1].backgroundColor == UIColor().SwedenYellow() || buttons[2].backgroundColor == UIColor().SwedenYellow() || buttons[0].backgroundColor == UIColor().SwedenYellow() {
                    
                    buttons[3].backgroundColor = UIColor().SwedenYellow()
                }
                else {
                    
                    falseAnswer()
                    
                }
                
            } else if buttons[3].titleLabel?.text == thirdItem {
                
                if buttons[1].backgroundColor == UIColor().SwedenYellow() && buttons[2].backgroundColor == UIColor().SwedenYellow() || buttons[2].backgroundColor == UIColor().SwedenYellow() && buttons[0].backgroundColor == UIColor().SwedenYellow() || buttons[1].backgroundColor == UIColor().SwedenYellow() && buttons[0].backgroundColor == UIColor().SwedenYellow() {
                    
                    buttons[3].backgroundColor = UIColor().SwedenYellow()
                }
                else {
                    
                    falseAnswer()
                    
                }
                
                
            } else if buttons[3].titleLabel?.text == fourthItem {
                
                if buttons[1].backgroundColor == UIColor().SwedenYellow() && buttons[2].backgroundColor == UIColor().SwedenYellow() && buttons[0].backgroundColor == UIColor().SwedenYellow() {
                    
                    correctAnswer()
                    buttons[3].backgroundColor = UIColor().SwedenYellow()
                    
                } else {
                    
                    falseAnswer()
                    
                }
            }
            
        } else if mainTypeString == "Button Quick" {
            
            if buttons[1].tintColor == UIColor.clear && buttons[0].tintColor == UIColor.clear && buttons[2].tintColor == UIColor.clear  {
                
                correctAnswer()
                buttons[3].backgroundColor = UIColor().SwedenYellow()
                
            } else {
                
                UIView.animate(withDuration: 0.7,
                               animations: {
                                self.buttons[3].backgroundColor = self.randomColour
                                self.buttons[3].tintColor = UIColor.clear
                                
                                
                },
                               completion: { _ in
                                UIView.animate(withDuration: 0.2) {
                                    self.buttons[3].backgroundColor = UIColor.white
                                    self.buttons[3].tintColor = UIColor.white
                                    
                                }
                })
                
            }
            
        } else if mainTypeString == "KYC" {
            
                print("start KYC path")
                KYCTimer = Timer.scheduledTimer(timeInterval: 0.12, target: self, selector: #selector(GameVC.updateProgress), userInfo: nil, repeats: true)
                KYCTimer.fire()
                lightCount += 1
            buttons[3].setTitle("Hastighet\n\(lightCount)🖍", for: .normal)
            
        } else {
            
            falseAnswer()
            if mainTypeString == "KYC" {
                KYCTimer.invalidate()
            }
            
        }//end of big if
    }
    
    
    //MARK: prepareforsegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newTaskSegue"{
            if let destination = segue.destination as? GameVC {
                
                var mainTypeArray = [String]()
                //mainTypeArray = ["Swipe Left"]
                /*if mainTypeString == "Numbers" {
                 MARK: THIS LEVEL HAS NOT BEEN INCLUDED IN THE LATEST VERSION --> has been removed from all below levels
                    mainTypeArray = ["Images", "Game Art", "Orientation Change", "Button Pattern", "Button Tap", "Button Quick", "Pan Gesture", "KYC", "Core Motion", "Add 1", "Find hidden", "Run a lap", "Doesn't fit", "End sentence", "Long Press", "Multiple Tap Button", "Swipe Gesture", "Image Collide", "Swipe Left", "Blow in Mic"]
                
                }*/ if mainTypeString == "Game Art" {
                    
                    mainTypeArray = ["Images", "Orientation Change", "Button Pattern", "Button Tap",  "Button Quick", "Pan Gesture", "KYC", "Core Motion", "Find hidden", "Doesn't fit", "End sentence", "Long Press", "Multiple Tap Button", "Image Collide",  "Swipe Left", "Swipe Gesture", "Swipe Down", "Don't Press", "Blow in Mic"]
                    
                } else if mainTypeString == "Images" {
                    
                    mainTypeArray = [ "Game Art", "Orientation Change", "Button Pattern", "Button Tap",  "Button Quick", "Pan Gesture", "KYC", "Core Motion", "Find hidden", "Doesn't fit", "End sentence", "Long Press", "Multiple Tap Button", "Image Collide",  "Swipe Left", "Swipe Gesture", "Swipe Down", "Don't Press", "Blow in Mic"]
                    
                } else if mainTypeString == "Button Tap" {
                    
                    mainTypeArray = [ "Images", "Game Art", "Orientation Change", "Button Pattern", "Button Quick", "Pan Gesture", "KYC", "Core Motion", "Find hidden", "Doesn't fit", "End sentence", "Long Press", "Multiple Tap Button", "Image Collide",  "Swipe Left", "Swipe Gesture", "Swipe Down", "Don't Press", "Blow in Mic"]
                 
                } else if mainTypeString == "Button Pattern" {
                    
                    mainTypeArray = [ "Images", "Game Art", "Orientation Change", "Button Tap",  "Button Quick", "Pan Gesture", "KYC", "Core Motion", "Find hidden", "Doesn't fit", "End sentence", "Long Press", "Multiple Tap Button", "Image Collide",  "Swipe Left", "Swipe Gesture", "Swipe Down", "Don't Press", "Blow in Mic"]
                    
                } else if mainTypeString == "Orientation Change" {
                    
                    mainTypeArray = [ "Images", "Game Art", "Button Pattern", "Button Tap",  "Button Quick", "Pan Gesture", "KYC", "Core Motion", "Find hidden", "Doesn't fit", "End sentence", "Long Press", "Multiple Tap Button", "Image Collide",  "Swipe Left", "Swipe Gesture", "Swipe Down", "Don't Press", "Blow in Mic"]
                    
                } else if mainTypeString == "Button Quick" {
                    
                    mainTypeArray = ["Images", "Game Art", "Orientation Change", "Button Pattern", "Button Tap", "Pan Gesture", "KYC", "Core Motion", "Find hidden", "Doesn't fit", "End sentence", "Long Press", "Multiple Tap Button", "Image Collide",  "Swipe Left", "Swipe Gesture", "Swipe Down", "Don't Press", "Blow in Mic"]
                    
                 } else if mainTypeString == "Pan Gesture" {
                 
                    mainTypeArray = [ "Images", "Game Art", "Orientation Change", "Button Pattern", "Button Tap",  "Button Quick", "KYC", "Core Motion", "Find hidden", "Doesn't fit", "End sentence", "Long Press", "Multiple Tap Button", "Image Collide",  "Swipe Left", "Swipe Gesture", "Swipe Down", "Don't Press", "Blow in Mic"]
                 
                 } else if mainTypeString == "KYC" {
                 
                    mainTypeArray = [ "Images", "Game Art", "Orientation Change", "Button Pattern", "Button Tap",  "Button Quick", "Pan Gesture", "Core Motion", "Find hidden", "Doesn't fit", "End sentence", "Long Press", "Multiple Tap Button", "Image Collide",  "Swipe Left", "Swipe Gesture", "Swipe Down", "Don't Press", "Blow in Mic"]
                 
                 } else if mainTypeString == "Core Motion" {
                 
                    mainTypeArray = [ "Images", "Game Art", "Orientation Change", "Button Pattern", "Button Tap",  "Button Quick", "Pan Gesture", "KYC", "Find hidden", "Doesn't fit", "End sentence", "Long Press", "Multiple Tap Button", "Image Collide",  "Swipe Left", "Swipe Gesture", "Swipe Down", "Don't Press", "Blow in Mic"]
                 
                 } /*else if mainTypeString == "Add 1" {
                     MARK: THIS LEVEL HAS NOT BEEN INCLUDED IN THE LATEST VERSION --> has been removed from all below levels
                    mainTypeArray = [ "Images", "Game Art", "Orientation Change", "Button Pattern", "Button Tap", "Button Quick", "Pan Gesture", "KYC", "Core Motion", "Find hidden", "Run a lap", "Doesn't fit", "End sentence", "Long Press", "Multiple Tap Button", "Swipe Gesture", "Image Collide", "Swipe Left", "Blow in Mic"]
                 
                }*/ else if mainTypeString == "Find Hidden" {
                    
                    mainTypeArray = ["Images", "Game Art", "Orientation Change", "Button Pattern", "Button Tap",  "Button Quick", "Pan Gesture", "KYC", "Core Motion", "Doesn't fit", "End sentence", "Long Press", "Multiple Tap Button", "Image Collide",  "Swipe Left", "Swipe Gesture", "Swipe Down", "Don't Press", "Blow in Mic"]
                    
                } /*else if mainTypeString == "Run a lap" {
                     //MARK: THIS LEVEL HAS NOT BEEN INCLUDED IN THE LATEST VERSION -->has been removed from all below levels
                    
                    mainTypeArray = [ "Images", "Game Art", "Orientation Change", "Button Pattern", "Button Tap", "Button Quick", "Pan Gesture", "KYC", "Core Motion",  "Find hidden", "Doesn't fit", "End sentence", "Long Press", "Multiple Tap Button", "Swipe Gesture", "Image Collide", "Swipe Left", "Blow in Mic"]
                    
                }*/ else if mainTypeString == "Doesn't fit" {
                    
                    mainTypeArray = [ "Images", "Game Art", "Orientation Change", "Button Pattern", "Button Tap",  "Button Quick", "Pan Gesture", "KYC", "Core Motion", "Find hidden",  "End sentence", "Long Press", "Multiple Tap Button", "Image Collide",  "Swipe Left", "Swipe Gesture", "Swipe Down", "Don't Press","Blow in Mic"]
                    
                } else if mainTypeString == "End sentence" {
                    
                    mainTypeArray = [ "Images", "Game Art", "Orientation Change", "Button Pattern", "Button Tap",  "Button Quick", "Pan Gesture", "KYC", "Core Motion", "Find hidden", "Doesn't fit", "Long Press", "Multiple Tap Button", "Image Collide",  "Swipe Left", "Swipe Gesture", "Swipe Down", "Don't Press","Blow in Mic"]
                    
                } else if mainTypeString == "Long Press" {
                    
                    mainTypeArray = ["Images", "Game Art", "Orientation Change", "Button Pattern", "Button Tap",  "Button Quick", "Pan Gesture", "KYC", "Core Motion", "Find hidden", "Doesn't fit", "End sentence", "Multiple Tap Button", "Image Collide",  "Swipe Left", "Swipe Gesture", "Swipe Down", "Don't Press","Blow in Mic"]
                    
                 }else if mainTypeString == "Multiple Tap Button" {
                 
                 mainTypeArray = [ "Images", "Game Art", "Orientation Change", "Button Pattern", "Button Tap",  "Button Quick", "Pan Gesture", "KYC", "Core Motion", "Find hidden", "Doesn't fit", "End sentence", "Long Press", "Image Collide",  "Swipe Left", "Swipe Gesture", "Swipe Down", "Don't Press","Blow in Mic"]
                 
                 } else if mainTypeString == "Swipe Gesture" {
                 
                 mainTypeArray = [ "Images", "Game Art", "Orientation Change", "Button Pattern", "Button Tap",  "Button Quick", "Pan Gesture", "KYC", "Core Motion", "Find hidden", "Doesn't fit", "End sentence", "Long Press", "Multiple Tap Button", "Image Collide",  "Swipe Left", "Swipe Down","Don't Press", "Blow in Mic"]
                 
                 } else if mainTypeString == "Image Collide" {
                 
                 mainTypeArray = ["Images", "Game Art", "Orientation Change", "Button Pattern", "Button Tap",  "Button Quick", "Pan Gesture", "KYC", "Core Motion", "Find hidden", "Doesn't fit", "End sentence", "Long Press", "Multiple Tap Button", "Swipe Left", "Swipe Gesture", "Swipe Down", "Don't Press","Blow in Mic"]
                 
                } else if mainTypeString == "Swipe Left" {
                    
                    mainTypeArray = [ "Images", "Game Art", "Orientation Change", "Button Pattern", "Button Tap",  "Button Quick", "Pan Gesture", "KYC", "Core Motion", "Find hidden", "Doesn't fit", "End sentence", "Long Press", "Multiple Tap Button", "Image Collide",  "Swipe Gesture", "Swipe Down", "Don't Press", "Blow in Mic"]
                    
                } else if mainTypeString == "Blow in Mic" {
                    
                mainTypeArray = [ "Images", "Game Art", "Orientation Change", "Button Pattern", "Button Tap",  "Button Quick", "Pan Gesture", "KYC", "Core Motion", "Find hidden", "Doesn't fit", "End sentence", "Long Press", "Multiple Tap Button", "Image Collide",  "Swipe Left", "Swipe Gesture", "Swipe Down", "Don't Press",]
                    
                } else if mainTypeString == "Swipe Down" {
                    
                    mainTypeArray = [ "Images", "Game Art", "Orientation Change", "Button Pattern", "Button Tap",  "Button Quick", "Pan Gesture", "KYC", "Core Motion", "Find hidden", "Doesn't fit", "End sentence", "Long Press", "Multiple Tap Button", "Image Collide",  "Swipe Left", "Swipe Gesture", "Don't Press", "Blow in Mic"]
                    
                } else if mainTypeString == "Don't Press" {
                    
                    mainTypeArray = [ "Images", "Game Art", "Orientation Change", "Button Pattern", "Button Tap",  "Button Quick", "Pan Gesture", "KYC", "Core Motion", "Find hidden", "Doesn't fit", "End sentence", "Long Press", "Multiple Tap Button", "Image Collide",  "Swipe Left", "Swipe Gesture",  "Swipe Down",  "Blow in Mic"]
                    
                } else  {
                
                    mainTypeArray = ["Images", "Game Art", "Orientation Change", "Button Pattern", "Button Tap",  "Button Quick", "Pan Gesture", "KYC", "Core Motion", "Find hidden", "Doesn't fit", "End sentence", "Long Press", "Multiple Tap Button", "Image Collide",  "Swipe Left", "Swipe Gesture", "Swipe Down", "Don't Press", "Blow in Mic"]
                
                }
                
                
                //blow in mic måste vara sist på ALLA! SÅ att den kan tas bort ifall-->
                if microphoneStatusString == "NO" {
                    mainTypeArray.removeLast()
                }
                
                //Randomizing the type =
                let range: UInt32 = UInt32(mainTypeArray.count)
                let randomNumber = Int(arc4random_uniform(range))
                let pickRandom = mainTypeArray[randomNumber]
                
                destination.mainTypeString = pickRandom
                destination.answer = answer
                destination.score = score
                destination.seconds = seconds
                destination.totalSeconds = totalSeconds
                destination.fails = fails
                destination.rewardUsed = rewardUsed
                
                KYCTimer.invalidate()
                
            }
        }
        
        if segue.identifier == "GameToEnd"{
            if let destination = segue.destination as? EndMenuVC {

                destination.scoreNumber = score
                destination.failsNumber = fails
                destination.timeNumber = totalSeconds
                destination.microphoneStatusString = microphoneStatusString
                destination.rewardUsed = rewardUsed
                destination.formerMainTypeString = mainTypeString
                destination.formerSpecialTypeString = specialTypeString
                timer.invalidate()
                KYCTimer.invalidate()
                
                //MARK: Randomize notificationBanner informing of ___
                let bannerRandom = ["1", "2", "3", "4",]         //"1", "2", "3", "4", "5",
                let bannerRange: UInt32 = UInt32(bannerRandom.count)
                let bannerNumber = Int(arc4random_uniform(bannerRange))
                let pickedBannerRandom = bannerRandom[bannerNumber]
                print("notificationBannerRandom", pickedBannerRandom)
                
                //Another randomization deciding which banner to show
                let bannerTypes = ["ourStory", "review", "socialMedia", "goodScore"]         //"1", "2", "3", "4", "5",
                let bannerTypesRange: UInt32 = UInt32(bannerTypes.count)
                let bannerTypesNumber = Int(arc4random_uniform(bannerTypesRange))
                let pickedBannerTypeRandom = bannerTypes[bannerTypesNumber]
                print("type of random notificationBanner", pickedBannerTypeRandom)
                
                //OUT-COMMENTED tills vidare för att de skapar lagg i spelet
                //destination.pickedBannerRandom = pickedBannerRandom
                //destination.pickedBannerTypeRandom = pickedBannerTypeRandom
                
            }
        }
        
    }//end of prepareforsegue
    
//MARK: orientation Upside down / portrait
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .portraitUpsideDown]
    }
    
    @objc func orientationChanged(notification : NSNotification) {
        print("orientation changed")
            correctAnswer()
    }
    
    
//MARK: Pan Gesture View
    fileprivate func setupActions(){
        
        //randomize background colours
        let randomColourInt:Int = Int(arc4random_uniform(7))
        randomColour = colourArray[randomColourInt]
        colourArray.remove(at: randomColourInt)
        let randomColourInt2:Int = Int(arc4random_uniform(6))
        randomColour2 = colourArray[randomColourInt2]
        colourArray.remove(at: randomColourInt2)
        let randomColourInt3:Int = Int(arc4random_uniform(5))
        randomColour3 = colourArray[randomColourInt3]
        colourArray.remove(at: randomColourInt3)
        let randomColourInt4:Int = Int(arc4random_uniform(4))
        randomColour4 = colourArray[randomColourInt4]
        colourArray.remove(at: randomColourInt4)

        if panImageset == "Zlatan" {
            
            let action = PanGestureAction(swipeDirection: PanGestureViewSwipeDirection.right, image: UIImage(named: "Right")!)
            action.backgroundColor = randomColour
            action.didTriggerBlock = {
                direction in
                
                self.actionDidTrigger(action)
            }
            panGestureView.addAction(action)
            
            let action2 = PanGestureAction(swipeDirection: PanGestureViewSwipeDirection.left, image: UIImage(named: "Left")!)
            action2.backgroundColor = randomColour2
            action2.didTriggerBlock = {
                direction in
                
                self.actionDidTrigger(action2)
                
            }
            panGestureView.addAction(action2)
            
            let action3 = PanGestureAction(swipeDirection: PanGestureViewSwipeDirection.up, image: UIImage(named: "Up")!)
            action3.backgroundColor = randomColour3
            action3.didTriggerBlock = {
                direction in
                
                self.actionDidTrigger(action3)
                
            }
            panGestureView.addAction(action3)
            
            let action4 = PanGestureAction(swipeDirection: PanGestureViewSwipeDirection.down, image: UIImage(named:"Down")!)
            action4.backgroundColor = randomColour4
            action4.didTriggerBlock = {
                direction in
                
                self.actionDidTrigger(action4)
                
            }
            panGestureView.addAction(action4)
            
        } else if panImageset == "Knugen" {
            
            let action = PanGestureAction(swipeDirection: PanGestureViewSwipeDirection.right, image: UIImage(named: "knugenRight")!)
            action.backgroundColor = randomColour
            action.didTriggerBlock = {
                direction in
                
                self.actionDidTrigger(action)
            }
            panGestureView.addAction(action)
            
            let action2 = PanGestureAction(swipeDirection: PanGestureViewSwipeDirection.left, image: UIImage(named: "knugenLeft")!)
            action2.backgroundColor = randomColour2
            action2.didTriggerBlock = {
                direction in
                
                self.actionDidTrigger(action2)
                
            }
            panGestureView.addAction(action2)
            
            let action3 = PanGestureAction(swipeDirection: PanGestureViewSwipeDirection.up, image: UIImage(named: "knugenUp")!)
            action3.backgroundColor = randomColour3
            action3.didTriggerBlock = {
                direction in
                
                self.actionDidTrigger(action3)
                
            }
            panGestureView.addAction(action3)
            
            let action4 = PanGestureAction(swipeDirection: PanGestureViewSwipeDirection.down, image: UIImage(named:"knugenDown")!)
            action4.backgroundColor = randomColour4
            action4.didTriggerBlock = {
                direction in
                
                self.actionDidTrigger(action4)
                
            }
            panGestureView.addAction(action4)
            
        }
    }
    
    fileprivate func setupViews(){
        
        let bigRandArray = ["Knugen", "Zlatan"]
        let bigRange: UInt32 = UInt32(bigRandArray.count)
        let randomNumber = Int(arc4random_uniform(bigRange))
        panImageset = bigRandArray[randomNumber]
        print("panImageset =", panImageset)
        
        if panImageset == "Zlatan" {
            answersArray = [
                "Left", "Right", "Down", "Up"
            ]
        } else if panImageset == "Knugen" {
            answersArray = [
                "knugenUp", "knugenRight", "knugenLeft", "knugenDown"
            ]
        }
        
        //randomize image
        let firstRandom:Int = Int(arc4random_uniform(4))
        firstItem = self.answersArray[firstRandom] as! String
        answersArray.remove(at: firstRandom)
        let secondRandom:Int = Int(arc4random_uniform(3))
        secondItem = self.answersArray[secondRandom] as! String
        answersArray.remove(at: secondRandom)
        let thirdRandom:Int = Int(arc4random_uniform(2))
        thirdItem = self.answersArray[thirdRandom] as! String
        answersArray.remove(at: thirdRandom)
        let fourthRandom:Int = Int(arc4random_uniform(1))
        fourthItem = self.answersArray[fourthRandom] as! String
        
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        container.backgroundColor = UIColor(white: 0.8, alpha: 0.7)
        container.layer.cornerRadius = 150
        container.autoresizingMask = [UIViewAutoresizing.flexibleLeftMargin, UIViewAutoresizing.flexibleRightMargin, UIViewAutoresizing.flexibleTopMargin, UIViewAutoresizing.flexibleBottomMargin]
        
        panImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        panImage.image = UIImage(named: firstItem)
        panImage.center = container.center
        
        container.addSubview(panImage)
        
        panGestureView.contentView.addSubview(container)
        container.center = panGestureView.contentView.center

    }
    
    fileprivate func actionDidTrigger(_ action: PanGestureAction){
        
        let container = self.panImage.superview!
        
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            
            if self.panImage.image == UIImage(named: self.firstItem) && action.image == UIImage(named: self.firstItem) {
            
                self.panImage.image = UIImage(named: self.secondItem)
                container.backgroundColor = action.backgroundColor
                
            } else if self.panImage.image == UIImage(named: self.secondItem) && action.image == UIImage(named: self.secondItem) {
                
                self.panImage.image = UIImage(named: self.thirdItem)
                container.backgroundColor = action.backgroundColor
                
            } else if self.panImage.image == UIImage(named: self.thirdItem) && action.image == UIImage(named: self.thirdItem) {
                
                self.panImage.image = UIImage(named: self.fourthItem)
                container.backgroundColor = action.backgroundColor
                
            } else if self.panImage.image == UIImage(named: self.fourthItem) && action.image == UIImage(named: self.fourthItem) {
                
                self.correctAnswer()
                container.backgroundColor = action.backgroundColor
                
            } else {
            
                self.falseAnswer()
            }
            
        })//end of uiview animate
        
    }//end of actionDidTrigger / PAN GESTURE
    
    
//MARK: KYC PROGRESS VIEW https://github.com/kentya6/KYCircularProgress
    private func configureStarProgress() {
        
        //add container (presented differently on different devices -> works on all like this, comprimised)
        let container = UIView()
        container.frame.size.width = buttons[0].frame.width * 1.3
        container.frame.size.height = buttons[0].frame.height * 1.5
        container.center.x = buttons[3].frame.minX - 60
        container.center.y = buttons[3].frame.minY - 10
        playView.addSubview(container)
        
        //randomize colours
        let firstNumber:Int = Int(arc4random_uniform(UInt32(colourArray.count)))
        randomColour = colourArray[firstNumber]
        colourArray.remove(at: firstNumber)
        let secondNumber:Int = Int(arc4random_uniform(UInt32(colourArray.count)))
        randomColour2 = colourArray[secondNumber]
        colourArray.remove(at: secondNumber)
        let thirdNumber:Int = Int(arc4random_uniform(UInt32(colourArray.count)))
        randomColour3 = colourArray[thirdNumber]
        colourArray.remove(at: thirdNumber)
        
        //the path
        starProgress = KYCircularProgress(frame: CGRect(x: container.center.x, y: container.center.y, width: container.frame.width, height: container.frame.height))
        starProgress.colors = [randomColour, randomColour2, randomColour3]
        starProgress.lineWidth = 12.0
        starProgress.guideLineWidth = 3.0
        starProgress.guideColor = .white
        
        let pathArray = ["Polygon", "Circle", "Triangle", "Half Curve Rectangle", "Curve Rectangle", "Oval" ] //"Polygon", "Circle", "Triangle", "Half Curve Rectangle", "Curve Rectangle", "Oval"
        let randPathInt:Int = Int(arc4random_uniform(UInt32(pathArray.count)))
        let randPath = pathArray[randPathInt]
        let path = UIBezierPath()
        let x = container.frame.width - 20
        let y = container.frame.height - 20
 
        if randPath == "Polygon" {

            path.move(to: CGPoint(x: x/2, y: 10))
            path.addLine(to: CGPoint(x: x, y: y/2))
            path.addLine(to: CGPoint(x: x/2, y: y))
            path.addLine(to: CGPoint(x: 10, y: y/2))
            path.close()
            starProgress.path = path
            backgroundNose.image = UIImage(named: "Polygon")
            
        } else if randPath == "Circle" {
            
            let center = CGPoint(x: container.frame.width / 2, y: container.frame.height / 2)
            starProgress.path = UIBezierPath(arcCenter: center, radius: CGFloat((container.frame).width/2.5), startAngle: CGFloat(Double.pi), endAngle: CGFloat(10), clockwise: true)
            backgroundNose.image = UIImage(named: "Circle")
            
        } else if randPath == "Triangle" {
        
            path.move(to: CGPoint(x: 20, y: 20))
            path.addLine(to: CGPoint(x: x, y: 20))
            path.addLine(to: CGPoint(x: x/2, y: y))
            UIColor.black.setStroke()
            path.stroke()
            path.close()
            starProgress.path = path
            backgroundNose.image = UIImage(named: "Triangle")

        } else if randPath == "Half Curve Rectangle" {
        
            let rectangle = CGRect(x: 10, y: 10, width: x, height: y)
            starProgress.path = UIBezierPath(roundedRect: rectangle, byRoundingCorners: [.topLeft, .bottomRight], cornerRadii: CGSize(width: 35, height: 35))
            backgroundNose.image = UIImage(named: "Half Curve Rectangle")
        
        } else if randPath == "Curve Rectangle" {
            
            let rectangle = CGRect(x: 10, y: 10, width: x, height: y)
            starProgress.path = UIBezierPath(roundedRect: rectangle, cornerRadius: 20)
            backgroundNose.image = UIImage(named: "Curve Rectangle")
            
        } else if randPath == "Oval" {
            
            let ovalPath = UIBezierPath(ovalIn: CGRect(x: 10, y: 10, width: x, height: y))
            starProgress.path = ovalPath
            backgroundNose.image = UIImage(named: "Oval")
        }
        
        starProgress.center = container.center
        playView.addSubview(starProgress)
        starProgress.layer.zPosition = 5;
        backgroundNose.isHidden = true
        backgroundNose.frame = starProgress.frame
        backgroundNose.bounds = starProgress.bounds
        backgroundNose.contentMode = .scaleAspectFit
        playView.addSubview(backgroundNose)
 
    }
    
    @objc private func updateProgress() {
        
        //procent och path inte sync
        progress = progress &+ 1
        let normalizedProgress = Double(progress) / Double(UInt8.max)
        starProgress.progress = normalizedProgress
        taskLabel.text = String.init(format: "%.1f", normalizedProgress * 100.0) + "% Färdig"
        
        if starProgress.progress >= 1.0 && (playView.backgroundColor != UIColor().SwedenYellow()) {
            playView.backgroundColor = UIColor().SwedenYellow()
             backgroundNose.isHidden = false
              //designa images som matchar formerna av svenska flaggan
            perform(#selector(correctAnswerWithDelay), with: nil, afterDelay: 0.5)
            KYCTimer.invalidate()
        }
 
    }//end of KYC PROGRESS VIEW
  
    
//MARK: THIS LEVEL HAS NOT BEEN INCLUDED IN THE LATEST VERSION --> "Numbers" has been removed from all below levels
        //Add 1
    /*func generateRandom3Number() -> String
    {
        var result:String = ""
        
        for _ in 1...3
        {
            let digit:Int = Int(arc4random_uniform(8) + 1)
            
            result += "\(digit)"
        }
        
        return result
    }//end of generaterandomnumber
    
    @objc func textFieldDidChange(textField:UITextField) {
        if inputField?.text?.characters.count == 3 {
            
            inputNumber = Int(inputField!.text!)!

                if(inputNumber - startNumber == 111) {
                    print("Correct!")
                    correctAnswer()
                    
                }else{
                    print("Incorrect!")
                    falseAnswer()
                }
        }
        
        if inputField?.text?.characters.count ?? 0 < 3 {
            return
        }
        
    }//end of textfielddidchange
    */
    
//MARK: Run a lap
    @objc func runALapButton() {
        
        runButton.isEnabled = false
        runButton.backgroundColor = UIColor.white
        runButton.layer.borderColor = UIColor.darkGray.cgColor
        runButton.setTitle("Wait...", for: .normal)
        runnerImageview.layer.add(runnerKeyFrameAnimation, forKey: "animation")
        
        //Delay function to enable your button
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(GameVC.lower1sec)), userInfo: nil, repeats: false)
    }
    
    @objc func lower1sec() {
        
        runButton.isEnabled = true
        runButton.backgroundColor = UIColor.red
        runButton.setTitle("RUN!", for: .normal)
        runButton.layer.borderColor = UIColor.white.cgColor
        randomLaps -= 1
        
        taskLabel.text = "Run \(randomLaps) laps"
        
        if randomLaps <= 0 {
            correctAnswer()
        }
    }//end of run a lap
    
    
//MARK: Long Press
    @objc func longPressBuild(sender: UILongPressGestureRecognizer)  {
        
        if sender.state == .began {
            animateImageView.startAnimating()
            //3 sec to complete
            completeTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(GameVC.buildTimer)), userInfo: nil, repeats: true)
        
        } else if sender.state == .ended || sender.state == .cancelled || sender.state == .failed {
            animateImageView.stopAnimating()
            completeTimer.invalidate()
            if specialTypeString == "midsommarstang" {
                buttons[3].setTitle(" RES IGEN ", for: .normal)
                taskLabel.text = "Släpp inte taget 💪"

            } else {
                taskLabel.text = "Släpp inte taget 🔨"
                buttons[3].setTitle(" BYGG IGEN ", for: .normal)
                
            }
            buttons[3].titleLabel?.numberOfLines = 2
        }
    }
    
    @objc func buildTimer() {
        
        randomLaps += 1
        print(randomLaps, "lapS")
        
        if randomLaps >= 3 {
            animateImageView.stopAnimating()
            animateImageView.image = firstCurrentAnimationImages.last
        }
        if randomLaps >= 3 {
            correctAnswer()
            completeTimer.invalidate()
        }
    }//end of Long Press

//MARK: Swipe Gesture
    @objc func SwipeGesture(sender: UISwipeGestureRecognizer) {
    
        if sender.state == .recognized {
            
            if buttons[0].imageView?.image == firstCurrentAnimationImages.first {
                
                buttons[0].imageView?.startAnimating()
                randomLaps -= 1
                
                if randomLaps > 1 {
                    if firstArray == "cake" {
                        taskLabel.text = "Skär \(randomLaps) prinsesstårtbitar🍰"
                    } else if firstArray == "smorcake" {
                        taskLabel.text = "Skär \(randomLaps) smörgåstårtbitar🍰"
                    } else if firstArray == "jordgubbscake" {
                        taskLabel.text = "Skär \(randomLaps) jordgubbstårtbitar🍰"
                    }
                } else if randomLaps <= 1 {
                    if firstArray == "cake" {
                        taskLabel.text = "Skär \(randomLaps) prinsesstårtbit🍰"
                    } else if firstArray == "smorcake" {
                        taskLabel.text = "Skär \(randomLaps) smörgåstårtbit🍰"
                    } else if firstArray == "jordgubbscake" {
                        taskLabel.text = "Skär \(randomLaps) jordgubbstårtbit🍰"
                    }
                }
                }
            
                if randomLaps <= 0 {
                    taskLabel.text = "Smarrigt 🍰"
                    perform(#selector(correctAnswerWithDelay), with: nil, afterDelay: 0.6)
                }
        }
        
    }//end of Swipe Gesture

//MARK: TOUCH // "image collide"
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if mainTypeString == "Image Collide" {
            
            let touch = touches.first
            location = (touch?.location(in: self.view))!
            runnerImageview.center = location
            
            //ifall bilden touchar den andra
            if (runnerImageview.frame.intersects(backgroundNose.frame)) {
                
                perform(#selector(correctAnswerWithDelay), with: nil, afterDelay: 1)
                self.runnerImageview.isHidden = true
                
                if specialTypeString == "horse" {
                    self.zlatanHead.image = UIImage(named: "whole horse")
                    self.taskLabel.text = "Lilla Gubben, Herr Nilsson och Pippi är glada 🐎"
                } else  if specialTypeString == "zlatan" {
                    self.zlatanHead.image = UIImage(named: "Zlatan")
                    self.taskLabel.text = "Zlatan tackar dig!🤑"
                }
                
            }
        }
    }//end of Touch
    
//MARK: Blow in Mic
    //http://stackoverflow.com/questions/31230854/ios-detect-blow-into-mic-and-convert-the-results-swift
    @objc func levelTimerCallback() {
        
        //we have to update meters before we can get the metering values
        recorder.updateMeters()
        
        //print to the console if we are beyond a threshold value
        if recorder.averagePower(forChannel: 0) > -5 {
            print("blow good")
            print("blow power", recorder.averagePower(forChannel: 0))
            buttons[0].imageView?.startAnimating()
            perform(#selector(correctAnswerWithDelay), with: nil, afterDelay: 0.6)
            recorder?.stop()
            do {
                // This is to unduck others, make other playing sounds go back up in volume
                try session.setActive(false)
            } catch {
                print("Failed to set AVAudioSession inactive. error=\(error)")
            }
        } else if recorder.averagePower(forChannel: 0) < -5  && recorder.averagePower(forChannel: 0) > -12 {
         /*   print("blow too low")
            //randomize cheering
            let cheerArray = ["Harder!😇", "Shake harder!😅", "One more time!🙏", "Try again!😬", "Shake that one more time!👯‍♂️", "You're stronger than that!💪", "Give it another try!💥", "You can shake harder!🙄", "\"Everybody look to the LEFT...\"👈🎶", ] //färre är bättre = "mindre hopp"!
            let firstNumber:Int = Int(arc4random_uniform(9))
            cheerLabel.text = cheerArray[firstNumber]
            */
        } else {
            print("blow no good")
        }
    }//end of blow in mic
    
//MARK: Left Swipe Gesture
    @objc func leftSwipeGesture(sender: UISwipeGestureRecognizer){
    
        if sender.state == .recognized {
            
            if firstArray == "leftKaviar" {
                //klämma ut kaviar åt vänst
            if buttons[0].currentBackgroundImage == UIImage(named: "leftKaviar0") {
                
                buttons[0].setBackgroundImage(UIImage(named: "leftKaviar1"), for: .normal)
                taskLabel.text = "Lite mer, tack."
        
            } else if buttons[0].currentBackgroundImage == UIImage(named: "leftKaviar1") {
                
                buttons[0].setBackgroundImage(UIImage(named: "leftKaviar2"), for: .normal)
                taskLabel.text = "Fortsätt snälla."
                
            }  else if buttons[0].currentBackgroundImage == UIImage(named: "leftKaviar2") {
                
                buttons[0].setBackgroundImage(UIImage(named: "leftKaviar3"), for: .normal)
                taskLabel.text = "Komigen nu!"
                
            } else if buttons[0].currentBackgroundImage == UIImage(named: "leftKaviar3") {
                
                buttons[0].setBackgroundImage(UIImage(named: "leftKaviar4"), for: .normal)
                taskLabel.text = "Tack!"
                perform(#selector(swipeDelay), with: nil, afterDelay: 0.2)
                }
            } else if specialTypeString == "hissaIda" {
                //klämma ut kaviar åt vänst
                if buttons[0].currentBackgroundImage == UIImage(named: "hissaIda0") {
                    
                    buttons[0].setBackgroundImage(UIImage(named: "hissaIda1"), for: .normal)
                    taskLabel.text = "Mer kan du💪"
                    
                } else if buttons[0].currentBackgroundImage == UIImage(named: "hissaIda1") {
                    
                    buttons[0].setBackgroundImage(UIImage(named: "hissaIda2"), for: .normal)
                    taskLabel.text = "Hon ska hela vägen up☝️"
                    
                }  else if buttons[0].currentBackgroundImage == UIImage(named: "hissaIda2") {
                    
                    buttons[0].setBackgroundImage(UIImage(named: "hissaIda3"), for: .normal)
                    taskLabel.text = "Snart där❗️"
                    
                } else if buttons[0].currentBackgroundImage == UIImage(named: "hissaIda3") {
                    
                    buttons[0].setBackgroundImage(UIImage(named: "hissaIda4"), for: .normal)
                    taskLabel.text = "Förgrymmade unge"
                    perform(#selector(swipeDelay), with: nil, afterDelay: 0.2)
                }
            }  else if specialTypeString == "ost" {
                //hyvla ost
                if buttons[0].currentBackgroundImage == UIImage(named: "ost0") {
                    
                    buttons[0].setBackgroundImage(UIImage(named: "ost1"), for: .normal)
                    taskLabel.text = "Lite mer tack🙌"
                    
                } else if buttons[0].currentBackgroundImage == UIImage(named: "ost1") {
                    
                    buttons[0].setBackgroundImage(UIImage(named: "ost2"), for: .normal)
                    taskLabel.text = "Hela vägen ner👇"
                    
                }  else if buttons[0].currentBackgroundImage == UIImage(named: "ost2") {
                    
                    buttons[0].setBackgroundImage(UIImage(named: "ost3"), for: .normal)
                    taskLabel.text = "Snart där❗️"
                    
                } else if buttons[0].currentBackgroundImage == UIImage(named: "ost3") {
                    
                    buttons[0].setBackgroundImage(UIImage(named: "ost4"), for: .normal)
                    taskLabel.text = "Tack😍"
                    perform(#selector(swipeDelay), with: nil, afterDelay: 0.2)
                }
            }else if firstArray == "rightmessmor" {
                //klämma ut kaviar åt vänst
                if buttons[0].currentBackgroundImage == UIImage(named: "rightmessmor0") {
                    
                    buttons[0].setBackgroundImage(UIImage(named: "rightmessmor1"), for: .normal)
                    taskLabel.text = "Lite mer, tack."
                    
                } else if buttons[0].currentBackgroundImage == UIImage(named: "rightmessmor1") {
                    
                    buttons[0].setBackgroundImage(UIImage(named: "rightmessmor2"), for: .normal)
                    taskLabel.text = "Fortsätt snälla."
                    
                }  else if buttons[0].currentBackgroundImage == UIImage(named: "rightmessmor2") {
                    
                    buttons[0].setBackgroundImage(UIImage(named: "rightmessmor3"), for: .normal)
                    taskLabel.text = "Komigen nu!"
                    
                } else if buttons[0].currentBackgroundImage == UIImage(named: "rightmessmor3") {
                    
                    buttons[0].setBackgroundImage(UIImage(named: "rightmessmor4"), for: .normal)
                    taskLabel.text = "Tack!"
                    perform(#selector(swipeDelay), with: nil, afterDelay: 0.2)
                }
            } else if firstArray == "messmor" {
                //klämma ut kaviar åt vänst
                if buttons[0].currentBackgroundImage == UIImage(named: "messmor0") {
                    
                    buttons[0].setBackgroundImage(UIImage(named: "messmor1"), for: .normal)
                    taskLabel.text = "Lite mer, tack."
                    
                } else if buttons[0].currentBackgroundImage == UIImage(named: "messmor1") {
                    
                    buttons[0].setBackgroundImage(UIImage(named: "messmor2"), for: .normal)
                    taskLabel.text = "Fortsätt snälla."
                    
                }  else if buttons[0].currentBackgroundImage == UIImage(named: "messmor2") {
                    
                    buttons[0].setBackgroundImage(UIImage(named: "messmor3"), for: .normal)
                    taskLabel.text = "Komigen nu!"
                    
                } else if buttons[0].currentBackgroundImage == UIImage(named: "messmor3") {
                    
                    buttons[0].setBackgroundImage(UIImage(named: "messmor4"), for: .normal)
                    taskLabel.text = "Tack!"
                    perform(#selector(swipeDelay), with: nil, afterDelay: 0.2)
                }
            } else if firstArray == "rightKaviar" {
                //klämma ut kaviar åt höger
                if buttons[0].currentBackgroundImage == UIImage(named: "rightKaviar0") {
                    
                    buttons[0].setBackgroundImage(UIImage(named: "rightKaviar1"), for: .normal)
                    taskLabel.text = "Lite mer, tack."
                    
                } else if buttons[0].currentBackgroundImage == UIImage(named: "rightKaviar1") {
                    
                    buttons[0].setBackgroundImage(UIImage(named: "rightKaviar2"), for: .normal)
                    taskLabel.text = "Fortsätt snälla."
                    
                }  else if buttons[0].currentBackgroundImage == UIImage(named: "rightKaviar2") {
                    
                    buttons[0].setBackgroundImage(UIImage(named: "rightKaviar3"), for: .normal)
                    taskLabel.text = "Komigen nu!"
                    
                } else if buttons[0].currentBackgroundImage == UIImage(named: "rightKaviar3") {
                    
                    buttons[0].setBackgroundImage(UIImage(named: "rightKaviar4"), for: .normal)
                    taskLabel.text = "Tack!"
                    perform(#selector(swipeDelay), with: nil, afterDelay: 0.2)
                    
                }
                
            }
            
        }
    }
    
    @objc func swipeDelay() {
    
        if firstArray == "rightKaviar" || firstArray == "leftKaviar" {
            taskLabel.text = "En väldigt svensk smak🇸🇪"
            buttons[0].setBackgroundImage(UIImage(named: "Kalles Kaviar Kalle"), for: .normal)
        } else if firstArray == "messmor" || firstArray == "rightmessmor" {
            taskLabel.text = "En väldigt svensk smak🇸🇪"
            buttons[0].setBackgroundImage(UIImage(named: "Messmor"), for: .normal)
        } else if specialTypeString == "hissaIda" {
            taskLabel.text = "Förgrymmade unge!"
            buttons[0].setBackgroundImage(UIImage(named: "Emil"), for: .normal)
        } else if specialTypeString == "ost" {
            taskLabel.text = "En härlig ostmacka 🥪"
            buttons[0].setBackgroundImage(UIImage(named: "Ostmacka"), for: .normal) 
        }
        perform(#selector(correctAnswerWithDelay), with: nil, afterDelay: 0.7)
    }
    
    @objc func swipeIncorrectTouch() {
    
        if mainTypeString == "Swipe Left" && firstArray == "leftKaviar" {
            taskLabel.text = "Tryck ut kaviaren åt 👈"
        } else if mainTypeString == "Swipe Left" && firstArray == "rightKaviar" {
            taskLabel.text = "Tryck ut kaviaren åt 👉"
        } else if mainTypeString == "Swipe Left" && firstArray == "rightmessmor" {
            taskLabel.text = "Tryck ut messmöret åt 👉"
        } else if mainTypeString == "Swipe Left" && firstArray == "messmor" {
            taskLabel.text = "Tryck ut messmöret åt 👈"
        } else if mainTypeString == "Swipe Down" && specialTypeString == "hissaIda"  {
            taskLabel.text = "Hjälp Emil dra snöret 👇"
        } else if mainTypeString == "Swipe Down" && specialTypeString == "ost"  {
            taskLabel.text = "Swipea osthyveln 👇"
        } else if mainTypeString == "Swipe Gesture" {
            taskLabel.text = "Swipea kniven 👇"
        } else if mainTypeString == "KYC" {
            taskLabel.text = "Öka hastigheten🖍"
        }
    
    } //end of left swipe gesture

    
}//end of class
