//
//  ContentView.swift
//  AppRealitykit1
//
//  Created by Jose Luis Bustos Esteban on 7/6/24.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    var body: some View {
        ARViewContainer()
            .edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    //funcion que se ejecta 1 vez. y crea una ARVIew.
    func makeUIView(context: Context) -> ARView {
        return makeUIViewEjercicio3()
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

#Preview {
    ContentView()
}
