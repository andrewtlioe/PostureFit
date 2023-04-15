//
//  MainView.swift
//  Prototype
//
//  Created by Andrew Tian Lioe on 11/21/22.
//

import SwiftUI

struct MainView: View {
  @State var tab: Int = 0
  
    var body: some View {
        TabView(selection: $tab) {
          //HomeView().tabItem { Label("Home", systemImage: "house") }.tag(1)
            
          TrainerMenuView().tabItem { Label("Train", systemImage: "figure.run")
          
            }.tag(1)
            
          SettingsView().tabItem { Label("Settings", systemImage: "gearshape.fill") }.tag(2)
        }.background(Color.gray)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
