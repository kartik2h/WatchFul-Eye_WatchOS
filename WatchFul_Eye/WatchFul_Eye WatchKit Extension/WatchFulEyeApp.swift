//
//  HeartRateApp.swift
//  HeartRate WatchKit Extension
//
//  Created by Anastasia Ryabenko on 27.01.2021.
//
import Foundation
import SwiftUI
import HealthKit

@main
struct WatchFulEyeApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            TabView {
                HeartRateMesurementView()
                OxygenSaturationMesurementView()
                HRVMeasurementView()
                AudioLevelMeasurementView()
            }
            .tabViewStyle(PageTabViewStyle())
        }
        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
    var callFunc = WatchFulEye()
}



public class WatchFulEye: ObservableObject {
    
    private var healthStore = HKHealthStore()
    @ObservedObject var heartRateMeasurementService = HeartRateMeasurementService()
//    var recordAudioService = RecordAudioService()
    

    init() {
            
        autorizeHealthKit()
        heartRateMeasurementService.callAllApis()
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
//
//            let heartRateValue = self.heartRateMeasurementService.currentHeartRate
//            let oxygenValue = self.heartRateMeasurementService.currentOxygenSaturation
//            let hrvValue = self.heartRateMeasurementService.averageHRV
//            let audioLevelValue = self.heartRateMeasurementService.environmentalAudioExposure
//
//            self.startApiCalls(heartRate: heartRateValue, oxygen: oxygenValue, hrv: hrvValue, audioLevel: audioLevelValue)
//            self.recordAudioService.requestPermissionAndStartRecording()
//        }
    }
    
    func autorizeHealthKit() {

        let heartRateSampleType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        let oxygenSaturationSampleType = HKObjectType.quantityType(forIdentifier: .oxygenSaturation)!
        let hrvSampleType = HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!
        let environmentalAudioExposureSampleType = HKObjectType.quantityType(forIdentifier: .environmentalAudioExposure)!
        
        healthStore.requestAuthorization(toShare: [heartRateSampleType, oxygenSaturationSampleType, hrvSampleType, environmentalAudioExposureSampleType], read: [heartRateSampleType, oxygenSaturationSampleType, hrvSampleType, environmentalAudioExposureSampleType]) { _, _ in }
        
//        code to run HealthKit in background
//            let heartRateQuery = HKObserverQuery(sampleType: heartRateSampleType, predicate: nil) { (query, completionHandler, error) in
//                if error != nil {
//                    // Handle error
//                    return
//                }
//                self.apiCall(heartRate: heart, oxygen: self.oxygenValue)
//                // Handle updates
//            }

//            let oxygenSaturationQuery = HKObserverQuery(sampleType: oxygenSaturationSampleType, predicate: nil) { (query, completionHandler, error) in
//                if error != nil {
//                    // Handle error
//                    return
//                }
//
//                // Handle updates
//            }
        
        //code to start receiving updates in the background
    //        healthStore.execute(heartRateQuery)
    //        healthStore.execute(oxygenSaturationQuery)

        //code to stop receiving updates in the background
    //        healthStore.stop(heartRateQuery)
    //        healthStore.stop(oxygenSaturationQuery)

    }
    
//    func scheduleHeartRateSample() {
//        OperationQueue.async() {
//                while true {
//                    self.apiCall(heartRate: self.heartRateValue, oxygen: self.oxygenValue)
//                    sleep(60)
//                }
//            }
//        }
    
//    func startApiCalls(heartRate : Int, oxygen : Double, hrv: Double, audioLevel: Double) {
//        // Schedule the apiCall method to be called every 1 minute
//        self.apiCall(heartRate: heartRate, oxygen: oxygen, hrv: hrv, audioLevel: audioLevel)
//        
//        Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { _ in
//            // Call the apiCall method with some sample data
//            self.apiCall(heartRate: heartRate, oxygen: oxygen, hrv: hrv, audioLevel: audioLevel)
//        }
//    }
//    
//    func apiCall(heartRate : Int, oxygen : Double, hrv: Double, audioLevel: Double){
//        
//        print("function called")
//        
//        let vitals = VitalsModel()
//        
//        //code to send healthkit data to POST api
//        vitals.heartRate = heartRate
//        vitals.oxygen = oxygen
//        vitals.hrv = hrv
//        vitals.audioLevel = audioLevel
//        
//        print(vitals.heartRate)
//        print(vitals.oxygen)
//        print(vitals.hrv)
//        print(vitals.audioLevel)
//        
//        //create a dictionary to store the sample data
//        let sampleData: [String: Any] = [
//            "heart_rate": heartRate,
//            "oxygen_saturation": oxygen,
//            "hrv": hrv,
//            "audio_level": audioLevel
//        ]
//        
//        //convert the dictionary to JSON data
//        let jsonData = try? JSONSerialization.data(withJSONObject: sampleData)
//        print("method called")
//        
//        //create the URLRequest with the POST API endpoint
//        var request = URLRequest(url: URL(string: "https://dgkt1uyc90.execute-api.us-east-2.amazonaws.com/healthAPI/healthData")!)
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
//               response.statusCode == 200 {
//                print("Data sent to API successfully")
//            }
//        }
//        task.resume()
//    }
}
