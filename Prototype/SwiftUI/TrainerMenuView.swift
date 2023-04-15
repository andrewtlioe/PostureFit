//
//  TrainerMenuView.swift
//  Prototype
//
//  Created by Andrew Tian Lioe on 2/15/23.
//

import SwiftUI

enum AnimationState {
  case normal
  case compress
  case expand
}

struct TrainerMenuView: View {
  
  @State private var animationState: AnimationState = .normal
  @State private var done: Bool = false
  
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
    
    
    ZStack {
          
//------------------- UI Interaction Function -------------------//
      NavigationView {
        
        VStack (spacing: 20){
          NavigationLink(destination: ViewControllerWrapper(passedPosition: "Squat")) {
            ZStack {
              RoundedRectangle(cornerRadius: 10)
                .padding(20.0)
                .frame(height: 270.0)
                .foregroundColor(Color.gray)
              
              HStack(spacing: 25.0) {
                Image("Squat")
                  .resizable()
                  .frame(width: 130.0, height: 130.0)
                Text("Squat")
                  .font(.system(.title, design: .rounded))
                  .foregroundColor(.white)
              }
            }
          }
          
          NavigationLink(destination: ViewControllerWrapper(passedPosition: "Deadlift")) {
            ZStack {
              RoundedRectangle(cornerRadius: 10)
                .padding(20.0)
                .frame(height: 270.0)
                .foregroundColor(Color.gray)
              
              HStack(spacing: 25.0){
                Image("Deadlift")
                  .resizable()
                  .frame(width: 130.0, height: 130.0)
                Text("Deadlift")
                  .font(.system(.title, design: .rounded))
                  .foregroundColor(.white)
              }
            }
          }.navigationTitle(Text("Train"))
        }.scaleEffect(done ? 1: 0.95)
      }
//------------------- UI Interaction Function -------------------//


        
//------------------- Splash Screen Animation -------------------//
        VStack{
          Image("PostureFit_Logo")
            .resizable()
            .aspectRatio(contentMode:.fit)
            .scaleEffect(calculate())
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
//------------------- Splash Screen Animation -------------------//
      
      
    }
  }


struct TrainerMenuView_Previews: PreviewProvider {
    static var previews: some View {
      TrainerMenuView()
    }
}
