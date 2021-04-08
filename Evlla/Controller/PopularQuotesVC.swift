//
//  PopularQuotesVC.swift
//  Evlla
//
//  Created by Dambar Bista on 4/8/20.
//  Copyright © 2020 Dambar Bista. All rights reserved.
//

import UIKit
import CoreData

class PopularQuotesVC: UIViewController {
    
    // MARK:- IBOutlets and Properties
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var quotesLabel: UILabel!
    @IBOutlet weak var folderButton: UIButton!
    
    var userLikeQuotes = false
    var currentQuotesIndex = Int.random(in: 0..<500)
    var icon = IconData()
    
    // MARK:- ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.sendMotivationQuotes(with: updatePopularQuotes())
        configurePageVC()

        CoreDataModel.fetchQuotes()
    }
    
    
    // update the PopularQuotesData.getFamousQuotes(from: currentQuotesIndex) to make it  tidy and shorter
    
    func updatePopularQuotes() -> String {
        let popularQuotes = PopularQuotesModel.getPopularQuotes(from: currentQuotesIndex)
        return popularQuotes
    }
    
    
    @IBAction func favoriteFolderPressed(_ sender: UIButton) {
        
        CoreDataModel.fetchQuotes()
    }
    
    
    // MARK:- Share Pressed
    
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        
        ShareModel.share(updatePopularQuotes(), viewController: self, sourceView: sender)
    }
    
    
    // MARK:- Favorite Pressed Button
    
    @IBAction func favoritePressed(_ sender: UIButton) {
        
        userLikeQuotes = !userLikeQuotes
        
        if userLikeQuotes == true {
            CoreDataModel.saveQuotes(with: updatePopularQuotes())
            IconData.setHeartFillIcon(on: favoriteButton)
            
        } else {
            CoreDataModel.removeQuotes()
            IconData.setHeartIcon(on: favoriteButton)
        }
    }
    
    
    func configurePageVC() {
        
        guard  let pageVC = storyboard?.instantiateViewController(withIdentifier: String(describing: RandomPageVC.self)) as? RandomPageVC else { return }
        
        pageVC.delegate     = self
        pageVC.dataSource   = self
        addChild(pageVC)
        pageVC.didMove(toParent: self)
        contentView.addSubview(pageVC.view)
        
        guard let startingVC = displayPopularQuotes(by: currentQuotesIndex) else { return }
        pageVC.setViewControllers([startingVC], direction: .forward, animated: true, completion: nil)
    }
    
    
    // this method will run the qotes on popular Quotes when scroll
    func displayPopularQuotes(by currentPageIndex: Int) -> UIViewController? {
        
        let textViewController  = TextViewController(pageIndex: currentPageIndex, pageText: updatePopularQuotes())
        quotesLabel.text        = textViewController.pageText
        
        return textViewController
    }
}


// MARK:- PageVC DataSource and Delegate

extension PopularQuotesVC: UIPageViewControllerDelegate,UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if currentQuotesIndex == 0 { return nil }
        currentQuotesIndex -= 1
        IconData.setHeartIcon(on: favoriteButton)
        IconData.showHeartFillIcon(on: favoriteButton, quotes: updatePopularQuotes())
        
        userLikeQuotes = false
        return displayPopularQuotes(by: currentQuotesIndex)
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if currentQuotesIndex >= PopularQuotesModel.quotesList.count { return nil }
        currentQuotesIndex += 1
        userLikeQuotes = false
        IconData.setHeartIcon(on: favoriteButton)
        IconData.showHeartFillIcon(on: favoriteButton, quotes: updatePopularQuotes())
        
        return displayPopularQuotes(by: currentQuotesIndex)
    }
    
}
