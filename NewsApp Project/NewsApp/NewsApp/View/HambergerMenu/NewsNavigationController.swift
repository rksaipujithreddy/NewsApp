//
//  NewsNavigationController.swift
//  NewsApp
//
//  Created by Saipujith on 30/03/21.
//

import UIKit

class NewsNavigationController: NewsSideMenuNavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a table view controller
        let tableViewController = NewsHamburgurTableViewController()
        
        // Create side menu
        sideMenu = NewsSideMenu(sourceView: view, menuViewController: tableViewController, menuPosition:.left)
        
        // Set a delegate
        sideMenu?.delegate = self as NewsSideMenuDelegate
        
        // Configure side menu
        sideMenu?.menuWidth = 250.0
        
        // Show navigation bar above side menu
        view.bringSubviewToFront(navigationBar)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension NewsNavigationController: NewsSideMenuDelegate {
    
    
    func sideMenuWillOpen() {
        print("sideMenuWillOpen")
    }
    
    func sideMenuWillClose() {
        print("sideMenuWillClose")
    }
    
    func sideMenuDidClose() {
        print("sideMenuDidClose")
    }
    
    func sideMenuDidOpen() {
        print("sideMenuDidOpen")
    }
    
    func sideMenuShouldOpNewsSideMenu() -> Bool {
        return true
    }
}
