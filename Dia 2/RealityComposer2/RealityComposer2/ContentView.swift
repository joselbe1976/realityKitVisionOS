//
//  ContentView.swift
//  RealityComposer2
//
//  Created by Jose Luis Bustos Esteban on 8/6/24.
//

import SwiftUI
import RealityKit
import ARKit

struct ContentView : View {
    var body: some View {
        ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)

        //validamos que este permitido en el dispositivo el Face Traking
        if !ARFaceTrackingConfiguration.isSupported{
            print("Device not suported")
            fatalError()
        } else {
            //Si esta soportado
            let configuration = ARFaceTrackingConfiguration()
            arView.session.run(configuration)
            
            //Cargamos la escena
            let faceAnchor = try! Experience.loadEscena()
            
            //añado  el anchor la escena
            arView.scene.addAnchor(faceAnchor)
        }
        
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

#Preview {
    ContentView()
}
