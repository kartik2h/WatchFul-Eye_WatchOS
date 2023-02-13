//
//  AudioLevelView.swift
//  WatchFul_Eye WatchKit App
//
//  Created by Megh Patel on 10/02/23.
//

import SwiftUI

struct AudioLevelView: View {
    var value: Double
    var units = "dB"
    
    @State var isAnimating = false
    
    var body: some View {
        HStack(spacing: 8) {
            Text(String(format: "%.1f", value))
                .fontWeight(.medium)
                .font(.system(size: 60))
            VStack {
                Text(units)
                    .font(.footnote)
                Image(systemName: "speaker.3")
                    .resizable()
                    .font(Font.system(.largeTitle).bold())
                    .frame(width: 16, height: 16)
            }
        }
        .onAppear {
            self.isAnimating = true
        }
    }
}
