//
//  SocialMediaShareViewController.swift
//  PTAApp
//
//  Created by Jacob Rios on 11/25/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import UIKit
import Social

class SocialMediaShareViewController: UIViewController {
    
    @IBOutlet weak var textToShare: UITextView!
    
    @IBAction func shareOnFacebook(_ sender: Any) {
        NSLog("entering shareOnFacebook")
        
        let shareOnFacebook: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        shareOnFacebook.setInitialText(textToShare.text)
        self.present(shareOnFacebook, animated: true, completion: nil)
        
        shareOnFacebook.completionHandler = { (result: SLComposeViewControllerResult) in
            switch result {
            case SLComposeViewControllerResult.cancelled:
                break
                
            case SLComposeViewControllerResult.done:
                let activityInd: CustomActivityIndicator = CustomActivityIndicator()
                activityInd.customActivityIndicatory(self.view, startAnimate: true).startAnimating()
                
                UIApplication.shared.beginIgnoringInteractionEvents()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    UIApplication.shared.endIgnoringInteractionEvents()
                    activityInd.customActivityIndicatory(self.view, startAnimate: false).stopAnimating()
                    let postAlert = UIAlertController(title: "SUCCESS!!", message: "Message Posted to Facebook!!", preferredStyle: UIAlertControllerStyle.alert)
                    
                    postAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                        print("Exiting from alert")
                    }))
                    
                    self.present(postAlert, animated: true, completion: nil)
                }
                
                break
            }
            
        }
        
        NSLog("exiting shareOnFacebook")
    }
    
    @IBAction func shareOnTwitter(_ sender: Any) {
        NSLog("entering shareOnTwitter")
        
        let shareOnTwitter: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        shareOnTwitter.setInitialText(textToShare.text)
        self.present(shareOnTwitter, animated: true, completion: nil)
        
        shareOnTwitter.completionHandler = { (result: SLComposeViewControllerResult) in
            switch result {
            case SLComposeViewControllerResult.cancelled:
                break
                
            case SLComposeViewControllerResult.done:
                let activityInd: CustomActivityIndicator = CustomActivityIndicator()
                activityInd.customActivityIndicatory(self.view, startAnimate: true).startAnimating()
                
                UIApplication.shared.beginIgnoringInteractionEvents()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    UIApplication.shared.endIgnoringInteractionEvents()
                    activityInd.customActivityIndicatory(self.view, startAnimate: false).stopAnimating()
                    let postAlert = UIAlertController(title: "SUCCESS!!", message: "Message Posted to Twitter!!", preferredStyle: UIAlertControllerStyle.alert)
                    
                    postAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                        print("Exiting from alert")
                    }))
                    
                    self.present(postAlert, animated: true, completion: nil)
                }
                
                break
            }
            
        }
        
        NSLog("exiting shareOnTwitter")
    }
    
    let gradientLayer = CAGradientLayer()
    
    override func viewWillAppear(_ animated: Bool) {
        view.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.blue, gradientLayer: gradientLayer)
        textToShare.text = ""
        textToShare.placeholder = "Type social media message here..."
    }
    
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.layer.bounds
        view.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.blue, gradientLayer: gradientLayer)
    }
}
