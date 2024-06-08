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
    
    //Cancelable de combine
    var cancelable: AnyCancellable?
    
    func setup() {
        //Desempaquetamos la view y sino no hacemos nada
        guard let arView = view else{
            return
        }
        
        //Ancla Horizontal
        let anchor = AnchorEntity(plane: .horizontal)
        
        //Ahora generamos una BOX: splitfaces = true
        //https://developer.apple.com/documentation/realitykit/meshresource/generatebox(width:height:depth:cornerradius:splitfaces:)
        
        let mesh = MeshResource.generateBox(width: 0.3, height: 0.3, depth: 0.3, cornerRadius: 0, splitFaces: true)
        let box = ModelEntity(mesh: mesh)
        
        //Cargar las imagenes
        cancelable = TextureResource.loadAsync(named: "lola")
            .append(TextureResource.loadAsync(named: "purple_flower"))
            .append(TextureResource.loadAsync(named: "cover.jpg"))
            .append(TextureResource.loadAsync(named: "DSC_0003.JPG"))
            .append(TextureResource.loadAsync(named: "DSC_0117.JPG"))
            .append(TextureResource.loadAsync(named: "DSC_0171.JPG"))
            .collect()
            .sink(receiveCompletion: { [weak self] completion in
                // Aqui nos llega el Completion
                if case let .failure(error)  = completion {
                    fatalError("Imposible cargar las texturas \(error)")
                }
                
                //Puedo cancelar el suscriptor.
                self?.cancelable?.cancel()
                
            }, receiveValue: { textures in
                //Aqui nos llegan las Texturas
                //https://developer.apple.com/documentation/realitykit/unlitmaterial
                
                
                //me creo un array de materiales
                var materials : [UnlitMaterial] = []
                
                //recorremos cada Textura recibida y la cargamos al array
                textures.forEach { texture in //$0
                    var material = UnlitMaterial()
                    material.color = .init(tint: .white, texture: .init(texture))
                    
                    //añadimos el mayerial al array
                    materials.append(material)
                }
                
                //Configuramos la escena-----
                
                //asigno los materiales a la cubo
                box.model?.materials = materials
                
                //Añadimos gestos
                box.generateCollisionShapes(recursive: true)
                
                //añadimos la box al anchor
                anchor.addChild(box)
                
                //añadimos el ancla a la escena
                arView.scene.addAnchor(anchor)
                
                //Instalamos los gestos
                arView.installGestures(.all, for: box)
            })
    }
}
