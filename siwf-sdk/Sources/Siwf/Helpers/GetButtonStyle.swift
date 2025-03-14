//
//  GetButtonStyle.swift
//  Siwf
//
//  Created by Claire Olmstead on 3/14/25.
//

import Foundation
import UIKit

public struct ButtonStyles {
    var title: String
    var backgroundColor: UIColor
    var textColor: UIColor
    var borderColor: UIColor
    var logoImage: UIImage?
}

public func getButtonStyle(mode: SiwfButtonMode, assets: Assets) -> ButtonStyles {
    let title = assets.content.title
    let primaryColor = UIColor(hex: assets.colors.primary)
    let darkColor = UIColor(hex: assets.colors.dark)
    let lightColor = UIColor(hex: assets.colors.light)

    switch mode {
    case .primary:
        return ButtonStyles(
            title: title,
            backgroundColor: primaryColor,
            textColor: lightColor,
            borderColor: primaryColor,
            logoImage: decodeBase64Image(base64String: assets.images.logoPrimary)
        )
        
    case .dark:
        return ButtonStyles(
            title: title,
            backgroundColor: darkColor,
            textColor: lightColor,
            borderColor: darkColor,
            logoImage: decodeBase64Image(base64String: assets.images.logoLight)
        )

    case .light:
        return ButtonStyles(
            title: title,
            backgroundColor: lightColor,
            textColor: darkColor,
            borderColor: darkColor,
            logoImage: decodeBase64Image(base64String: assets.images.logoDark)
        )
    }
}
