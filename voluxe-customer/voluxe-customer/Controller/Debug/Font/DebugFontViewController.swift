//
//  DebugFontViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 6/13/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class DebugFontViewController: UIViewController {
    
    var currentViewController: UIViewController?

    let testedFonts = [Fonts.FontType.volvoNovum, Fonts.FontType.volvoSansPro]
    let segmentedControl = UISegmentedControl(frame: .zero)
    let contentView = UIView(frame: .zero)

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.setupViews()
        
        for (index, font) in testedFonts.enumerated() {
            segmentedControl.insertSegment(withTitle: font.rawValue, at: index, animated: true)
        }
        
        displayCurrentTab(0)
        
        segmentedControl.addTarget(self, action: #selector(switchTabs(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
    }
    
    func setupViews() {
        self.view.addSubview(segmentedControl)
        self.view.addSubview(contentView)
        
        if self.view.hasSafeAreaCapability {
            segmentedControl.snp.makeConstraints { make in
                make.equalsToTop(view: self.view, offset: 20)
                make.width.equalToSuperview().offset(-40)
                make.centerX.equalToSuperview()
                make.height.equalTo(40)
            }
        } else {
            segmentedControl.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(84)
                make.width.equalToSuperview().offset(-40)
                make.centerX.equalToSuperview()
                make.height.equalTo(40)
            }
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(20)
            make.width.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Switching Tabs Functions
    @objc func switchTabs(_ sender: UISegmentedControl) {
        self.currentViewController!.view.removeFromSuperview()
        self.currentViewController!.removeFromParent()
        
        displayCurrentTab(sender.selectedSegmentIndex)
    }
    
    func displayCurrentTab(_ tabIndex: Int){
        let vc = DebugFontTestViewController(fontType: testedFonts[tabIndex])
        
        self.addChild(vc)
        vc.didMove(toParent: self)
        
        vc.view.frame = self.contentView.bounds
        self.contentView.addSubview(vc.view)
        self.currentViewController = vc
    }
    
    
}
