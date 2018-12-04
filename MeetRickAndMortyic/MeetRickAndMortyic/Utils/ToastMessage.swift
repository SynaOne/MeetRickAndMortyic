//
//  ToastMessage.swift
//  MeetRickAndMortyic
//
//  Created by Nicolas MORANNY on 04/12/2018.
//  Copyright © 2018 Nicolas Moranny. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    func showToast(message : String) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.center.x - 100,
                                               y: self.view.frame.size.height - 100,
                                               width: 200,
                                               height: 75))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 14)
        toastLabel.text = message
        toastLabel.alpha = 1
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines = 0
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 3,
                       delay: 5,
                       options: .curveEaseOut,
                       animations: {
                        toastLabel.alpha = 0
                       }, completion: { (isCompleted) in
                        toastLabel.removeFromSuperview()
                       })
    }
}
