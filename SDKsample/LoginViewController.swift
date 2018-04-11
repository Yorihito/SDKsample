//
//  LoginViewController.swift
//  SDKsample
//
//  Created by Yorihito Tada on 2018/04/11.
//  Copyright © 2018 ytada. All rights reserved.
//


import UIKit

class loginViewController: UIViewController {
    
    @IBOutlet weak var txtUsername: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBAction func btnLogin(_ sender: UIButton) {
        logInPlx()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func logInPlx(){
        let loginInfo = VMLoginInfoBuilder()
            .setUsername(txtUsername.text)
            .setPassword(txtPassword.text)
            .setReturnCrossReferences(false)
            .setReturnConsumerInfo(true)
            .build()
        
        VMob.sharedInstance().authenticationManager().login(with: loginInfo)
        {(data, error) in
            if error != nil {
                print(error ?? "error")
            } else {
                print("success")
            }
        }
    }
}
