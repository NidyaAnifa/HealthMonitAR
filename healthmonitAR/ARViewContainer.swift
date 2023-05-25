//
//  ARViewContainer.swift
//  healthmonitAR
//
//  Created by Nidya Anifa on 25/05/23.
//

import SwiftUI
import RealityKit
import ARKit

struct ARViewContainer: UIViewRepresentable {
    @Binding var heartRate: Double // Use a binding for heartRate

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
            Coordinator(heartRate: $heartRate) // Pass heartRate to the Coordinator
        }

    class Coordinator: NSObject, ARSCNViewDelegate {
        @Binding var heartRate: Double // Use a binding for heartRate

        init(heartRate: Binding<Double>) {
                _heartRate = heartRate
        }
        
        func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
            
            guard let faceAnchor = anchor as? ARFaceAnchor else { return }

            let textNode = SCNNode()
            let textGeometry = SCNText(string: String(format: "%.0f", heartRate), extrusionDepth: 0.1)
            
//            let textGeometry = SCNText(string: "User", extrusionDepth: 0.5)
            textNode.geometry = textGeometry
            
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.lightGray // Set the desired color here
            textGeometry.firstMaterial = material

            // Position the text node relative to the face anchor
            textNode.scale = SCNVector3(0.005, 0.005, 0.005)
            textNode.position = SCNVector3(x: faceAnchor.transform.columns.3.x,
                                           y: faceAnchor.transform.columns.3.y,
                                           z: faceAnchor.transform.columns.3.z)

            node.addChildNode(textNode) // Add the text node to the ARSCNView's node
        }
        
    }
}



//struct ARViewContainer_Previews: PreviewProvider {
//    static var previews: some View {
//        ARViewContainer()
//    }
//}
