//
//  TrainerMenuView.swift
//  Prototype
//
//  Created by Andrew Tian Lioe on 2/15/23.
//

import SwiftUI


struct TrainerMenuView: View {
  //@StateObject private var model = FrameHandler() //for old framehandler, uncomment if use again
  
  var body: some View {
    NavigationView {
      //Text("TrainerView")
      
      VStack{
        NavigationLink{
          //CameraFeedView(image: model.frame)
          ViewControllerWrapper()
        } label:{
          Image(systemName: "play.circle.fill")
            .resizable()
            .frame(width: 200.0, height: 200.0)
            .foregroundColor(.black)
        }
        
        .navigationTitle(Text("Train"))
        
      }
      
    }
  }
}




struct TrainerMenuView_Previews: PreviewProvider {
    static var previews: some View {
        TrainerMenuView()
    }
}
