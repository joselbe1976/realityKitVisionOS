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
    var cancelable = Set<AnyCancellable>()
    
    
    func setup() {
        guard let arView = view else {
            return
        }
        
        let anchor = AnchorEntity(plane: .horizontal)
        
        //Creamos una caja
       // let box = ModelEntity(mesh: MeshResource.generateBox(size: 0.2), materials: [SimpleMaterial(color: .blue, isMetallic: true)])
        
        let box = ModelEntity(mesh: MeshResource.generateBox(size: 0.2), materials: [OcclusionMaterial()])
        
        //Oclusion Material es un material Invisible
        //https://developer.apple.com/documentation/realitykit/occlusionmaterial
        
        //la caja de sebe mover
        box.generateCollisionShapes(recursive: true)
        arView.installGestures(.all, for: box)
        anchor.addChild(box)
        
        //cargamos el robot
        ModelEntity.loadAsync(named: "robot")
            .sink { completion in
                switch completion {
                case .finished:
                    NSLog("Success load model")
                case .failure(let error):
                    NSLog("error load model: \(error)")
                }
            } receiveValue: { entity in
                //añadir al anchor
                anchor.addChild(entity)
            }
            .store(in: &cancelable)

        
        //Anchor al Scene
        arView.scene.addAnchor(anchor)
        
        
    }
    
}
