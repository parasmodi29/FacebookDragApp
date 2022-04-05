//
//  ReactionViewController.swift
//  FacebookDragApp
//
//  Created by Techniexe Infolabs on 24/09/20.
//

import UIKit

class ReactionViewController: UIViewController {

  enum CardViewState {
    case expanded
    case normal
  }
  
  // default card view state is normal
  var cardViewState : CardViewState = .normal
  var cardPanStartingTopConstant : CGFloat = 30.0
  
  @IBOutlet var topConstraint: [NSLayoutConstraint]!
  @IBOutlet weak var cardView: UIView!
  @IBOutlet weak var dimmerView: UIView!
  @IBOutlet weak var handleView: UIView!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // round the handle view
    handleView.clipsToBounds = true
    handleView.layer.cornerRadius = 3.0
    
    let dimmerTap = UITapGestureRecognizer(target: self, action: #selector(dimmerViewTapped(_:)))
    dimmerView.addGestureRecognizer(dimmerTap)
    dimmerView.isUserInteractionEnabled = true
    
    //    self.dimmerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
    // Do any additional setup after loading the view.
    
    cardView.clipsToBounds = true
    cardView.layer.cornerRadius = 0.0
    cardView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    
    // hide the card view at the bottom when the View first load
    
    // hide the card view at the bottom when the View first load
    
    self.topConstraint[0].constant = UIApplication.shared.windows[0].safeAreaLayoutGuide.layoutFrame.size.height + UIApplication.shared.windows[0].safeAreaInsets.bottom
    // set dimmerview to transparent
    dimmerView.alpha = 0.0
    
    // add pan gesture recognizer to the view controller's view (the whole screen)
    let viewPan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))
    
    // by default iOS will delay the touch before recording the drag/pan information
    // we want the drag gesture to be recorded down immediately, hence setting no delay
    viewPan.delaysTouchesBegan = false
    viewPan.delaysTouchesEnded = false
    
    self.cardView.addGestureRecognizer(viewPan)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.showCard()
  }
