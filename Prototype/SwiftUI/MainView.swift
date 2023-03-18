//
//  MainView.swift
//  Prototype
//
//  Created by Andrew Tian Lioe on 11/21/22.
//

import SwiftUI

struct MainView: View {
  //@StateObject private var model = FrameHandler()
  @State var tab: Int = 0
  
    var body: some View {
        TabView(selection: $tab) {
          HomeView().tabItem { Label("Home", systemImage: "house") }.tag(1)
            
          TrainerMenuView().tabItem { Label("Train", systemImage: "figure.run")
          
            /*CameraFeedView(image: model.frame).tabItem { Label("Train", systemImage: "figure.run")
                //.ignoresSafeArea()*/
            }.tag(2)
            
          SettingsView().tabItem { Label("Settings", systemImage: "gearshape.fill") }.tag(3)
        }.background(Color.gray)
        //.background(Color(hue: 0.719, saturation: 0.002, brightness: 0.943).edgesIgnoringSafeArea(.all))
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
