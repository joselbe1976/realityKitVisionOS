//
//  Coodinator.swift
//  AppRealitykitTemplate
//
//  Created by Jose Luis Bustos Esteban on 14/10/23.
//

import Foundation
import ARKit
import RealityKit


class Coordinator: NSObject {
    weak var view: ARView?
    
    func setup(){
        
        //Pillamos la View
        guard let arView = view else {
            return
        }
        
        
        
    }
}
