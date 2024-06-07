//
//  CoordinadorGestos.swift
//  AppRealitykit1
//
//  Created by Jose Luis Bustos Esteban on 7/6/24.
//

import Foundation
import RealityKit
import ARKit

class CoordinadorGestos: NSObject, ARSessionDelegate {
   weak var view : ARView? //referencia a la vista. Pero ojo Debil.

    //Cuando haga TAP en la pantalla... hago algo...
    /*
    @objc func handleTap(_ recognizer: UITapGestureRecognizer){
        //Desempaqueto la vista y si hay error salimos
        guard let view = self.view else { return }
        
        //Al pulsar en la pantalla recibimos la localizacion de la pulsamos
        let tapLocation = recognizer.location(in: view)
        
        // el objeto donde tenemos el TAp (RayCast)
        let results = view.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .horizontal)
        
        //me quedo con el primer TAP
        if let result = results.first {
            
            //Creo un ancla horizontal
            let anchor = ARAnchor(name: "Tap del dedo", transform: result.worldTransform)
            
            //añadimos a la vista el ancla. ARKIT
            view.session.add(anchor: anchor)
            
            // creo una box
            let box = ModelEntity(mesh: MeshResource.generateBox(size: 0.3))
            box.model?.materials = [SimpleMaterial(color: .blue, isMetallic: true)]
            
            
            // Creamos un Anchor de RealityKit desde uno de ARKit
            //añado al ancla y  a la escena
            let anchorEntity = AnchorEntity(anchor: anchor)
            anchorEntity.addChild(box)
            
            view.scene.addAnchor(anchorEntity)
        }
    }
    */
    //refactor del anterior, añadiendo solo Reality kit
    /*
    @objc func handleTap(_ recognizer: UITapGestureRecognizer){
        //Desempaqueto la vista y si hay error salimos
        guard let view = self.view else { return }
        
        //Al pulsar en la pantalla recibimos la localizacion de la pulsamos
        let tapLocation = recognizer.location(in: view)
        
        // el objeto donde tenemos el TAp (RayCast)
        let results = view.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .horizontal)
        
        //me quedo con el primer TAP
        if let result = results.first {
            
            // ARAnchor = ARkit
            // AnchorEntity = Reality Kit
            
            //Creo un ancla horizontal
            let anchorEntity = AnchorEntity(raycastResult: result)
            
            
            // creo una box
            let box = ModelEntity(mesh: MeshResource.generateBox(size: 0.3))
            box.model?.materials = [SimpleMaterial(color: .blue, isMetallic: true)]
            
            //añadir la caja al anchor
            anchorEntity.addChild(box)
            
            //añadir el anchor a la escena
            view.scene.addAnchor(anchorEntity)
        }
    }
    */
    
    //codigo anterior añadiendo gestos.
    @objc func handleTap(_ recognizer: UITapGestureRecognizer){
        //Desempaqueto la vista y si hay error salimos
        guard let view = self.view else { return }
        
        //Al pulsar en la pantalla recibimos la localizacion de la pulsamos
        let tapLocation = recognizer.location(in: view)
        
        // el objeto donde tenemos el TAp (RayCast)
        let results = view.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .horizontal)
        
        //me quedo con el primer TAP
        if let result = results.first {
            
            // ARAnchor = ARkit
            // AnchorEntity = Reality Kit
            
            //Creo un ancla horizontal
            let anchorEntity = AnchorEntity(raycastResult: result)
            
            
            // creo una box
            let box = ModelEntity(mesh: MeshResource.generateBox(size: 0.3))
            box.model?.materials = [SimpleMaterial(color: .blue, isMetallic: true)]
            
            //Cambio1.
            box.generateCollisionShapes(recursive: true)
            
            
            //añadir la caja al anchor
            anchorEntity.addChild(box)
            
            //añadir el anchor a la escena
            view.scene.addAnchor(anchorEntity)
            
            
            //CAMBIO 2. Instalamos en la vista y el objeto,  los gestos que queremos
            view.installGestures(.all, for: box)
            
            
        }
    }
}
