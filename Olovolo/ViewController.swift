//
//  ViewController.swift
//  Olovolo
//
//  Created by Emil on 14.08.15.
//  Copyright © 2015 Emil Askerov. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    // Функция для DELAY
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time( DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }
    // Функция для DELAY
    
///////////////////////////////////////ТАЙМЕР////////////////////////////////////////////
    var timerRunning = false
    var timerCount: IntegerLiteralType = 80
    var timerClock = NSTimer()

    @IBOutlet weak var labelTimer: UILabel!
    
    func Counting(){
        timerCount -= 1
        if (timerCount >= 70){
                labelTimer.text = "1:" + "\(timerCount-60)"
        } else if (timerCount >= 60 && timerCount < 70) {labelTimer.text = "1:0" + "\(timerCount-60)"}
          else if (timerCount < 60 && timerCount >= 10) {labelTimer.text = "0:" + "\(timerCount)"}
          else if (timerCount > 0 && timerCount < 10){labelTimer.text = "0:0" + "\(timerCount)"}
        else {labelTimer.text = "0:00"}
}
    
//////////////////////////////////////ТАЙМЕР/////////////////////////////////////////////
    
    @IBOutlet weak var volchok: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var buttonStart: UIButton!
    @IBOutlet weak var imageSectora: UIImageView!
    @IBOutlet weak var buttonOkay: UIButton!
    @IBOutlet var konvert: [UIImageView]!
    @IBOutlet weak var labelZnatoki: UILabel!
    @IBOutlet weak var labelZriteli: UILabel!
    @IBOutlet weak var siluet: UIImageView!
    @IBOutlet weak var voprosZadaet: UILabel!
    @IBOutlet weak var buttonNewGame: UIButton!

    var playedQuestions = [(Int)]()
    var defaults = NSUserDefaults.standardUserDefaults()
    
    func saveDoneQuestions(){
        playedQuestions.append(currentKey)
        defaults.setObject(playedQuestions, forKey: "SavedArray")
        print(playedQuestions)
    }
    
    var keyboardIsOn = false
    var arrayEnvelopes: Array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    var zriteli = 0
    var znatoki = 0
    var answer = (key:"", prefiks:"", theword:"", suffiks:"", komments:"")
    var namesPlist = NSBundle.mainBundle().pathForResource("names", ofType: "plist") // Получаем доступ к файлу
    var surnamesPlist = NSBundle.mainBundle().pathForResource("surnames", ofType: "plist") // Получаем доступ к файлу
    var citiesPlist = NSBundle.mainBundle().pathForResource("cities", ofType: "plist") // Получаем доступ к файлу
    var questionsPlist = NSBundle.mainBundle().pathForResource("questions", ofType: "plist") // Получаем доступ к файлу
    var answersPlist = NSBundle.mainBundle().pathForResource("answers", ofType: "plist") // Получаем доступ к файлу
    var prefixesPlist = NSBundle.mainBundle().pathForResource("prefixes", ofType: "plist") // Получаем доступ к файлу
    var suffixesPlist = NSBundle.mainBundle().pathForResource("suffixes", ofType: "plist") // Получаем доступ к файлу
    var kommentsPlist = NSBundle.mainBundle().pathForResource("komments", ofType: "plist") // Получаем доступ к файлу
    var numderOfRotations: Int = 0
    var randomNumderOfRotations = Int()
    var period: Double = 0.06
    var currentAngle: Int = 0
    var summaryAngle: Int = 0
    var currentKey = Int()
    var isRotating = true
    var timer = NSTimer()
    
    @IBOutlet var mainView: UIView!

    func loadQuestion (){
        repeat {currentKey = Int(arc4random_uniform(91))} while (playedQuestions.contains(currentKey))
        
            let dictQuestions = NSDictionary(contentsOfFile: questionsPlist!)
            let dictPrefixes = NSDictionary(contentsOfFile: prefixesPlist!)
            let dictSuffixes = NSDictionary(contentsOfFile: suffixesPlist!)
            let dictKomments = NSDictionary(contentsOfFile: kommentsPlist!)

            answer.prefiks = dictPrefixes!.valueForKey("\(currentKey)") as! String
            answer.suffiks = dictSuffixes!.valueForKey("\(currentKey)") as! String
            answer.komments = dictKomments!.valueForKey("\(currentKey)") as! String
            textView.text = dictQuestions!.valueForKey("\(currentKey)") as! String
    }
    
    func authorOfQuestion(){
        let currentAuthorName = arc4random_uniform(22)+1
        let dictAuthorName = NSDictionary(contentsOfFile: namesPlist!)
        let currentAuthorSurname = arc4random_uniform(22)+1
        let dictAuthorSurname = NSDictionary(contentsOfFile: surnamesPlist!)
        let currentCity = arc4random_uniform(22)+1
        let dictCity = NSDictionary(contentsOfFile: citiesPlist!)
        voprosZadaet.text = "Вопрос задает" + "\n" + (dictAuthorName!.valueForKey("\(currentAuthorName)") as! String) + " " + (dictAuthorSurname!.valueForKey("\(currentAuthorSurname)") as! String) + "\n" + "из " + (dictCity!.valueForKey("\(currentCity)") as! String)
    }
    
    func hideKeyboard(){
        if (keyboardIsOn == true) {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.mainView.frame.origin.y += 200
        })
        keyboardIsOn = false
        }
    }
    
    func showKeyboard (){
        if (keyboardIsOn == false) {
        textField.text = nil
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.mainView.frame.origin.y -= 200
        })
        keyboardIsOn = true
        }
    }
    
    func thatsRight(){
        labelTimer.alpha = 0
        labelTimer.text = "1:20"
        let dictAnswers = NSDictionary(contentsOfFile: answersPlist!)
        answer.theword = dictAnswers!.valueForKey("\(currentKey)") as! String
        znatoki += 1
        labelZnatoki.text = "\(self.znatoki)"
        labelZriteli.text = "\(self.zriteli)"
        textView.text = "Совершенно верно!"+"\n"+" \(answer.theword)"+"\n"+"\n" + "\(answer.komments)" + "\n" + "\n" + "Cчёт становится \(znatoki):\(zriteli)"
    }
    
    func thatsWrong(){
        labelTimer.alpha = 0
        labelTimer.text = "1:20"
        let dictAnswers = NSDictionary(contentsOfFile: answersPlist!)
        answer.theword = dictAnswers!.valueForKey("\(currentKey)") as! String
        zriteli += 1
        labelZnatoki.text = "\(self.znatoki)"
        labelZriteli.text = "\(self.zriteli)"
        textView.text = "Внимание, правильный ответ:"+"\n"+"\(answer.theword)" + "\n" + "\n" + "\(answer.komments)" + "\n" + "\n" + "Cчёт становится \(znatoki):\(zriteli)"
    }
    
    func rotating(){
        if (randomNumderOfRotations > numderOfRotations){
            numderOfRotations += 1
            UIButton.animateWithDuration(1.2, delay: 0.0, options: UIViewAnimationOptions.BeginFromCurrentState, animations:
            {
        self.buttonStart.transform = CGAffineTransformRotate(self.buttonStart.transform, 30*CGFloat(M_PI)/180.0)
                            }, completion: nil)
            
            UIImageView.animateWithDuration(1.8, delay: 0.0, options: UIViewAnimationOptions.BeginFromCurrentState, animations:
                {
        self.volchok.transform = CGAffineTransformRotate(self.volchok.transform, 30*CGFloat(M_PI)/360.0)
                }, completion: nil)
        }
//        UIButton.animateWithDuration(1.0, animations: {() -> Void in
//        self.buttonStart.transform = CGAffineTransformMakeRotation((30 * CGFloat(M_PI)) / 180.0)
//            })
//        }
    }
    
    
    @IBAction func actionOkay(sender: UIButton) {
        textField.enabled = true
        UIButton.animateWithDuration(0.5, animations: {() -> Void in
            self.imageSectora.alpha = 1
            self.textView.alpha = 0
            self.buttonOkay.alpha = 0
            self.textField.alpha = 0
            self.voprosZadaet.alpha = 0
            self.siluet.alpha = 0
            self.labelZnatoki.alpha = 1
            self.labelZriteli.alpha = 1
            })
        isRotating = true
        if (zriteli == 2) {
            buttonOkay.alpha = 1
            textView.alpha = 1
            textView.text = "\n" + "\n" + "К сожалению," + "\n" + "вы не выиграли 😒" + "\n" + "\n" + "Cчёт \(znatoki):\(zriteli)" + "\n" + "в пользу телезрителей" + "\n" + "\n" + "Начните новую игру и вас ждёт удача!" + "\n" + "🖐"
            buttonNewGame.alpha = 1
        }
        if (znatoki == 2) {
            buttonOkay.alpha = 1
            textView.alpha = 1
            textView.text = "\n" + "\n" + "🍾Победа!🍾" + "\n" + "Игра окончена" + "\n" + "\n" + "Cчёт \(znatoki):\(zriteli)" + "\n" + "в вашу пользу" + "\n" + "\n" + "Начните новую игру и улучшите свой результат!👏"
            buttonNewGame.alpha = 1
        }
    }
    
    @IBAction func actionNewGame(sender: AnyObject) {
    }
    
    @IBAction func actionStart(sender: AnyObject) {


        
        //Загружаем ушедшие вопросы
//        playedQuestions = defaults.arrayForKey("SavedArray") as! [(Int)] //УБРАТЬ ЭТУ СТРОКУ, ЧТОБЫ СБРОСИТЬ СПИСОК УШЕДШИХ ВОПРОСОВ
        print("Сыгранные вопросы:", playedQuestions)
        //Загрузили ушедшие вопросы
        
        var temporaryAngle = Int()
        
        if (isRotating == true){
        let currentAngle =  Int(arc4random_uniform(12))+1
        print("currentAngle:", currentAngle)
        randomNumderOfRotations = 60 + currentAngle
        print("summaryAngle1:", summaryAngle)
        if (summaryAngle + currentAngle <= 12) {summaryAngle = summaryAngle+currentAngle} else {summaryAngle = summaryAngle+currentAngle-12}
        print("summaryAngle2:" ,summaryAngle)
        timer = NSTimer.scheduledTimerWithTimeInterval(period, target: self, selector: #selector(ViewController.rotating), userInfo: nil, repeats: true)
        numderOfRotations = 0
        period += period*3.1415*2
        print(arrayEnvelopes, "\n")

        loadQuestion()
        authorOfQuestion()
        
        delay(5.0){
            temporaryAngle = self.summaryAngle
            while self.arrayEnvelopes[temporaryAngle - 1] == 0 {
                if (temporaryAngle < 12){temporaryAngle += 1} else {temporaryAngle = 1}
            }
            

            print("array:", self.arrayEnvelopes[temporaryAngle-1])

            let CGTemporaryAngle = CGFloat(temporaryAngle)
        UIButton.animateWithDuration(0.5, animations: {() -> Void in
            self.view.viewWithTag(temporaryAngle)?.transform = CGAffineTransformRotate((self.view.viewWithTag(temporaryAngle)?.transform)!, (360-CGTemporaryAngle*30) * CGFloat(M_PI)/180.0)
        })
            }
        
            delay(5.6) {
        UIButton.animateWithDuration(0.5, animations: {() -> Void in
            self.view.viewWithTag(temporaryAngle)?.frame.size.height += 250
            self.view.viewWithTag(temporaryAngle)?.frame.size.width += 400
            self.view.viewWithTag(temporaryAngle)?.center.x += self.mainView.center.x - (self.view.viewWithTag(self.summaryAngle)?.center.x)!
            self.view.viewWithTag(temporaryAngle)?.center.y += self.mainView.center.y - (self.view.viewWithTag(self.summaryAngle)?.center.y)!
            self.view.viewWithTag(temporaryAngle)?.alpha = 0
            })
        }
        
        delay(6.0) {
                self.arrayEnvelopes[temporaryAngle-1] = 0
                print(self.arrayEnvelopes)
            
            UIButton.animateWithDuration(0.5, animations: {() -> Void in
                self.imageSectora.alpha = 0
                self.textView.alpha = 1
                self.textField.alpha = 1
                self.voprosZadaet.alpha = 1
                self.siluet.alpha = 1
                self.labelZnatoki.alpha = 0
                self.labelZriteli.alpha = 0
//////////////////////////////////////ТАЙМЕР/////////////////////////////////////////////
                self.labelTimer.alpha = 1
            })
            self.timerCount = 80
            self.timerRunning = true
            self.timerClock = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ViewController.Counting), userInfo: nil, repeats: true)
//////////////////////////////////////ТАЙМЕР/////////////////////////////////////////////
        }
            isRotating = false
        }
        saveDoneQuestions()
    }

    @IBAction func startType(sender: AnyObject) {
        showKeyboard()
    }

    @IBAction func finishTyping(sender: AnyObject) {
        timerClock.invalidate()
        self.buttonOkay.alpha = 1
        hideKeyboard()
        if(textField.text!.hasPrefix(answer.prefiks) || textField.text!.hasSuffix(answer.suffiks)){
            thatsRight()
        } else {thatsWrong()}
        textField.text = ""
        textField.enabled = false
        textField.alpha = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.viewWithTag(1)?.transform = CGAffineTransformRotate((self.view.viewWithTag(1)?.transform)!, 30*CGFloat(M_PI)/180.0)
        self.view.viewWithTag(2)?.transform = CGAffineTransformRotate((self.view.viewWithTag(2)?.transform)!, 60*CGFloat(M_PI)/180.0)
        self.view.viewWithTag(3)?.transform = CGAffineTransformRotate((self.view.viewWithTag(3)?.transform)!, 90*CGFloat(M_PI)/180.0)
        self.view.viewWithTag(4)?.transform = CGAffineTransformRotate((self.view.viewWithTag(4)?.transform)!, 120*CGFloat(M_PI)/180.0)
        self.view.viewWithTag(5)?.transform = CGAffineTransformRotate((self.view.viewWithTag(5)?.transform)!, 150*CGFloat(M_PI)/180.0)
        self.view.viewWithTag(6)?.transform = CGAffineTransformRotate((self.view.viewWithTag(6)?.transform)!, 180*CGFloat(M_PI)/180.0)
        self.view.viewWithTag(7)?.transform = CGAffineTransformRotate((self.view.viewWithTag(7)?.transform)!, 210*CGFloat(M_PI)/180.0)
        self.view.viewWithTag(8)?.transform = CGAffineTransformRotate((self.view.viewWithTag(8)?.transform)!, 240*CGFloat(M_PI)/180.0)
        self.view.viewWithTag(9)?.transform = CGAffineTransformRotate((self.view.viewWithTag(9)?.transform)!, 270*CGFloat(M_PI)/180.0)
        self.view.viewWithTag(10)?.transform = CGAffineTransformRotate((self.view.viewWithTag(10)?.transform)!, 300*CGFloat(M_PI)/180.0)
        self.view.viewWithTag(11)?.transform = CGAffineTransformRotate((self.view.viewWithTag(11)?.transform)!, 330*CGFloat(M_PI)/180.0)
        self.view.viewWithTag(12)?.transform = CGAffineTransformRotate((self.view.viewWithTag(12)?.transform)!, 360*CGFloat(M_PI)/180.0)
        self.buttonStart.transform = CGAffineTransformRotate((self.buttonStart.transform), 270*CGFloat(M_PI)/180.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

