//
//  HeartRateMeasurementService.swift
//  HeartRate WatchKit Extension
//
//  Created by Megh Patel
//


import Foundation
import SwiftUI
import HealthKit

class HeartRateMeasurementService: ObservableObject {
    private var healthStore = HKHealthStore()
    let heartRateQuantity = HKUnit(from: "count/min")
    let oxygenSaturationUnit = HKUnit(from: "%")
    let hrvQuantityUnit = HKUnit(from: "ms")
    let environmentalAudioExposureUnit = HKUnit.decibelAWeightedSoundPressureLevel()

    @Published var currentHeartRate: Int = 0
    @Published var currentOxygenSaturation: Double = 0.0
    @Published var averageHRV: Double = 0.0
    @Published var environmentalAudioExposure: Double = 0.0

    @Published var minHeartRate: Int = 0
    @Published var maxHeartRate: Int = 0
    
    init() {
        startQuery(quantityTypeIdentifier: .heartRate)
        startQuery(quantityTypeIdentifier: .oxygenSaturation)
        startQuery(quantityTypeIdentifier: .heartRateVariabilitySDNN)
        startQuery(quantityTypeIdentifier: .environmentalAudioExposure)
    }
    
    func callAllApis() {
//        autorizeHealthKit()
        print("main method executed")
        
        startQuery(quantityTypeIdentifier: .heartRate)
        startQuery(quantityTypeIdentifier: .oxygenSaturation)
        startQuery(quantityTypeIdentifier: .heartRateVariabilitySDNN)
        startQuery(quantityTypeIdentifier: .environmentalAudioExposure)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                                    
            let heartRateValue = self.currentHeartRate
            let oxygenValue = self.currentOxygenSaturation
            let hrvValue = self.averageHRV
            let audioLevelValue = self.environmentalAudioExposure
            
            let audioService = RecordAudioService()
            
            self.startApiCalls(heartRate: heartRateValue, oxygen: oxygenValue, hrv: hrvValue, audioLevel: audioLevelValue)
            
            var flag = true

            if ((oxygenValue >= 95 && oxygenValue <= 100) && (hrvValue > 50 && hrvValue < 105) || (heartRateValue > 60 && heartRateValue < 110)) {
                flag = false
            } else {
                flag = true
            }

            if ((oxygenValue >= 95 && oxygenValue <= 100) && (hrvValue > 50 && hrvValue < 105) || (heartRateValue < 60 || heartRateValue > 110)) {
                flag = true
            } else {
                flag = false
            }

            if ((oxygenValue >= 95 && oxygenValue <= 100) && (hrvValue < 50 || hrvValue > 105) || (heartRateValue > 60 && heartRateValue < 110)) {
                flag = true
            } else {
                flag = false
            }

            if ((oxygenValue >= 95 && oxygenValue <= 100) && (hrvValue < 50 || hrvValue > 105) || (heartRateValue < 60 || heartRateValue > 110)) {
                flag = true
            } else {
                flag = false
            }

            if ((oxygenValue < 95 || oxygenValue > 100) || (hrvValue > 50 && hrvValue < 105) || (heartRateValue > 60 && heartRateValue < 110)) {
                flag = true
            } else {
                flag = false
            }

            if ((oxygenValue < 95 || oxygenValue > 100) || (hrvValue > 50 && hrvValue < 105) || (heartRateValue < 60 || heartRateValue > 110)) {
                flag = true
            } else {
                flag = false
            }

            if ((oxygenValue < 95 || oxygenValue > 100) || (hrvValue < 50 || hrvValue > 105) || (heartRateValue > 60 && heartRateValue < 110)) {
                flag = true
            } else {
                flag = false
            }

            if ((oxygenValue < 95 || oxygenValue > 100) || (hrvValue < 50 || hrvValue > 105) || (heartRateValue < 60 || heartRateValue > 110)) {
                flag = true
            } else {
                flag = false
            }

            if(flag){
                audioService.requestRecordingPermission()
            }
            
        }
    }
    
    func startApiCalls(heartRate : Int, oxygen : Double, hrv: Double, audioLevel: Double) {
        // Schedule the apiCall method to be called every 1 minute
        self.apiCall(heartRate: heartRate, oxygen: oxygen, hrv: hrv, audioLevel: audioLevel)
        
        self.startQuery(quantityTypeIdentifier: .heartRate)
        self.startQuery(quantityTypeIdentifier: .oxygenSaturation)
        self.startQuery(quantityTypeIdentifier: .heartRateVariabilitySDNN)
        self.startQuery(quantityTypeIdentifier: .environmentalAudioExposure)
        
        let audioService = RecordAudioService()
        
        Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { _ in
            // Call the apiCall method with some sample data
            print("executed after 60 seconds")
            
            self.startQuery(quantityTypeIdentifier: .heartRate)
            self.startQuery(quantityTypeIdentifier: .oxygenSaturation)
            self.startQuery(quantityTypeIdentifier: .heartRateVariabilitySDNN)
            self.startQuery(quantityTypeIdentifier: .environmentalAudioExposure)
            
            let heartRateValueFunc = self.currentHeartRate
            let oxygenValueFunc = self.currentOxygenSaturation
            let hrvValueFunc = self.averageHRV
            let audioLevelValueFunc = self.environmentalAudioExposure
            
            self.apiCall(heartRate: heartRateValueFunc, oxygen: oxygenValueFunc, hrv: hrvValueFunc, audioLevel: audioLevelValueFunc)
            
            var flag = true

            if ((oxygenValueFunc >= 95 && oxygenValueFunc <= 100) && (hrvValueFunc > 50 && hrvValueFunc < 105) || (heartRateValueFunc > 60 && heartRateValueFunc < 110)) {
                flag = false
            } else {
                flag = true
            }

            if ((oxygenValueFunc >= 95 && oxygenValueFunc <= 100) && (hrvValueFunc > 50 && hrvValueFunc < 105) || (heartRateValueFunc < 60 || heartRateValueFunc > 110)) {
                flag = true
            } else {
                flag = false
            }

            if ((oxygenValueFunc >= 95 && oxygenValueFunc <= 100) && (hrvValueFunc < 50 || hrvValueFunc > 105) || (heartRateValueFunc > 60 && heartRateValueFunc < 110)) {
                flag = true
            } else {
                flag = false
            }

            if ((oxygenValueFunc >= 95 && oxygenValueFunc <= 100) && (hrvValueFunc < 50 || hrvValueFunc > 105) || (heartRateValueFunc < 60 || heartRateValueFunc > 110)) {
                flag = true
            } else {
                flag = false
            }

            if ((oxygenValueFunc < 95 || oxygenValueFunc > 100) || (hrvValueFunc > 50 && hrvValueFunc < 105) || (heartRateValueFunc > 60 && heartRateValueFunc < 110)) {
                flag = true
            } else {
                flag = false
            }

            if ((oxygenValueFunc < 95 || oxygenValueFunc > 100) || (hrvValueFunc > 50 && hrvValueFunc < 105) || (heartRateValueFunc < 60 || heartRateValueFunc > 110)) {
                flag = true
            } else {
                flag = false
            }

            if ((oxygenValueFunc < 95 || oxygenValueFunc > 100) || (hrvValueFunc < 50 || hrvValueFunc > 105) || (heartRateValueFunc > 60 && heartRateValueFunc < 110)) {
                flag = true
            } else {
                flag = false
            }

            if ((oxygenValueFunc < 95 || oxygenValueFunc > 100) || (hrvValueFunc < 50 || hrvValueFunc > 105) || (heartRateValueFunc < 60 || heartRateValueFunc > 110)) {
                flag = true
            } else {
                flag = false
            }

            if(flag){
                audioService.requestRecordingPermission()
            }
        }
    }
    
    func apiCall(heartRate : Int, oxygen : Double, hrv: Double, audioLevel: Double){
        
        print("function called")
        
        let vitals = VitalsModel()
        
        //code to send healthkit data to POST api
        vitals.heartRate = heartRate
        vitals.oxygen = oxygen
        vitals.hrv = hrv
        vitals.audioLevel = audioLevel
        
        print(vitals.heartRate)
        print(vitals.oxygen)
        print(vitals.hrv)
        print(vitals.audioLevel)
        
        //create a dictionary to store the sample data
        let sampleData: [String: Any] = [
            "heart_rate": heartRate,
            "oxygen_saturation": oxygen,
            "hrv": hrv,
            "audio_level": audioLevel
        ]
        
        //convert the dictionary to JSON data
        let jsonData = try? JSONSerialization.data(withJSONObject: sampleData)
        print("method called")
        
        //create the URLRequest with the POST API endpoint
        var request = URLRequest(url: URL(string: "https://dgkt1uyc90.execute-api.us-east-2.amazonaws.com/healthAPI/healthData")!)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        //send the request to the API
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error sending data to API: \(error)")
                return
            }
            
            //handle the response from the API
            if let response = response as? HTTPURLResponse,
               response.statusCode == 200 {
                print("Data sent to API successfully")
            }
        }
        task.resume()
    }
    
