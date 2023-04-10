//
//  DashBoardViewController.swift
//  SwiftAssignment
//
//  Created by MA-31 on 23/03/23.
//

import UIKit


class DashBoardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var userStatsData: [RealmUserStats]? = [RealmUserStats]()
    // MARK: - Declaration
    @IBOutlet weak var usertableView: UITableView!
    @IBOutlet weak var sideMenuBtn: UIBarButtonItem!
    @IBOutlet weak var addUserButton: UIBarButtonItem!
    
    @IBOutlet weak var closeButton: UIButton!
    var sideBarMenuView : UIView!
    var sideBarTableMenu : UITableView!
    var isSideBarMenuEnabled : Bool = false
    var sideMenuData = ["Profile", "Logout"]
    var sideMenuImageData = [ UIImage(systemName: "person.crop.circle.fill")!, UIImage(systemName: "rectangle.portrait.and.arrow.forward")! ]
    var imageV : UIImageView!
    var cellLabel : UILabel!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var backgroundPopupView: UIView!
    @IBOutlet weak var userDetialsLabel: UILabel!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var firstNameFieldError: UILabel!
    @IBOutlet weak var lastNameFieldError: UILabel!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var emailFieldError: UILabel!
    @IBOutlet weak var avatarField: UITextField!
    @IBOutlet weak var avatarFieldError: UILabel!
    @IBOutlet weak var addUserButtonPopup: UIButton!
    @IBOutlet weak var deleteUserButton: UIButton!
    var operationUserID : Int = -1
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenuBtn.target = revealViewController()
        sideMenuBtn.action = #selector(revealViewController()?.revealSideMenu)
        popUpView.isHidden = true
        backgroundPopupView.isHidden = true
        popUpView.layoutIfNeeded()
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.clickAction(sender:)))
        self.backgroundPopupView.addGestureRecognizer(gesture)
        resetForm()
        usertableView.delegate = self
        usertableView.dataSource = self
        downLoadJSON {
            self.usertableView.reloadData()
        }
    }
    func resetForm(){
        addUserButtonPopup.isEnabled=false
        emailFieldError.text = "Please enter the email"
        lastNameFieldError.text = "Please enter the name"
        firstNameFieldError.text = "Please enter the name"
        avatarFieldError.text = "Please enter the url"
        emailFieldError.isHidden = false
        lastNameFieldError.isHidden = false
        firstNameFieldError.isHidden=false
        avatarFieldError.isHidden=false
        emailField.text = ""
        lastNameField.text = ""
        firstNameField.text = ""
        avatarField.text = ""
     }
    @objc func clickAction(sender : UITapGestureRecognizer) {
        popUpView.isHidden = true
        backgroundPopupView.isHidden = true
        firstNameField.text = ""
        lastNameField.text = ""
        emailField.text = ""
        avatarField.text = ""
        emailFieldError.text = "Please enter the email"
        lastNameFieldError.text = "Please enter the name"
        firstNameFieldError.text = "Please enter the name"
        avatarFieldError.text = "Please enter the url"
        addUserButtonPopup.isEnabled = false
        operationUserID = -1
    }
    @IBAction func firstNameChange(_ sender: Any) {
        if let name=firstNameField.text{
            if let errorMessage = nameChange(testStr: name){
                firstNameFieldError.isHidden=false
                firstNameFieldError.text = (errorMessage)
            }else{
                firstNameFieldError.isHidden = true
            }
        }
        checkValidationForm()
    }
    @IBAction func lastNameChange(_ sender: Any) {
        if let name=lastNameField.text{
            if let errorMessage = nameChange(testStr: name){
                lastNameFieldError.isHidden=false
                lastNameFieldError.text = (errorMessage)
            }else{
                lastNameFieldError.isHidden = true
            }
        }
        checkValidationForm()
    }
    
    func nameChange(testStr : String) -> String?{
        if testStr.count < 2 { return "Please enter the name" }
        return nil
    }
    
    @IBAction func emailChange(_ sender: Any) {
        if let email=emailField.text{
            if let errorMessage = LoginViewController().invalidEmail(value: email){
                emailFieldError.isHidden=false
                emailFieldError.text = (errorMessage)
            }else{
                emailFieldError.isHidden = true
            }
        }
        checkValidationForm()
    }
    
    func checkValidationForm(){
        if emailField.text != "" && lastNameField.text != "" &&  firstNameField.text != "" && avatarField.text != ""
        {
            addUserButtonPopup.isEnabled=true
        }else{
            addUserButtonPopup.isEnabled=false
        }
    }
    
    @IBAction func deleteUserButtonAction(_ sender: Any) {
        
        deleteParticularData(index: self.operationUserID)
    }
    
    @IBAction func avatarURLChange(_ sender: Any) {
        if let avatarUrl = avatarField.text{
            if let errorMessage = isValidUrl(url: avatarUrl){
                avatarFieldError.isHidden=false
                avatarFieldError.text = (errorMessage)
            }else{
                avatarFieldError.isHidden = true
            }
        }
        checkValidationForm()
    }
    func isValidUrl(url: String) -> String? {
        let urlRegEx = "^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        let result = urlTest.evaluate(with: url)
        if result {
            return nil
        }else{
            return "URL is not valid"
        }
    }
    // MARK: - TablenumberOfRowsInSection method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case usertableView:
            return self.userStatsData?.count ?? 0
        default:
            return 0
        }
    }
    // MARK: - Data Mapping for the cell.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
        case usertableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! myTableViewCell
            if userStatsData?[indexPath.row].first_name != nil{
                cell.firstNameCell.text = "\(userStatsData?[indexPath.row].first_name ?? " ") " + "\((userStatsData?[indexPath.row].last_name ?? " "))"
            }
            
            if userStatsData?[indexPath.row].email != nil{
                cell.lastNameCell.text = "\(userStatsData?[indexPath.row].email ?? " ")"
            }
            cell.imageCell.layer.masksToBounds = true
            cell.imageCell.layer.cornerRadius = 40
         
            if userStatsData?[indexPath.row].avatar != nil{
                let url = URL(string: userStatsData?[indexPath.row].avatar ?? "emptyImage")
                cell.imageCell.downloadImage(from: url!)
            }else{
                cell.imageCell.image = UIImage(named: "emptyImage")
            }
            cell.btnEditClicked = {
                self.handleEditData(index:indexPath.row)
            }
            cell.btnDeleteClicked = {
                self.deleteDataFun(index: indexPath.row)
            }
            return cell
        default:
            print("Some things Wrong!!")
            return UITableViewCell()
        }
    }
    func deleteDataFun(index: Int){
        let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete this user?",         preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            
        }))
        alert.addAction(UIAlertAction(title: "Delete",
                                      style: UIAlertAction.Style.default,
                                      handler: {action in self.deleteParticularData( index:index)}))
        self.present(alert, animated: true, completion: nil)
    }
    // MARK: editStyling for the cell of the table
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            self.deleteDataFun(index: indexPath.row)
        }
    }
    // MARK: leadingSwipeActionsConfigurationForRowAt for the cell of table
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal,
                                        title: "Edit") { [weak self] (action, view, completionHandler) in
                                            self?.handleEditData(index:indexPath.row)
                                            completionHandler(true)
        }
        action.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [action])

    }
   // MARK: handleEditCell function
    private func handleEditData(index: Int) {
        self.editParticularData( index:index)
    }
    func editParticularData(index: Int){
       popUpView.isHidden = false
       backgroundPopupView.isHidden = false
        userDetialsLabel.text = "EDIT USER DETAILS"
        self.firstNameField.text =  self.userStatsData?[index].first_name
        self.firstNameFieldError.text = ""
        self.lastNameField.text = self.userStatsData?[index].last_name
        self.lastNameFieldError.text = ""
        self.avatarField.text =  self.userStatsData?[index].avatar
        self.avatarFieldError.text = ""
        self.emailField.text = self.userStatsData?[index].email
        self.emailFieldError.text = ""
        self.addUserButtonPopup.isEnabled = true
        self.addUserButtonPopup.setTitle("EDIT USER", for: .normal)
        emailFieldError.isHidden = false
        lastNameFieldError.isHidden = false
        firstNameFieldError.isHidden=false
        avatarFieldError.isHidden=false
        self.operationUserID = index
        deleteUserButton.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    // MARK: Delete Particular Data for the cell
    func deleteParticularData(index: Int){
        RealmUserStatsStore.shared.deleteUser(realmUserStats:
                                                self.userStatsData?[index].id ?? -1 )
        self.operationUserID = -1
        resetForm()
        self.userStatsData?.remove(at: index)
        self.usertableView.reloadData()
       
        popUpView.isHidden = true
        backgroundPopupView.isHidden = true
    }
    // MARK: Data Validation METHOD
    func validateData(firstName:String, lastName: String, email: String) ->(Bool){
        if !(invalidEmail(email: email)!){
            return false
        } else if inValidValue(value: lastName)!{
            return false
        }
        else if inValidValue(value: firstName)!{
            return false
        }
        return true
    }
 
    @IBAction func addUserButtonAction(_ sender: Any) {
        popUpView.isHidden = false
        backgroundPopupView.isHidden = false
        userDetialsLabel.text = "ADD USER DETAILS"
        self.addUserButtonPopup.setTitle("ADD USER", for: .normal)
        deleteUserButton.isHidden = true
    }
    
    @IBAction func addUserButtonPopUpAction(_ sender: Any) {
      
        if self.operationUserID == -1 {
            let createuser = RealmUserStats(id: Int.random(in: 10000...99999), email: emailField.text ?? "", first_name: firstNameField.text ?? "", last_name: lastNameField.text ?? "", avatar: avatarField.text ?? "")
            self.userStatsData?.append(createuser)
            RealmUserStatsStore.shared.saveUser(RealmUserStats: createuser)
            self.usertableView.reloadData()
         
        }else{
            let createuser = RealmUserStats(id: self.userStatsData?[self.operationUserID].id ?? -1, email: emailField.text ?? "", first_name: firstNameField.text ?? "", last_name: lastNameField.text ?? "", avatar: avatarField.text ?? "")
          
            RealmUserStatsStore.shared.updateUser(realmUserStats:createuser)
            self.usertableView.reloadData()
            
        }
        resetForm()
        popUpView.isHidden = true
        backgroundPopupView.isHidden = true
        self.operationUserID = -1
    
    }
    func inValidValue(value: String)-> Bool?{
        if(value.count<=8){
            return false
        }
        return true
    }

    func invalidEmail(email : String) -> Bool?{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if !emailPred.evaluate(with: email){
            return false
        }
        return true
    }
    @IBAction func profilePageNavigation(_ sender: Any) {
        let storyBoard = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        self.navigationController?.pushViewController(storyBoard, animated: true)
       // self.present(storyBoard, animated: true)
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        popUpView.isHidden = true
        backgroundPopupView.isHidden = true
        firstNameField.text = ""
        lastNameField.text = ""
        emailField.text = ""
        avatarField.text = ""
        emailFieldError.text = "Please enter the email"
        lastNameFieldError.text = "Please enter the name"
        firstNameFieldError.text = "Please enter the name"
        avatarFieldError.text = "Please enter the url"
        addUserButtonPopup.isEnabled = false
        operationUserID = -1
    }
    func downLoadJSON(completed : @escaping () -> ()){
        self.userStatsData = RealmUserStatsStore.shared.getAllUser()
//        let url = URL(string: "https://reqres.in/api/users")
//        URLSession.shared.dataTask(with: url!){
//            data, URLResponse, err in
//            DispatchQueue.main.async {
//                if let data = data{
//                    do {
//                        let tasks = try? JSONDecoder().decode(userStats.self, from: data)
//                        UserDefaults.standard.set(data, forKey: "userData")
//
//
//                        completed()
//                    }
//                }
//            }
//        }.resume()
    }
}


extension UIImageView{
    func downloadImage(from url:URL){
        contentMode = .scaleToFill
        let dataTask = URLSession.shared.dataTask(with: url, completionHandler:  { (data, response, error) in
            guard let httpResponse =  response as? HTTPURLResponse, httpResponse.statusCode == 200,
                  let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                  let image = UIImage(data: data)
            else{
                return}
            DispatchQueue.main.async{
                self.image=image
            }
        })
        dataTask.resume()
    }
}
                                                  

