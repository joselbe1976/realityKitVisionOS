//
//  HerosVRowView.swift
//  AppVisionDragonBall
//
//  Created by Jose Luis Bustos Esteban on 9/6/24.
//

import SwiftUI
import KCNetworkVisionPro

struct HerosRowView: View {
    let hero: HerosData
    
    var body: some View {
        ZStack{
            AsyncImage(url: URL(string: hero.photo)) { photo in
                ZStack{
                    photo
                        .resizable()
                        .frame(height: 120)
                        .cornerRadius(20)
                    
                    Image(systemName: "")
                        .resizable()
                        .frame(height: 120)
                        .cornerRadius(20)
                        .background(.black)
                        .opacity(0.5)
                }
                
            } placeholder: {
                Image(systemName: "house")
                    .resizable()
            }
            
            //nombre
            Text("\(hero.name)")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .foregroundStyle(.white)
            
        }
    }
}

#Preview {
    HerosRowView(hero: HerosData.getHeroMock()) //Mock hero
}
