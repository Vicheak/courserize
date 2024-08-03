//
//  PresentationTheme.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 2/8/24.
//

import UIKit

public final class PresentationThemeView {
    public let backgroundColor: UIColor

    init(backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
    }
}


public final class PresentationThemeLabel {
    public let primaryColor: UIColor
    public let secondaryColor: UIColor
    
    init(primaryColor: UIColor, secondaryColor: UIColor) {
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
    }
}

public final class PresentationThemeImageView {
    public let backgroundColor: UIColor
    public let tintColor: UIColor

    init(backgroundColor: UIColor, tintColor: UIColor) {
        self.backgroundColor = backgroundColor
        self.tintColor = tintColor
    }
}

public final class PresentationThemeTextField {
    public let backgroundColor: UIColor
    public let placeholderColor: UIColor

    init(backgroundColor: UIColor, placeholderColor: UIColor) {
        self.backgroundColor = backgroundColor
        self.placeholderColor = placeholderColor
    }
}

public final class PresentationThemeNavigationBar {
    public let barTintColor: UIColor
    public let tintColor: UIColor
    
    init(barTintColor: UIColor, tintColor: UIColor) {
        self.barTintColor = barTintColor
        self.tintColor = tintColor
    }
}

public final class PresentationTheme {
    public let view: PresentationThemeView
    public let label: PresentationThemeLabel
    public let imageView: PresentationThemeImageView
    public let textField: PresentationThemeTextField
    public let navigationBar: PresentationThemeNavigationBar
    
    init(view: PresentationThemeView, label: PresentationThemeLabel, imageView: PresentationThemeImageView, textField: PresentationThemeTextField, navigationBar: PresentationThemeNavigationBar) {
        self.view = view
        self.label = label
        self.imageView = imageView
        self.textField = textField
        self.navigationBar = navigationBar
    }
}
