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
    var recordAudioService = RecordAudioService()
    

    init() {
            
        autorizeHealthKit()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 20.0) {
            let heartRateValue = self.heartRateMeasurementService.currentHeartRate
            let oxygenValue = self.heartRateMeasurementService.currentOxygenSaturation
            let hrvValue = self.heartRateMeasurementService.averageHRV
            let audioLevelValue = self.heartRateMeasurementService.environmentalAudioExposure
            
            self.apiCall(heartRate: heartRateValue, oxygen: oxygenValue, hrv: hrvValue, audioLevel: audioLevelValue)
            self.recordAudioService.requestPermissionAndStartRecording()
        }
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
    
    func apiCall(heartRate : Int, oxygen : Double, hrv: Double, audioLevel: Double){
        
        print("function called")
        
        //code to send healthkit data to POST api
        let heartRateSample = heartRate
        let oxygenSaturationSample = oxygen
        let hrvSample = hrv
        let audioLevelSample = audioLevel
        
        print(heartRateSample)
        print(oxygenSaturationSample)
        print(hrvSample)
        print(audioLevelSample)
        
        //create a dictionary to store the sample data
        let sampleData: [String: Any] = [
            "heart_rate": heartRateSample,
            "oxygen_saturation": oxygenSaturationSample,
            "hrv": hrvSample,
            "audio_level": audioLevelSample
        ]
        
        //convert the dictionary to JSON data
        let jsonData = try? JSONSerialization.data(withJSONObject: sampleData)
        print("method called")
        
        //create the URLRequest with the POST API endpoint
        var request = URLRequest(url: URL(string: "https://dgkt1uyc90.execute-api.us-east-2.amazonaws.com/healthAPI")!)
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
}
