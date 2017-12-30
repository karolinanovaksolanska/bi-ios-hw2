//
//  TableViewController.swift
//  BI-IOS
//
//  Created by Dominik Vesely on 30/10/2017.
//  Copyright © 2017 ČVUT. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class TableViewController : UIViewController {
    
    weak var pushButton: UIButton!
    weak var sampleTextField: UITextField!
    weak var maleSwitch: UISwitch!
    weak var femaleSwitch: UISwitch!
    weak var unknownSwitch: UISwitch!
    var gender = "male"
    var dataManager = DataManager()
    
    let locationManager = CLLocationManager()
    var userLatitude:CLLocationDegrees! = 0
    var userLongitude:CLLocationDegrees! = 0
    
    
    override func loadView() {
        super.loadView();
        
        view.backgroundColor = .white
    
        let sampleTextField =  UITextField(frame: CGRect(x: 20, y: 100, width: 270, height: 50))
        sampleTextField.placeholder = "Enter Username here"
        sampleTextField.font = UIFont.systemFont(ofSize: 15)
        sampleTextField.borderStyle = UITextBorderStyle.roundedRect
        sampleTextField.autocorrectionType = UITextAutocorrectionType.no
        sampleTextField.keyboardType = UIKeyboardType.default
        sampleTextField.returnKeyType = UIReturnKeyType.done
        sampleTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
        sampleTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        view.addSubview(sampleTextField)
        
        let maleSwitch = UISwitch(frame: CGRect(x: 40, y: 170, width: 50, height: 50))
        view.addSubview(maleSwitch)
        
        let switchLabelMale = UILabel(frame: CGRect(x: 100, y: 170, width: 50, height: 50))
        switchLabelMale.text = "Male"
        view.addSubview(switchLabelMale)

        
        let femaleSwitch = UISwitch(frame: CGRect(x: 40, y: 210, width: 50, height: 50))
        view.addSubview(femaleSwitch)
        
        let switchLabelFemale = UILabel(frame: CGRect(x: 100, y: 210, width: 100, height: 50))
        switchLabelFemale.text = "Female"
        view.addSubview(switchLabelFemale)

        
        let unknownSwitch = UISwitch(frame: CGRect(x: 40, y: 250, width: 50, height: 50))
        view.addSubview(unknownSwitch)
        
        let switchLabelUnknown = UILabel(frame: CGRect(x: 100, y: 250, width: 100, height: 50))
        switchLabelUnknown.text = "Unknown"
        view.addSubview(switchLabelUnknown)
        
        let pushButton = UIButton(frame: CGRect(x: 20, y: 300, width: 270, height: 50))
        pushButton.setTitle("Add pin", for: .normal)
        pushButton.setTitleColor(.white, for: .normal)
        pushButton.backgroundColor = .blue
        view.addSubview(pushButton)

        self.sampleTextField = sampleTextField
        self.pushButton = pushButton
        self.maleSwitch = maleSwitch
        self.femaleSwitch = femaleSwitch
        self.unknownSwitch = unknownSwitch
        
        
        
        unknownSwitch.addTarget(self, action: #selector(unknownChanged), for: UIControlEvents.valueChanged)
        femaleSwitch.addTarget(self, action: #selector(femaleChanged), for: UIControlEvents.valueChanged)
        maleSwitch.addTarget(self, action: #selector(maleChanged), for: UIControlEvents.valueChanged)
        maleSwitch.setOn(true, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled()
            
        {
            locationManager.delegate = self as? CLLocationManagerDelegate
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startMonitoringSignificantLocationChanges()
            
            userLatitude  = locationManager.location?.coordinate.latitude
            userLongitude  = locationManager.location?.coordinate.longitude
        }
        
        pushButton.addTarget(self, action: #selector(pushButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc func maleChanged(maleSwitch: UISwitch) {
        if maleSwitch.isOn {
            femaleSwitch.setOn(false, animated: true)
            unknownSwitch.setOn(false, animated: true)
            self.gender = "male"
        } else {
            femaleSwitch.setOn(true, animated: true)
            self.gender = "female"
        }
    }
    
    @objc func femaleChanged(femaleSwitch: UISwitch) {
        if femaleSwitch.isOn {
            maleSwitch.setOn(false, animated: true)
            unknownSwitch.setOn(false, animated: true)
            self.gender = "female"
        } else {
            unknownSwitch.setOn(true, animated: true)
            self.gender = "unknown"
        }
    }
    
    @objc func unknownChanged(unknownSwitch: UISwitch) {
        if unknownSwitch.isOn {
            maleSwitch.setOn(false, animated: true)
            femaleSwitch.setOn(false, animated: true)
            self.gender = "unknown"
        } else {
            maleSwitch.setOn(true, animated: true)
            self.gender = "male"
        }
    }
    
    @objc func pushButtonTapped(_ sender: UIButton) {
        
        let username: String = sampleTextField.text!
        if username != "" {
            dataManager.addPin(username: username, gender: self.gender, lat: self.userLatitude, lon: self.userLongitude) { [weak self] pin in
                print(pin)
                navigationController?.pushViewController(TableViewController(), animated: true)
            }
        } else {
            let alert = UIAlertController(title: "Missing username", message: "Please fill in username before sending.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}



