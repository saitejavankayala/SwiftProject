//
//  LoginViewController.swift
//  SwiftAssignment
//
//  Created by MA-31 on 20/03/23.
//

import UIKit

class LoginViewController: UIViewController {

    //password hide and show
    var iconClick = false
    let imageIcon = UIImageView()
    @IBOutlet weak var passWordField: UITextField!
    @IBOutlet weak var emailFieldError: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordFieldError: UILabel!
    @IBOutlet weak var submitButton: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.passWordField.delegate = self
        self.emailField.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tapGesture)
        imageIcon.image = UIImage(named: "closeEye")
        let contentView = UIView()
        contentView.addSubview(imageIcon)
        contentView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        imageIcon.frame = CGRect(x: -10, y: 0, width:25, height: 25)
        passWordField.rightView = contentView
        passWordField.rightViewMode =  .always
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageIcon.isUserInteractionEnabled = true
        imageIcon.addGestureRecognizer(tapGestureRecognizer)
        resetForm()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    func resetForm(){
        submitButton.isEnabled=false
        emailField.text = ""
        passWordField.text=""
        emailFieldError.isHidden = false
        passwordFieldError.isHidden = false
        emailFieldError.text=""
        passwordFieldError.text=""
     }

    @objc func imageTapped(tapGestureRecognizer:UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        if iconClick
        {
            iconClick = false
            tappedImage.image = UIImage(named: "openEye")
            passWordField.isSecureTextEntry = false
        }else{
            iconClick = true
            tappedImage.image = UIImage(named: "closeEye")
            passWordField.isSecureTextEntry = true
        
        }
    }
    
    @IBAction func emailChange(_ sender: Any) {
        if let email=emailField.text{
            if let errorMessage = invalidEmail(value: email){
                emailFieldError.isHidden=false
                emailFieldError.text=(errorMessage)
            }else{
                emailFieldError.isHidden = true
            }
        }
        checkValidationForm()
    }
    
    func invalidEmail(value : String) -> String?{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if !emailPred.evaluate(with: value){
            return "Invalid Email Address"
        }
        return nil
    }
    func checkValidationForm(){
        if emailFieldError.isHidden && passwordFieldError.isHidden
        {
            submitButton.isEnabled=true
        }else{
            submitButton.isEnabled=false
        }
    }
    
    @IBAction func passwordChange(_ sender: Any) {
        if let password=passWordField.text{
            if let passwordErrorValue = inValidPassword(password){
                passwordFieldError.isHidden=false
                passwordFieldError.text=(passwordErrorValue)
            }else{
                passwordFieldError.isHidden=true
            }
        }
        checkValidationForm()
    }
    
    func inValidPassword(_ value: String)-> String?{
        if(!NSPredicate(format:"SELF MATCHES %@", ".*[A-Z]+.*").evaluate(with: value)){
                return ("least one uppercase")
        }
        if(!NSPredicate(format:"SELF MATCHES %@", ".*[0-9]+.*").evaluate(with: value)){
               return("least one digit")
        }
        if(!NSPredicate(format:"SELF MATCHES %@", ".*[!&^%$#@()/]+.*").evaluate(with: value)){
                return("least one symbol")
        }
        if(!NSPredicate(format:"SELF MATCHES %@", ".*[a-z]+.*").evaluate(with: value)){
                return("least one lowercase")
        }
        if(value.count<=8){
            return "Please enter password more than 8 characters"
        }
        
        return nil
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        self.view.resignFirstResponder()
        emailField.resignFirstResponder()
    }

    
    @IBAction func loginInButtonAction(_ sender: Any) {
            apiCalling()
    }
  
    func navigationToDashboard() {
        DispatchQueue.main.async {
            guard let storyBoard =
                    UIStoryboard(name: "DashBoard", bundle: .main).instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else{
                return
            }
            UserDefaults.standard.set(true, forKey: "isLoginStatus")
            UserDefaults.standard.set(self.emailField.text!, forKey: "emailValue")
            UserDefaults.standard.set(self.passWordField.text!, forKey: "passwordValue")
           
            self.navigationController?.pushViewController(storyBoard, animated: true)
        }
    }
    func showAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: "User Doesnot Exist" ,preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: { _ in
                //Cancel Action
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func apiCalling() {
        DispatchQueue.main.async {
            let emailField = self.emailField.text
            let passwordField = self.passWordField.text
            let parameters = ["email":emailField, "password":passwordField]
            guard let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])else{
                return
            }
            var request = URLRequest(url: URL(string: "https://reqres.in/api/login")!,timeoutInterval: Double.infinity)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = postData
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if data != nil {
                    do {
                        let jsonResult = try JSONSerialization.jsonObject(with: data!) as? [String: Any]
                        let nsResponse = response as? HTTPURLResponse
                        print(nsResponse?.statusCode ?? -1)
                        if let statusCode = nsResponse?.statusCode {
                            if statusCode == 200{
                                print(jsonResult?["data"]  as? [[String: Any]] ?? [] )
                                self.navigationToDashboard()
                            }
                            else if statusCode == 400 {
                                self.showAlert()
                                }
                           }else{
                               print("something went wrong")
                           }
                       } catch {
                           print("error")
                       }
                }
                else{
                    print("error")
                }
            }
            task.resume()
        }

    }
    

    @IBAction func signUpButton(_ sender: Any) {
        let storyBoard = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(storyBoard, animated: true)
    }
}

extension LoginViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField{
            passWordField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
    }
}
