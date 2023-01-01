//
//  ViewController.swift
//  Money by the Minute
//
//  Created by William Jones on 12/31/22.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var hourlyRateFld: UITextField!
    
    @IBOutlet var hoursLabel: UILabel!
    @IBOutlet var minutesLabel: UILabel!
    @IBOutlet var secondsLabel: UILabel!
    @IBOutlet var totalLabel: UILabel!
    @IBOutlet var startStopBtn: UIButton!
    
    private var timeTracking: Bool = false
    private var timer: Timer?
    private var hours = 0
    private var minutes = 0
    private var seconds = 0
    private var hourlyRate: Double = 0.00 //38.4615385 // *** HARD CODED ***
    private var payPerSecond = 0.00
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        startStopBtn.isEnabled = false // disable start/stop button
        hourlyRateFld.delegate = self
        hourlyRateFld.text = "0.00"
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }

    @IBAction func startStop(_ sender: UIButton) {
        switch timeTracking {
        case true:
            print("Stop Timer")
            startStopBtn.setTitle("Start", for: .normal)
            timeTracking = false
            stopTimer()
        case false:
            print("Start Timer")
            startStopBtn.setTitle("Stop", for: .normal)
            timeTracking = true
            startTimer()
        }
        
    }
    
    func startTimer() {
        //payPerSecond = hourlyRate/3600
        print("Pay Per Second: \(payPerSecond)")
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
          // This block of code will be executed every second
            self.seconds += 1
            //print("Seconds: \(self.seconds)")
            
            if (self.seconds == 60) {
                self.seconds = 0
                self.minutes += 1
            }
            
            if (self.minutes == 60) {
                self.minutes = 0
                self.hours += 1
            }
            
            self.hoursLabel.text = "Hours: \(self.hours)"
            self.minutesLabel.text = "Minutes: \(self.minutes)"
            self.secondsLabel.text = "Seconds: \(self.seconds)"
            
            let totalHours = 0.00
            let totalMinutes = self.roundToTwoDecimalPlaces(value:(Double(self.minutes) * 60 * self.payPerSecond))
            let totalSeconds = self.roundToTwoDecimalPlaces(value:(Double(self.seconds) * self.payPerSecond))
            let totalPay = totalHours + totalMinutes + totalSeconds
            
            print("total seconds: \(totalSeconds)")
            self.totalLabel.text = String(format: "$%.2f", totalPay)
            
        }// end closure
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @IBAction func reset(_ sender: UIButton) {
        print("Reset")
        stopTimer()
        hourlyRate = 0.00
        hours = 0
        minutes = 0
        seconds = 0
        hourlyRate = 0.00
        payPerSecond = 0.00
        hourlyRateFld.text = "0.00"
        totalLabel.text = "$0.00"
        hoursLabel.text = "Hours: \(hours)"
        minutesLabel.text = "Minutes: \(minutes)"
        secondsLabel.text = "Seconds: \(seconds)"
        startStopBtn.isEnabled = false
    }
    
    func calculatePayPerSecond(hourlyRate: Double) -> Double {
        let payPerSecond = hourlyRate / 3600
        let roundedPayPerSecond = (payPerSecond * 100).rounded() / 100
        return roundedPayPerSecond
    }
    
    func roundToTwoDecimalPlaces(value: Double) -> Double {
        let roundedValue = (value * 100).rounded() / 100
        print("Rounded Value: \(roundedValue)")
        return roundedValue
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Get the current text in the text field
        let currentText = textField.text ?? ""

        // Calculate the new text after adding the replacement string
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)

        // Check if the new text is a valid number with two decimal places
        let regex = "^\\d*(\\.\\d{0,2})?$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        
        return predicate.evaluate(with: newText)
    }
    
    @objc func handleTap() {
        // enable/disable Start/Stop button based on valid
        if let text = hourlyRateFld.text, let value = Double(text) {
            // The text field contains a valid Double value
            if (value > 0) {
                print(value)
                hourlyRate = value
                payPerSecond = hourlyRate/3600
                startStopBtn.isEnabled = true
                print("Hourly Rate: $\(hourlyRate)\nPer Second Rate: \(payPerSecond)")
                
            } else {
                startStopBtn.isEnabled = false
            }
        }

        // keyboard is dismissed
        hourlyRateFld.resignFirstResponder()
    }
    
}
