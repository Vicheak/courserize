//
//  DefaultDarkPresentation.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 2/8/24.
//


import UIKit

private func makeDefaultDarkPresentationTheme() -> PresentationTheme {
    let defaultDarkColor = UIColor(rgb: 0x1c1c1d)
    
    let view = PresentationThemeView(backgroundColor: defaultDarkColor)
    let label = PresentationThemeLabel(primaryColor: .white, secondaryColor: .white)
    let imageView = PresentationThemeImageView(backgroundColor: defaultDarkColor, tintColor: .white)
    let textField = PresentationThemeTextField(backgroundColor: UIColor(rgb: 0x808080, alpha: 0.5), placeholderColor: .white)
    let navigationBar = PresentationThemeNavigationBar(barTintColor: defaultDarkColor, tintColor: .white)
    
    return PresentationTheme(view: view, label: label, imageView: imageView, textField: textField, navigationBar: navigationBar)
}

public let defaultDarkPresentationTheme = makeDefaultDarkPresentationTheme()
