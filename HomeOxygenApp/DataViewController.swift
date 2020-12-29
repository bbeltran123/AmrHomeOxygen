//
//  DataViewController.swift
//  HomeOxygenApp
//
//  Created by Amr Mousa on 17.8.2020.
//  Copyright © 2020 Amr Mousa. All rights reserved.
//

import UIKit
import HealthKit

class DataViewController: UIViewController {
    
    @IBOutlet var heartRateLabel: UILabel!
    
    override func viewDidLoad() {
        defaultHealthManager.subscribeToHeartBeatChanges(success: { (samples) in
            /// Converting the heart rate to bpm
            let heartRateUnit = HKUnit(from: "count/min");
            DispatchQueue.global().async {
                samples?.forEach{ sample in
                    let heartRate = sample.quantity.doubleValue(for: heartRateUnit)
                    let df = DateFormatter()
                    df.dateFormat = "yyyy-MM-dd hh:mm:ss"
                    let start = df.string(from: sample.startDate)
                    let end = df.string(from: sample.endDate)
                    dataBase.sendHeartRate(Int(heartRate), date: sample.startDate)
                    print("\(Int(heartRate)): \(start) - \(end)")
                }
            }
            DispatchQueue.main.sync {
                if let heartRate = samples?[0].quantity.doubleValue(for: heartRateUnit){
                    self.heartRateLabel.text = ("\(Int(heartRate))")
                }
            }
        })
    }
}
