//
//  ViewControllerWrapper.swift
//  PostureFit
//
//  Created by Andrew Tian Lioe on 3/17/23.
//

import SwiftUI

struct ViewControllerWrapper: UIViewControllerRepresentable {
  typealias UIViewControllerType = ViewController
  
  func makeUIViewController(context: Context) -> ViewController {
    let sb = UIStoryboard(name: "Main", bundle: nil)
    let viewController = sb.instantiateViewController(identifier: "ViewController") as! ViewController
    return viewController
  }
  
  func updateUIViewController(_ uiViewController: ViewController, context: Context) {
    
  }
}

struct ViewControllerWrapper_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerWrapper()
    }
}
