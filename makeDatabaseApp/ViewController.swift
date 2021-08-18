//
//  ViewController.swift
//  makeDatabaseApp
//
//  Created by 酒井直輝 on 2021/05/28.
//

import UIKit
import Firebase
import FirebaseFirestore
class ViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var foodNameTextField: UITextField!
    @IBOutlet weak var cTextField: UITextField!
    @IBOutlet weak var pTextField: UITextField!
    @IBOutlet weak var fTextField: UITextField!
    @IBOutlet weak var kcalTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        foodNameTextField.delegate = self
        cTextField.delegate = self
        pTextField.delegate = self
        fTextField.delegate = self
        kcalTextField.delegate = self
        registerButtonIsEnabled()
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func showKeyboard(notification: Notification){
        let keyboardFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        guard let keyboardMinY = keyboardFrame?.minY else {return}
        let registerButtonMaxY = registerButton.frame.maxY
        let distance = registerButtonMaxY - keyboardMinY + 20
        let transform = CGAffineTransform(translationX: 0, y: -distance)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
            self.view.transform = transform
        })
        
    }
    
    
    @objc func hideKeyboard(){
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
            self.view.transform = .identity
        })
    }
    
    func registerButtonIsEnabled(){
        if cTextField.text?.isEmpty == true || pTextField.text?.isEmpty == true || fTextField.text?.isEmpty == true || kcalTextField.text?.isEmpty == true || foodNameTextField.text?.isEmpty == true {
            registerButton.isEnabled = false
            registerButton.backgroundColor = .gray
        }else{
            registerButton.isEnabled = true
            registerButton.backgroundColor = .blue
        }
    }
    func calc(){
        let cKcal = Double(cTextField.text!)! * 4.0
        let pKcal = Double(pTextField.text!)! * 4.0
        let fKcal = Double(fTextField.text!)! * 9.0
        let totalKcal = (floor(cKcal + pKcal + fKcal))
        print(cKcal)
        print(pKcal)
        print(fKcal)
        print(totalKcal)
        kcalTextField.text = String(totalKcal)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        registerButtonIsEnabled()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }

    @IBAction func registerButton(_ sender: Any) {
        guard let foodName = foodNameTextField.text else {return}
        guard let c = cTextField.text else {return}
        guard let p = pTextField.text else {return}
        guard let f = fTextField.text else {return}
        guard let kcal = kcalTextField.text else {return}
        
        let docData = ["foodName":foodName,
                       "carb":c,
                       "protein":p,
                       "fat":f,
                       "kcal":kcal
        ]
        Firestore.firestore().collection("foods").document().setData(docData) { Error in
            if Error != nil{
                print("データベースへの保存に失敗しました。")
                return
            }else{
                print("データベースへの保存に成功しました。")
                self.foodNameTextField.text = ""
                self.cTextField.text = ""
                self.pTextField.text = ""
                self.fTextField.text = ""
                self.kcalTextField.text = ""
            }
        }
        
        
    }
    
}

