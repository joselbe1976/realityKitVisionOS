//
//  ContentView.swift
//  MiniIKeaApp
//
//  Created by Jose Luis Bustos Esteban on 8/6/24.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    @StateObject private var vm = ViewModel()  //el viewModel
    
    let fornitures = ["sofa","chair","table","armoire"]
    
    var body: some View {
        VStack{
            ARViewContainer(vm: self.vm)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView(.horizontal){
                HStack{
                    ForEach(fornitures, id:\.self){ name in
                        Image("\(name)")
                            .resizable()
                            .frame(width: 90, height: 75)
                            .cornerRadius(20)
                            .border(.white, width: vm.selectedForniture == name ? 4.0 : 0.0)
                            .onTapGesture {
                                vm.selectedForniture = name//asigno el mueble seleccionado
                            }
                    }
                }
            }
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    var vm: ViewModel  //referencia al viewModel
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
        arView.addGestureRecognizer(UITapGestureRecognizer(target: context.coordinator, action: #selector(FornitureCoordinator.tapped)))
        context.coordinator.arView = arView //le paso la vista.

        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    func makeCoordinator() -> FornitureCoordinator{
        FornitureCoordinator(vm: self.vm)
    }
}

#Preview {
    ContentView()
}
