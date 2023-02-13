//
//  HeartRateApp.swift
//  HeartRate WatchKit Extension
//
//  Created by Anastasia Ryabenko on 27.01.2021.
//
import Foundation
import SwiftUI

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
    
    var callFunc = WatchFulEye().self
}

public class WatchFulEye: ObservableObject {
    
    
    
    var heartRateValue = HeartRateMeasurementService().currentHeartRate
    var oxygenValue = HeartRateMeasurementService().currentOxygenSaturation
    
    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 20.0) {
            self.apiCall(heartRate: self.heartRateValue, oxygen: self.oxygenValue)
            print("init called")
        }
    }
    
    func apiCall(heartRate : Int, oxygen : Double){
        
        print("function called")
        
        //code to send healthkit data to POST api
        let heartRateSample = heartRate
        let oxygenSaturationSample = oxygen
        
        print(heartRateSample)
        print(oxygenSaturationSample)
        
        //create a dictionary to store the sample data
        let sampleData: [String: Any] = [
            "heart_rate": heartRateSample,
            "oxygen_saturation": oxygenSaturationSample
        ]
        
        //convert the dictionary to JSON data
        let jsonData = try? JSONSerialization.data(withJSONObject: sampleData)
        print("method called")
        
        //create the URLRequest with the POST API endpoint
        var request = URLRequest(url: URL(string: "https://55yum95q3g.execute-api.us-east-2.amazonaws.com/data")!)
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
