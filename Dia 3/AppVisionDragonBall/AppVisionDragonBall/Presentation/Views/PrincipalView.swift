//
//  PrincipalView.swift
//  AppVisionDragonBall
//
//  Created by Jose Luis Bustos Esteban on 9/6/24.
//

import SwiftUI
import KCNetworkVisionPro


//Aqui solo los TABSView
struct PrincipalView: View {
    let vm: HerosViewModel
    
    init(vm: HerosViewModel = HerosViewModel()) {
        self.vm = vm
    }
    
    var body: some View {
        ZStack{
            // ----------------------
            // Desarrollo UI
            // ----------------------
            VStack{
                TabView{
                    HerosView(viewModel: vm)
                        .tabItem {
                            Label(
                                title: { Text("Heroes") },
                                icon: { Image(systemName: "house") }
                            )
                        }
                    
                    Heros3DView(viewModel: vm)
                        .tabItem {
                            Label(
                                title: { Text("Heroes 3D") },
                                icon: { Image(systemName: "person.fill") }

                            )
                        }
                }
            }
            
            
            
            // ----------------------
            // Relaity Kir. Sonido
            // ----------------------
            
        }
    }
}

#Preview {
    PrincipalView(vm: HerosViewModel(useCaseHeros: UseCaseHerosFake()))
}
