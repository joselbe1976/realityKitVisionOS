//
//  FornitureCoordinator.swift
//  MiniIKeaApp
//
//  Created by Jose Luis Bustos Esteban on 8/6/24.
//

import Foundation
import RealityKit
import ARKit

final class FornitureCoordinator {
   //referencia debil de la vista de ARVIew
    weak var arView: ARView?
    
  //inyeccion dependencias el viewModel
    var vm: ViewModel
    
    //aqui tengo el reality composer
    var experience: Experience.Escena?
    
    init(vm: ViewModel) {
        self.vm = vm
        Task{
            try await loadScene() //cargamos la escena
        }
    }
    
    //Cargo la escena
    private func loadScene() async throws {
        self.experience = try await Experience.loadEscena()
    }
    
    
    //TAP
    @objc func tapped(_ recognizer : UITapGestureRecognizer){
        //desempaqueto la view
        guard let arView = arView else{
            return
        }
        
        let location = recognizer.location(in: arView)
        let results = arView.raycast(from: location, allowing: .estimatedPlane, alignment: .horizontal)
        
        if let result = results.first {
            //ya tenemos resltado del tap
            
            //Achor.
            let anchor = AnchorEntity(raycastResult: result)
            
            //buscamos el objeto seleccionado en la Experience
            guard let entity = experience?.findEntity(named: vm.selectedForniture) else {
                NSLog("el objeto \(vm.selectedForniture) no se ha encontrado en la experience")
                return
            }
            //posicionar el objeto en 0,0,0
            entity.position = SIMD3(0,0,0)
            
            //Convertil el Entity -> ModelEntity
            var modelEntity = ModelEntity()
            modelEntity.addChild(entity)
            
            
            //añadimos al anchor y la Scene
            anchor.addChild(modelEntity)
            arView.scene.addAnchor(anchor)
            
            //ainstalamos los gestos.
            modelEntity.generateCollisionShapes(recursive: true)
            arView.installGestures([.rotation, .translation], for: modelEntity)
            
            
        }
     }
}
