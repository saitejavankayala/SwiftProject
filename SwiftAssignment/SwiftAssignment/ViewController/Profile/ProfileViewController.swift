//
//  ProfileViewController.swift
//  SwiftAssignment
//
//  Created by MA-31 on 24/03/23.
//

import UIKit

class ProfileViewController: UIViewController {
    var userStatsData: [data]? = [data]()
    var userEmail = ""
    @IBOutlet weak var firstNameValue: UITextField!
    @IBOutlet weak var lastNameValue: UITextField!
    @IBOutlet weak var emailValue: UITextField!
    @IBOutlet weak var phoneNumberValue: UITextField!
    @IBOutlet weak var uiButton: UIButton!
    @IBOutlet weak var sideMenuBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenuBtn.target = self.revealViewController()
        sideMenuBtn.action = #selector(self.revealViewController()?.revealSideMenu)
        userEmail = UserDefaults.standard.value(forKey: "emailValue") as! String
        let userDataDetails : Data = UserDefaults.standard.value(forKey: "userData") as! Data
        let tasks = try? JSONDecoder().decode(userStats.self, from: userDataDetails)
        self.userStatsData = tasks?.data
        checkingUserEmail()
    }
 
    func checkingUserEmail(){
        print("\(self.userStatsData?[0].last_name ?? "NA" )")
        for userData in self.userStatsData ?? []{
            if(userData.email == userEmail){
                self.firstNameValue.text = userData.first_name
                self.lastNameValue.text = userData.last_name
                self.emailValue.text = userData.email
                break
            }
        }
    }
    @IBAction func logoutAction(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "isLoginStatus")
        UserDefaults.standard.set("", forKey: "emailValue")
        UserDefaults.standard.set("", forKey: "userData")
        self.navigationController?.popToRootViewController(animated: true)
    }
}
