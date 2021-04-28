//
//  NewsSideMenuNavigationController.swift
//  NewsApp
//
//  Created by Saipujith on 30/03/21.
//

import UIKit

open class NewsSideMenuNavigationController: UINavigationController , NewsSideMenuProtocol {
    
    open var sideMenu : NewsSideMenu?
    open var sideMenuAnimationType : NewsSideMenuAnimation = .default


    // MARK: - Life cycle
    open override func viewDidLoad() {
        super.viewDidLoad()
    }

    public init( menuViewController: UIViewController, contentViewController: UIViewController?) {
        super.init(nibName: nil, bundle: nil)

        if (contentViewController != nil) {
            self.viewControllers = [contentViewController!]
        }

        sideMenu = NewsSideMenu(sourceView: self.view, menuViewController: menuViewController, menuPosition:.left)
        view.bringSubviewToFront(navigationBar)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation
    open func setContentViewController(_ contentViewController: UIViewController) {
        self.sideMenu?.toggleMenu()
        switch sideMenuAnimationType {
        case .none:
            self.viewControllers = [contentViewController]
            break
        default:
            contentViewController.navigationItem.hidesBackButton = true
            self.setViewControllers([contentViewController], animated: true)
            break
        }

    }

}


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
