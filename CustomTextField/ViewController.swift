//
//  ViewController.swift
//  CustomTextField
//
//  Created by HSIAOJOU WEN on 2016/4/2.
//  Copyright © 2016年 HSIAOJOU WEN. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField_LTR: CustomTextField!
    @IBOutlet weak var textField_RTL: CustomTextField!
    @IBOutlet weak var textField_CTB: CustomTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Left to Right
        // Default
        
        // Right to Left
        textField_RTL.mode = CustomTextFieldMode.RightToLeft
        textField_RTL.lineColor = UIColor.blueColor()
        // Center to Board
        textField_CTB.mode = CustomTextFieldMode.CenterStart
        textField_CTB.lineColor = UIColor.orangeColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

