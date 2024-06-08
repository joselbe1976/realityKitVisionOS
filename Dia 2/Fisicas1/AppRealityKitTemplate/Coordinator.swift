//
//  Coordinator.swift
//  AppRealityKitTemplate
//
//  Created by Jose Luis Bustos Esteban on 7/6/24.
//

import Foundation
import ARKit
import RealityKit
import Combine

class Coordinator: NSObject {
    weak var view: ARView?
    
    var collisionSubscriptions = [AnyCancellable]()
    
    //Tap Gesture
    @objc func handleTap(_ recognizer: UITapGestureRecognizer){
        
        //Desempaquetamos el view
        guard let view = view else {
            return
        }
        
        let location = recognizer.location(in: view)
        let results = view.raycast(from: location, allowing: .estimatedPlane, alignment: .horizontal)
        
        //Pillo el primer TAP (por si hay varios) ojo se puede hacer bucle.
        if let result = results.first {
            //Creo el anchor
            let anchor = AnchorEntity(raycastResult: result)
            
                        //Creamos una entidad Box
            let box = ModelEntity(mesh: MeshResource.generateBox(size: 0.3), materials: [SimpleMaterial(color: .green, isMetallic: true)])
            
            
            //aplicamos las fisicas a la entidad
            box.physicsBody = PhysicsBodyComponent(mode: .dynamic)
            
            //Genere colisiones de la box
            box.generateCollisionShapes(recursive: true)
            
            //posicioonamos la caja (arriba 0.5 metros para probar la gravedad)
            box.position = simd_float3(0, 0.5, 0)
            
            //Añadimos al anchor y a la escena
            anchor.addChild(box)
            view.scene.anchors.append(anchor)
        }
        
        
    }
}
