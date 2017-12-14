//
//  SchoolCreateVerifyViewController.swift
//  PTAApp
//
//  Created by Jacob Rios on 9/19/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import UIKit

class SchoolCreateVerifyViewController: UIViewController {
    
    var codeText: String!

    @IBOutlet weak var accessCodeText: UILabel!
    @IBAction func backBtn(_ sender: Any) {
        NSLog("entering back button")
        self.performSegue(withIdentifier: "unwindFromSchoolCreateVerify", sender: self)
    }
    
    @IBAction func doneBtn(_ sender: Any) {
    }
    
    @IBAction func okBtn(_ sender: UIButton) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "Select School")
        self.present(vc, animated: true, completion: nil)
    }
    
    let gradientLayer = CAGradientLayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.blue, gradientLayer: gradientLayer)
        
        accessCodeText.text = codeText
        let activityInd: CustomActivityIndicator = CustomActivityIndicator()
        activityInd.customActivityIndicatory(self.view, startAnimate: true).startAnimating()
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIApplication.shared.endIgnoringInteractionEvents()
            activityInd.customActivityIndicatory(self.view, startAnimate: false).stopAnimating()
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.layer.bounds
        view.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.blue, gradientLayer: gradientLayer)
    }

}
