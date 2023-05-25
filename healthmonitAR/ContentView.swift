//
//  ContentView.swift
//  healthmonitAR
//
//  Created by Nidya Anifa on 22/05/23.
//

import SwiftUI
import RealityKit
import ARKit

struct ContentView : View {
    let heartRateManager = HeartRateManager()
    @State var heartRate: Double = 0.0
    @State var isFetchingHeartRate = false
    
    var body: some View {
        ZStack {
            ARViewContainer(heartRate: $heartRate).edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("HeartMonitAR")
                    .foregroundColor(.red)
                    .font(.system(size: 30))
                
//              Text(String(format: "%.0f", heartRate))
                
                Spacer()
            }
        }
        .onAppear {
            // Request authorization and fetch heart rate data
            fetchHeartRate()
        }
    }
    
    func fetchHeartRate() {
        isFetchingHeartRate = true
        heartRateManager.requestAuthorization { fetchedHeartRate in
            DispatchQueue.main.async {
                heartRate = fetchedHeartRate ?? 0.0
                isFetchingHeartRate = false
            }
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
