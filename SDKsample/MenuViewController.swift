//
//  MenuViewController.swift
//  SDKsample
//
//  Created by Yorihito Tada on 2018/04/11.
//  Copyright © 2018 ytada. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var MenuTableView: UITableView!
    
    // menu contents
    let menuArray: [String] = ["Login", "Logoff", "List Ad", "List LC", "List Offer"]
    
    var chosenCell: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        MenuTableView.register(UINib(nibName: "MenuTableViewCell", bundle: nil),forCellReuseIdentifier: "cell_01")
        
        MenuTableView.delegate = self
        MenuTableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let secVC: ListViewController = segue.destination as? ListViewController {
            secVC.chosenCellinFirst = chosenCell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // UITableViewCell instance
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_01", for: indexPath) as! MenuTableViewCell
        
        // cell contents
        cell.label.text = menuArray[indexPath.row]
        
        return cell
    }
    
    // When cell selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenCell = menuArray[indexPath.row]
        
        switch chosenCell {
        case "Login":
            performSegue(withIdentifier: "button2login",sender: self.chosenCell)
        case "Logoff":
            logOutPlex()
        case "List Ad","List LC", "List Offer":
            performSegue(withIdentifier: "button2list",sender: self.chosenCell)
        default:
            break
        }
    }
    
    func logOutPlex(){
        VMob.sharedInstance().authenticationManager().logout()
            { [unowned self](data, error) in
                if error != nil {
                    print(error ?? "error")
                } else {
                    print(self, "success")
                }
        }
    }
    
    func dispDialog(title s1: String, message s2: String) {
        
        let alert: UIAlertController = UIAlertController(title: s1, message: s2, preferredStyle: UIAlertControllerStyle.alert)
        
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            (action: UIAlertAction!) -> Void in
            print("OK")
        })
        
        alert.addAction(defaultAction)
        
        present(alert, animated: true, completion: nil)
    }
}
