//
//  rootView.swift
//  AppVisionDragonBall
//
//  Created by Jose Luis Bustos Esteban on 9/6/24.
//

import SwiftUI

struct rootView: View {
    @Environment(AppStateVM.self) private var appStateVM
    
    
    var body: some View {
        ZStack{
            VStack{
                switch (appStateVM.status){
                case .none:
                    loginView()
                case .error(error: let errorString):
                    Text("Error \(errorString)")
                case .loaded:
                    PrincipalView()
                }
            }
        }
    }
}

#Preview {
    rootView()
        .environment(AppStateVM())
}
