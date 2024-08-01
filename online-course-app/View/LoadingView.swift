//
//  LoadingView.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 29/7/24.
//

import UIKit
import SnapKit
import NVActivityIndicatorView

class LoadingView: UIView {

    private let indicatorView = NVActivityIndicatorView(frame: .zero)
    private let textLabel = UILabel()
    private var text: String
    
    init(text: String) {
        self.text = text
        super.init(frame: .zero)
        setUpViews()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateText(_ text: String) {
        self.text = text
        textLabel.text = text
        layoutIfNeeded()
    }
    
    private func setUpViews() {
        backgroundColor = .white
        addSubview(indicatorView)
        addSubview(textLabel)
        
        indicatorView.type = .ballBeat
        indicatorView.color = .mainColor
        textLabel.numberOfLines = 0
        textLabel.text = text
        
        indicatorView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(15)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        textLabel.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview().inset(10)
            make.left.equalTo(indicatorView.snp.right).inset(-10)
            make.height.equalTo(60)
        }

        layoutIfNeeded()
        indicatorView.startAnimating()
    }
    
}
