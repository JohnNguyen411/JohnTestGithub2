//
//  VLAlertViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 4/27/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import SnapKit

class VLAlertViewController: UIViewController {
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel(frame: .zero)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 1
        titleLabel.font = .volvoSansProMedium(size: 20)
        titleLabel.textColor = .luxeDarkGray()
        return titleLabel
    }()
    
    let messageLabel: UILabel = {
        let messageLabel = UILabel(frame: .zero)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.font = .volvoSansProLight(size: 15)
        messageLabel.textColor = .luxeDarkGray()
        return messageLabel
    }()
    
    let alertView: UIView = {
        let alertView = UIView(frame: .zero)
        alertView.backgroundColor = .luxeLightestGray()
        return alertView
    }()
    
    let cancelButton: UIButton = {
        let cancelButton = UIButton(frame: .zero)
        cancelButton.setTitleColor(UIColor.luxeCobaltBlue(), for: .normal)
        return cancelButton
    }()
    
    let okButton: UIButton = {
        let okButton = UIButton(frame: .zero)
        okButton.setTitleColor(UIColor.luxeCobaltBlue(), for: .normal)
        return okButton
    }()
    
    weak var delegate: VLAlertViewDelegate?
    
    private let cancelButtonVisible: Bool
    private let okButtonVisible: Bool
    
    var dismissOnTap: Bool = true
    
    init(title: String, message: String, cancelButtonTitle: String?, okButtonTitle: String?) {
        titleLabel.text = title
        messageLabel.text = message
        self.cancelButtonVisible = cancelButtonTitle != nil
        self.okButtonVisible = okButtonTitle != nil
        cancelButton.setTitle(cancelButtonTitle, for: .normal)
        okButton.setTitle(okButtonTitle, for: .normal)
        cancelButton.isHidden = !cancelButtonVisible
        okButton.isHidden = !okButtonVisible
        
        super.init(nibName: nil, bundle: nil)
        
        self.providesPresentationContextTransitionStyle = true
        self.definesPresentationContext = true
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
        
        okButton.addTarget(self, action: #selector(onTapOkButton(_:)), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(onTapCancelButton(_:)), for: .touchUpInside)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
        if okButtonVisible && cancelButtonVisible {
            okButton.addBorder(side: .top, color: .luxeLightGray(), width: 1)
            cancelButton.addBorder(side: .top, color: .luxeLightGray(), width: 1)
            cancelButton.addBorder(side: .right, color: .luxeLightGray(), width: 1)
            
        } else {
            if okButtonVisible {
                okButton.addBorder(side: .top, color: .luxeLightGray(), width: 1)
            }
            if cancelButtonVisible {
                cancelButton.addBorder(side: .top, color: .luxeLightGray(), width: 1)
            }
        }
        
    }
    
    func setupView() {
        self.view.addSubview(alertView)
        
        alertView.layer.cornerRadius = 15
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        alertView.addSubview(titleLabel)
        alertView.addSubview(messageLabel)
        alertView.addSubview(cancelButton)
        alertView.addSubview(okButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.right.equalToSuperview()
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        }
        
        if okButtonVisible && cancelButtonVisible {
            
            cancelButton.snp.makeConstraints { make in
                make.bottom.left.equalToSuperview()
                make.height.equalTo(50)
                make.width.equalToSuperview().dividedBy(2)
            }
            
            okButton.snp.makeConstraints { make in
                make.bottom.right.equalToSuperview()
                make.height.equalTo(50)
                make.width.equalToSuperview().dividedBy(2)
            }
            
        } else {
            if okButtonVisible {
                okButton.snp.makeConstraints { make in
                    make.height.equalTo(50)
                    make.bottom.left.right.equalToSuperview()
                }
            }
            if cancelButtonVisible {
                cancelButton.snp.makeConstraints { make in
                    make.height.equalTo(50)
                    make.bottom.left.right.equalToSuperview()
                }
            }
        }
        
        let messageHeight = messageLabel.sizeThatFits(CGSize(width: 280, height: CGFloat(MAXFLOAT))).height
        
        alertView.snp.makeConstraints { make in
            make.width.equalTo(280)
            make.height.equalTo(messageHeight+120)
            make.center.equalToSuperview()
        }
    }
    
    func animateView() {
        alertView.alpha = 0;
        self.alertView.frame.origin.y = self.alertView.frame.origin.y + 50
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.alertView.alpha = 1.0;
            self.alertView.frame.origin.y = self.alertView.frame.origin.y - 50
        })
    }
    
    @IBAction func onTapCancelButton(_ sender: Any) {
        delegate?.cancelButtonTapped()
        if dismissOnTap {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func onTapOkButton(_ sender: Any) {
        delegate?.okButtonTapped()
        if dismissOnTap {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
}

protocol VLAlertViewDelegate: class {
    func okButtonTapped()
    func cancelButtonTapped()
}
