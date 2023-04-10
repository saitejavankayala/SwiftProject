//
//  NetworkErrorViewController.swift
//  SwiftAssignment
//
//  Created by MA-31 on 06/04/23.
//

import UIKit
import Reachability
class NetworkErrorViewController: UIViewController {
    let reachability = try! Reachability()
    @IBOutlet weak var retryButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

  
    @IBAction func retryButtonAction(_ sender: Any) {
    
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
        
    }
    
}
