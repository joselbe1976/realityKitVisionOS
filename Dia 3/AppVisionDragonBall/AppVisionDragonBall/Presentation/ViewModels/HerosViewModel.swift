//
//  HerosViewModel.swift
//  AppVisionDragonBall
//
//  Created by Jose Luis Bustos Esteban on 9/6/24.
//

import Foundation
import KCNetworkVisionPro

@Observable
final class HerosViewModel {
    var heros: [HerosData]? //Heroes
    var heros3D: [HerosData]?
    var status = Status.none
    
    var HerosUseCase: UseCaseHerosProtocol
    
    init(useCaseHeros: UseCaseHerosProtocol = UseCaseHeros()) {
        self.HerosUseCase = useCaseHeros
        
        //lanzamos la lista de heros por defecto
        Task{
            await getHeros(filter: "")
        }
    }
    
    
    
    //Buscar los Heros
    func getHeros(filter: String) async {
        let data = await HerosUseCase.getData(filter: filter)
        
        DispatchQueue.main.async{
            self.heros = data
            
            //filtrar los heroes 3d y asignarlos
            if let heros = self.heros {
                self.heros3D = heros.filter { $0.id3DModel != ""}
            }
        }
    }
    
    
    
    
    
  }
