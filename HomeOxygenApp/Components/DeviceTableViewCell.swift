//
//  DeviceTableViewCell.swift
//  HomeOxygenApp
//
//  Created by Amr Mousa on 10.8.2020.
//  Copyright © 2020 Amr Mousa. All rights reserved.
//

import Foundation
import UIKit

class DeviceTableViewCell: UITableViewCell {
    
    @IBOutlet var deviceName: UILabel?
    @IBOutlet var deviceImage: UIImageView?
    @IBOutlet var connectButton: UIButton?
    
    var connectFunction: () -> () = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.connectButton?.layer.cornerRadius = 5
        self.connectButton?.layer.borderColor = UIColor(hex: "#4DA6A6")!.cgColor
        self.connectButton?.layer.borderWidth = 1
    }
    
    func setDetails(name: String, image: UIImage?, connectFunction: @escaping ()->()) {
        self.deviceName?.text = name
        self.deviceImage?.image = image
        self.connectFunction = connectFunction
    }
    
    @IBAction func connectToDevice () {
        self.connectFunction()
    }
}

