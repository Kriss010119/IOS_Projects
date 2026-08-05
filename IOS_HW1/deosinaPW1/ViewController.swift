//
//  ViewController.swift
//  deosinaPW1
//
//  Created by Kriss on 13.09.2025.
//

import UIKit


class ViewController: UIViewController {
    
    private enum Const {
        static let maxRad: CGFloat = 50.0
        static let animDur: TimeInterval = 1.0
        static let moveDistance: CGFloat = 100.0
    }
    var cnt = 0
    
    @IBOutlet var views: [UIView]!
    
    @IBOutlet weak var count: UILabel!
    
    @IBAction func buttonTap(_ button: UIButton) {
        button.isEnabled = false
        button.alpha = 0.5
        
        var colorSet = Set<UIColor>()
        
        let animationGroup = DispatchGroup()
        let safeArea = view.safeAreaLayoutGuide
        let safeBounds = safeArea.layoutFrame
        
        cnt += 1
        
        while colorSet.count < views.count {
            colorSet.insert(
                UIColor.randomHex()
            )
        }
        
        for view in views {
            animationGroup.enter()
            
            let originalCenter = view.center
            let maxRight = safeBounds.maxX - view.bounds.width/2 - 10.0
            let maxLeft = safeBounds.minX + view.bounds.width/2 + 10.0
            
            let availableRight = maxRight - originalCenter.x
            let availableLeft = originalCenter.x - maxLeft
            
            let moveDirection: CGFloat = Bool.random() ? 1.0 : -1.0
            let maxAvailable = moveDirection > 0 ? availableRight : availableLeft
            let actualDistance = min(Const.moveDistance, maxAvailable)
            
            let targetX = originalCenter.x + (actualDistance * moveDirection)
            
            count.text = "Count of clicks: \(cnt)"
            UIView.animate(
                withDuration: Const.animDur,
                animations: {
                    view.backgroundColor = colorSet.popFirst()
                    view.layer.cornerRadius = .random(in: 0...Const.maxRad)
                    view.center.x = targetX
                    
                },
                completion: { _ in
                    animationGroup.leave()
                }
            )
        }
        
        animationGroup.notify(queue: .main) {
                button.isEnabled = true
                button.alpha = 1.0
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


}

