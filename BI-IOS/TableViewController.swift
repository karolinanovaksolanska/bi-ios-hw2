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
    weak var maleFemaleSwitch: UISwitch!
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
        
        var switchLabelMale = UILabel(frame: CGRect(x: 40, y: 170, width: 50, height: 50))
        switchLabelMale.text = "Male"
        view.addSubview(switchLabelMale)
        
        var maleFemaleSwitch = UISwitch(frame: CGRect(x: 100, y: 170, width: 50, height: 50))
        view.addSubview(maleFemaleSwitch)
        
        var switchLabelFemale = UILabel(frame: CGRect(x: 160, y: 170, width: 100, height: 50))
        switchLabelFemale.text = "Female"
        view.addSubview(switchLabelFemale)
        
        let pushButton = UIButton(frame: CGRect(x: 20, y: 240, width: 270, height: 50))
        pushButton.setTitle("Add pin", for: .normal)
        pushButton.setTitleColor(.white, for: .normal)
        pushButton.backgroundColor = .blue
        view.addSubview(pushButton)

        self.sampleTextField = sampleTextField
        self.pushButton = pushButton
        self.maleFemaleSwitch = maleFemaleSwitch
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
    
    
    
    @objc func pushButtonTapped(_ sender: UIButton) {
        
        let username: String = sampleTextField.text!
        var gender: String = "male"
        if maleFemaleSwitch.isOn {
            gender = "female"
        }
        dataManager.addPin(username: username, gender: gender, lat: self.userLatitude, lon: self.userLongitude) { [weak self] pin in
            print(pin)
            navigationController?.pushViewController(TableViewController(), animated: true)
        }
    }
}



