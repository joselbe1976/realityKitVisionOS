//
//  AppStateVM.swift
//  AppVisionDragonBall
//
//  Created by Jose Luis Bustos Esteban on 9/6/24.
//

import Foundation
import KCNetworkVisionPro

//notacion Swift 5.10

//final class AppStateVM: ObservableObject{
   
@Observable
final class AppStateVM{
    var status = Status.none //Estado del login
    
    @ObservationIgnored
    var isLogged = false //Si esta o no logado

    @ObservationIgnored
    var heroSelected: HerosData? //heroe seleccionado para abrir alguna ventana
    
    
    init(){
        //Control de auto-login
        Task{
            await controlLogin()
        }
    }
    
    //funcion de Login
    func login(user: String, password: String) async {
        let loginOK = await UseCaseLogin().loginApp(user: user, password: password)
        
        //primero plano gilo principal
        DispatchQueue.main.async {
            if loginOK{
                self.status = .loaded
                self.isLogged = true
            } else{
                self.status = .error(error: "Usuario/clave no son correctos")
                self.isLogged = false
            }
        }
    }
    
    
    //Funcion Cierre Session
    
    func closeSession() {
        _ = UseCaseLogin().closeSession()
        isLogged = false
        status = .none
    }
    
    
    //Control de login (autoLogin)
    func controlLogin() async {
        if await UseCaseLogin().isLogged(){
            //Esta conectado OK.
            DispatchQueue.main.async{
                self.status = .loaded
                self.isLogged = true
            }
        }
    }
    
    
    //Asignar el Heroe seleccionado
    func setHero(hero: HerosData){
        self.heroSelected = hero
    }
    
    
    //Funcion 3d. Ojo esto deberia venir en el modelo 3D del Heroe desde el servidor.
    func getHeroSelected3Dvalues() -> (String, String) {
        
        //datos de Vegeta
        var soundFile = "/Root/vegeta/Vegatable_wav" //audio
        var usdaFile = "Vegeta.usda" //Scene
        
        
        //si es Goku, pues Goku
        if heroSelected!.id3DModel != "Vegeta"{
            soundFile = "/Root/goku/goku_wav" //audio
            usdaFile = "goku.usda" //Scene
          
        }
        
        return (soundFile, usdaFile)
        
    }
    
}
