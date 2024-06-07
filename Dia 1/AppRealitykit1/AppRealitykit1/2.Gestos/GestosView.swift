//
//  GestosView.swift
//  AppRealitykit1
//
//  Created by Jose Luis Bustos Esteban on 7/6/24.
//

import SwiftUI
import RealityKit

struct GestosView: View {
    var body: some View {
        ARViewContainer_Gestos().edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
}

struct ARViewContainer_Gestos : UIViewRepresentable{
    //funcion que crea la vista
    func makeUIView(context: Context) -> ARView {
        
        //ARView
        let arView = ARView(frame: .zero)
        
        //Añadimos a la vista el gesto TAP creado en el coordinador
        arView
            .addGestureRecognizer(UITapGestureRecognizer(target: context.coordinator, action: #selector(CoordinadorGestos.handleTap)))
        
        //indicamos el coordinador la vista y el delegado
        context.coordinator.view = arView
        arView.session.delegate = context.coordinator //indicamos a la vista que use nuestro coordinador
        
        return arView
    }
    //funcion de actualizacion de la vista. no se suele usar
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    //coordinador de nuestra clase
    func makeCoordinator() -> CoordinadorGestos {
        CoordinadorGestos()
    }
    
}
