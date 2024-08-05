//
//  DefaultPresentationTheme.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 2/8/24.
//

import UIKit

private func makeDefaultPresentationTheme() -> PresentationTheme {
    let view = PresentationThemeView(backgroundColor: .white)
    let label = PresentationThemeLabel(primaryColor: .black, secondaryColor: .black)
    let imageView = PresentationThemeImageView(backgroundColor: .white, tintColor: .black)
    let textField = PresentationThemeTextField(backgroundColor: .white, placeholderColor: UIColor(rgb: 0x000000, alpha: 0.4))
    let navigationBar = PresentationThemeNavigationBar(barTintColor: .white, tintColor: .black)
    let popUpView = PresentationThemePopUpView(entryBackgroundColor: .white, titleLabelColor: .black, descriptionLabelColor: .black, buttonLabelColor: .white, buttonBackgroundColor: .mainColor)
    let tabBar = PresentationThemeTabBar(barTintColor: .white, tintColor: .black)
    
    return PresentationTheme(view: view, label: label, imageView: imageView, textField: textField, navigationBar: navigationBar, popUpView: popUpView, tabBar: tabBar)
}

public let defaultPresentationTheme = makeDefaultPresentationTheme()
