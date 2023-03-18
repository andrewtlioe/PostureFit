//
//  SettingsView.swift
//  Prototype
//
//  Created by Andrew Tian Lioe on 11/21/22.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            Text("SettingsView")
            .navigationTitle(Text("Settings"))
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
