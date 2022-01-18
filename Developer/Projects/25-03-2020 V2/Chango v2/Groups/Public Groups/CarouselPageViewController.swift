//
//  CarouselPageViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 07/10/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation
import UIKit


class CarouselPageViewController: UIPageViewController {

    fileprivate var items: [UIViewController] = []
    fileprivate var pc: UIPageControl!
    var campaignId: String = ""
    var campaignImages: [String] = []
    var index = 0
    var pending_index = 0
    var campaignImageArray: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = SwiftEventBus.onMainThread(self, name: "images", handler: { result in
            let event: imageEvent = result?.object as! imageEvent
            print("start chats segue")

            self.getImageUrls(event)
        })
        
        dataSource = self
        delegate = self
//        print("images: \(campaignImageArray)")


    }
    
    
    func getImageUrls(_ event: imageEvent){
        
        campaignImageArray = event.groupImages
        decoratePageControl()
        populateImages()
        if let firstViewController = items.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        pc.currentPage = index

    }
    
    var currentIndex:Int {
        get {
            let index = items.firstIndex(of: self.viewControllers!.first!)!
            print("index: \(index)")
            return index
        }
        
        set {
            guard newValue >= 0,
                newValue < items.count else {
                    return
            }
            
            let vc = items[newValue]
            let direction:UIPageViewController.NavigationDirection = newValue > currentIndex ? .forward : .reverse
            self.setViewControllers([vc], direction: direction, animated: true, completion: nil)
        }
    
    }


    fileprivate func populateImages() {
        var images: [String] = []
//        let images = ["pregnant", "dona", "report"]
        if campaignImageArray == [] {
            images = ["people"]
            print("empty")
        }else {
        images = campaignImageArray
        }
        print("camp: \(images)")

        for (index, t) in images.enumerated() {
            let url = URL(string: t)!
            
            let c = createCarouselItemController(with: url)
            items.append(c)
        }
    }


    fileprivate func createCarouselItemController(with imageType: URL) -> UIViewController {
        let c = UIViewController()
        let myImage = imageType
        c.view = CarouselItem(image: myImage)
        return c
    }
    
    
    override func viewDidLayoutSubviews() {
//            pc.subviews.forEach {
//            $0.transform = CGAffineTransform(scaleX: 2, y: 2)
//        }
    }
    
    fileprivate func decoratePageControl() {
        pc = UIPageControl.appearance(whenContainedInInstancesOf: [CarouselPageViewController.self])
        pc.currentPageIndicatorTintColor = UIColor.lightGray
//        let image = UIImage.outlinedEllipse(size: CGSize(width: 7.0, height: 7.0), color: UIColor.blue)
//        pc.pageIndicatorTintColor = UIColor.init(patternImage: image!)
        
        pc.borderColor = .black
    }
    
}


// MARK: - DataSource

extension CarouselPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = items.index(of: viewController) else {
            return nil
    }
    
    let previousIndex = viewControllerIndex - 1
    
    guard previousIndex >= 0 else {
    return items.last
    }
        
    guard items.count > previousIndex else {
            return nil
    }
    
    return items[previousIndex]
}

    func pageViewController(_: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = items.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        guard items.count != nextIndex else {
            return items.first
        }
        
        guard items.count > nextIndex else {
            return nil
        }
        
        return items[nextIndex]
    }
    
    func presentationCount(for _: UIPageViewController) -> Int {
        return items.count
    }
    
    func presentationIndex(for _: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = items.index(of: firstViewController) else {
                return 0
        }
        
        return firstViewControllerIndex
    }
}


extension CarouselPageViewController: UIPageViewControllerDelegate {
    
}
