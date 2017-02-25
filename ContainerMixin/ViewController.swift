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
    case red
    case blue
    case green
    case purple
}

class ViewController: UIViewController, SectionContainer {

    @IBOutlet weak var containerSegmentedController: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    var sectionViewControllers: [UIViewController] = []
    var currentSection: Section?
    
    lazy var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createSectionViewControllers()
        self.hookUpSectionContainer()
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
}
