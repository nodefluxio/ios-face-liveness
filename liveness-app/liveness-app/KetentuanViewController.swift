//
//  KetentuanViewController.swift
//  liveness-app
//
//  Created by Ahmad Nizar on 27/01/22.
//

import UIKit

protocol KetentuanViewControllerDelegate: AnyObject {
  func didClickVerifyButton(controller: KetentuanViewController)
}

class KetentuanViewController: UIViewController {
  
  public var delegate: KetentuanViewControllerDelegate! = nil
  
  //List component
  @IBOutlet var VerifyButton: UIButton!
  @IBOutlet var ThirdInstructionLabel: UILabel!
  @IBOutlet var SecondInstructionLabel: UILabel!
  @IBOutlet var FirstInstructionLabel: UILabel!
  @IBOutlet var FirstLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
    
    FirstLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(700))
    
    FirstInstructionLabel.text = "\u{2022} Position your face in  available face area"
    SecondInstructionLabel.text = "\u{2022} Make sure you have a good lightning"
    ThirdInstructionLabel.text = "\u{2022} Make Hold your phone at eye level and look straight to the camera, then follow the instruction"
    
    // Add corner radius to verify button
    VerifyButton.layer.cornerRadius = 15
//    VerifyButton.clipsToBounds = true
  }
  
  @IBAction func VerifyButtonAction(_ sender: Any) {
    self.navigationController?.popToRootViewController(animated: true)
    self.delegate?.didClickVerifyButton(controller: self)
  }
}