//    func apiCall(heartRate : Int, oxygen : Double){
//
//        //code to send healthkit data to POST api
//        let heartRateSample = heartRate
//        let oxygenSaturationSample = oxygen
//
//        //create a dictionary to store the sample data
//        let sampleData: [String: Any] = [
//            "heart_rate": heartRateSample,
//            "oxygen_saturation": oxygenSaturationSample
//        ]
//
//        //convert the dictionary to JSON data
//        let jsonData = try? JSONSerialization.data(withJSONObject: sampleData)
//        print("method called")
//
//        //create the URLRequest with the POST API endpoint
//        var request = URLRequest(url: URL(string: "https://55yum95q3g.execute-api.us-east-2.amazonaws.com/data")!)
//        request.httpMethod = "POST"
//        request.httpBody = jsonData
//
//        //send the request to the API
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            if let error = error {
//                print("Error sending data to API: \(error)")
//                return
//            }
//
//            //handle the response from the API
//            if let response = response as? HTTPURLResponse,
//                response.statusCode == 200 {
//                print("Data sent to API successfully")
//            }
//        }
//        task.resume()
//
//
//    }
    
//    func autorizeHealthKit() {
//        let healthKitTypes: Set = [
//            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!, HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.oxygenSaturation)!]
//
//        let heartRateSampleType = HKObjectType.quantityType(forIdentifier: .heartRate)!
//        let oxygenSaturationSampleType = HKObjectType.quantityType(forIdentifier: .oxygenSaturation)!
//        let hrvSampleType = HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!
//        let environmentalAudioExposureSampleType = HKObjectType.quantityType(forIdentifier: .environmentalAudioExposure)!
//
//        healthStore.requestAuthorization(toShare: [heartRateSampleType, oxygenSaturationSampleType, hrvSampleType, environmentalAudioExposureSampleType], read: [heartRateSampleType, oxygenSaturationSampleType, hrvSampleType, environmentalAudioExposureSampleType]) { _, _ in }
//
//        //code to run HealthKit in background
//        let heartRateQuery = HKObserverQuery(sampleType: heartRateSampleType, predicate: nil) { (query, completionHandler, error) in
//            if error != nil {
//                // Handle error
//                return
//            }
//
//            // Handle updates
//        }
//
//        let oxygenSaturationQuery = HKObserverQuery(sampleType: oxygenSaturationSampleType, predicate: nil) { (query, completionHandler, error) in
//            if error != nil {
//                // Handle error
//                return
//            }
//
//            // Handle updates
//        }
//
//        //code to start receiving updates in the background
//        healthStore.execute(heartRateQuery)
//        healthStore.execute(oxygenSaturationQuery)
//
//        //code to stop receiving updates in the background
//        healthStore.stop(heartRateQuery)
//        healthStore.stop(oxygenSaturationQuery)
//
//    }
    
    public func startQuery(quantityTypeIdentifier: HKQuantityTypeIdentifier) {
        
        let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
        let updateHandler: (HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, Error?) -> Void = {
            query, samples, deletedObjects, queryAnchor, error in
            guard let samples = samples as? [HKQuantitySample] else {
                return
            }
            self.process(samples, type: quantityTypeIdentifier)
        }
        let query = HKAnchoredObjectQuery(type: HKObjectType.quantityType(forIdentifier: quantityTypeIdentifier)!, predicate: devicePredicate, anchor: nil, limit: HKObjectQueryNoLimit, resultsHandler: updateHandler)
        query.updateHandler = updateHandler
        healthStore.execute(query)
    }
    
    public func process(_ samples: [HKQuantitySample], type: HKQuantityTypeIdentifier) {
        var lastHeartRate = 0.0
        var hrvSamples = [Double]()

        for sample in samples {

            if type == .heartRate {
                lastHeartRate = sample.quantity.doubleValue(for: heartRateQuantity)
            }
            DispatchQueue.main.async {
                self.currentHeartRate = Int(lastHeartRate)
                if self.maxHeartRate < self.currentHeartRate {
                    self.maxHeartRate = self.currentHeartRate
                }
                if self.minHeartRate == -1 || self.minHeartRate > self.currentHeartRate {
                    self.minHeartRate = self.currentHeartRate
                }
            }
            
            if type == .oxygenSaturation {
                    let oxygenSaturation = sample.quantity.doubleValue(for: oxygenSaturationUnit) * 100.0
                    DispatchQueue.main.async {
                    self.currentOxygenSaturation = oxygenSaturation
                }
            }
            
            if type == .heartRateVariabilitySDNN {
                    let hrv = sample.quantity.doubleValue(for: hrvQuantityUnit)
                    DispatchQueue.main.async {
                        self.averageHRV = hrv
                    }
                    hrvSamples.append(hrv)
            }
            
            if type == .environmentalAudioExposure {
                let audio = sample.quantity.doubleValue(for: environmentalAudioExposureUnit)
                    DispatchQueue.main.async {
                    self.environmentalAudioExposure = audio
                }
            }

        }
        
//        if type == .heartRateVariabilitySDNN {
//                let avgHRV = hrvSamples.reduce(0, +) / Double(hrvSamples.count)
//                DispatchQueue.main.async {
//                self.averageHRV = avgHRV
//            }
//        }
    }
}
