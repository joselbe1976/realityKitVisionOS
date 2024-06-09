//
//  AppVisionDragonBallApp.swift
//  AppVisionDragonBall
//
//  Created by Jose Luis Bustos Esteban on 9/6/24.
//

import SwiftUI

@main
struct AppVisionDragonBallApp: App {
    //ViewModels Globales
    @State private var appState = AppStateVM()
    
    
    var body: some Scene {
        
        //ventana Main
        
        WindowGroup {
            rootView()
                .environment(appState)
                //Tamaño minimo y maximo
                .frame(minWidth: 1000, maxWidth: .infinity, minHeight: 800, maxHeight: .infinity)
        }
        .windowStyle(.plain) //es una ventana plana normal
        .windowResizability(.contentMinSize)//Aplica al redimensionar los tamaños minimo
        
        
        //ventana de Mapa de un Heroe
        WindowGroup(id: "mapa") {
            heroMapKit()
                .environment(appState)
        }
        .windowStyle(.automatic)
        .defaultSize(width: 1000.0, height: 1000.0)
        
        
        
        //Ventana Volumetrica
        WindowGroup(id: "Modelo3D"){
            Volume3DView()
                .environment(appState)
        }
        .windowStyle(.volumetric)
    }
}
