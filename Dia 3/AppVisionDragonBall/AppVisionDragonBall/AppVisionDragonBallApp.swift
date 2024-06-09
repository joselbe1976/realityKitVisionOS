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
        WindowGroup {
            rootView()
                .environment(appState)
                //Tamaño minimo y maximo
                .frame(minWidth: 1000, maxWidth: .infinity, minHeight: 800, maxHeight: .infinity)
        }
        .windowStyle(.plain) //es una ventana plana normal
        .windowResizability(.contentMinSize)//Aplica al redimensionar los tamaños minimo
    }
}
