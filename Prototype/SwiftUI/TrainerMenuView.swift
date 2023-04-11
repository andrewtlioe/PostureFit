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
      
      VStack (spacing: 50){
        NavigationLink(destination: ViewControllerWrapper(passedPosition: "Squat")) {
          
          HStack {
                  
            Image("Squat")
              .resizable()
              .frame(width: 100.0, height: 100.0)
            Text("Squat")
              .font(.system(.title, design: .rounded))
              }
          .padding()
          .foregroundColor(.white)
          .background(Color.gray)
          .cornerRadius(.infinity)
        }
        
        
        NavigationLink(destination: ViewControllerWrapper(passedPosition: "Deadlift")) {
          
          HStack {
                  
            Image("Deadlift")
              .resizable()
              .frame(width: 100.0, height: 100.0)
            Text("Deadlift")
              .font(.system(.title, design: .rounded))
              }
          .padding()
          .foregroundColor(.white)
          .background(Color.gray)
          .cornerRadius(.infinity)
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

/*
 NavigationLink{
   //CameraFeedView(image: model.frame)
   ViewControllerWrapper()
 } label: {
   /*
   Image(systemName: "play.circle.fill")
     .resizable()
     .frame(width: 200.0, height: 200.0)
     .foregroundColor(.black)*/
   
   HStack {
           
     Image("Deadlift")
       .resizable()
       .frame(width: 100.0, height: 100.0)
     Text("Deadlift")
       }
   .padding()
   .foregroundColor(.white)
   .background(Color.gray)
   .cornerRadius(.infinity)
 */
