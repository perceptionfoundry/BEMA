//
//  ChatContactVC.swift
//  Bema
//
//  Created by Syed ShahRukh Haider on 29/10/2019.
//  Copyright © 2019 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import Firebase
import CodableFirebase
import SDWebImage

class ChatContactVC: UIViewController, UITableViewDelegate, UITableViewDataSource{

    
    @IBOutlet weak var contactTable :UITableView!
    @IBOutlet weak var searchTF :UITextField!
    @IBOutlet weak var continueButton : UIButton!
    
    
    

    
    
    
    var SectionTitle = ["Recent Contacts", "All Contacts"]
    
    var contactArray = [["John", "Gray", "Adam"],
    ["Adam","Bob","Geoger","Gray","John","Kevin"]]
    
    
    
    let recentContact = [User]()
    
    var allContact = [User]()
    
    var showContact = [[User]]()
    
    
    var selectedSection : Int?
    var selectedRow : Int?
    
    var dbStore = Firestore.firestore()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getData()
        
        if selectedRow == nil {
            continueButton.isHidden = true
        }
        
        self.showContact.append(recentContact)
    }
    
    
    // ******** PERSONALIZE FUNCTIONS ********
    func getData(){
          let userId = (globalVariable.userSnapDetail?.userId)!
        
        print("*********")
        print(userId)
        print("*********")

            
             let sourceLink = self.dbStore.collection("Friends").document(userId)
             
             // ***** GET CONTACT
             
             sourceLink.collection("Directory").getDocuments { (snapResult, snapError) in
                 
                 guard let fetchValue = snapResult?.documents else{return}
                 
                 var index = 0
                 fetchValue.forEach { (value) in
                     
                     let getValue = value.data()
                     
                     let id = getValue["friendId"] as! String
                     
                     print(id)
                     
                     self.dbStore.collection("Users").document(id).getDocument { (contactResult, contactError) in
                         
                         let fetchData = contactResult?.data()
                         
//                         print(fetchData)
                         
                         let friend = try! FirestoreDecoder().decode(User.self, from: fetchData!)
                      
                        self.allContact.append(friend)
                        
                        
                        index = index + 1
                        if index == fetchValue.count{
                            self.showContact.append(self.allContact)
                            self.contactTable.delegate = self
                            self.contactTable.dataSource = self
                            self.contactTable.reloadData()
                        }
                         
                     }
                    

                 }
             }
        
       

      }
    
    
    
    //*********** SECTION ****************
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionTitle.count
    }
    

    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return SectionTitle[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        view.tintColor = UIColor(red: 0.941, green: 0.941, blue: 0.937, alpha: 1)
        
        let header = view  as! UITableViewHeaderFooterView
        
        header.textLabel?.font = UIFont(name: "Montserrat-Medium", size: 16)
    }
    
//************ ROW *****************
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  
//
        return showContact[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CONTACT", for: indexPath) as! ContactTableViewCell
        
//        cell.userName.text = contactArray[indexPath.section][indexPath.row]
        
        cell.tickImage.isHidden = true

        
        if self.selectedSection == indexPath.section && self.selectedRow == indexPath.row{
            cell.tickImage.isHidden = false
        }
        
        cell.userName.text = showContact[indexPath.section][indexPath.row].displayName
        
        let imageString = (showContact[indexPath.section][indexPath.row].imageUrl)!
               
               let imageURL = URL(string: imageString)
        
        
               
        cell.userImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "contact_AR"), options: .progressiveLoad, context: nil)
        
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        continueButton.isHidden = false

        
        self.selectedRow = indexPath.row
        self.selectedSection = indexPath.section
        
        contactTable.reloadData()
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    //************** OUTLET ******************
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueButton(_ sender: Any){
           performSegue(withIdentifier: "Chat_Segue", sender: nil)
       }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Chat_Segue"{
            
            let dest = segue.destination as!  chatRoomVC
            
            dest.recieverDetail = self.showContact[selectedSection!][selectedRow!]
       
            
        }
    }

}
