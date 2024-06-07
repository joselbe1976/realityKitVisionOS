//
//  ArViewBuilder.swift
//  AppRealitykit1
//
//  Created by Jose Luis Bustos Esteban on 7/6/24.
//

import Foundation
import SwiftUI
import RealityKit


func makeUIViewEjercicio1() -> ARView {
    //Creamos la vista
    let arView = ARView(frame: .zero)

    // Create a cube model
    let mesh = MeshResource.generateBox(size: 0.1, cornerRadius: 0.005)
    let material = SimpleMaterial(color: .blue, roughness: 0.15, isMetallic: false)
    let model = ModelEntity(mesh: mesh, materials: [material])
    

    // Create horizontal plane anchor for the content
    //let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.2, 0.2)))
    
    let anchor = AnchorEntity(plane: .horizontal)
    
    //minimumBounds = tamaño mínimo del plano
    //SIMD2 = Eacalar de un vector X,Y
    
    //añadir el modelo al anchor
    anchor.children.append(model)

    // Add the horizontal plane anchor to the scene
    arView.scene.anchors.append(anchor)

    return arView
}


//añadimos varios objetos en la escena (box, esfera y un plano)
func makeUIViewEjercicio2() -> ARView {
    //Creamos la vista
    let arView = ARView(frame: .zero)

    // Creo el Ancla (horizontal)
    let anchor = AnchorEntity(plane: .horizontal)
    
    //Crear modelos
    
    //Cubo 0,3 metros
    let material = SimpleMaterial(color: .blue, isMetallic: true)
    let box = ModelEntity(mesh: MeshResource.generateBox(size: 0.3), materials: [material])
    
    //Esfera de radio 0.3 metros amarilla y metalica
    let sphere  = ModelEntity(mesh: MeshResource.generateSphere(radius: 0.3), materials: [SimpleMaterial(color: .yellow, isMetallic: true)])
    
    sphere.position = simd_float3(0, 0.5, 0) //X,Y;Z
    
    
    //Plano rojo metalico de 0.5 x 0.3 de profundad (depth)
    let plane = ModelEntity(mesh: MeshResource.generatePlane(width: 0.5, depth: 0.3), materials: [SimpleMaterial(color: .red, isMetallic: true)])
    //movemos el plano
    plane.position = simd_float3(0.5, 0, 0)
    
    
    //habra que añadirlos al ancla
    anchor.addChild(box)
    anchor.addChild(sphere)
    anchor.addChild(plane)
    
    //y añadirmos el ancla a la Scena de la vista
    arView.scene.anchors.append(anchor)
    
    //devuelvo la vista
    return arView
}


//Añadir texto a la Scene
func makeUIViewEjercicio3() -> ARView {
    //Creamos la vista
    let arView = ARView(frame: .zero)

    // Creo el Ancla (horizontal)
    let anchor = AnchorEntity(plane: .horizontal)
   
    //https://developer.apple.com/documentation/realitykit/meshresource/generatetext(_:extrusiondepth:font:containerframe:alignment:linebreakmode:)-4fuil
    
    let text = ModelEntity(mesh: MeshResource.generateText("Hola keepcoders!", extrusionDepth: 0.03, font: .systemFont(ofSize: 0.2)), materials: [SimpleMaterial(color: .blue, isMetallic: true)])
    
    //extrusionDepth => Extension en metros del texto en el eje Z
    
    anchor.addChild(text)
    
    
    //y añadirmos el ancla a la Scena de la vista
    arView.scene.anchors.append(anchor)
    
    //devuelvo la vista
    return arView
}
