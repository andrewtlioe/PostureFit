//
//  TrainerView.swift
//  Prototype
//
//  Created by Andrew Tian Lioe on 11/21/22.
//

import SwiftUI

struct CameraFeedView: View {
    var image: CGImage?
    private let label = Text("frame")
  
    var body: some View {
        NavigationView {
          
          VStack{
            
            /*HStack{
              NavigationLink{
                //print("startSet")
                TrainerMenuView()
              } label:{
                Text("back").padding([.leading])
                Spacer()
              }
            }*/
            
            if let image = image {
              Image(image, scale: 1.0, orientation: .up, label: label)
                .ignoresSafeArea()
            } else {
              Color.black
            }
            
          }
        }//.navigationTitle(Text("Train"))
    }
}

struct CameraFeedView_Previews: PreviewProvider {
    static var previews: some View {
        CameraFeedView()
    }
}
