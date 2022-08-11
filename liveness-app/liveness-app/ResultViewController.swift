//
//  ResultViewController.swift
//  liveness-app
//
//  Created by Ahmad Nizar on 07/02/22.
//

import Foundation
import UIKit

class ResultViewController: UIViewController {
  @IBOutlet var BackHomeLabel: UILabel!
  @IBOutlet var ResultScore: UILabel!
  @IBOutlet var ResultMessage: UILabel!
  @IBOutlet var ResultStatus: UILabel!
  @IBOutlet var FrontalImage: UIImageView!
  
  // List result variable
  public var score: Double?
  public var isLive: Bool?
  public var images: [String]?
  public var errorMessage: String?
  public var errorDetail: [String : Any]?
  public var isError: Bool?
  
  override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      // Hide the Navigation Bar
      self.navigationController?.setNavigationBarHidden(true, animated: animated)
  }
  
  override func viewDidLoad() {
    //set backhome label
    self.setupBackLabelTap()
    
    // handling result
    if self.isError! {
      self.ResultStatus.text = "Verification Failed"
      self.ResultMessage.text = self.errorMessage ?? "Internal SDK Error"
      self.ResultScore.text = ""
    } else {
      self.ResultStatus.text = "Verification Success"
      self.FrontalImage.image = self.convertBase64StringToImage(base64String: self.images![0])
      self.ResultMessage.text = "We detect a certain live selfie with liveness score :"
      let currentScore = self.score! * 100
      let roundedScore = String(format: "%.2f", ceil(currentScore*100)/100)
      let currentTextScore = roundedScore+" %"
      self.ResultScore.text = currentTextScore
      
      //make image rounded
      self.FrontalImage.layer.borderWidth = 2.0
      self.FrontalImage.layer.cornerRadius = self.FrontalImage.frame.size.height / 2
      self.FrontalImage.layer.borderColor = UIColor.white.cgColor
      self.FrontalImage.contentMode = .scaleAspectFill
      self.FrontalImage.clipsToBounds = true
    }
    
    
  }
  
  func convertBase64StringToImage (base64String: String) -> UIImage {
    let pureBase64 = base64String.components(separatedBy: "base64,")[1]
    let imageData = Data(base64Encoded: pureBase64, options: .ignoreUnknownCharacters)!
    let image = UIImage(data: imageData)
    
    return image!
  }
  
  @objc func backLabelTapped(_ sender: UITapGestureRecognizer) {
    self.navigationController?.popToRootViewController(animated: true)
  }
  
  func setupBackLabelTap() {
    let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.backLabelTapped(_:)))
    self.BackHomeLabel.isUserInteractionEnabled = true
    self.BackHomeLabel.addGestureRecognizer(labelTap)
  }
}
