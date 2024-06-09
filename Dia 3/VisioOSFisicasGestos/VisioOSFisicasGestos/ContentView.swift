//
//  ContentView.swift
//  VisioOSFisicasGestos
//
//  Created by Jose Luis Bustos Esteban on 9/6/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    //referencia a la esfera
    private var model: ModelEntity
    
    init(){
        self.model = ModelEntity(mesh: .generateSphere(radius: 0.1), materials: [SimpleMaterial(color: .red, isMetallic: true)])
    }
    
    var body: some View {
        RealityView{ content in
            
            //Plano Horizontal
            let plane  = ModelEntity(mesh: MeshResource.generatePlane(width: 0.9, depth: 0.9), materials: [SimpleMaterial(color: .orange, isMetallic: true)])
            
            //bajamos un poco el plano
            plane.position = .init(0,-0.2, 0)
            
            //fisicas al plano
            plane.generateCollisionShapes(recursive: true)
            plane.physicsBody = PhysicsBodyComponent(mode: .static)
            
            //añadimos
            content.add(plane)
            
            
            
            //Creamo una Sfera
            self.model.position.x = -0.2
            self.model.physicsBody = PhysicsBodyComponent(mode: .dynamic)
            self.model.generateCollisionShapes(recursive: true)
            
            //Activo las interacciones con la esfera
            self.model.components.set(InputTargetComponent()) //acepta inputs del sistema
            self.model.components.set(CollisionComponent(shapes: [.generateSphere(radius: 0.1)]))
            
            content.add(self.model)
            
            
            //Creamos una segunda esfera sin Fisicas
            let model2 = ModelEntity(mesh: .generateSphere(radius: 0.1), materials: [SimpleMaterial(color: .blue, isMetallic: true)])
            
            model2.generateCollisionShapes(recursive: true)
            model2.physicsBody = PhysicsBodyComponent(mode: .dynamic) //aplican fisicas
            
            model2.position = .init(0,0,0)
            model2.components.set(InputTargetComponent())
            content.add(model2)
            
        }
        .gesture(
            DragGesture() //Gesto tipo Drag
                .targetedToAnyEntity() //este gesto todas las entidades
                .onChanged({ value in
                    print(value.entity.name)
                    //movemos la entity
                    value.entity.position =  value.convert(value.location3D, from: .local, to: value.entity.parent!)
                })
        )
        .gesture(
            SpatialTapGesture() //gesto espacial TAP sobre un modelo
                .targetedToEntity(self.model) //solo controlamos el tap en la esfera
                .onEnded({ valor in
                    print("Has hecho TAP en la esfera roja")
                    self.model.position = .init(0, 0, 0) //posicionamos la esfera al centro
                })
        )
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
