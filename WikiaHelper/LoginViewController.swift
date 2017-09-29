//
//  LoginViewController.swift
//  WikiaHelper
//
//  Created by Jille van der Weerd on 08/09/2017.
//  Copyright © 2017 De Programmeermeneer. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    var nameField : UITextField?
    var wikiaField : UITextField?
    var button : UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animateIntro()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func animateIntro(){
        let windowBG = UIImageView(image: #imageLiteral(resourceName: "loginWindow"))
        windowBG.frame = CGRect(x: view.bounds.width/2, y: view.bounds.height/2, width: view.bounds.width/1.2, height: view.bounds.height/1.2)
        //the window background
        windowBG.alpha = 0
        windowBG.center = CGPoint(x: view.bounds.width/2, y: view.bounds.height/4)
        view.addSubview(windowBG)
        
        nameField = UITextField(frame: CGRect(x: 0, y: 0, width: view.bounds.width/2, height: 40))
        nameField!.alpha = 0
        nameField!.placeholder = "Username"
        nameField!.center = CGPoint(x: view.bounds.width/2, y: view.bounds.height/3+90)
        nameField!.delegate = self
        view.addSubview(nameField!)
        
        wikiaField = UITextField(frame: CGRect(x: 0, y: 0, width: view.bounds.width/2, height: 40))
        wikiaField!.alpha = 0
        wikiaField!.placeholder = "Wikia"
        wikiaField!.center = CGPoint(x: view.bounds.width/2, y: view.bounds.height/3+150)
        wikiaField!.delegate = self
        view.addSubview(wikiaField!)
        
        button = UIButton(frame: CGRect(x: 0, y: 0, width: view.bounds.width/2, height: 40))
        button!.alpha = 0
        button!.setTitle("Continue", for: .normal)
        button!.setTitleColor(.blue, for: .normal)
        button!.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        button!.center = CGPoint(x: view.bounds.width/2, y: view.bounds.height/1.6)
        view.addSubview(button!)
        
        
        UIView.animate(withDuration: 1.5, animations: {
            windowBG.alpha = 1.0
            windowBG.center = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height/2)
        }, completion: {(finished:Bool) in
            UIView.animate(withDuration: 2, animations: {
                self.nameField!.alpha = 0.7
                self.wikiaField!.alpha = 0.7
                self.button!.alpha = 0.5
            })
        })
    }
    
    func buttonPressed(){
        performSegue(withIdentifier: "loginToView", sender: self)
        Defaults.defaults.setValue(nameField!.text, forKeyPath: "name")
        Defaults.defaults.setValue(wikiaField!.text, forKeyPath: "wikia")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
