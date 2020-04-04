//
//  ViewController.swift
//  Speller
//
//  Created by user on 04/04/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet var numberTextField: UITextField!
    @IBOutlet var convertButton: UIButton!
    @IBOutlet var resultLabel: UILabel!
    var onesArray = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
    var partialTensArray = ["eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "ninteen"]
    var tensArray = ["ten", "twenty", "thirty", "fourty", "fifty", "sixty", "seventy", "eighty", "ninety"]
    var resultString = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        numberTextField.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    @IBAction func convertButtonAction(_ sender: Any) {
        resultLabel.text = resultString
        if validationPassed() {
            processInput(for: numberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
        } else {
            return
        }
    }
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
               let content = text.count + string.count - range.length
               //Only Numbers without spaces
               //Note: The double Quotes NSCharacterSet ends with Space i.e "ABCD....9 "
               let set = NSCharacterSet(charactersIn:
                   "0123456789").inverted
        if content > 5 { warningAlert(with: "Only Five digits is allowed") }
        return string.rangeOfCharacter(from: set) == nil && content <= 5
    }
    func processInput(for inputNumber: String) {
        var numbersArray = inputNumber.compactMap{ $0.wholeNumberValue }
        if numbersArray.count >= 2 && numbersArray[0] == 0 {
            numbersArray.remove(at: 0)
        }
        if numbersArray.count == 1 {
            resultString = onesCalculation(numbersArray)
        } else if numbersArray.count == 2 {
            resultString = tensCalculation(numbersArray)
        } else if numbersArray.count == 3 {
            resultString = hundredsCalculation(numbersArray)
        } else if numbersArray.count == 4 {
            resultString = thousandsCalculation(numbersArray)
        } else if numbersArray.count == 5 {
            resultString = tenThousandsCalculation(numbersArray)
        }
        resultLabel.text = resultString
    }
    func validationPassed() -> Bool {
        if numberTextField.text == "" {
            warningAlert(with: "Please Enter the Number")
            return false
        } else if  numberTextField.text != nil && numberTextField.text!.count > 5 {
            warningAlert(with: "Only Five digits is allowed")
        }
        return true
    }
    func warningAlert(with message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    func onesCalculation(_ inputNumberArray: [Int]) -> String {
        //inputNumberArray[0] -> Unit Digit
        if inputNumberArray[0] == 0 {
            return "zero"
        }
        return onesArray[inputNumberArray[0] - 1]
    }
    func tensCalculation(_ inputNumberArray: [Int]) -> String {
        //inputNumberArray[0] -> Tens Digit
        //inputNumberArray[1] -> Unit Digit
        if inputNumberArray[1] == 0 {
            return tensArray[inputNumberArray[0] - 1]
        } else if inputNumberArray[0] == 1 {
            return partialTensArray[inputNumberArray[1] - 1]
        } else if inputNumberArray[0] > 1 {
            return tensArray[inputNumberArray[0] - 1] + "-" + onesArray[inputNumberArray[1] - 1]
        } else {
            return ""
        }
    }
    func hundredsCalculation(_ inputNumberArray: [Int]) -> String {
        //inputNumberArray[0] -> hundreds Digit
        //inputNumberArray[1] -> Tens Digit
        //inputNumberArray[2] -> Unit Digit
        var result = ""
        if inputNumberArray[1] == 0 && inputNumberArray[2] == 0 {
            result = onesArray[inputNumberArray[0] - 1] + " hundred "
            return result
        } else if inputNumberArray[1] == 0 {
            result = onesArray[inputNumberArray[0] - 1] + " hundred and " + onesCalculation([inputNumberArray[2]])
            return result
        } else {
            result = onesArray[inputNumberArray[0] - 1] + " hundred and " + tensCalculation([inputNumberArray[1], inputNumberArray[2]])
            return result
        }
    }
    func thousandsCalculation(_ inputNumberArray: [Int]) -> String {
        //inputNumberArray[0] -> Thousands Digit
        //inputNumberArray[1] -> hundreds Digit
        //inputNumberArray[2] -> Tens Digit
        //inputNumberArray[3] -> Unit Digit
        var result = ""
        if inputNumberArray[1] == 0 && inputNumberArray[2] == 0 && inputNumberArray[3] == 0 {
            result = onesArray[inputNumberArray[0] - 1] + " thousand "
            return result
        } else if inputNumberArray[1] == 0 && inputNumberArray[2] == 0 {
            result = onesArray[inputNumberArray[0] - 1] + " thousand " + onesCalculation([inputNumberArray[3]])
            return result
        } else if inputNumberArray[1] == 0 {
            result = onesArray[inputNumberArray[0] - 1] + " thousand " + tensCalculation([inputNumberArray[2], inputNumberArray[3]])
            return result
        } else {
            result = onesArray[inputNumberArray[0] - 1] + " thousand " + hundredsCalculation([inputNumberArray[1], inputNumberArray[2], inputNumberArray[3]])
            return result
        }
    }
    func tenThousandsCalculation(_ inputNumberArray: [Int]) -> String {
        //inputNumberArray[0] -> Ten Thousands Digit
        //inputNumberArray[1] -> Thousands Digit
        //inputNumberArray[2] -> hundreds Digit
        //inputNumberArray[3] -> Tens Digit
        //inputNumberArray[4] -> Unit Digit
        var result = ""
        if inputNumberArray[2] == 0 && inputNumberArray[3] == 0 && inputNumberArray[4] == 0 {
            result = tensCalculation([inputNumberArray[0], inputNumberArray[1]]) + " thousand "
            return result
        } else if inputNumberArray[2] == 0 && inputNumberArray[3] == 0 {
            result = tensCalculation([inputNumberArray[0], inputNumberArray[1]]) + " thousand " + onesCalculation([inputNumberArray[4]])
            return result
        } else if inputNumberArray[2] == 0 {
            result = tensCalculation([inputNumberArray[0], inputNumberArray[1]]) + " thousand " + tensCalculation([inputNumberArray[3], inputNumberArray[4]])
            return result
        } else {
            result = tensCalculation([inputNumberArray[0], inputNumberArray[1]]) + " thousand " + hundredsCalculation([inputNumberArray[2], inputNumberArray[3], inputNumberArray[4]])
            return result
        }
    }
}
