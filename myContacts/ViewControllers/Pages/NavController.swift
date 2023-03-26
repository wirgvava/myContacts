//
//  NavController.swift
//  myContacts
//
//  Created by konstantine on 05.03.23.
//

import UIKit

class NavController: UINavigationController, UINavigationControllerDelegate {
    
    let rootVC = UINavigationController()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.rootVC.delegate = self
        
    }
    
    func setNavigation(){
        let navigation = UINavigationController(rootViewController: rootVC)
        rootVC.title = "Ragaca"
        rootVC.navigationBar.prefersLargeTitles = true
        present(navigation, animated: true)
    }
}
