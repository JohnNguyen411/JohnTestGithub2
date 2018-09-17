//
//  DriverInfoViewController.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 8/3/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import SnapKit

class DriverInfoViewController: UIViewController {
    
    let driver: Driver
    let roundImageView: RoundImageView
    let delegate: DriverInfoViewControllerProtocol
    private let closeButton = UIButton(type: UIButton.ButtonType.custom)

    init(driver: Driver, delegate: DriverInfoViewControllerProtocol) {
        
        if let screenSize = ViewUtils.screenSize {
            self.roundImageView = RoundImageView(size: CGSize(width: screenSize.width - 48, height: screenSize.width - 48), shadowRadius: 1, shadowOffset: CGSize(width: 0, height: 1))
        } else {
            self.roundImageView = RoundImageView(size: CGSize(width: 252, height: 252), shadowRadius: 1, shadowOffset: CGSize(width: 0, height: 1))
        }
        
        self.delegate = delegate
        self.driver = driver
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        self.view.isUserInteractionEnabled = true
        self.roundImageView.isUserInteractionEnabled = true
        
        closeButton.setImage(UIImage(named: "close"), for: .normal)
        closeButton.addTarget(self, action: #selector(onCloseClicked), for: .touchUpInside)
        
        let blurBgTap = UITapGestureRecognizer(target: self, action: #selector(onCloseClicked))
        self.view.addGestureRecognizer(blurBgTap)
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(onImageTap))
        self.roundImageView.addGestureRecognizer(imageTap)
        
    }
    
    private func setupViews() {
        
        self.view.addSubview(self.roundImageView)
        self.view.addSubview(self.closeButton)

        self.roundImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(roundImageView.frame.size.width)
        }
        
        closeButton.snp.makeConstraints { make in
            make.equalsToTop(view: self.view, offset: !self.view.hasSafeAreaCapability ? 15 : 0)
            make.left.equalToSuperview().offset(3)
            make.width.height.equalTo(50)
        }
        
    }
    
    @objc private func onCloseClicked() {
        self.dismiss(animated: true)
    }
    
    @objc private func onImageTap() {
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        delegate.onDismiss()
    }
    
}

protocol DriverInfoViewControllerProtocol {
    func onDismiss()
}
