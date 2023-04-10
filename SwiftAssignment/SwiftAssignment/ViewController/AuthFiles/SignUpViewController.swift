//
//  SignUpViewController.swift
//  SwiftAssignment
//
//  Created by MA-31 on 21/03/23.
//

import UIKit

class SignUpViewController: UIViewController {
  
    var iconClick = false
    var iconClickCF = false
    let imageIcon = UIImageView()
    let imageIconCF = UIImageView()
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var emailError: UILabel!
    @IBOutlet weak var passwordError: UILabel!
    @IBOutlet weak var confirmPasswordError: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageIcon.image = UIImage(named: "closeEye")
        let contentView = UIView()
        contentView.addSubview(imageIcon)
        contentView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        imageIcon.frame = CGRect(x: -10, y: 0, width:25, height: 25)
        passwordField.rightView = contentView
        passwordField.rightViewMode =  .always
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageIcon.isUserInteractionEnabled = true
        imageIcon.addGestureRecognizer(tapGestureRecognizer)
        
        imageIconCF.image = UIImage(named: "closeEye")
        let contentViewCF = UIView()
        contentViewCF.addSubview(imageIconCF)
        contentViewCF.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        confirmPasswordField.rightView = contentViewCF
        confirmPasswordField.rightViewMode =  .always
        let tapGestureRecognizerCF = UITapGestureRecognizer(target: self, action: #selector(imageTappedCF(tapGestureRecognizer:)))
        imageIconCF.isUserInteractionEnabled = true
        imageIconCF.addGestureRecognizer(tapGestureRecognizerCF)
     
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
    
    @objc func imageTapped(tapGestureRecognizer:UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        if iconClick
        {
            iconClick = false
            tappedImage.image = UIImage(named: "openEye")
            passwordField.isSecureTextEntry = false
        }else{
            iconClick = true
            tappedImage.image = UIImage(named: "closeEye")
            passwordField.isSecureTextEntry = true
        }
    }
    @objc func imageTappedCF(tapGestureRecognizer:UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        if iconClickCF
        {
            iconClickCF = false
            tappedImage.image = UIImage(named: "openEye")
            confirmPasswordField.isSecureTextEntry = false
        }else{
            iconClickCF = true
            tappedImage.image = UIImage(named: "closeEye")
            confirmPasswordField.isSecureTextEntry = true
        }
    }
   
    func resetForm(){
        submitButton.isEnabled=false
        emailField.text = ""
        passwordField.text=""
        confirmPasswordField.text=""
        emailError.isHidden = false
        passwordError.isHidden = false
        confirmPasswordField.isHidden = false
        emailError.text=""
        passwordError.text=""
        confirmPasswordError.text=""
    }
    
    
    
    @IBAction func emailChanged(_ sender: Any) {
        if let email=emailField.text{
            if let errorMessage = invalidEmail(email){
                emailError.isHidden=false
                emailError.text=(errorMessage)
            }else{
                emailError.isHidden = true
            }
        }
        checkValidationForm()
    }
    
    
    
    
    func invalidEmail(_ value : String) -> String?{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if !emailPred.evaluate(with: value){
            return "Invalid Email Address"
        }
        return nil
    }
    
    
    func checkValidationForm(){
        if emailError.isHidden && passwordError.isHidden && confirmPasswordError.isHidden
        {
            submitButton.isEnabled=true
        }else{
            submitButton.isEnabled=false
        }
    }
    @IBAction func passwordChanged(_ sender: Any) {
        if let password=passwordField.text{
            if let passwordErrorValue = inValidPassword(password){
                passwordError.isHidden=false
                passwordError.text=(passwordErrorValue)
            }else{
                passwordError.isHidden=true
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
    @IBAction func confirmPasswordChanged(_ sender: Any) {
        if let password=confirmPasswordField.text{
            if let passwordErrorValue = inValidPassword(password){
                confirmPasswordError.isHidden=false
                confirmPasswordError.text=(passwordErrorValue)
            }else if confirmPasswordField.text != passwordField.text{
                confirmPasswordError.isHidden=false
                confirmPasswordError.text="Password and ConfirmPassword not same!!!"
            }else{
                confirmPasswordError.isHidden=true
            }
        }
        checkValidationForm()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

    @IBAction func signUpButton(_ sender: Any) {
       apiCalling()
    }
    func navigationToLogin() {
        DispatchQueue.main.async {
            let storyBoard = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(storyBoard, animated: true)
        }
    }
    func showAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: "Something Went Wrong" ,preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: { _ in
                //Cancel Action
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func apiCalling(){
        DispatchQueue.main.async {
            let emailField = self.emailField.text
            let passwordField = self.passwordField.text
            let parameters = ["email":emailField, "password":passwordField]
            guard let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])else{
                return
            }
            var request = URLRequest(url: URL(string: "https://reqres.in/api/register")!,timeoutInterval: Double.infinity)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = postData
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if data != nil  {
                    do {
                        let jsonResult = try JSONSerialization.jsonObject(with: data!) as? [String: Any]
                        let nsResponse = response as? HTTPURLResponse
                        print(nsResponse?.statusCode ?? -1)
                        if let statusCode = nsResponse?.statusCode {
                            if statusCode == 200{
                                self.navigationToLogin()
                            }
                            else if statusCode == 400 {
                                self.showAlert()
                                }
                           }else{
                               print("something went wrong")
                           }
                       } catch {
                           print("error")
                       }                }else{
                    print("error")
                }
            }
            task.resume()
        }
    }
    
    @IBAction func loginButton(_ sender: Any) {
        let storyBoard = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(storyBoard, animated: true)
    }
    
    @IBAction func termsButton(_ sender: Any) {
        let storyBoard = self.storyboard?.instantiateViewController(withIdentifier: "WebEngineViewController") as! WebEngineViewController
        storyBoard.url = "https://policies.google.com/terms?hl=en-US"
        self.present(storyBoard, animated: true)
        //self.navigationController?.pushViewController(storyBoard, animated: true)
    }
    @IBAction func privacyButton(_ sender: Any) {
        let storyBoard = self.storyboard?.instantiateViewController(withIdentifier: "WebEngineViewController") as! WebEngineViewController
        storyBoard.url = "https://policies.google.com/privacy?hl=en-US"
        self.present(storyBoard, animated: true)
//        self.navigationController?.pushViewController(storyBoard, animated: true)
    }
}

extension SignUpViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField{
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            confirmPasswordField.becomeFirstResponder()
        }else {
            textField.resignFirstResponder()
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
}

//   let stringValue="By continuing, you are indicating that you accept our Terms of Service and Privacy Policy"
//let attributedString = NSMutableAttributedString(string: stringValue)
//attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.red, NSMutableAttributedString.Key.link: "https://policies.google.com/terms?hl=en-US/"], range: NSString(string: stringValue).range(of: "accept our Terms of Service"))
//attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.red, NSMutableAttributedString.Key.link: "https://policies.google.com/terms?hl=en-US/"], range: NSString(string: stringValue).range(of: "Privacy Policy"))
