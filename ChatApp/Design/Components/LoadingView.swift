//
//  LoadingView.swift
//  ChatApp
//
//  Created by Max Gabriel on 2026-01-01.
//

import UIKit

class LoadingView: UIView {

  @IBOutlet var containerView: UIView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.frame = frame
    initSubviews()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    initSubviews()
  }
  
  func initSubviews() {
    let nib = UINib(nibName: String(describing: type(of: self)), bundle: Bundle(for: type(of: self))) //initializing the nib view (simple also could be written with the name of the view "LoadingView
    nib.instantiate(withOwner: self)
    containerView.frame = bounds //making sure the frame is set to the bounds of the entire loadingView
    containerView.backgroundColor = .black.withAlphaComponent(0.5)
    addSubview(containerView)
  }
  
}
