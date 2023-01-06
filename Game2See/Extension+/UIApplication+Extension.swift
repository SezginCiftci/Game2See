//
//  UIApplication+Extension.swift
//  Game2See
//
//  Created by Sezgin Çiftci on 30.12.2022.
//

import UIKit

extension UIApplication {
    var keyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)
    }
}
