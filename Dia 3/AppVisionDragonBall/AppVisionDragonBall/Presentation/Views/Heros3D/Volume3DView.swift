//
//  Volume3DView.swift
//  AppVisionDragonBall
//
//  Created by Jose Luis Bustos Esteban on 9/6/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct Volume3DView: View {
    @Environment(AppStateVM.self) private var appStateVM
    
    var body: some View {
        RealityView{ content in
            
            if let scene = try? await Entity(named: appStateVM.heroSelected!.id3DModel, in: realityKitContentBundle) {
                 //busco los Path de sounido y Scene de cada Heroe
                let (soundFile, usdaFile) = appStateVM.getHeroSelected3Dvalues()
                
                //SONIDO ------------------
                
                //cargamos el sonido
                guard let SoundEmitter =  scene.findEntity(named: "SoundEmitter") else {
                    NSLog("Emitter no encontrado en la escena Login")
                    return
                }
                
                //buscamos el audio
                guard let recourceSound = try? await AudioFileResource(named: soundFile, from: usdaFile, in: realityKitContentBundle) else {
                    NSLog("No encuenta el sonido")
                    return
                }
                
                //asociado al emisor de Sonido el audio
                let audio = SoundEmitter.prepareAudio(recourceSound)
                audio.play()
                
                
                // ----- ANIMACIONES ----------
                
                //Convertimos entity-> ModelEntity (como en iOS)
                let modelEntity = ModelEntity()
                modelEntity.addChild(scene)
                
                //Activamos las animaciones de los modelos
                for animation in modelEntity.availableAnimations {
                    modelEntity.playAnimation(animation.repeat())
                }
                
                
                
                //añadimos la escenea a Content
                content.add(modelEntity)
                
                
                
                
            }
            
        }
    }
}

#Preview {
    Volume3DView()
        .environment(AppStateVM())
}
