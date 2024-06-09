//
//  PrincipalView.swift
//  AppVisionDragonBall
//
//  Created by Jose Luis Bustos Esteban on 9/6/24.
//

import SwiftUI
import KCNetworkVisionPro
import RealityKit
import RealityKitContent


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
            // Reality Kit. Sonido
            // ----------------------
            RealityView{ content in
                if let scene = try? await Entity(named: "Login", in: realityKitContentBundle){

                    //busco el emisor
                    guard let SoundEmitter = scene.findEntity(named: "SoundEmitter") else {
                        return
                    }
                    
                    //buscamos el audio
                    guard let recourceSound = try? await AudioFileResource(named: "/Root/dragonBallCorto_wav", from: "Login.usda", in: realityKitContentBundle) else {
                        NSLog("No encuenta el sonido")
                        return
                    }
                    
                    //asociado al emisor de Sonido el audio
                    let audio = SoundEmitter.prepareAudio(recourceSound)
                    audio.play()
                    
                    //añadimos la escenea a Content
                    content.add(scene)
                    
                }
            }
        }
    }
}

#Preview {
    PrincipalView(vm: HerosViewModel(useCaseHeros: UseCaseHerosFake()))
}
