//
//  ViewController.swift
//  liveness-app
//
//  Created by Ahmad Nizar on 13/10/21.
//

import UIKit
import AVFoundation
import LivenessSDK

class ViewController: UIViewController {
  @IBOutlet var StartButton: UIButton!
  @IBSegueAction func KetentuanSegue(_ coder: NSCoder) -> KetentuanViewController? {
    let ketentuanController = KetentuanViewController(coder: coder)
    ketentuanController?.delegate = self
    return ketentuanController
  }
  @IBOutlet var ScoreLabel: UILabel!
  
  var SDKController: SDKViewController?
  
  private lazy var sdkOptions: SDKOption = {
    let options = SDKOption()
    
    //
    
    //Please input your access key in here
    options.setAccessKey(accessKey: "")
    
    //Please input your secret key in here
    options.setSecretKey(secretKey: "")
    options.setActiveLivenessFlag(activeLivenessFlag: true)
    options.setThreshold(threshold: 0.7)
    options.setGestureToleranceThreshold(gestureToleranceThreshold: 3000)
    options.setTimeoutThreshold(timeoutThreshold: 15000)
    
    return options
  }()
  
  func onVerifyButtonClickedAction() {
    SDKController = SDKViewController(sdkOptions: sdkOptions)
    SDKController?.delegate = self
    SDKController?.view.backgroundColor = .gray
    self.present(SDKController!, animated: true)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ketentuanSegue" {
      let ketentuanController = KetentuanViewController()
      ketentuanController.delegate = self
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // self.ScoreLabel.text = "Lets test our SDK"
    // Do any additional setup after loading the view.
    StartButton.layer.cornerRadius = 15
  }
  
  override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      // Hide the Navigation Bar
      self.navigationController?.setNavigationBarHidden(true, animated: animated)
  }

  override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      // Show the Navigation Bar
      self.navigationController?.setNavigationBarHidden(false, animated: animated)
  }
  
  func setMediaApproval() {
    AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
      if response{
        //success request camera usage
        print("Log message: success granted camera permission")
      } else {
       //failed request camera usage
        print("Log message: failing request camera usage")
      }
    }
  }
}

extension ViewController: SDKViewControllerDelegate {
  func onSuccess(score: Double, isLive: Bool, images: [String]) {
    DispatchQueue.main.async {
      let ResultController = self.storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
      ResultController.score = score
      ResultController.isLive = isLive
      ResultController.images = images
      ResultController.isError = false
      self.navigationController?.pushViewController(ResultController, animated: true)
    }
  }
  
  func onSuccessWithSubmissionToken(jobID: String, images: [String]) {
    if jobID.count > 0 {
      DispatchQueue.main.async {
        self.ScoreLabel.text = "Current Job ID is = \(jobID)"
      }
    } else {
      DispatchQueue.main.async {
        self.ScoreLabel.text = "Failing on submit job"
      }
    }
  }
  
  func onError(message: String, errors: [String : Any]) {
    DispatchQueue.main.async {
      let ResultController = self.storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
      ResultController.isError = true
      ResultController.errorMessage = message
      ResultController.errorDetail = errors
      
      self.navigationController?.pushViewController(ResultController, animated: true)
    }
  }
}

extension ViewController: KetentuanViewControllerDelegate {
  func didClickVerifyButton(controller: KetentuanViewController) {
    controller.navigationController?.popToRootViewController(animated: true)
    self.onVerifyButtonClickedAction()
  }
}
