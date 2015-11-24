//
//  ViewController.swift
//  NKSwitchDemo
//
//  Created by Peng on 11/18/15.
//  Copyright © 2015 Peng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let myswitch: NKSwitch = NKSwitch(frame: CGRectMake(view.center.x - 60.0, view.center.y - 30.0, 120.0, 60.0))
        view.addSubview(myswitch)
    }

}

