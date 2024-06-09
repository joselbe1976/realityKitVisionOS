//
//  Heros3DView.swift
//  AppVisionDragonBall
//
//  Created by Jose Luis Bustos Esteban on 9/6/24.
//

import SwiftUI
import KCNetworkVisionPro

//imports de Reality Kit
import RealityKit
import RealityKitContent

struct Heros3DView: View {
    @Environment(\.openWindow) private var openWindow
    @Environment(AppStateVM.self) private var appStateVM
    @State var viewModel: HerosViewModel //View model de heroes (me lo intecta principalView)
    
    @State private var selectedHero: HerosData?
    
    var body: some View {
        NavigationSplitView {
            //Lista heroes 3D
            
            List(selection: $selectedHero){
                if let heros = viewModel.heros3D {
                    ForEach(heros){data in
                        NavigationLink(value: data){
                            HerosRowView(hero: data)
                        }.tag(data)
                    }
                }
            }
            .navigationTitle("Heroes 3D")
            .navigationSplitViewColumnWidth(300)
            
        } detail: {
            // Modelo 3D del heroe con Reality Kit
            
            if let hero = selectedHero {
                Model3D(named: hero.id3DModel, bundle: realityKitContentBundle)
                //realityKitContentBundle = paquete de Swift
            }
            
        }
        .ornament(attachmentAnchor: .scene(.trailing)) {
            VStack{
                Button(action: {
                    //set hero selected
                    if let hero = selectedHero{
                        appStateVM.setHero(hero: hero)
                        //open Window
                        openWindow(id:"Modelo3D")
                    }
                    
                    
                }, label: {
                    Image(systemName: "rotate.3d")
                        .resizable()
                        .frame(width: 45, height: 45)
                        
                })
               
            }
            .frame(width: 60, height: 160)
            .glassBackgroundEffect()
            
        }

    }
}

#Preview {
    Heros3DView(viewModel: HerosViewModel(useCaseHeros: UseCaseHerosFake()))
        .environment(AppStateVM())
}
