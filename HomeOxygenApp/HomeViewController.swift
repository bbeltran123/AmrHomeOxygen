//
//  SecondViewController.swift
//  HomeOxygenApp
//
//  Created by Amr Mousa on 9.8.2020.
//  Copyright © 2020 Amr Mousa. All rights reserved.
//
import UIKit
import CoreBluetooth

class HomeViewController: UIViewController, CBPeripheralDelegate, CBCentralManagerDelegate {

    private var centralManager: CBCentralManager!
    private var smartValve: CBPeripheral?
    private var oxygenWriteService: CBService?
    private var oxygenWriteCharacteristic: CBCharacteristic?

    @IBOutlet var activityIndicator: UIActivityIndicatorView?
    @IBOutlet var writeValueTextField: UITextField?
    @IBOutlet var loadingView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        // Do any additional setup after loading the view.
    }


    // If we're powered on, start scanning
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("Central state update")
        if central.state != .poweredOn {
            print("Central is not powered on")
        } else {
            print("Central scanning for", ParticlePeripheral.particleLEDServiceUUID);
            centralManager.scanForPeripherals(withServices: [],
                                              options: [CBCentralManagerScanOptionAllowDuplicatesKey : false])
        }
    }

    // Handles the result of the scan
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {

        if(peripheral.name != "BlueFruit52")
        {
            return
        }
        let discovered_peripheral = peripheral
        discovered_peripheral.delegate = self
        self.smartValve = discovered_peripheral
        self.centralManager.connect(smartValve!, options: nil)
        self.smartValve?.discoverServices(nil)
        self.centralManager.stopScan()

    }

    // The handler if we do connect succesfully
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to \(peripheral.name!)")
    }

    // Handles discovery event
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                if service.uuid == CBUUID(string: ""){
                    self.oxygenWriteService = service
                    peripheral.discoverCharacteristics(nil, for: service)
                    return
                }
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if (error != nil) {
            print(error!)
        }else{
            print(characteristic.descriptors!)
        }
    }

    // H_ discovery of characteristics
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
       if let characteristics = service.characteristics {
            for characteristic in characteristics {
                if characteristic.uuid == CBUUID(string: "6E400002-B5A3-F393-E0A9-E50E24DCCA9E") {
                    self.oxygenWriteCharacteristic = characteristic
                    self.activityIndicator?.isHidden = true
                    self.loadingView?.isHidden = true
                    return
                }
            }
        }
    }
    @IBAction func writeValue()
    {
        let data = Data("\(writeValueTextField!.text!)".utf8)
        if(self.oxygenWriteCharacteristic != nil){
            self.smartValve?.writeValue(data, for: oxygenWriteCharacteristic!, type: CBCharacteristicWriteType.withoutResponse)
        }
    }


}
