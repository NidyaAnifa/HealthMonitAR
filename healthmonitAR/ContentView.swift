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
    @State private var isPulsing = false
    
    var body: some View {
        ZStack {
            ARViewContainer(heartRate: $heartRate).edgesIgnoringSafeArea(.all)
            
            CoachingOverlayView(duration: 3.0)
            
            VStack {
                HStack {
                    Text("❤️")
                        .scaleEffect(isPulsing ? 1.5 : 1)
                        .animation(
                            Animation.easeInOut(duration: 1)
                                        .repeatForever(autoreverses: true)
                        )
                        .font(.system(size: 15))
                    
                    Text("Welcome to HealthMonitAR")
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                        .font(.system(size: 25))
                    
                }.padding(.top)
                
                
//                Text(String(heartRate))
                Spacer()
                
                Button(action: { fetchHeartRate()
                }) {
                    Image(systemName: "arrow.clockwise.circle.fill")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .foregroundColor(Color.white)
//                        .clipShape(Circle())
                }
            }
        }
        .onAppear {
            // Request authorization and fetch heart rate data
            fetchHeartRate()
            self.isPulsing = true
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
