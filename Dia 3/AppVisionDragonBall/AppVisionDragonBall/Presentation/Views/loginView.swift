//
//  loginView.swift
//  AppVisionDragonBall
//
//  Created by Jose Luis Bustos Esteban on 9/6/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct loginView: View {
    @Environment(AppStateVM.self) private var appStateVM
    
    @State private var user: String = "bejl@keepcoding.es"
    @State private var pass: String = "123456"
    
    var body: some View {
        // ------------------------------
        //para incluir dentro la UI y Reality Kit
        // ------------------------------
        ZStack{
            //Componemos la UI
            ZStack{
                //Imagen Fondo
                Image(.cielo)
                    .resizable()
                
                //Login
                HStack{
                    //image goku
                    VStack{
                        Image(.gokuOK)
                            .resizable()
                            .scaledToFit()
                            .padding([.all], 20)
                    }
                    
                    //login Form
                    VStack{
                        Image(.logo)
                            .resizable()
                            .scaledToFit()
                            .padding(.top, 70)
                        
                        //Formulario del login
                        Form{
                            Section{
                                //User
                                TextField("Usuario", text: $user)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                                    .font( .title)
                                    .id(1) //Testing
                            }
                            
                            Section{
                                //Pass
                                SecureField("Clave", text: $pass)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                                    .font(.title)
                                    .id(2)
                            }
                            
                            
                        }
                        .padding(.top, 50)
                        .padding([.leading, .trailing],10)
                        
                        //Boton de login
                        Button(action: {
                            Task{
                                //Llamamos al login
                                await appStateVM.login(user: self.user, password: self.pass)
                            }
                            
                        }, label: {
                            Text("Login")
                                .font(.title)
                                .padding()
                                .frame(width: 400, height: 60)
                        })
                        .background(Color.orange)
                        .cornerRadius(20)
                        .padding(.bottom, 50)
                        
                    }
                }
            }
            
            // ------------------------------
            // Reality Kit para cargar sonido
            // ------------------------------
            RealityView{ content in
                if let scene = try? await Entity(named: "Login", in:  realityKitContentBundle){
                    
                    //BUscamos el Emisor de sonido
                    guard let SoundEmitter =  scene.findEntity(named: "SoundEmitter") else {
                        NSLog("Emitter no encontrado en la escena Login")
                        return
                    }
                    
                    //buscamos el audio
                    guard let recourceSound = try? await AudioFileResource(named: "/Root/dragonballMain_wav", from: "Login.usda", in: realityKitContentBundle) else {
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
    loginView()
        .environment(AppStateVM())
}
