//
//  HomeView.swift
//  Prototype
//
//  Created by Andrew Tian Lioe on 11/21/22.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            Text("HomeView")
            .navigationTitle(Text("Home"))
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
