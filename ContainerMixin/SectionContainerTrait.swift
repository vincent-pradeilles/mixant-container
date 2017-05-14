//
//  SectionContainerTrait.swift
//  ContainerMixin
//
//  Created by Vincent on 25/02/2017.
//  Copyright © 2017 Vincent Pradeilles. All rights reserved.
//

import UIKit
import RxSwift

protocol SectionContainerTrait: class {
    associatedtype T: RawRepresentable
    
    var containerSegmentedController: UISegmentedControl! { get }
    var containerView: UIView! { get }
    var sectionViewControllers: [UIViewController] { get }
    var currentSection: T? { get set }
    
    var disposeBag: DisposeBag { get }
}

extension SectionContainerTrait where Self: UIViewController, T.RawValue == Int {
    
    func hookUpSectionContainer() {
        containerSegmentedController
            .rx
            .selectedSegmentIndex
            .asDriver()
            .drive(onNext: { (newSelectedIndex) in
                if let newSection = T(rawValue: newSelectedIndex) {
                    self.transition(toSection: newSection)
                }
            })
            .addDisposableTo(disposeBag)
    }
    
    fileprivate func transition(toSection section: T) {
        if let newSectionViewController = sectionViewControllers[safe: section.rawValue] {
            
            let currentSectionViewController: UIViewController?
            if let currentSection = self.currentSection {
                currentSectionViewController = self.sectionViewControllers[safe: currentSection.rawValue]
            } else {
                currentSectionViewController = nil
            }
            
            currentSectionViewController?.willMove(toParentViewController: nil)
            addChildViewController(newSectionViewController)
            
            newSectionViewController.view.frame = self.containerView.bounds
            
            containerSegmentedController.isUserInteractionEnabled = false
            
            UIView.animate(withDuration: 0.25, delay: 0, options: [.transitionCrossDissolve], animations: {
                currentSectionViewController?.view.removeFromSuperview()
                self.containerView.addSubview(newSectionViewController.view)
            }, completion: { (_) in
                currentSectionViewController?.removeFromParentViewController()
                newSectionViewController.didMove(toParentViewController: self)
                
                self.currentSection = section
                self.containerSegmentedController.isUserInteractionEnabled = true
            })
        }
    }
    
}
