//
//  heroMapKit.swift
//  AppVisionDragonBall
//
//  Created by Jose Luis Bustos Esteban on 9/6/24.
//

import SwiftUI
import MapKit
import KCNetworkVisionPro

struct heroMapKit: View {
    @Environment(AppStateVM.self) private var appStateVM
    
    var body: some View {
        NavigationStack{
            VStack{
                if let hero = appStateVM.heroSelected{
                    Map(){
                        ForEach(hero.locations){ loc in
                            Marker(hero.name, coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(Double(loc.latitud)!), longitude: CLLocationDegrees(Double(loc.longitud)!)))
                        }
                    }
                }
            }
            .navigationTitle(appStateVM.heroSelected?.name ?? "Sin heroe")

        }
    }
}



#Preview {
    var vm = AppStateVM()
    vm.setHero(hero: HerosData.getHeroMock())
    
    let view = heroMapKit().environment(vm)
    
    return view
}
