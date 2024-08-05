//
//  ShowPopUp.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 30/7/24.
//

import UIKit
import SwiftEntryKit

class PopUpUtil {
        
    static let successImage = UIImage(named: "logo-preview-screen")!
    static let warningImage = UIImage(named: "warning")!
    static let crossImage = UIImage(named: "cross")!
    
    public static func popUp(withTitle title: String, withMessage message: String, withAlert alert: Alert, completion: @escaping () -> Void){
        //dismiss the keyboard
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        
        let theme = ThemeManager.shared.theme
        
        // Create the title and description attributes
        let title = EKProperty.LabelContent(
            text: title,
            style: .init(
                font: UIFont(name: "KhmerOSBattambang-Bold", size: 18)!,
                color: theme.popUpView.titleLabelColor,
                alignment: .center
            )
        )
        
        let description = EKProperty.LabelContent(
            text: message,
            style: .init(
                font: .systemFont(ofSize: 16),
                color: theme.popUpView.descriptionLabelColor,
                alignment: .center
            )
        )
        
        // Create the button attributes
        let buttonLabelStyle = EKProperty.LabelStyle(
            font: .systemFont(ofSize: 16),
            color: theme.popUpView.buttonLabelColor
        )
        
        let buttonLabel = EKProperty.LabelContent(
            text: "OK",
            style: buttonLabelStyle
        )
        
        let button = EKProperty.ButtonContent(
            label: buttonLabel,
            backgroundColor: .init(theme.popUpView.buttonBackgroundColor),
            highlightedBackgroundColor: .init(.darkGray)
        ) { }
        
        // Optional theme image
        let themeImage = EKPopUpMessage.ThemeImage(
            image: EKProperty.ImageContent(
                image: alert == .success ? successImage : alert == .warning ? warningImage : crossImage,
                size: CGSize(width: 120, height: 120)
            )
        )
        
        // Create the popup message
        let message = EKPopUpMessage(
            themeImage: themeImage,
            title: title,
            description: description,
            button: button,
            action: {
                completion()
                SwiftEntryKit.dismiss()
            }
        )
        
        // Create the attributes for the popup message
        var attributes = EKAttributes()
        attributes.position = .center
        attributes.positionConstraints.verticalOffset = 10
        attributes.displayDuration = .infinity
        attributes.entryBackground = .color(color: .init(theme.popUpView.entryBackgroundColor))
        attributes.screenBackground = .color(color: .init(UIColor.black.withAlphaComponent(0.5)))
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 8))
        attributes.roundCorners = .all(radius: 10)
        attributes.positionConstraints.size = .init(width: .offset(value: 60), height: .intrinsic)
        attributes.positionConstraints.verticalOffset = 0
        attributes.positionConstraints.safeArea = .overridden
        attributes.screenInteraction = .absorbTouches
        attributes.lifecycleEvents.willDisappear = {
            completion()
        }
        
        // Display the popup message
        SwiftEntryKit.display(entry: EKPopUpMessageView(with: message), using: attributes)
    }
    
}
