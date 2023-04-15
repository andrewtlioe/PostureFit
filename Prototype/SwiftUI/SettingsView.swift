//
//  SettingsView.swift
//  Prototype
//
//  Created by Andrew Tian Lioe on 11/21/22.
//

import SwiftUI

/// Off by default
struct MyVariables {
  static var voiceCounter = false
  static var overlayGuide = false
}

struct SettingsView: View {
  
  @State private var voiceCounter = MyVariables.voiceCounter
  @State private var overlayGuide = MyVariables.overlayGuide
  
    var body: some View {
      NavigationView{
        
          List {
            Section{
              HStack {
                Label("Counter Sound", systemImage: "speaker.wave.2.fill").foregroundColor(.black)
                Spacer()
                Toggle(isOn: $voiceCounter) { }
              }
            } footer: {
              Text("Enable repetition counter voice feedback.")
            }
            
            Section{
              HStack {
                Label("Overlay", systemImage: "line.diagonal.arrow").foregroundColor(.black)
                Spacer()
                Toggle(isOn: $overlayGuide) { }
              }
            } footer: {
              Text("Enable overlay lines and dots onto person in frame.")
            }
            
          }
        
        .navigationTitle (Text("Settings"))
        .toolbar {
          Button("Apply") {
            MyVariables.voiceCounter = voiceCounter
            MyVariables.overlayGuide = overlayGuide
          }
      }
        
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
