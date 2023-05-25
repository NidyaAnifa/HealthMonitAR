//
//  CoachingOverlayView.swift
//  healthmonitAR
//
//  Created by Nidya Anifa on 25/05/23.
//

import SwiftUI

struct CoachingOverlayView: View {
    @State private var isShowing = false
    let duration: TimeInterval
    
    init(duration: TimeInterval = 3.0) {
        self.duration = duration
    }
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .opacity(isShowing ? 0.7 : 0.0)
                .foregroundColor(.black)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                Text("Make sure you wear your Apple Watch\nShow your face to the camera\nClick the button bellow to get the newest heart rate")
                    .padding(20)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .font(.system(size: 17, weight: .bold))
                    .opacity(isShowing ? 1.0 : 0.0)
                
                Spacer()
            }
        }
        .animation(.easeInOut)
        .onAppear {
            isShowing = true
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                isShowing = false
            }
        }
    }
}

struct CoachingOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        CoachingOverlayView()
    }
}
