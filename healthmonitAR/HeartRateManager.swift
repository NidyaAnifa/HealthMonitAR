//
//  HeartKitManager.swift
//  healthmonitAR
//
//  Created by Nidya Anifa on 22/05/23.
//
//

import SwiftUI
import HealthKit

class HeartRateManager {
    let healthStore = HKHealthStore()
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!

        func requestAuthorization(completion: @escaping (Double?) -> Void) {
            guard HKHealthStore.isHealthDataAvailable() else {
                print("Heart rate data is not available.")
                completion(nil)
                return
            }

            healthStore.requestAuthorization(toShare: nil, read: [heartRateType]) { (success, error) in
                if success {
                    print("Authorization succeeded.")
                    self.fetchHeartRateData(completion: completion)
                } else {
                    print("Authorization failed: \(error?.localizedDescription ?? "")")
                    completion(nil)
                }
            }
        }

        func fetchHeartRateData(completion: @escaping (Double?) -> Void) {
            let startDate = Date.distantPast
            let endDate = Date()
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
            let limit = HKObjectQueryNoLimit

            let heartRateQuery = HKSampleQuery(sampleType: heartRateType, predicate: predicate, limit: limit, sortDescriptors: [sortDescriptor]) { (query, results, error) in
                if let heartRateSamples = results as? [HKQuantitySample] {
                    if let sample = heartRateSamples.first {
                        let heartRate = sample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: .minute()))
                        completion(heartRate)
                    } else {
                        completion(nil)
                    }
                } else {
                    print("Failed to fetch heart rate data: \(error?.localizedDescription ?? "")")
                    completion(nil)
                }
            }

            healthStore.execute(heartRateQuery)
        }
}
