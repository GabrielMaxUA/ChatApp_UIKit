//
//  UploadViewController.swift
//  ChatApp
//
//  Created by Max Gabriel on 2026-01-07.
//

import UIKit

class UploadViewController: UIViewController {

  @IBOutlet weak var uploadLabel: UILabel!
  @IBOutlet weak var progressView: UIProgressView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      //making blurred background
      view.backgroundColor = .white.withAlphaComponent(0)//important
      let blurEffect = UIBlurEffect(style: .dark)//setting const
      let visualEffectView = UIVisualEffectView(effect: blurEffect)//setting visualleffectView
      visualEffectView.frame = view.bounds//making sure that frame is entire screen
      view.addSubview(visualEffectView)//adding visualeffectView to mainView of the storyboard
      view.sendSubviewToBack(visualEffectView)//making sure the blur effect view is on the firsl layer of the view (at the back so the rest of the content placed over it
      uploadLabel.textColor = .white
      uploadLabel.font = Font.formLabel
      progressView.tintColor = .white //or progressView.progressTintColor = .white
      progressView.trackTintColor = .white.withAlphaComponent(0.5)
    }
    


}
