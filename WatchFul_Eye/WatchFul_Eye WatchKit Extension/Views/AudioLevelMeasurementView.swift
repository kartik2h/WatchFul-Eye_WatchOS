//
//  AudioLevelMeasurementView.swift
//  WatchFul_Eye WatchKit App
//
//  Created by Megh Patel on 12/02/23.
//

import SwiftUI
import HealthKit

struct AudioLevelMeasurementView: View {
    @ObservedObject var heartRateMeasurementService = HeartRateMeasurementService()
    
    var body: some View {
        VStack {
            Text("Environmental Audio Exposure")
                .font(.headline)
            AudioLevelView(value: heartRateMeasurementService.environmentalAudioExposure)
            if heartRateMeasurementService.environmentalAudioExposure > 85 {
                Text("Too loud!\n🔊")
                    .multilineTextAlignment(.center)
                    .font(.footnote)
            } else {
                Text("Noise level is normal\n🔇")
                    .multilineTextAlignment(.center)
                    .font(.footnote)
            }
            Spacer()
        }.padding()
    }
}

struct EnvironmentalAudioExposureView_Previews: PreviewProvider {
    static var previews: some View {
        AudioLevelMeasurementView()
    }
}

