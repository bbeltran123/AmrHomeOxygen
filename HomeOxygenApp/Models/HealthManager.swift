//
//  HealthManager.swift
//  HomeOxygenApp
//
//  Created by Amr Mousa on 19.8.2020.
//  Copyright © 2020 Amr Mousa. All rights reserved.
//
import Foundation
import HealthKit

//Default class for collecting and sending health-data
let defaultHealthManager = HealthManager()

class HealthManager {

    let healthStore: HKHealthStore = HKHealthStore()
    var heartRateQuery: HKObserverQuery?

    public func subscribeToHeartBeatChanges(success: @escaping (_ samples: [HKQuantitySample]?) -> Void) {
        // Creating the sample for the heart rate
        guard let sampleType: HKSampleType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
          return
        }
        // Creating an observer, so updates are received whenever HealthKit’s;
        // heart rate data changes.
        self.heartRateQuery = HKObserverQuery.init(
        sampleType: sampleType,
        predicate: nil, updateHandler:
        {[weak self] _, _, error in
          guard error == nil else {
            print(error.debugDescription)
            return
          }

          /// When the completion is called, an other query is executed
          /// to fetch the latest heart rate
            self?.fetchLatestHeartRateSample(completion: { samples in
            guard let samples = samples else {
              return
            }
            success(samples)
          })
        })
        healthStore.execute(heartRateQuery!)
    }

        public func fetchLatestHeartRateSample(
          completion: @escaping (_ sample: [HKQuantitySample]?) -> Void) {

          /// Create sample type for the heart rate
          guard let sampleType = HKObjectType
            .quantityType(forIdentifier: .heartRate) else {
              completion(nil)
            return
          }

          /// Predicate for specifiying start and end dates for the query
          let predicate = HKQuery
            .predicateForSamples(
              withStart: Date.distantPast,
              end: Date(),
              options: .strictEndDate)

          /// Set sorting by date.
          let sortDescriptor = NSSortDescriptor(
            key: HKSampleSortIdentifierStartDate,
            ascending: false)

          /// Create the query
          let query = HKSampleQuery(
            sampleType: sampleType,
            predicate: predicate,
            limit: Int(HKObjectQueryNoLimit),
            sortDescriptors: [sortDescriptor], resultsHandler: { (_, results, error) in

              guard error == nil else {
                print("Error: \(error!.localizedDescription)")
                return
              }

                completion(results as? [HKQuantitySample])
          })

          self.healthStore.execute(query)
        }
    
    func requestAuthorization() {
        let heartRateType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
        //reading
        let readingTypes:Set = Set( [heartRateType] )

        //writing
        let writingTypes:Set = Set( [heartRateType] )
        let permissionStatus = healthStore.authorizationStatus(for: heartRateType)

        if(permissionStatus == HKAuthorizationStatus.notDetermined) {
            healthStore.requestAuthorization(toShare: writingTypes, read: readingTypes) { (success, error) -> Void in

                if error != nil
                {
                    print("error \(error!.localizedDescription)")
                }
                else if success
                {

                }
            }
        } else if(permissionStatus != HKAuthorizationStatus.sharingAuthorized) {
            print("Alert user that permission is required!")
        }
    }

}
