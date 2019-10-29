//
//  ChatContactVC.swift
//  Bema
//
//  Created by Syed ShahRukh Haider on 29/10/2019.
//  Copyright © 2019 Syed ShahRukh Haider. All rights reserved.
//

import UIKit

class ChatContactVC: UIViewController, UITableViewDelegate, UITableViewDataSource{

    
    @IBOutlet weak var contactTable :UITableView!
    @IBOutlet weak var searchTF :UITextField!

    
    
    
    var SectionTitle = ["Recent Contacts", "All Contacts"]
    
    var contactArray = [["John", "Gray", "Adam"],
    ["Adam","Bob","Geoger","Gray","John","Kevin"]]
    
    
    var selectedSection : Int?
    var selectedRow : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactTable.delegate = self
        contactTable.dataSource = self
        contactTable.reloadData()

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
        
        return contactArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CONTACT", for: indexPath) as! ContactTableViewCell
        
        cell.userName.text = contactArray[indexPath.section][indexPath.row]
        
        cell.tickImage.isHidden = true

        
        if self.selectedSection == indexPath.section && self.selectedRow == indexPath.row{
            cell.tickImage.isHidden = false
        }
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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

}
