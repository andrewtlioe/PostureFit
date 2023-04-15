//
//  SplashScreen.swift
//  PostureFit
//
//  Created by Andrew Tian Lioe on 4/14/23.
//

import SwiftUI

enum AnimationState {
  case normal
  case compress
  case expand
}


struct SplashScreen: View {
  
  @State private var animationState: AnimationState = .normal
  @State private var done: Bool
  
  func calculate () -> Double {
    switch animationState {
    case .normal:
      return 0.2
    case .compress:
      return 0.18
    case .expand:
      return 10.0
    }
  }
  
    var body: some View {
        //Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
      
      ZStack{
        
        VStack{
          Image("AppIcon")
            .resizable()
            .aspectRatio(contentMode:.fit)
            .scaleEffect (calculate())
        }
        .frame (maxWidth: .infinity, maxHeight: .infinity)
        .background(.blue)
        .opacity (done ? 0: 1)
        
        
      } .onAppear {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          withAnimation (.spring( )) {
            animationState = .compress
            DispatchQueue.main.asyncAfter (deadline: .now() + 0.5) {
              withAnimation(.spring()) {
                animationState = .expand
                withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 100.0, damping: 10.0, initialVelocity: 0)) {
                  done = true
                }
              }
            }
          }
        }
      }
      
      
      
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
