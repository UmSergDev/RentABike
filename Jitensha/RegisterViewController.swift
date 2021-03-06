//
//  RegisterViewController.swift
//  Jitensha
//
//  Created by Sergey Umarov on 11.12.16.
//  Copyright © 2016 Sergey Umarov. All rights reserved.
//

import UIKit
import Alamofire

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    //MARK : IBOutlets
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    //MARK : Properties
    
    var request: Request?
    
    //MARK : ViewController Lifetime
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //configure UI settings
        self.configureUI()
    }
    
    func configureUI(){
        
        //configure textfields
        self.emailText.returnKeyType = .Done
        self.passwordText.returnKeyType = .Done
        
        //configure view for keyboard dismiss on tap
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    //dismiss keyboard on tap
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    deinit {
        request?.cancel()
    }
    
    //MARK : API Call Functions
    
    func register() {
        
        //validate empty fields to avoid typing every time
        if self.emailText.text == "" {
            self.emailText.text = "crossover@crossover.com"
        }
        
        if self.passwordText.text == "" {
            self.passwordText.text = "crossover"
        }
        
        let email = self.emailText.text!
        let pass = self.passwordText.text!
        
        request = APIManager.sharedInstance.register(email, password: pass, completion: { [unowned self] (session, error) in
            
            self.request = nil
            
            if let errorValid = error {
                let alert = ErrorManager.errorAlertController(errorValid)
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                
                //show alert message and continue to Home
                self.showAlert("Signup Success", message: "Please continue to the Map Screen", handler:  { (action) in
                    self.showMap()
                })
            }
        })
    }
    
    //MARK : Navigation
    
    func showMap() {
        
        //show MapController (after logged in) with NavigationController
        let nc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MapNavigator") as! UINavigationController
        
        let vc = nc.viewControllers.first as! MapViewController
        vc.modalTransitionStyle = .CrossDissolve
        
        self.presentViewController(nc, animated: true, completion: nil)
    }
    
    //MARK : Actions
    
    @IBAction func registerAction(sender: UIButton) {
        //callback login functionality
        self.register()
    }
    
    //MARK : TextField Delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        //dismiss on return
        textField.resignFirstResponder()
        return true
    }
}
