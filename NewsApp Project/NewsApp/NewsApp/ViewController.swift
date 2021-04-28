//
//  ViewController.swift
//  NewsApp
//
//  Created by Saipujith on 28/03/21.
//

import UIKit

class ViewController: UIViewController ,NewsSideMenuDelegate{
    
    
    func sideMenuShouldOpNewsSideMenu() -> Bool {
        return true
    }
    
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

    @IBOutlet weak var menuTabView: MenuTabsView!
    
    var gesture : UITapGestureRecognizer?
    var currentIndex: Int = 0
    var tabs : [String] = []
    var pageController: UIPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sideMenuController()?.sideMenu?.delegate = self
        if let string = Bundle.main.path(forResource: "CategoryList", ofType: "plist"),let dict = NSDictionary(contentsOfFile: string) as? [String : String]
           {
               let lazyMapCollection = dict.keys
               tabs  = Array(lazyMapCollection)
               tabs.sort()
           }
        
        menuTabView.dataArray = tabs
        menuTabView.isSizeToFitCellsNeeded = true
        menuTabView.collView.backgroundColor = UIColor.init(white: 1, alpha: 0.97)
        
        presentPageVCOnView()
        
        menuTabView.menuDelegate = self
        pageController.delegate = self
        pageController.dataSource = self
        //For Intial Display
        menuTabView.collView.selectItem(at: IndexPath.init(item: 0, section: 0), animated: true, scrollPosition: .centeredVertically)
        pageController.setViewControllers([viewController(At: 0)!], direction: .forward, animated: true, completion: nil)
        gesture = UITapGestureRecognizer(target: self, action: #selector(toggleSideMenu))

    }
    
    @objc func toggleSideMenu() {
        
        if let sideMenuView = sideMenuController(),let menu = sideMenuView.sideMenu{
            
            if menu.isMenuOpen {
                toggleSideMenuView()
                self.view.removeGestureRecognizer(gesture!)
            } else {
                self.view.addGestureRecognizer(gesture!)
            }
        }
    }

    @IBAction func buttonToggle(_ sender: Any) {
        
        toggleSideMenuView()
        if let sideMenuView = sideMenuController(),let menu = sideMenuView.sideMenu{
            if menu.isMenuOpen {
                self.view.addGestureRecognizer(gesture!)
            }else {
                self.view.addGestureRecognizer(gesture!)
            }
        }
    }
    
    func presentPageVCOnView() {
        
        self.pageController = storyboard?.instantiateViewController(withIdentifier: "NewsPageViewController") as! NewsPageViewController
        self.pageController.view.frame = CGRect.init(x: 0, y: menuTabView.frame.maxY, width: self.view.frame.width, height: self.view.frame.height - menuTabView.frame.maxY)
        self.addChild(self.pageController)
        self.view.addSubview(self.pageController.view)
        self.pageController.didMove(toParent: self)
    }
    
    //Present ViewController At The Given Index
    
    func viewController(At index: Int) -> UIViewController? {
        
        if((self.menuTabView.dataArray.count == 0) || (index >= self.menuTabView.dataArray.count)) {
            return nil
        }
        
        let contentVC = storyboard?.instantiateViewController(withIdentifier: "NewsViewController") as! NewsViewController
        contentVC.categoryStr = tabs[index]
        contentVC.pageIndex = index
        currentIndex = index
        return contentVC
        
    }
    
}

extension ViewController: MenuBarDelegate {
    
    func menuBarDidSelectItemAt(menu: MenuTabsView, index: Int) {
        
        // If selected Index is other than Selected one, by comparing with current index, page controller goes either forward or backward.
        
        if index != currentIndex {
            
            if index > currentIndex {
                self.pageController.setViewControllers([viewController(At: index)!], direction: .forward, animated: true, completion: nil)
            }else {
                self.pageController.setViewControllers([viewController(At: index)!], direction: .reverse, animated: true, completion: nil)
            }
            
            menuTabView.collView.scrollToItem(at: IndexPath.init(item: index, section: 0), at: .centeredHorizontally, animated: true)
            
        }
        
    }
    
}


extension ViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! NewsViewController).pageIndex
        
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index -= 1
        return self.viewController(At: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! NewsViewController).pageIndex
        
        if (index == tabs.count) || (index == NSNotFound) {
            return nil
        }
        
        index += 1
        return self.viewController(At: index)
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if finished {
            if completed {
                let cvc = pageViewController.viewControllers!.first as! NewsViewController
                let newIndex = cvc.pageIndex
                menuTabView.collView.selectItem(at: IndexPath.init(item: newIndex, section: 0), animated: true, scrollPosition: .centeredVertically)
                menuTabView.collView.scrollToItem(at: IndexPath.init(item: newIndex, section: 0), at: .centeredHorizontally, animated: true)
            }
        }
        
    }
    
}

