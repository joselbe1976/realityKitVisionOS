//
//  VisioOSFisicasGestosApp.swift
//  VisioOSFisicasGestos
//
//  Created by Jose Luis Bustos Esteban on 9/6/24.
//

import SwiftUI

@main
struct VisioOSFisicasGestosApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
    }
}
