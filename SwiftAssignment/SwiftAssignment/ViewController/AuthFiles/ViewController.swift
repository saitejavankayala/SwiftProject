//
//  ViewController.swift
//  SwiftAssignment
//
//  Created by MA-31 on 20/03/23.
//

import UIKit
import Reachability
class ViewController: UIViewController {
  
    let reachability = try! Reachability()
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.reachability.whenReachable = { reachability in
                if reachability.connection == .wifi {
                    print("Reachable via WiFi")
                } else {
                    print("Reachable via Cellular")
                }
                let loginStatusValue = UserDefaults.standard.bool(forKey: "isLoginStatus")
                if loginStatusValue {
                        guard let dashboardVC = UIStoryboard(name: "DashBoard", bundle: .main).instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else {
                            return
                        }
                        self.navigationController?.pushViewController(dashboardVC, animated: true)
                    
                }
            }
            self.reachability.whenUnreachable = { _ in
                print("Not reachable")
                let storyBoard = self.storyboard?.instantiateViewController(withIdentifier: "NetworkErrorViewController") as! NetworkErrorViewController
                self.navigationController?.pushViewController(storyBoard, animated: true)
            
            }
            do {
                try self.reachability.startNotifier()
            } catch {
                print("Unable to start notifier")
            }
          
           
        }
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    deinit{
        reachability.stopNotifier()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    @IBAction func loginButton(_ sender: Any) {
        let storyBoard = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(storyBoard, animated: true)
        // self.present(storyBoard, animated: true)
        //self.dimiss
    }
    
    
    @IBAction func signUpButton(_ sender: Any) {
        let storyBoard=self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(storyBoard, animated: true)
    }
}

