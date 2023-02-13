//
//  HRVMeasurementView.swift
//  WatchFul_Eye WatchKit App
//
//  Created by Megh Patel on 11/02/23.
//

import SwiftUI
import HealthKit

struct HRVMeasurementView: View {
    @ObservedObject var heartRateMeasurementService = HeartRateMeasurementService()
    
    var body: some View {
        VStack {
            HRVLevelView(value: heartRateMeasurementService.averageHRV)
            if heartRateMeasurementService.averageHRV < 50 {
                Text("HRV is low\nConsult a doctor\n🏥")
                    .multilineTextAlignment(.center)
                    .font(.footnote)
            } else {
                Text("HRV is normal\n👌🏼")
                    .multilineTextAlignment(.center)
                    .font(.footnote)
            }
            Spacer()
        }.padding()
    }

}

struct HRVMeasurementView_Previews: PreviewProvider {
    static var previews: some View {
        HRVMeasurementView()
    }
}

