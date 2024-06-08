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

class Coordinator: NSObject, ARSessionDelegate, UIGestureRecognizerDelegate {
    weak var view: ARView?
    
    var collisionSubscriptions = [Cancellable]()
    
    //objetos que se quieren mover
    var movableEntities = [ModelEntity]()
    
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
            
            //añado el objeto como que lo queremos mover
            movableEntities.append(box)
            
            
            
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
            
            
            
            //instamos los gestos de las entidades que queremos mover.
            movableEntities.forEach{
                //A cade entidad le instalamos los gestos y el delegado del gesto
                view.installGestures(.all, for: $0).forEach{
                    $0.delegate = self //nuestra clae es el delegado de gestos
                }
            }
            
            //configuramos los gestos
            setupGestos()
            
            
        }
    }
    
    //MARK: Delegados
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    //Empieza el reconoce el gestos. Pillamos la entidad y le pasamos a kinematic
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let translationGesture = gestureRecognizer as? EntityTranslationGestureRecognizer,
              let entity = translationGesture.entity as? ModelEntity else {
            return true
        }
        
        //Cambiamo a la entidad el tipo de fisica a kinematic, para que pueda moverla el usuario
        //en la Scene
        entity.physicsBody?.mode = .kinematic
        return true
    }
    
    //configurar los gestos indicandoele el delahdo y la funcion
    func setupGestos(){
        guard let view = view else {return }
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panned(_:)))
        panGesture.delegate = self //que yoy el delegado(, la clase
        view.addGestureRecognizer(panGesture) //a la vista le digo que reconozca el gesto.
        
    }
    
    //Cuando la view reconozca un Gesto, nos va a llamar a esta funcion.
    @objc func panned(_ sender: UIPanGestureRecognizer){
        switch sender.state{
            //estados donde queremos cambiar el modo de las fiscias de la entidad a dinamico
        case .ended, .cancelled, .failed:
            movableEntities
                .compactMap{$0}
                .forEach{
                    $0.physicsBody?.mode = .dynamic //cambiamos las entidades en estos estados a dinamico
                }
        default:
                return //no hacemos nada en resto de estados
        }
    }
    
    
}
