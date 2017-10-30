//
//  FTUEViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 10/30/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import  UIKit

class FTUEViewController: BaseViewController {
    
    let viewPager = ViewPager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewPager.dataSource = self
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func setupViews() {
        super.setupViews()
        
        self.view.addSubview(viewPager)
        
        viewPager.snp.makeConstraints { (make) -> Void in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.view).offset(60)
        }
    }
    
    
}


extension FTUEViewController: ViewPagerDataSource{
    func numberOfItems(viewPager:ViewPager) -> Int {
        return 5;
    }
    
    func viewAtIndex(viewPager:ViewPager, index:Int, view:UIView?) -> UIView {
        var newView = view;
        var label:UILabel?
        if(newView == nil){
            newView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height:  self.view.frame.height))
            
            label = UILabel(frame: newView!.bounds)
            label!.tag = 1
            label!.autoresizingMask =  [.flexibleWidth, .flexibleHeight]
            label!.textAlignment = .center
            label!.font =  label!.font.withSize(28)
            newView?.addSubview(label!)
        }else{
            label = newView?.viewWithTag(1) as? UILabel
        }
        
        label?.text = "Page View Pager  \(index+1)"
        
        return newView!
    }
    
    func didSelectedItem(index: Int) {
        print("select index \(index)")
    }
    
}
