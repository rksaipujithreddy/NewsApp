//
//  NewsDetailsViewController.swift
//  NewsApp
//
//  Created by Saipujith on 29/03/21.
//

import UIKit

class NewsDetailsViewController: UIViewController {

    @IBOutlet weak var buttonDismiss: UIButton!
    
    @IBOutlet weak var imageDetail: UIImageView!

    @IBOutlet weak var textNewsDetails: UITextView!
    
    @IBOutlet weak var labelHeadline: UILabel!
    
    @IBOutlet weak var buttonBookmark: UIButton!

    @IBOutlet weak var labelDetailsData: UILabel!
    
    @IBOutlet weak var buttonBack: UIButton!
    var listItem : NewsListItem?
        
    var category : String = ""
    
    var animationProgress: CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let newsItem = listItem,let url = URL(string:newsItem.imageURL) {
            textNewsDetails.text = newsItem.description
            isNetworkAvailable()
            DispatchQueue.global(qos: .userInteractive).async {
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data, error == nil else { return }
                    
                    DispatchQueue.main.async { [self] in /// execute on main thread
                        imageDetail.image = UIImage(data: data)
                    }
                }
                task.resume()
            }
        }
        // Create a gesture recognizer and add to a UIView
        let recognizer = InstantPanGestureRecognizer(target: self, action: #selector(panRecognizer))
        buttonDismiss.addGestureRecognizer(recognizer)
        buttonBack.addGestureRecognizer(recognizer)
        setUpUI()
    }
    
    func setUpUI(){
        
        guard let articleItem = listItem else {
            buttonBookmark.setImage(UIImage.init(systemName:"bookmark"), for: .normal)
            return
        }
        labelHeadline.text = category
        
        labelDetailsData.text = getDate(date: articleItem.date) + " | " + "By " + articleItem.author
        
        if DBManager.sharedInstance.isArticleExists(newsListItem: articleItem){
            buttonBookmark.setImage(UIImage.init(systemName:"bookmark.fill"), for: .normal)
        }else{
            buttonBookmark.setImage(UIImage.init(systemName:"bookmark"), for: .normal)
        }
    }    
    
    @IBAction func tapBookmarkAction(_ sender: Any) {
        
        guard let articleItem = listItem else {
            return
            
        }
        DBManager.sharedInstance.insert(article: articleItem)
        setUpUI()
    }
    
    // Recognizer state
    @objc func panRecognizer(recognizer: UIPanGestureRecognizer){
        let translation = recognizer.translation(in: buttonDismiss)
        switch recognizer.state{
        case .began:
            shrinkAnimation()
            animationProgress = animator.fractionComplete
            // Pause after Start enable User to interact with the animation
            animator.pauseAnimation()
        case .changed:
            // translation.y = the distance finger drag on screen
            let fraction = translation.y / 100
            // fractionComplete the percentage of animation progress
            animator.fractionComplete = fraction + animationProgress
            // when animation progress > 99%, stop and start the dismiss transition
            if animator.fractionComplete > 0.99{
                animator.stopAnimation(true)
                dismiss(animated: true, completion: nil)
            }
        case .ended:
            // when tap  on the screen animator.fractionComplete = 0
            if animator.fractionComplete == 0{
                animator.stopAnimation(true)
                dismiss(animated: true, completion: nil)
            }
            // when animator.fractionComplete < 99 % and release finger, automative rebounce to the initial state
            else{
                // rebounce effect
                animator.isReversed = true
                animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            }
        default:
            break
        }
    }
    
    // The main animation
    var animator = UIViewPropertyAnimator()
    func shrinkAnimation(){
        animator = UIViewPropertyAnimator(duration: 1.0, curve: .easeOut, animations: {
            self.view.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
            self.view.layer.cornerRadius = 15
        })
        animator.startAnimation()
    }
}

// Achieve drag and start animation simultaneously
class InstantPanGestureRecognizer: UIPanGestureRecognizer {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if (self.state == UIGestureRecognizer.State.began) { return }
        super.touchesBegan(touches, with: event)
        self.state = UIGestureRecognizer.State.began
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


