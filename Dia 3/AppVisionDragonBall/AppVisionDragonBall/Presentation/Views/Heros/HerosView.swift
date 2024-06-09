//
//  HerosView.swift
//  AppVisionDragonBall
//
//  Created by Jose Luis Bustos Esteban on 9/6/24.
//

import SwiftUI
import KCNetworkVisionPro

struct HerosView: View {
    @Environment(AppStateVM.self) private var appStateVM
    @State var viewModel: HerosViewModel //view model de heros
    
    //heroe seleccionado
    @State private var selectedHero: HerosData?
    //Para Buscar
    @State private var searchText = ""
    
    var body: some View {
        NavigationSplitView {
            //Lista Heroes
            List(selection: $selectedHero){
                //desempaquetamos y si es OK pintamos los heroes
                if let heros = viewModel.heros {
                    ForEach(heros){ data in
                        NavigationLink(value: data){
                            HerosRowView(hero: data)
                        }.tag(data)
                    }
                }
            }
            .navigationTitle("Heroes")
            .searchable(text: $searchText,placement: .navigationBarDrawer(displayMode: .always) , prompt: "Buscar heroe por nombre")
            
            
        } content: {
            //Detalle del Hero
            VStack{
                if let hero = selectedHero {
                    NavigationStack{
                        VStack{
                            //Foto
                            AsyncImage(url: URL(string: hero.photo))
                            //description del hero
                            Text(hero.description)
                        }
                    }
                    .navigationTitle(hero.name)
                } else {
                    //Vista sin contenido
                    ContentUnavailableView("Selecciona un heroe", systemImage: "person.fill")
                }
            }
        } detail: {
            //Transformaciones del Hero
            NavigationStack{
                if let hero = selectedHero{
                    List{
                        ForEach(hero.transformations){ trans in
                            VStack{
                                AsyncImage(url: URL(string: trans.photo)) { foto in
                                    foto
                                        .resizable()
                                        .frame(minHeight: 200, maxHeight: 400)
                                        .cornerRadius(20)
                                } placeholder: {
                                    ProgressView()
                                }
                                
                                //nombre
                                Text(trans.name)
                                    .font(.title2)
                                //detalle
                                Text(trans.description)
                                    .font(.caption2)

                            }
                            
                        }
                    }
                } else {
                    ContentUnavailableView("Sin Datos", systemImage: "cube.transparent")
                }
            }
            .navigationTitle("Transformaciones")
            
        }
        .ornament(attachmentAnchor: .scene(.bottom)) {
            //contenido del Ornament
            HStack{
                //un boton de mostrar la slocalizaciones
                Button(action: {
                    if let hero = selectedHero {
                        appStateVM.setHero(hero: hero)
                        
                        //TODO: LLamar a la ventana de localizaciones
                    }
                    
                }, label: {
                    Image(systemName: "map")
                        .resizable()
                        .frame(width: 45, height: 45)
                })
                
                
                // un botom para cerrar la session
                Button(action: {
                    appStateVM.closeSession()
                }, label: {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .frame(width: 45, height: 45)
                })
            }
            .frame(width: 400, height: 80)
            .glassBackgroundEffect(in: .rect(cornerRadius: 40))
            
            
        }
        .onChange(of: searchText){
            Task{
                await viewModel.getHeros(filter: searchText)
            }
        }

    }
}

#Preview {
    HerosView(viewModel: HerosViewModel(useCaseHeros: UseCaseHerosFake()))
        .environment(AppStateVM())
}
