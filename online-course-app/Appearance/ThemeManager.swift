//
//  ThemeManager.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 2/8/24.
//

import Foundation

extension Notification.Name {
    static let changeTheme = Notification.Name("changeTheme")
}

class ThemeManager {
    static let shared = ThemeManager()
    
    var theme: PresentationTheme = defaultPresentationTheme
    
    var themeType = Theme.day {
        didSet {
            if oldValue != themeType {
                NotificationCenter.default.post(name: Notification.Name.changeTheme, object: nil)
            }
        }
    }
    
    private init() {
        
    }
    
    func applyTheme(type: Theme) {
        if type == .day || type == .system {
            theme = defaultPresentationTheme
        } else {
            theme = defaultDarkPresentationTheme
        }
        self.themeType = type
    }
}

enum Theme: String {
    case day, night, system
    
    var rawValue: String {
        switch self {
        case .day:
            return "day"
        case .night:
            return "night"
        case .system:
            return "system"
        }
    }
}
