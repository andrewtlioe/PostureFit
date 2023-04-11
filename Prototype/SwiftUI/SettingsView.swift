//
//  SettingsView.swift
//  Prototype
//
//  Created by Andrew Tian Lioe on 11/21/22.
//

import SwiftUI

struct MyVariables {
  static var voiceCounter = true
}

struct SettingsView: View {
  
  @State private var voiceCounter = MyVariables.voiceCounter
  
    var body: some View {
        NavigationView {
          List {
            HStack {
              Label ("Counter Sound", systemImage: "speaker")
              Spacer ()
              Toggle(isOn: $voiceCounter) { }
            }
          }
        }
        .navigationTitle (Text("Train"))
        .toolbar {
          Button("Save") {
            MyVariables.voiceCounter = voiceCounter
          }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
