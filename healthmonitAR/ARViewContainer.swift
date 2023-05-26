//
//  ARViewContainer.swift
//  healthmonitAR
//
//  Created by Nidya Anifa on 25/05/23.
//

import SwiftUI
import ARKit
//import UIKit

struct ARViewContainer: UIViewRepresentable {
    @Binding var heartRate: Double
    @State var heartStatus: String = "normal"
    @State var prompt: String = ""

    init(heartRate: Binding<Double>) {
        _heartRate = heartRate
    }

    let arView = ARSCNView()

    func makeUIView(context: Context) -> ARSCNView {
        arView.delegate = context.coordinator
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        arView.session.run(configuration)
        return arView
    }

    func updateUIView(_ uiView: ARSCNView, context: Context) {
        
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(heartRate: $heartRate, heartStatus: $heartStatus, prompt: $prompt)
    }

    class Coordinator: NSObject, ARSCNViewDelegate {
        @Binding var heartRate: Double
        @Binding var heartStatus: String
        @Binding var prompt: String

        init(heartRate: Binding<Double>, heartStatus: Binding<String>, prompt: Binding<String>) {
            _heartRate = heartRate
            _heartStatus = heartStatus
            _prompt = prompt
        }
        
        func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
            if heartRate >= 0 && heartRate <= 60 {
                        heartStatus = "low"
                        prompt = "Let's move your body a bit!"
                    } else if heartRate > 60 && heartRate <= 100 {
                        heartStatus = "normal"
                        prompt = "Good! Let's maintain your health"
                    } else if heartRate > 100 {
                        heartStatus = "high"
                        prompt = "Let's take a deep breath and relax"
                    }
            
            guard let faceAnchor = anchor as? ARFaceAnchor else { return }

            let heartRateNode = SCNNode()
            let heartRateGeometry = SCNText(string: String(format: "Heart rate: %.0f", heartRate), extrusionDepth: 0.1)
            var font = UIFont(name: "Helvetica", size: 7)
            heartRateGeometry.font = font
//            heartRateGeometry.alignment = SCNTextAlignmentCenter
            heartRateNode.geometry = heartRateGeometry
            
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.lightGray
            heartRateGeometry.firstMaterial = material
            
            heartRateNode.scale = SCNVector3(0.005, 0.005, 0.005)
            heartRateNode.position = SCNVector3(x: faceAnchor.transform.columns.3.x - 0.2,
                                                y: faceAnchor.transform.columns.3.y + 0.2,
                                                z: faceAnchor.transform.columns.3.z)
            
            let heartStatusNode = SCNNode()
            let heartStatusGeometry = SCNText(string: String(format: "Your heart rate is %@\n%@", heartStatus, prompt), extrusionDepth: 0.1)
            heartStatusGeometry.font = font
//            heartStatusGeometry.alignment = SCNTextAlignmentCenter
            heartStatusNode.geometry = heartStatusGeometry
            material.diffuse.contents = UIColor.red
            heartStatusGeometry.firstMaterial = material
            
            heartStatusNode.scale = SCNVector3(0.005, 0.005, 0.005)
            heartStatusNode.position = SCNVector3(x: faceAnchor.transform.columns.3.x - 0.2,
                                                  y: faceAnchor.transform.columns.3.y + 0.1,
                                                z: faceAnchor.transform.columns.3.z)
            
            node.addChildNode(heartRateNode)
            node.addChildNode(heartStatusNode)
        }
    }
}
