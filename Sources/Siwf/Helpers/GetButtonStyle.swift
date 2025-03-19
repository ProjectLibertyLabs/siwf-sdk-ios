//
//  GetButtonStyle.swift
//  Siwf
//
//  Created by Claire Olmstead on 3/14/25.
//

import SwiftUI

public struct ButtonStyles {
    var title: String
    var backgroundColor: Color
    var textColor: Color
    var borderColor: Color
    var logoImage: UIImage?
}

func getButtonStyle(mode: SiwfButtonMode, assets: Assets) -> ButtonStyles {
    let title = assets.content.title
    let primaryColor = Color(hex: assets.colors.primary)
    let darkColor = Color(hex: assets.colors.dark)
    let lightColor = Color(hex: assets.colors.light)

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
