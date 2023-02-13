//
//  OxygenSaturationMeasurementView.swift
//  WatchFul_Eye WatchKit App
//
//  Created by Megh Patel on 10/02/23.
//

import SwiftUI
import HealthKit

struct OxygenSaturationMesurementView: View {
    @ObservedObject var heartRateMeasurementService = HeartRateMeasurementService()
    
    var body: some View {
        VStack {
            OxygenLevelView(value: heartRateMeasurementService.currentOxygenSaturation)
            if heartRateMeasurementService.currentOxygenSaturation < 90 {
                Text("Consult a doctor\n🏥")
                    .multilineTextAlignment(.center)
                    .font(.footnote)
            } else {
                Text("Oxygen saturation is normal\n👌🏼")
                    .multilineTextAlignment(.center)
                    .font(.footnote)
            }
            Spacer()
        }.padding()
    }

}

struct OxygenSaturationMesurementView_Previews: PreviewProvider {
    static var previews: some View {
        OxygenSaturationMesurementView()
    }
}

