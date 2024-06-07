//
//  ContentView.swift
//  AppRealityKitTemplate
//
//  Created by Jose Luis Bustos Esteban on 7/6/24.
//

import SwiftUI
import RealityKit
import AVFoundation

struct ContentView : View {
    var body: some View {
        ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
        //Anchor en horizontal
        let anchor = AnchorEntity(plane: .horizontal)
        
        //Cargamos el video
        guard let url = Bundle.main.url(forResource: "goku", withExtension: "mp4") else {
            fatalError("No se encuentra el video")
        }
        
        //AVPlayer
        let player = AVPlayer(url: url)
        
        //Video Material. Tipo de material
        let material = VideoMaterial(avPlayer: player)
        
        //activamos el audio, espacial
        material.controller.audioInputMode = .spatial
        
        //creamos la entidad PLANO
        let modelEntity = ModelEntity(mesh: MeshResource.generatePlane(width: 1, depth: 1), materials: [material])
        
        //ponemos el plano a la vertical como si fuera una TV.
        // Esto es lo que hace visionOS
        modelEntity.orientation = simd_quatf(angle: .pi/2, axis: [1,0,0])
        
        
        //activamos el video
        player.play()
        
        
        //añadimos el ancla
        anchor.addChild(modelEntity)
        arView.scene.addAnchor(anchor)
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    
   
    
}

