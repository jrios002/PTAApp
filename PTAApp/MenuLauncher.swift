//
//  MenuLauncher.swift
//  PTAApp
//
//  Created by Jacob Rios on 10/7/17.
//  Copyright © 2017 Jacob Rios. All rights reserved.
//

import UIKit

var cellId = "cellId"
var menuArray = [String]()
var menuShowing: Bool = false

class MenuLauncher: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    let blackView = UIView()
    let menuTableView = UITableView()
    
    func showMenu(menuList: [String]) {
        menuShowing = true
        if let window = UIApplication.shared.keyWindow {
            menuArray = menuList
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissMenu)))
            
            window.addSubview(blackView)
            window.addSubview(menuTableView)
            menuTableView.frame = CGRect(x: 0, y: 0, width: 0, height: window.frame.height)
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                
                self.menuTableView.frame = CGRect(x: 0, y: 16, width: 250, height: window.frame.height)
            }, completion: nil)
        }
    }
    
    func dismissMenu(){
        menuShowing = false
        UIView.animate(withDuration: 0.5, animations: {
            NSLog("exiting menu button")
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.menuTableView.frame = CGRect(x: 0, y: 0, width: 0, height: window.frame.height)
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: cellId)
        cell.textLabel?.text = menuArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if menuArray[indexPath.row] != "Log Out" {
            dismissMenu()
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: menuArray[indexPath.row])
            UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
        }
        else {
            let firebaseMgr: FirebaseMgr = FirebaseMgr()
            firebaseMgr.signOutFirebase()
            let activityInd: CustomActivityIndicator = CustomActivityIndicator()
            activityInd.customActivityIndicatory(blackView, startAnimate: true).startAnimating()
            
            UIApplication.shared.beginIgnoringInteractionEvents()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                let message = firebaseMgr.getMessage()
                self.dismissMenu()
                if message == "SUCCESS" {
                    UIApplication.shared.endIgnoringInteractionEvents()
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "Home")
                    UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
                }
                else{
                    UIApplication.shared.endIgnoringInteractionEvents()
                    print("Error: \(message)")
                }
            }
        }
    }
    
    override init(){
        super.init()
        self.menuTableView.dataSource = self
        self.menuTableView.delegate = self
        
        
        menuTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
}
