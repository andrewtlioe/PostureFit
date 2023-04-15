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
            ScrollView {
                RoundedRectangle(cornerRadius: 10)
                    .padding(20.0)
                    .frame(height: 200.0)
                    .foregroundColor(Color.white)
                
                RoundedRectangle(cornerRadius: 10)
                    .padding(20.0)
                    .frame(height: 200.0)
                    .foregroundColor(Color.white)
                
                RoundedRectangle(cornerRadius: 10)
                    .padding(20.0)
                    .frame(height: 200.0)
                    .foregroundColor(Color.white)
                
                RoundedRectangle(cornerRadius: 10)
                    .padding(20.0)
                    .frame(height: 200.0)
                    .foregroundColor(Color.white)
                
                RoundedRectangle(cornerRadius: 10)
                    .padding(20.0)
                    .frame(height: 200.0)
                    .foregroundColor(Color.white)
                
                RoundedRectangle(cornerRadius: 10)
                    .padding(20.0)
                    .frame(height: 200.0)
                    .foregroundColor(Color.white)
            }//scrollview
            .background(Color(hue: 0.719, saturation: 0.002, brightness: 0.943).edgesIgnoringSafeArea(.all))
            
            .navigationTitle(Text("Home"))
        }//navigationview
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
