//
//  ViewController.swift
//  LedsControl
//
//  Created by Alessio Roberto on 28/01/2017.
//  Copyright © 2017 Alessio Roberto. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ViewProtocol {

    @IBOutlet weak var yellowSwitch: UISwitch!
    @IBOutlet weak var greenSwitch: UISwitch!
    
    lazy var presenter: Presenter = Presenter(view: self)
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = StyleKitName.green
        presenter.startUp()
    }
    
    @IBAction func yellowSwitchChanged(_ sender: Any) {
        presenter.yellowSwitch(isOn: yellowSwitch.isOn)
    }
    
    @IBAction func greenSwitchChanged(_ sender: Any) {
        presenter.greenSwitch(isOn: greenSwitch.isOn)
    }
    
    func resetAllSwitches() {
        greenSwitch.setOn(false, animated: true)
        yellowSwitch.setOn(false, animated: true)
    }
}

