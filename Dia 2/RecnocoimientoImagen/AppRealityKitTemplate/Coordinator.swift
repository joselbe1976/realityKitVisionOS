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
        
        guard let arView = view else { return }
        
        //ancla de la imagen a buscar por la camara
        let anchor = AnchorEntity(.image(group: "AR Resources", name: "alcachofa"))
        
        //Cargamos el robot con Combine
        ModelEntity.loadAsync(named: "toy_drummer")
            .sink { completion in
                if case let .failure(error) = completion {
                    NSLog("Error al cargar el modelo: \(error)")
                }
            } receiveValue: { entity in
                anchor.addChild(entity)
                arView.scene.addAnchor(anchor)
                print("loaded robot")
            }
            .store(in: &cancelable)

        
        
    }
    
}
