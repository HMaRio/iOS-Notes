//
//  NewPopupVC.swift
//  ios-todo
//
//  Created by Mario Holper on 12.10.19.
//  Copyright © 2019 Mario Holper. All rights reserved.
//

import UIKit

class NewPopupVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txt: UITextField!
    
    var mode = ""
    
    // zu ändernder Text und Eintrag (nur für Edit-Mode)
    var currentText = ""
    var currentRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if mode=="new" {
            //Tastatur sofort einblenden
            txt.becomeFirstResponder()
        }else {
            //vorhandenen Text einstellen
            txt.text = currentText
        }
        txt.delegate = self //Textfeld-Ereignisse verarbeiten
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
     //Reaktion auf "Return"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Eingabe beenden, Tastatur ausblenden
        view.endEditing(true)
        
        //Segue zur Hauptansicht initiieren
        performSegue(withIdentifier: "SegueUnwindToMain", sender: self)
        //'Return' nicht als Eingabe weitergeben
        return false
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
