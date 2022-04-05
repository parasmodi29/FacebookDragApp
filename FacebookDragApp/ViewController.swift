//
//  ViewController.swift
//  FacebookDragApp
//
//  Created by Techniexe Infolabs on 24/09/20.
//

import UIKit

class ViewController: UIViewController {

  // MARK:- View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }

  @IBAction func actionTap(_ sender: Any) {
   
    guard let reactionVC = storyboard?.instantiateViewController(withIdentifier: "ReactionViewController")
      as? ReactionViewController else {
          assertionFailure("No view controller ID ReactionViewController in storyboard")
          return
      }
      
      // set the modal presentation to full screen, in iOS 13, its no longer full screen by default
      reactionVC.modalPresentationStyle = .fullScreen
      
      // present the view controller modally without animation
      self.present(reactionVC, animated: false, completion: nil)
  }
  
  
  
}

extension UIView  {
    // render the view within the view's bounds, then capture it as image
  func asImage() -> UIImage {
    let renderer = UIGraphicsImageRenderer(bounds: bounds)
    return renderer.image(actions: { rendererContext in
        layer.render(in: rendererContext.cgContext)
    })
  }
}
