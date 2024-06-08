//
//  ContentView.swift
//  RealityComposer1
//
//  Created by Jose Luis Bustos Esteban on 8/6/24.
//

import SwiftUI
import RealityKit

//view model
final class ViewModel: ObservableObject{
    @Published
    var text : String = ""
}


struct ContentView : View {
    @StateObject var vm = ViewModel()
    
    var body: some View {
        VStack{
            ARViewContainer(vm: self.vm).edgesIgnoringSafeArea(.all)
            VStack{
                Text(vm.text)
            }
            .frame(maxWidth: .infinity, maxHeight: 100)
            .background(.orange)
            .foregroundStyle(.white)
            .font(.title)
            
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    let vm: ViewModel
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)

        //Cargar la escena de la Experiencia
        let SceneAnchor = try! Experience.loadEscena()
        
        
        //Buscamos los DisplayActions de Reality Composer
        let allDisplayActions = SceneAnchor.actions.allActions.filter{
            $0.identifier.hasPrefix("Display")
        }
        
        //Recorremos cada accion
        for displayAction in allDisplayActions {
            displayAction.onAction = {entity  in
                //acceso a la entidad
                if let entity = entity {
                    print("entity name:" + entity.name)
                    vm.text = "Robot Tap"
                }
            }
        }
        
        
        //Añadir el Anchor a la escena
        arView.scene.anchors.append(SceneAnchor)
        
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

#Preview {
    ContentView()
}
