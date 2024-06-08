//
//  ContentView.swift
//  AppRealityKitTemplate
//
//  Created by Jose Luis Bustos Esteban on 7/6/24.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    var body: some View {
        ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
        // Inicio ejercicio 1.
        
        //Creamos el anchor
        let planeAnchorEntity = AnchorEntity(plane: .horizontal)
        
        //Creamos un plano
        let plane = ModelEntity(mesh: MeshResource.generatePlane(width: 1, depth: 1), materials: [SimpleMaterial(color: .orange, isMetallic: true)])
        
        //indicamos las Fisicas al plano
        plane.physicsBody = PhysicsBodyComponent(mode: .static)
        
        /*
            modos de fisica:
            - Static   . No puede moverse, es como montaña, una estatua o el suelo
            - Dinamic  . Cuerpo que se puede mover, al cual le afecta la gravedad, friccion y las colisiones
            - Kinematic. El usuario es responsable de mover el objeto
         */
        
        //Detecta colisiones con otras entidades.
        plane.generateCollisionShapes(recursive: true)
        //https://developer.apple.com/documentation/realitykit/entity/generatecollisionshapes(recursive:)
        
        
        //añadimos el plano al anchor y a la Scene
        planeAnchorEntity.addChild(plane)
        arView.scene.anchors.append(planeAnchorEntity)
        
        //Fin ejercicio 1.
        
        
        //añadimos el gesto
        arView.addGestureRecognizer(UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap)))
        
        //indicamos el coordinador
        context.coordinator.view = arView
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
}

