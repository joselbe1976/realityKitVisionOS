//
//  ContentView.swift
//  AppRealitykitTemplate
//
//  Created by Jose Luis Bustos Esteban on 14/10/23.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    var body: some View {
        ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
        arView.addGestureRecognizer(UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap)))
        
       
        //indicamos el corrdinator
        context.coordinator.view = arView
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    //indicamos que el coordinardor es nuestra clase
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
}

#Preview {
    ContentView()
}
