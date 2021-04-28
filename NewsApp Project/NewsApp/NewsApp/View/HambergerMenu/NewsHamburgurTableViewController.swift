//
//  NewsHamburgurTableViewController.swift
//  NewsApp
//
//  Created by Saipujith on 30/03/21.
//

import UIKit

class NewsHamburgurTableViewController: UITableViewController {

    
    var weatherViewModel :WeatherViewModel?
    
    private let menuOptionCellId = "Cell"
    var selectedMenuItem : Int = 0
    let menuItems = [("Home"),("Clear")]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize apperance of table view
        tableView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.white
        tableView.scrollsToTop = false
        
        // Preserve selection between presentations
        clearsSelectionOnViewWillAppear = false
        
        // Preselect a menu option
        tableView.selectRow(at: IndexPath(row: selectedMenuItem, section: 0), animated: false, scrollPosition: .middle)
    
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 200
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
     
        
        let view = WeatherView.instanceFromNib()
        view.frame = CGRect.init(x: 5, y: 0, width: headerView.frame.width-10, height: headerView.frame.height)
        
        let manager = WeatherManager()
        
        if Reachability.isConnectedToNetwork() {
            manager.pullJSONData(nil, completionHandler:{ [weak self] (result, object, error)  in
                
                if let weatherItem = object, let temp = weatherItem.temp,let min = weatherItem.temp_min,let max = weatherItem.temp_max{
                    DispatchQueue.main.async {
                        view.labelWeather.text = self!.getCelciusFromFahreign(fahrein: temp)
                        view.labelMin.text = "Min : " + self!.getCelciusFromFahreign(fahrein: min)
                        view.labelMax.text = "Max : " + self!.getCelciusFromFahreign(fahrein: max)
                        view.labelLocation.text = "Bengaluru"
                        view.labelDate.text  = Date().string(format: "E, MMM d, yyyy")// self!.getCelciusFromFahreign(fahrein: temp)
                    }
                }
            })
        }else{
            view.labelLocation.text = "Internet not available"
        }
        
        headerView.addSubview(view)
        
        return headerView
    }
    
    func getCelciusFromFahreign(fahrein: Double) -> String {
        
        let celcius  = String(format: "%.1f", (fahrein - 32.0) * 5.0 / 9.0)
        return "\(celcius)º"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: menuOptionCellId)
        
        if (cell == nil) {
            cell = UITableViewCell(style:.default, reuseIdentifier: menuOptionCellId)
            cell!.backgroundColor = .clear
            cell!.textLabel?.textColor = .black
             cell!.textLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
            let selectedBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: cell!.frame.size.width, height: cell!.frame.size.height))
            selectedBackgroundView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
            cell!.selectedBackgroundView = selectedBackgroundView
        }
        
        cell!.textLabel?.text = menuItems[indexPath.row]
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("did select row: \(indexPath.row)")
        
        if (indexPath.row == selectedMenuItem) {
            sideMenuController()?.sideMenu?.hideSideMenu()
            return
        }
        
         selectedMenuItem = indexPath.row
                    
        //Present new view controller
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        var destViewController : UIViewController
        switch (indexPath.row) {
        case 0:
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "ViewController")
            break
        case 1:
            DBManager.sharedInstance.deleteAllData()
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "ViewController")
            break
        default:
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "ViewController")
            break
        }
        sideMenuController()?.setContentViewController(destViewController)

    }
}
