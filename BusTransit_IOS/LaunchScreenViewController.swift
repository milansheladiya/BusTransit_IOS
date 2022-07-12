//
//  LaunchScreenViewController.swift
//  BusTransit_IOS
//
//  Created by Milan Sheladiya on 2022-07-08.
//

import UIKit
import Lottie

//let logoAnimationView = LogoAnimationView()

class LaunchScreenViewController: UIViewController {
    
    private var animationView: AnimationView?

    override func viewDidLoad() {
        super.viewDidLoad()
           
        animationView = .init(name: "moving-bus")
          
          animationView!.frame = view.bounds
          animationView!.contentMode = .scaleAspectFit
          animationView!.loopMode = .loop
          animationView!.animationSpeed = 0.5
          view.addSubview(animationView!)
          animationView!.play()
        

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
            
            self.performSegue(withIdentifier: "goToLogin", sender: self)
        }
    }
    
}
