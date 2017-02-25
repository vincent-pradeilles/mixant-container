//
//  ViewController.swift
//  ContainerMixin
//
//  Created by Vincent on 25/02/2017.
//  Copyright © 2017 Vincent Pradeilles. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum Section: Int {
    case a
    case b
    case c
    case d
}

class ViewController: UIViewController {

    @IBOutlet weak var containerSegmentedController: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    var sectionViewControllers: [UIViewController] = []
    weak var currentSectionViewController: UIViewController?
    
    lazy var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bindUI()
        self.createSectionViewControllers()
        self.transition(toSection: .a)
    }
    
    func bindUI () {
        containerSegmentedController
            .rx
            .selectedSegmentIndex
            .asDriver()
            .drive(onNext: { (newSelectedIndex) in
                if let newSection = Section(rawValue: newSelectedIndex) {
                    self.transition(toSection: newSection)
                }
            })
            .addDisposableTo(disposeBag)
    }
    
    func createSectionViewControllers() {
        let redVC = UIViewController()
        redVC.view.backgroundColor = .red
        
        let blueVC = UIViewController()
        blueVC.view.backgroundColor = .blue
        
        let greenVC = UIViewController()
        greenVC.view.backgroundColor = .green
        
        let purpleVC = UIViewController()
        purpleVC.view.backgroundColor = .purple
        
        sectionViewControllers = [redVC, blueVC, greenVC, purpleVC]
    }
    
    func transition(toSection section: Section) {
        if let newSectionViewController = sectionViewControllers[safe: section.rawValue] {
            currentSectionViewController?.willMove(toParentViewController: nil)
            addChildViewController(newSectionViewController)
            
            newSectionViewController.view.frame = self.containerView.bounds
            
            containerSegmentedController.isUserInteractionEnabled = false
            
            UIView.animate(withDuration: 0.25, delay: 0, options: [.transitionCrossDissolve], animations: { 
                self.currentSectionViewController?.view.removeFromSuperview()
                self.containerView.addSubview(newSectionViewController.view)
            }, completion: { (_) in
                self.currentSectionViewController?.removeFromParentViewController()
                newSectionViewController.didMove(toParentViewController: self)
                
                self.currentSectionViewController = newSectionViewController
                self.containerSegmentedController.isUserInteractionEnabled = true
            })
        }
    }
}
