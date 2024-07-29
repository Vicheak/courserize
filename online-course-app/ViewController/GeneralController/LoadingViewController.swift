//
//  LoadingViewController.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 29/7/24.
//

import UIKit
import Localize_Swift
import NVActivityIndicatorView

class LoadingViewController: UIViewController {
    
    var loadingView = LoadingView(text: "Loading...")
    
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        
        self.setText()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func setText(){
        loadingView.updateText("Loading...".localized(using: "Generals"))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setUpViews() {
        view.backgroundColor = .black.withAlphaComponent(0.5)
        view.addSubview(loadingView)
        
        loadingView.layer.cornerRadius = 10
        
        loadingView.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}
