//
//  EventDetailsViewController.swift
//  PTAApp
//
//  Created by Jacob Rios on 9/28/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import UIKit

class EventDetailsViewController: UIViewController {
    var event: Event = Event()

    @IBAction func menuBtn(_ sender: Any) {
        NSLog("entering menu button")
        self.performSegue(withIdentifier: "unwindFromEventDetails", sender: self)
    }
    @IBOutlet weak var guestBtn: UIBarButtonItem!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var whenTxt: UILabel!
    @IBOutlet weak var whereTxt: UILabel!
    @IBOutlet weak var descTxt: UITextView!
    @IBAction func volunteerBtn(_ sender: Any) {
    }
    
    let gradientLayer = CAGradientLayer()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.blue, gradientLayer: gradientLayer)
        titleText.text = event.name
        whenTxt.text = event.date! + " " + event.time!
        whereTxt.text = event.location
        descTxt.text = event.description
        eventImage.image = #imageLiteral(resourceName: "EventExample")
    }

    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.layer.bounds
        view.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.blue, gradientLayer: gradientLayer)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
