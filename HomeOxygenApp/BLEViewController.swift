//
//  FirstViewController.swift
//  HomeOxygenApp
//
//  Created by Amr Mousa on 9.8.2020.
//  Copyright © 2020 Amr Mousa. All rights reserved.
//

import UIKit
import CoreBluetooth

class BLEViewController: UIViewController, CBPeripheralDelegate, CBCentralManagerDelegate {
    
    @IBOutlet var deviceTableView: UITableView? = nil
    
    var devices: Int!
    
    private var centralManager: CBCentralManager!
    private var peripherals: [CBPeripheral] = []
    private var selectedDevice: CBPeripheral?
    private let refreshControl = UIRefreshControl()

    private var loading = true
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        deviceTableView?.register(UINib(nibName: "DeviceTableViewCell", bundle: nil), forCellReuseIdentifier: "deviceCell")
        self.refreshControl.addTarget(self, action: #selector(refreshDevices), for: UIControl.Event.valueChanged)

        deviceTableView?.refreshControl = self.refreshControl
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    @objc func refreshDevices(sender:AnyObject)
    {
        self.loading = true
        self.peripherals = []
        self.selectedDevice = nil
        self.centralManagerDidUpdateState(self.centralManager)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "deviceScreen")
        {
            self.loading = false
            let deviceVC = segue.destination as! DeviceViewController
            deviceVC.device = self.selectedDevice
            deviceTableView?.refreshControl?.endRefreshing()
        }
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
        
        if(peripheral.name == nil || peripherals.contains(peripheral))
        {
            return
        }
        let discovered_peripheral = peripheral
        discovered_peripheral.delegate = self
        self.peripherals.append(discovered_peripheral)
        deviceTableView?.reloadData()

    }
    
    // The handler if we do connect succesfully
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to \(peripheral.name!)")
    }
    
    // Handles discovery event
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
//        if let services = peripheral.services {
//            for service in services {
//
//            }
//        }
    }
    
    // H_ discovery of characteristics
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
//       if let characteristics = service.characteristics {
//           for characteristic in characteristics {
//               
//           }
//       }
   }

}

extension BLEViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loading ? 0 : peripherals.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "deviceCell", for: indexPath) as! DeviceTableViewCell
        if loading {
            return cell
        }
        let connected = (peripherals[indexPath.row].state == CBPeripheralState.connected)

        cell.showConnected(connected)
        
        cell.setDetails(name: "\(peripherals[indexPath.row].name!)", image: nil, connectFunction: {() -> (()) in
            cell.showConnected(true)
            self.centralManager.connect(self.peripherals[indexPath.row], options: nil)
            self.selectedDevice = self.peripherals[indexPath.row]
            self.performSegue(withIdentifier: "deviceScreen", sender: self)
            
        })
        return cell
    }
    
}
