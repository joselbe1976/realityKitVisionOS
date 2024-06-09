//
//  loginView.swift
//  AppVisionDragonBall
//
//  Created by Jose Luis Bustos Esteban on 9/6/24.
//

import SwiftUI

struct loginView: View {
    @Environment(AppStateVM.self) private var appStateVM
    
    @State private var user: String = "bejl@keepcoding.es"
    @State private var pass: String = "123456"
    
    var body: some View {
        
        //para incluir dentro la UI y Reality Kit
        ZStack{
            
            //Componemos la UI
            
            
            
            //Reality Kit para cargar sonido
        }
    }
}

#Preview {
    loginView()
        .environment(AppStateVM())
}
