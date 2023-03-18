//
//  TrainerMenuView.swift
//  Prototype
//
//  Created by Andrew Tian Lioe on 2/15/23.
//

import SwiftUI

/*
class TrainerMenuViewController: UIViewController {
  @StateObject private var model = FrameHandler()
  
  var body: some View {
    NavigationView {
      //Text("TrainerView")
      
      VStack{
        NavigationLink{
          //print("startSet")
          CameraFeedView(image: model.frame)
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

struct TrainerMenuView: UIViewControllerRepresentable {
  typealias UIViewControllerType = TrainerMenuViewController
 
  func makeUIViewController(context: Context) -> TrainerMenuViewController {
      let sb = UIStoryboard(name: "Main", bundle: nil)
      let viewController = sb.instantiateViewController(identifier: "TrainerMenuViewController") as! TrainerMenuViewController
      return viewController
  }
  
  func updateUIViewController(_ uiViewController: TrainerMenuViewController, context: Context) {
    
    NavigationLink{
      ViewController()
    } label:{
      Image(systemName: "play.circle.fill")
        .resizable()
        .frame(width: 200.0, height: 200.0)
        .foregroundColor(.black)
    }
    
  }
}
*/




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
