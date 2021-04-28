//
//  NewsViewController.swift
//  NewsApp
//
//  Created by Saipujith on 28/03/21.
//

import UIKit

class NewsViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIViewControllerTransitioningDelegate,UISearchBarDelegate {
    
    fileprivate let viewModel = NewsListViewModel()
    
    var filteredNewsItems: [NewsListItem] = []
    
    let manager = NewsManager()
    
    let transition = NewsTransitionClone()
    
    var param = NewsQuery(category: "", country: "in", page: "", id: "a285e2e271aa41868ca1daf7f8233717", count: "30")
    
    var pageIndex: Int = 0
    var categoryStr: String!
    
    var collectionIndex: IndexPath?
    
    var imageFrame = CGRect.zero


    var isSearchBarEmpty: Bool {
      return searchBarView.text?.isEmpty ?? true
    }
    
    var searchActive : Bool = false
    
    @IBOutlet weak var searchBarView: UISearchBar!
    
    @IBOutlet weak var newsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
    }
    
    private func setUpData(){
        
        param =  NewsQuery(category: categoryStr, country: "in", page: "", id: "a285e2e271aa41868ca1daf7f8233717", count: "30")
        newsCollectionView?.dataSource = self
        newsCollectionView?.delegate   = self
        searchBarView.delegate         = self
        isNetworkAvailable()
        manager.request(query: param){  (results) in
            self.viewModel.data(results: results?.articles ?? [])
            DispatchQueue.main.async {
                self.newsCollectionView.reloadData()
            }
        }
        searchBarView.placeholder = "Search news articles"
    }
    
    // MARK: Search Bar Delegates
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredNewsItems = self.viewModel.items.filter { (newsItem: NewsListItem) -> Bool in
            return  newsItem.headLine.contains(searchText)
        }
        if(searchText.count == 0){
            searchActive = false
        } else {
            searchActive = true
        }
        newsCollectionView.reloadData()
    }
    
    
    // MARK: CollectionView Delegates
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        
        print("didHighlight")
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.3) {
            cell?.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.3) {
            cell?.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionIndex = indexPath
        print("didSelect")
        
        if let cell = collectionView.cellForItem(at: indexPath) as? NewsCollectionViewCell {
            let a = collectionView.convert(cell.frame, to: collectionView.superview)
            
            transition.startingFrame = CGRect(x: a.minX+15, y: a.minY+150, width: 375 / 414 * view.frame.width - 30, height: 408 / 736 * view.frame.height - 30)
            
            let sb = storyboard?.instantiateViewController(withIdentifier: "detail") as! NewsDetailsViewController
           
            var item = self.viewModel.items[indexPath.row]
            if(searchActive) {
                item = filteredNewsItems[indexPath.row]
            }
            sb.listItem    = item
            sb.category    = categoryStr
            sb.transitioningDelegate = self
            sb.modalPresentationStyle = .custom
            self.present(sb, animated: true, completion: nil)
        }
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        
        return transition
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}

extension NewsViewController : UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return  1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if(searchActive) {
            return filteredNewsItems.count
        }
        else if self.viewModel.items.count > 0{
            return self.viewModel.items.count
        }
        else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCollectionViewCell.identifier, for: indexPath) as? NewsCollectionViewCell {
            if(searchActive && filteredNewsItems.count > indexPath.row ) {
                let item =  filteredNewsItems[indexPath.row]
                cell.configure(with:item.imageURL, labelName: item.headLine)
            }
            else if viewModel.items.count > 0{
                let item =  viewModel.items[indexPath.row]
                cell.configure(with:item.imageURL, labelName: item.headLine)
            }
            transition.destinationFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: cell.imageNews.frame.height * view.frame.width / cell.imageNews.frame.width)
            imageFrame = cell.imageNews.frame
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("collectionViewLayout")
        return CGSize(width: 375 / 414 * view.frame.width, height: 408 / 736 * view.frame.height)
    }
    
}

extension UIViewController{
    
    func isNetworkAvailable() {
        //To check network connectivity
        if Reachability.isConnectedToNetwork() {
            print("Internet Connection Available!")
        } else {
            self.showAlert("Error","Internet Not Available", "Dismiss")
        }
    }

    func showAlert(_ title: String, _ message: String, _ buttonTitle: String) {
        let alert = UIAlertController(title: "Alert",
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Dismiss",
                                      style: UIAlertAction.Style.default,
                                      handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getDate(date:String)->String{
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = formatter.date(from:date) {
            formatter.dateFormat = "MM-dd-yyyy HH:mm"
            return formatter.string(from: date)
        }
        return ""
    }
}
