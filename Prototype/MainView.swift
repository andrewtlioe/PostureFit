//
//  MainView.swift
//  Prototype
//
//  Created by Andrew Tian Lioe on 11/21/22.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView(selection: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Selection@*/.constant(1)/*@END_MENU_TOKEN@*/) {
            HomeView().tabItem { Label("Home", systemImage: "house") }.tag(1)
            
            TrainerView().tabItem { Label("Train", systemImage: "figure.run") }.tag(2)
            
            SettingsView().tabItem { Label("Settings", systemImage: "gearshape.fill") }.tag(2)
        }.background(Color.gray)
        //.background(Color(hue: 0.719, saturation: 0.002, brightness: 0.943).edgesIgnoringSafeArea(.all))
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

// Test
