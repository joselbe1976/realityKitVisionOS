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
    
    var collisionSubscriptions = [Cancellable]()
    
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
            
            
            //Controlar las Colisiones
            
            box.collision = CollisionComponent(shapes: [.generateBox(width: 0.2, height: 0.2, depth: 0.2)], mode: .trigger, filter: .sensor)
            
            /*
                Mode: Default o Trigger. Trigger = evento capturable por combine
             https://developer.apple.com/documentation/realitykit/collisioncomponent/mode-swift.enum
             
                Filter: Sensor: Entidad colisiona con cualquier cosa
             https://developer.apple.com/documentation/realitykit/collisionfilter
             */
            
            
            
            //Añadimos al anchor y a la escena
            anchor.addChild(box)
            view.scene.anchors.append(anchor)
            
            
            //Combine. Suscripcion a colisiones.
            
            //cuando empieza la colision entre 2 objetos
            collisionSubscriptions.append(view.scene.subscribe(to: CollisionEvents.Began.self) { event in
                //qui nos llegan las 2 entidades involucradas con la colision.
                //event.entityA
                //event.entityB
                
                //pillamos las 2 entidades y las casteamos a ModelEntity
                guard let entity1 = event.entityA as? ModelEntity,
                      let entity2 = event.entityB as? ModelEntity else {return}
                
                //Cambiamos la entidad a rojo.
                entity1.model?.materials = [SimpleMaterial(color: .red, isMetallic: true)]
                entity2.model?.materials = [SimpleMaterial(color: .red, isMetallic: true)]
                
                //Cmabiar el color de la caja a rojo
               // box.model?.materials = [SimpleMaterial(color: .red, isMetallic: true)]
            })
            
            
            //Cuando termina la colision entre 2 objeto
            
            collisionSubscriptions.append(
                view.scene.subscribe(to: CollisionEvents.Ended.self, { event in
                   // box.model?.materials = [SimpleMaterial(color: .green, isMetallic: true)]
                    guard let entity1 = event.entityA as? ModelEntity,
                          let entity2 = event.entityB as? ModelEntity else {return}
                    
                    //Cambiamos la entidad a rojo.
                    entity1.model?.materials = [SimpleMaterial(color: .green, isMetallic: true)]
                    entity2.model?.materials = [SimpleMaterial(color: .green, isMetallic: true)]
                    
                    
                })
            )
            
            
            
        }
        
        
    }
}
