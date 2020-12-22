//
//  DeviceViewController.swift
//  HomeOxygenApp
//
//  Created by Amr Mousa on 10.8.2020.
//  Copyright © 2020 Amr Mousa. All rights reserved.
//

import UIKit
import CoreBluetooth

class DeviceViewController: UIViewController {
    
    var device: CBPeripheral!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(_ device: CBPeripheral)
    {
        self.device = device
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        self.title = self.device.name!
    }
    
}