//
//  @IBAction func viewPanned(_ panRecognizer: UIPanGestureRecognizer) {
//    // how much has user dragged
//    let translation = panRecognizer.translation(in: self.view)
//
//    switch panRecognizer.state {
//    case .began:
//      cardPanStartingTopConstant = self.topConstraint[0].constant
//    case .changed :
//      if self.cardPanStartingTopConstant + translation.y > 30.0 {
//          self.topConstraint[0].constant = self.cardPanStartingTopConstant + translation.y
//      }
//    case .ended :
//      let safeAreaHeight = UIApplication.shared.windows[0].safeAreaLayoutGuide.layoutFrame.size.height
//        let bottomPadding = UIApplication.shared.windows[0].safeAreaInsets.bottom
//
//        if self.topConstraint[0].constant < (safeAreaHeight + bottomPadding) * 0.25 {
//          // show the card at expanded state
//          // we will modify showCard() function later
//        } else if self.topConstraint[0].constant < (safeAreaHeight) - 70 {
//          // show the card at normal state
//          showCard()
//        } else {
//          // hide the card and dismiss current view controller
//          hideCardAndGoBack()
//        }
//      //}
//    default:
//      break
//    }
//  }
  
  // @IBAction is required in front of the function name due to how selector works
  @IBAction func dimmerViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
    hideCardAndGoBack()
  }

  
  // ReactionViewController.swift
  private func hideCardAndGoBack() {
      
    // ensure there's no pending layout changes before animation runs
    self.view.layoutIfNeeded()
    
    // set the new top constraint value for card view
    // card view won't move down just yet, we need to call layoutIfNeeded()
    // to tell the app to refresh the frame/position of card view
    let safeAreaHeight = UIApplication.shared.windows[0].safeAreaLayoutGuide.layoutFrame.size.height
    let bottomPadding = UIApplication.shared.windows[0].safeAreaInsets.bottom
      
      // move the card view to bottom of screen
      self.topConstraint[0].constant = safeAreaHeight + bottomPadding
    
    
    // move card down to bottom
    // create a new property animator
    let hideCard = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn, animations: {
      self.view.layoutIfNeeded()
    })
    
    // hide dimmer view
    // this will animate the dimmerView alpha together with the card move down animation
    hideCard.addAnimations {
      self.dimmerView.alpha = 0.0
    }
    
    // when the animation completes, (position == .end means the animation has ended)
    // dismiss this view controller (if there is a presenting view controller)
    hideCard.addCompletion({ position in
      if position == .end {
        if(self.presentingViewController != nil) {
          self.dismiss(animated: false, completion: nil)
        }
      }
    })
    
    // run the animation
    hideCard.startAnimation()
  }
  
  //MARK: Animations
  private func showCard(atState: CardViewState = .normal) {
     
    // ensure there's no pending layout changes before animation runs
    self.view.layoutIfNeeded()
    
    // set the new top constraint value for card view
    // card view won't move up just yet, we need to call layoutIfNeeded()
    // to tell the app to refresh the frame/position of card view
    let safeAreaHeight = UIApplication.shared.windows[0].safeAreaLayoutGuide.layoutFrame.size.height
    let bottomPadding = UIApplication.shared.windows[0].safeAreaInsets.bottom
      
      // when card state is normal, its top distance to safe area is
      // (safe area height + bottom inset) / 2.0
    //self.topConstraint[0].constant = (safeAreaHeight + bottomPadding) / 2.0
    
    if atState == .expanded {
      // if state is expanded, top constraint is 30pt away from safe area top
      self.topConstraint[0].constant = 30.0
    } else {
      self.topConstraint[0].constant = (safeAreaHeight + bottomPadding) / 2.0
    }
       
    cardPanStartingTopConstant = self.topConstraint[0].constant
    
    
    // move card up from bottom by telling the app to refresh the frame/position of view
    // create a new property animator
    let showCard = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn, animations: {
      self.view.layoutIfNeeded()
    })
    
    // show dimmer view
    // this will animate the dimmerView alpha together with the card move up animation
    showCard.addAnimations({
      self.dimmerView.alpha = 0.7
    })
    
    // run the animation
    showCard.startAnimation()
  }
  

  @objc func tap(_ tapRecognizer: UITapGestureRecognizer) {
    self.dismiss(animated: false, completion: nil)
  }
  

  @IBAction func viewPanned(_ panRecognizer: UIPanGestureRecognizer) {
    // how much has user dragged
    let translation = panRecognizer.translation(in: self.view)
    
    let velocity = panRecognizer.velocity(in: self.view)
    
    switch panRecognizer.state {
    case .began:
      cardPanStartingTopConstant = self.topConstraint[0].constant
    case .changed :
      if self.cardPanStartingTopConstant + translation.y > 30.0 {
        if cardPanStartingTopConstant >  self.cardPanStartingTopConstant + translation.y {
          return
        }
        self.topConstraint[0].constant = self.cardPanStartingTopConstant + translation.y
        
        
      }
      
      
      
      // change the dimmer view alpha based on how much user has dragged
     // dimmerView.alpha = dimAlphaWithCardTopConstraint(value: self.topConstraint[0].constant)
      
      
    case .ended :
      // if user drag down with a very fast speed (ie. swipe)
      if velocity.y > 1500.0 {
        // hide the card and dismiss current view controller
        hideCardAndGoBack()
        return
      }
      let safeAreaHeight = UIApplication.shared.windows[0].safeAreaLayoutGuide.layoutFrame.size.height
      let bottomPadding = UIApplication.shared.windows[0].safeAreaInsets.bottom //{
      
      if self.topConstraint[0].constant < (safeAreaHeight + bottomPadding) * 0.25 {
        // show the card at expanded state
        showCard(atState: .expanded)
      } else if self.topConstraint[0].constant < (safeAreaHeight) - 70 {
        // show the card at normal state
        showCard(atState: .normal)
      } else {
        // hide the card and dismiss current view controller
        hideCardAndGoBack()
      }
    //}
    default:
      break
    }
  }
  
  // ReactionViewController.swift

  private func dimAlphaWithCardTopConstraint(value: CGFloat) -> CGFloat {
    let fullDimAlpha : CGFloat = 0.7
    
    // ensure safe area height and safe area bottom padding is not nil
    guard let safeAreaHeight = UIApplication.shared.keyWindow?.safeAreaLayoutGuide.layoutFrame.size.height,
      let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom else {
      return fullDimAlpha
    }
    
    // when card view top constraint value is equal to this,
    // the dimmer view alpha is dimmest (0.7)
    let fullDimPosition = (safeAreaHeight + bottomPadding) / 2.0
    
    // when card view top constraint value is equal to this,
    // the dimmer view alpha is lightest (0.0)
    let noDimPosition = safeAreaHeight + bottomPadding
    
    // if card view top constraint is lesser than fullDimPosition
    // it is dimmest
    if value < fullDimPosition {
      return fullDimAlpha
    }
    
    // if card view top constraint is more than noDimPosition
    // it is dimmest
    if value > noDimPosition {
      return 0.0
    }
    
    // else return an alpha value in between 0.0 and 0.7 based on the top constraint value
    return fullDimAlpha * 1 - ((value - fullDimPosition) / fullDimPosition)
  }
}
