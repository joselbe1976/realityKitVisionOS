//
//  ContentView.swift
//  ProyectARCoaChing
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

//extendemos ARVIEw  ARCoachingOverlayVIewDelegate
extension ARView: ARCoachingOverlayViewDelegate {
    //Añadir el Coaching
    func addCoaching() {
        //Configurar la vista de Coaching
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.goal = .horizontalPlane
        coachingOverlay.session = self.session
        coachingOverlay.delegate = self
        
        self.addSubview(coachingOverlay)
    }
    
    //se desactiva el coaching
    public func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        NSLog("finaliza Coach")
        addVirtualObject()
    }
    
    private func addVirtualObject(){
        //aqui creariamos los objectos.
        
        let box = ModelEntity(mesh: MeshResource.generateBox(size: 0.5), materials: [SimpleMaterial(color: .blue, isMetallic: true)])
     
        //busco el Anchor crrado anteriomente
        guard let anchor = self.scene.anchors.first(where: {$0.name == "Plane Anchor"}) else {
            NSLog("Erroro anchor no encontrado")
            return
        }
        anchor.addChild(box)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        //Creo un Anchor horizontal
        let anchor = AnchorEntity(plane: .horizontal)
        anchor.name = "Plane Anchor"
        arView.scene.addAnchor(anchor)
        
        //llamo al coaching
        arView.addCoaching()
        
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

#Preview {
    ContentView()
}
