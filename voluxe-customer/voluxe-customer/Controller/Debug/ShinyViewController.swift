//
//  ShinyViewController.swift
//  voluxe-customer
//
//  Created by Christoph on 7/18/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class ShinyViewController: UIViewController {

    override func viewDidLoad() {

        super.viewDidLoad()
        self.view.backgroundColor = .white

        let scrollView = UIScrollView(frame: CGRect.zero)
        scrollView.isDirectionalLockEnabled = true
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            make in
            make.edges.equalToSuperview()
        }

        let contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            make in
            make.edges.equalToSuperview()
            if let superview = scrollView.superview { make.width.equalTo(superview.snp.width) }
            make.height.greaterThanOrEqualToSuperview().multipliedBy(1)
        }

        let marker = ETAMarker(frame: CGRect(x: 0, y: 0, width: 41, height: 62))
        self.arrange(view: marker, in: contentView)

        let logo = UIImageView(image: UIImage(named: "luxeByVolvo"))
        VLShinyView.withLuxeColors().add(to: logo, mask: logo.image)
        self.arrange(view: logo, in: contentView)

        var button = VLButton(type: .bluePrimary, title: "Blue Primary")
        VLShinyView.forLuxeButtons().add(to: button)
        self.arrange(view: button, in: contentView, withInsets: true)

        button = VLButton(type: .blueSecondary, title: "Blue Secondary")
        VLShinyView.forLuxeButtons().add(to: button)
        self.arrange(view: button, in: contentView, withInsets: true)

        button = VLButton(type: .whitePrimary, title: "White Primary")
        VLShinyView.forLuxeButtons().add(to: button)
        self.arrange(view: button, in: contentView, withInsets: true)

        button = VLButton(type: .orangePrimary, title: "Orange Primary")
        VLShinyView.forLuxeButtons().add(to: button)
        self.arrange(view: button, in: contentView, withInsets: true)

        button = VLButton(type: .orangeSecondary, title: "Orange Secondary")
        VLShinyView.forLuxeButtons().add(to: button)
        self.arrange(view: button, in: contentView, withInsets: true)

        if let last = contentView.subviews.last {
            last.snp.makeConstraints {
                make in
                make.bottom.equalToSuperview()
            }
        }
    }

    private func arrange(view: UIView, in superview: UIView, withInsets: Bool = false) {

        let subview = superview.subviews.last

        let containerView = UIView()
        superview.addSubview(containerView)
        containerView.snp.makeConstraints {
            make in
            make.left.right.equalToSuperview()
            make.height.greaterThanOrEqualTo(100)
            if let subview = subview {
                make.top.equalTo(subview.snp.bottom).offset(10)
            } else {
                make.top.equalToSuperview()
            }
        }

        containerView.addSubview(view)
        view.snp.makeConstraints {
            make in
            if withInsets { make.edges.equalToSuperview().inset(20) }
            else { make.center.equalToSuperview() }
        }
    }
}
