//
//  DefaultDarkPresentation.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 2/8/24.
//


import UIKit
import SwiftEntryKit

private func makeDefaultDarkPresentationTheme() -> PresentationTheme {
    let defaultDarkColor = UIColor(rgb: 0x1c1c1d)
    
    let view = PresentationThemeView(backgroundColor: defaultDarkColor)
    let label = PresentationThemeLabel(primaryColor: .white, secondaryColor: .white)
    let imageView = PresentationThemeImageView(backgroundColor: defaultDarkColor, tintColor: .white)
    let textField = PresentationThemeTextField(backgroundColor: UIColor(rgb: 0x808080, alpha: 0.5), placeholderColor: .white)
    let navigationBar = PresentationThemeNavigationBar(barTintColor: defaultDarkColor, tintColor: .white)
    let popUpView = PresentationThemePopUpView(entryBackgroundColor: defaultDarkColor, titleLabelColor: .white, descriptionLabelColor: .white, buttonLabelColor: .white, buttonBackgroundColor: .mainColor)
    
    return PresentationTheme(view: view, label: label, imageView: imageView, textField: textField, navigationBar: navigationBar, popUpView: popUpView)
}

public let defaultDarkPresentationTheme = makeDefaultDarkPresentationTheme()
