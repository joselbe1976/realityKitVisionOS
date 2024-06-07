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
    
    var cancelable: AnyCancellable? //para combine
    var suscriptions: [AnyCancellable] = []
    
    //Tap Gesture. Sincrono
    /*
    @objc func handleTap(_ recognizer: UITapGestureRecognizer){
        
        //Desempaqueto la vista
        guard let view = self.view else {return}
        
        //Localizacion del tap
        let taplocation = recognizer.location(in: view)
        
        let results = view.raycast(from: taplocation, allowing: .estimatedPlane, alignment: .horizontal)
        
        if let result = results.first {
            //aqui tenemos ya un sitio donde le han hecho TAP en la pantalla
            
            //Creo en Ancla
            let anchor = AnchorEntity(raycastResult: result)
            
            //Cargar el modelo. Forma sincrona
            guard let entity = try? ModelEntity.load(named: "dragonball") else {
                fatalError("No se ha podido cargal el modelo")
            }
            
            //añadimos el modelo al Anchor
            anchor.name = "DragonBall"
            anchor.addChild(entity)
            
            //añadimos el anchor a la Scene de la view
            view.scene.addAnchor(anchor)
        }
    }
     */
    /*
    //Tap Gesture Asincrono con Combine
    @objc func handleTap(_ recognizer: UITapGestureRecognizer){
        
        //Desempaqueto la vista
        guard let view = self.view else {return}
        
        //Localizacion del tap
        let taplocation = recognizer.location(in: view)
        
        let results = view.raycast(from: taplocation, allowing: .estimatedPlane, alignment: .horizontal)
        
        if let result = results.first {
            //aqui tenemos ya un sitio donde le han hecho TAP en la pantalla
            
            //Creo en Ancla
            let anchor = AnchorEntity(raycastResult: result)
            
            //Carga Asincrona con Combine del modelo
            cancelable = ModelEntity.loadAsync(named: "dragonball")
                .sink(receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        print("no se ha podido cargar el modelo")
                    }
                }, receiveValue: { entity in
                    NSLog("Cargado el modelo OK!")
                    anchor.name  = "DragonBall"
                    anchor.addChild(entity)
                })
            
            
            //añadimos el anchor a la Scene de la view
            view.scene.addAnchor(anchor)
        }
    }
    */
    
    
    //Tap Gesture Asincrono con Combine y Carga asincrona de las animaciones
    @objc func handleTap(_ recognizer: UITapGestureRecognizer){
        
        //Desempaqueto la vista
        guard let view = self.view else {return}
        
        //Localizacion del tap
        let taplocation = recognizer.location(in: view)
        
        let results = view.raycast(from: taplocation, allowing: .estimatedPlane, alignment: .horizontal)
        
        if let result = results.first {
            //aqui tenemos ya un sitio donde le han hecho TAP en la pantalla
            
            //Creo en Ancla
            let anchor = AnchorEntity(raycastResult: result)
            
            //Carga Asincrona con Combine del modelo
            cancelable = ModelEntity.loadAsync(named: "dragonball")
                .sink(receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        print("no se ha podido cargar el modelo")
                    }
                }, receiveValue: { entity in
                    NSLog("Cargado el modelo OK!")
                    anchor.name  = "DragonBall"
                    anchor.addChild(entity)  //añadimos entidad al anchor
                })
            
            
            //añadimos el anchor a la Scene de la view
            view.scene.addAnchor(anchor)
            
            //Me suscribo para que cuando se añada una entidad y tiene animaciones
            // se ejecuten.
            view.scene.subscribe(to: SceneEvents.DidAddEntity.self) { _ in
                //miro si el Anchor esta activo
                if anchor.isActive {
                    //recorremos todas las entidades añadidas al anchor
                    for entity in anchor.children {
                        //recorremos todas las anumaciones de la entidad (si tiene)
                        for animation in entity.availableAnimations{
                            entity.playAnimation(animation.repeat() , separateAnimatedValue: false)
                        }
                    }
                }
            }.store(in: &suscriptions)
        }
    }
}
