//
//  DebugFontTestViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 6/13/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class DebugFontTestViewController: UIViewController {
    
    static let bodyText = "I am an invisible man. No, I am not a spook like those who haunted Edgar Allan Poe; nor am I one of your Hollywood-movie ectoplasms. I am a man of substance, of flesh and bone, fiber and liquids—and I might even be said to possess a mind. I am invisible, understand, simply because people refuse to see me. Like the bodiless heads you see sometimes in circus sideshows, it is as though I have been surrounded by mirrors of hard, distorting glass. When they approach me they see only my surroundings, themselves, or figments of their imagination—indeed, everything and anything except me."
    
    static let sizeText16 = "KMHHT6KD8DU096161  2D8GZ57246H409701  2HKRL18522H185890  1FUPFXYB1SP725671  1FUJA6AV45DU93303"
    static let sizeText14 = "1HGCS2B84AA019461  1FUYDCYB7RP422729  JF2SH6FC9AH753746  2D4GP44RX3R309031  1G4AH19E1CD442960"
    static let sizeText12 = "1FT7W2BT4EEE74687  1GBEG25Z3N7191212  1JCHX7820GT150016  ZAREA43L9N6271598  1GCEK14X96Z180449"
    static let sizeText10 = "JT2EL36M3L0477253  2GTEC19V231255226  VG6M118B5RB340381  1GTHC24204E302639  1GCGK24K8RE259982"

    
    var didSetupConstraints = false
    
    let scrollView = UIScrollView(frame: .zero)
    let contentView = UIView(frame: .zero)
    
    let listContainerView = UIView(frame: .zero)
    let bodyWhiteContainerView = UIView(frame: .zero)
    let bodyBlackContainerView = UIView(frame: .zero)
    let sizesWhiteContainerView = UIView(frame: .zero)
    let sizesBlackContainerView = UIView(frame: .zero)
    let weightWhiteContainerView = UIView(frame: .zero)
    let weightBlackContainerView = UIView(frame: .zero)
    
    let fontType: Fonts.FontType
    
    init(fontType: Fonts.FontType) {
        self.fontType = fontType
        Fonts.fontType = fontType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(listContainerView)
        contentView.addSubview(bodyWhiteContainerView)
        contentView.addSubview(bodyBlackContainerView)
        contentView.addSubview(sizesWhiteContainerView)
        contentView.addSubview(sizesBlackContainerView)
        contentView.addSubview(weightWhiteContainerView)
        contentView.addSubview(weightBlackContainerView)
        
        setupView()
        
    }
    
    func setupView() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view).inset(UIEdgeInsets.zero)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView).inset(UIEdgeInsets.zero)
            make.width.equalTo(scrollView)
        }
        
        listContainerView.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.left.equalTo(contentView).offset(20)
            make.right.equalTo(contentView).offset(-20)
        }
        
        fillViews()
        
        contentView.snp.remakeConstraints { make in
            make.edges.equalTo(scrollView).inset(UIEdgeInsets.zero)
            make.width.equalTo(scrollView)
        }
        contentView.sizeToFit()
    }
    
    func fillViews() {
        fillList()
        fillBodies()
        fillSizes()
        fillFontWeight()
    }
    
    func fillList() {
        let minCellHeight: CGFloat = 64
        
        let header = DebugFontCellView(attributedString: Fonts.systemFontSize(text: "SCALE", size: 12), weight: "WEIGHT", size: "SIZE", tracking: "TRACKING")
        listContainerView.addSubview(header)
        header.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.greaterThanOrEqualTo(30)
        }
        
        header.title.snp.remakeConstraints { make in
            make.centerY.left.equalToSuperview()
            make.width.equalTo(90)
        }
        
        let h1 = DebugFontCellView(attributedString: Fonts.H1(text: "H1"), weight: "Light", size: "96", tracking: "-1.5")
        listContainerView.addSubview(h1)
        var cellHeight = h1.autoHeight()
        h1.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.greaterThanOrEqualTo(cellHeight < minCellHeight ? minCellHeight : cellHeight)
        }
        
        let h2 = DebugFontCellView(attributedString: Fonts.H2(text: "H2"), weight: "Light", size: "64", tracking: "-0.5")
        listContainerView.addSubview(h2)
        cellHeight = h2.autoHeight()
        h2.snp.makeConstraints { make in
            make.top.equalTo(h1.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.greaterThanOrEqualTo(cellHeight < minCellHeight ? minCellHeight : cellHeight)
        }
        
        let h3 = DebugFontCellView(attributedString: Fonts.H3(text: "H3"), weight: "Semi-Light", size: "48", tracking: "0")
        listContainerView.addSubview(h3)
        cellHeight = h3.autoHeight()
        h3.snp.makeConstraints { make in
            make.top.equalTo(h2.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.greaterThanOrEqualTo(cellHeight < minCellHeight ? minCellHeight : cellHeight)
        }
        
        let h4 = DebugFontCellView(attributedString: Fonts.H4(text: "H4"), weight: "Semi-Light", size: "36", tracking: "0.25")
        listContainerView.addSubview(h4)
        cellHeight = h4.autoHeight()
        h4.snp.makeConstraints { make in
            make.top.equalTo(h3.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.greaterThanOrEqualTo(cellHeight < minCellHeight ? minCellHeight : cellHeight)
        }
        
        let h5 = DebugFontCellView(attributedString: Fonts.H5(text: "H5"), weight: "Regular", size: "24", tracking: "0")
        listContainerView.addSubview(h5)
        cellHeight = h5.autoHeight()
        h5.snp.makeConstraints { make in
            make.top.equalTo(h4.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.greaterThanOrEqualTo(cellHeight < minCellHeight ? minCellHeight : cellHeight)
        }
        
        let h6 = DebugFontCellView(attributedString: Fonts.H6(text: "H6"), weight: "Medium", size: "20", tracking: "0.15")
        listContainerView.addSubview(h6)
        cellHeight = h6.autoHeight()
        h6.snp.makeConstraints { make in
            make.top.equalTo(h5.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.greaterThanOrEqualTo(cellHeight < minCellHeight ? minCellHeight : cellHeight)
        }
        
        let sub1 = DebugFontCellView(attributedString: Fonts.Sub1(text: "Subtitle 1"), weight: "Regular", size: "16", tracking: "0.15")
        listContainerView.addSubview(sub1)
        cellHeight = sub1.autoHeight()
        sub1.snp.makeConstraints { make in
            make.top.equalTo(h6.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.greaterThanOrEqualTo(cellHeight < minCellHeight ? minCellHeight : cellHeight)
        }
        
        let sub2 = DebugFontCellView(attributedString: Fonts.Sub2(text: "Subtitle 2"), weight: "Medium", size: "14", tracking: "0.1")
        listContainerView.addSubview(sub2)
        cellHeight = sub2.autoHeight()
        sub2.snp.makeConstraints { make in
            make.top.equalTo(sub1.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.greaterThanOrEqualTo(cellHeight < minCellHeight ? minCellHeight : cellHeight)
        }
        
        let body1 = DebugFontCellView(attributedString: Fonts.Body1(text: "Body 1"), weight: "Regular", size: "16", tracking: "0")
        listContainerView.addSubview(body1)
        cellHeight = body1.autoHeight()
        body1.snp.makeConstraints { make in
            make.top.equalTo(sub2.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.greaterThanOrEqualTo(cellHeight < minCellHeight ? minCellHeight : cellHeight)
        }
        
        let body2 = DebugFontCellView(attributedString: Fonts.Body2(text: "Body 2"), weight: "Regular", size: "14", tracking: "0.25")
        listContainerView.addSubview(body2)
        cellHeight = body2.autoHeight()
        body2.snp.makeConstraints { make in
            make.top.equalTo(body1.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.greaterThanOrEqualTo(cellHeight < minCellHeight ? minCellHeight : cellHeight)
        }
        
        let button = DebugFontCellView(attributedString: Fonts.button(text: "Button"), weight: "Medium", size: "14", tracking: "0.75")
        listContainerView.addSubview(button)
        cellHeight = button.autoHeight()
        button.snp.makeConstraints { make in
            make.top.equalTo(body2.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.greaterThanOrEqualTo(cellHeight < minCellHeight ? minCellHeight : cellHeight)
        }
        
        let caption = DebugFontCellView(attributedString: Fonts.caption(text: "Caption"), weight: "Regular", size: "12", tracking: "0.5")
        listContainerView.addSubview(caption)
        cellHeight = caption.autoHeight()
        caption.snp.makeConstraints { make in
            make.top.equalTo(button.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.greaterThanOrEqualTo(cellHeight < minCellHeight ? minCellHeight : cellHeight)
        }
        
        let overline = DebugFontCellView(attributedString: Fonts.overline(text: "Overline"), weight: "Medium", size: "10", tracking: "1.5")
        listContainerView.addSubview(overline)
        cellHeight = overline.autoHeight()
        overline.snp.makeConstraints { make in
            make.top.equalTo(caption.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.greaterThanOrEqualTo(cellHeight < minCellHeight ? minCellHeight : cellHeight)
        }
        
        listContainerView.snp.remakeConstraints { make in
            make.top.equalTo(contentView)
            make.left.equalTo(contentView).offset(20)
            make.right.equalTo(contentView).offset(-20)
            make.bottom.equalTo(overline).offset(20)
        }
        
    }
    
    private func fillBodies() {
        
        let whiteHeight = fillBody(isBlack: false, container: bodyWhiteContainerView)
        bodyWhiteContainerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(listContainerView.snp.bottom).offset(30)
            make.height.equalTo(whiteHeight)
        }
        bodyWhiteContainerView.sizeToFit()
        
        let blackHeight = fillBody(isBlack: true, container: bodyBlackContainerView)
        bodyBlackContainerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(bodyWhiteContainerView.snp.bottom).offset(30)
            make.height.equalTo(blackHeight)
        }
        bodyBlackContainerView.sizeToFit()
    }
    
    private func fillBody(isBlack: Bool, container: UIView) -> CGFloat {
        var totalHeight: CGFloat = 0
        
        let body1Title = UILabel(frame: .zero)
        let body1 = UILabel(frame: .zero)
        body1.numberOfLines = 0
        
        let body2Title = UILabel(frame: .zero)
        let body2 = UILabel(frame: .zero)
        body2.numberOfLines = 0
        
        if !isBlack {
            container.backgroundColor = UIColor.luxeWhite()
            body1Title.textColor = UIColor.luxeDarkGray()
            body1.textColor = UIColor.luxeDarkGray()
            
            body2Title.textColor = UIColor.luxeDarkGray()
            body2.textColor = UIColor.luxeDarkGray()
        } else {
            container.backgroundColor = UIColor.luxeDarkGray()
            body1Title.textColor = UIColor.luxeWhite()
            body1.textColor = UIColor.luxeWhite()
            
            body2Title.textColor = UIColor.luxeWhite()
            body2.textColor = UIColor.luxeWhite()
        }
        
        body1.attributedText = Fonts.Body1(text: DebugFontTestViewController.bodyText)
        body1Title.attributedText = Fonts.Body1(text: "Body 1")
        body2.attributedText = Fonts.Body2(text: DebugFontTestViewController.bodyText)
        body2Title.attributedText = Fonts.Body2(text: "Body 2")
        
        let sizeBody1Title = body1Title.sizeThatFits(CGSize(width: self.view.frame.width, height: CGFloat(MAXFLOAT))).height
        let sizeBody1 = body1.sizeThatFits(CGSize(width: self.view.frame.width, height: CGFloat(MAXFLOAT))).height
        let sizeBody2Title = body2Title.sizeThatFits(CGSize(width: self.view.frame.width, height: CGFloat(MAXFLOAT))).height
        let sizeBody2 = body2.sizeThatFits(CGSize(width: self.view.frame.width, height: CGFloat(MAXFLOAT))).height

        totalHeight = sizeBody1Title + sizeBody1 + sizeBody2 + sizeBody2Title + 130
        
        container.addSubview(body1Title)
        container.addSubview(body1)
        container.addSubview(body2Title)
        container.addSubview(body2)
        
        body1Title.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        body1.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(body1Title.snp.bottom)
        }
        
        body2Title.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(body1.snp.bottom).offset(30)
        }
        body2.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(body2Title.snp.bottom)
        }
        
        return totalHeight
    }
    
    private func fillSizes() {
        
        let whiteHeight = fillSize(isBlack: false, container: sizesWhiteContainerView)
        sizesWhiteContainerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(bodyBlackContainerView.snp.bottom).offset(30)
            make.height.equalTo(whiteHeight)
        }
        sizesWhiteContainerView.sizeToFit()
        
        let blackHeight = fillSize(isBlack: true, container: sizesBlackContainerView)
        sizesBlackContainerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(sizesWhiteContainerView.snp.bottom).offset(30)
            make.height.equalTo(blackHeight)
        }
        sizesBlackContainerView.sizeToFit()
        
    }
    
    private func fillSize(isBlack: Bool, container: UIView) -> CGFloat {
        var totalHeight: CGFloat = 0
        
        let size16Title = UILabel(frame: .zero)
        let size16Body = UILabel(frame: .zero)
        size16Body.numberOfLines = 0
        size16Body.lineBreakMode = .byWordWrapping
        
        let size14Title = UILabel(frame: .zero)
        let size14Body = UILabel(frame: .zero)
        size14Body.numberOfLines = 0
        size14Body.lineBreakMode = .byWordWrapping
        
        let size12Title = UILabel(frame: .zero)
        let size12Body = UILabel(frame: .zero)
        size12Body.numberOfLines = 0
        size12Body.lineBreakMode = .byWordWrapping
        
        let size10Title = UILabel(frame: .zero)
        let size10Body = UILabel(frame: .zero)
        size10Body.numberOfLines = 0
        size10Body.lineBreakMode = .byWordWrapping
        
        if !isBlack {
            container.backgroundColor = UIColor.luxeWhite()
            size16Title.textColor = UIColor.luxeDarkGray()
            size16Body.textColor = UIColor.luxeDarkGray()
            
            size14Title.textColor = UIColor.luxeDarkGray()
            size14Body.textColor = UIColor.luxeDarkGray()
            
            size12Title.textColor = UIColor.luxeDarkGray()
            size12Body.textColor = UIColor.luxeDarkGray()
            
            size10Title.textColor = UIColor.luxeDarkGray()
            size10Body.textColor = UIColor.luxeDarkGray()
        } else {
            container.backgroundColor = UIColor.luxeDarkGray()
            
            size16Title.textColor = UIColor.luxeWhite()
            size16Body.textColor = UIColor.luxeWhite()
            
            size14Title.textColor = UIColor.luxeWhite()
            size14Body.textColor = UIColor.luxeWhite()
            
            size12Title.textColor = UIColor.luxeWhite()
            size12Body.textColor = UIColor.luxeWhite()
            
            size10Title.textColor = UIColor.luxeWhite()
            size10Body.textColor = UIColor.luxeWhite()
            
        }
        
        size16Title.attributedText = Fonts.Sub1(text: "16")
        let attributedText = Fonts.Sub1(text: DebugFontTestViewController.sizeText16)
        size16Body.attributedText = Fonts.updateLetterSpacing(attStr: attributedText, spacing: 80.0)
        size16Body.lineSpacing(lineSpacing: 12)
        
        size14Title.attributedText = Fonts.Body2(text: "14")
        let attributedText14 = Fonts.Body2(text: DebugFontTestViewController.sizeText14)
        size14Body.attributedText = Fonts.updateLetterSpacing(attStr: attributedText14, spacing: 80.0)
        size14Body.lineSpacing(lineSpacing: 12)
        
        size12Title.attributedText = Fonts.captionMedium(text: "12")
        let attributedText12 = Fonts.captionMedium(text: DebugFontTestViewController.sizeText12)
        size12Body.attributedText = Fonts.updateLetterSpacing(attStr: attributedText12, spacing: 100.0)
        size12Body.lineSpacing(lineSpacing: 12)
        
        size10Title.attributedText = Fonts.overline(text: "10")
        let attributedText10 = Fonts.overline(text: DebugFontTestViewController.sizeText10)
        size10Body.attributedText = Fonts.updateLetterSpacing(attStr: attributedText10, spacing: 150.0)
        size10Body.lineSpacing(lineSpacing: 12)
        
        let size16BodyH = size16Body.sizeThatFits(CGSize(width: 240, height: CGFloat(MAXFLOAT))).height
        let size14BodyH = size14Body.sizeThatFits(CGSize(width: 240, height: CGFloat(MAXFLOAT))).height
        let size12BodyH = size12Body.sizeThatFits(CGSize(width: 240, height: CGFloat(MAXFLOAT))).height
        let size10BodyH = size10Body.sizeThatFits(CGSize(width: 240, height: CGFloat(MAXFLOAT))).height
        
        totalHeight = size16BodyH + size14BodyH + size12BodyH + size10BodyH + 150
        
        container.addSubview(size16Title)
        container.addSubview(size16Body)
        container.addSubview(size14Title)
        container.addSubview(size14Body)
        container.addSubview(size12Title)
        container.addSubview(size12Body)
        container.addSubview(size10Title)
        container.addSubview(size10Body)
        
        size16Title.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(20)
            make.width.equalTo(50)
        }
        
        size16Body.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.width.equalTo(240)
            make.top.equalTo(size16Title)
        }
        
        size14Title.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(50)
            make.top.equalTo(size16Body.snp.bottom).offset(30)
        }
        
        size14Body.snp.makeConstraints { make in
            make.width.equalTo(240)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(size14Title)
        }
        
        size12Title.snp.makeConstraints { make in
            make.top.equalTo(size14Body.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(50)
        }
        
        size12Body.snp.makeConstraints { make in
            make.width.equalTo(240)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(size12Title)
        }
        
        size10Title.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(50)
            make.top.equalTo(size12Body.snp.bottom).offset(30)
        }
        
        size10Body.snp.makeConstraints { make in
            make.width.equalTo(240)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(size10Title)
        }
        
        return totalHeight
    }
    
    
    private func fillFontWeight() {
        let fontWeightRegular = Fonts.fontWeight()
        let fontWeightItalic = Fonts.italicFontWeight()
        
        var regularHeight = generateWeightLabel(fontWeight: fontWeightRegular, container: weightWhiteContainerView, text: "Aa Bb Cc Handgloves", textColor: .luxeDarkGray(), topOffset: 0)
        var italicHeight = generateWeightLabel(fontWeight: fontWeightItalic, container: weightWhiteContainerView, text: "Aa Bb Cc Handgloves", textColor: .luxeDarkGray(),topOffset: regularHeight)
        var regularHeightNumber = generateWeightLabel(fontWeight: fontWeightRegular, container: weightWhiteContainerView, text: "1234567890", textColor: .luxeDarkGray(),topOffset: regularHeight + italicHeight)
        var italicHeightNumber = generateWeightLabel(fontWeight: fontWeightItalic, container: weightWhiteContainerView, text: "1234567890", textColor: .luxeDarkGray(),topOffset: regularHeight + italicHeight + regularHeightNumber)

        weightWhiteContainerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(sizesBlackContainerView.snp.bottom).offset(30)
            make.height.equalTo(regularHeight + italicHeight + regularHeightNumber + italicHeightNumber)
        }
        weightWhiteContainerView.sizeToFit()
        
        weightBlackContainerView.backgroundColor = .luxeDarkGray()
        
        regularHeight = generateWeightLabel(fontWeight: fontWeightRegular, container: weightBlackContainerView, text: "Aa Bb Cc Handgloves", textColor: .luxeWhite(),topOffset: 20)
        italicHeight = generateWeightLabel(fontWeight: fontWeightItalic, container: weightBlackContainerView, text: "Aa Bb Cc Handgloves", textColor: .luxeWhite(),topOffset: regularHeight)
        regularHeightNumber = generateWeightLabel(fontWeight: fontWeightRegular, container: weightBlackContainerView, text: "1234567890", textColor: .luxeWhite(),topOffset: regularHeight + italicHeight)
        italicHeightNumber = generateWeightLabel(fontWeight: fontWeightItalic, container: weightBlackContainerView, text: "1234567890", textColor: .luxeWhite(),topOffset: regularHeight + italicHeight + regularHeightNumber)
        
        weightBlackContainerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(weightWhiteContainerView.snp.bottom).offset(30)
            make.height.equalTo(regularHeight + italicHeight + regularHeightNumber + italicHeightNumber)
        }
        weightBlackContainerView.sizeToFit()
    }
    
    private func generateWeightLabel(fontWeight: [String], container: UIView, text: String, textColor: UIColor, topOffset: CGFloat) -> CGFloat {
        var totalHeight: CGFloat = 0
        var previousLabel: UILabel? = nil
        
        for fontName in fontWeight {
            let label = UILabel(frame: .zero)
            label.font = UIFont.customFont(fontName: fontName, size: 20.0)
            label.textAlignment = .center
            label.textColor = textColor
            label.text = text
            
            let labelHeight = label.sizeThatFits(CGSize(width: self.view.frame.width, height: CGFloat(MAXFLOAT))).height
            
            container.addSubview(label)
            label.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.height.equalTo(labelHeight)
                make.top.equalTo(previousLabel == nil ? topOffset : previousLabel!.snp.bottom)
            }
            
            previousLabel = label
            totalHeight += labelHeight
        }
        
        totalHeight += 50
        return totalHeight
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.async {
            if self.contentView.frame.size.height == 0 && self.listContainerView.frame.size.height > 0 {
                self.contentView.snp.remakeConstraints { make in
                    make.edges.equalTo(self.scrollView).inset(UIEdgeInsets.zero)
                    make.width.equalTo(self.scrollView)
                    make.height.greaterThanOrEqualTo(self.listContainerView.frame.size.height
                        + self.bodyBlackContainerView.frame.size.height + self.bodyWhiteContainerView.frame.size.height
                        + self.sizesBlackContainerView.frame.size.height + self.sizesWhiteContainerView.frame.size.height
                        + self.weightWhiteContainerView.frame.size.height + self.weightBlackContainerView.frame.size.height
                        + 180)
                }
            }
        }
    }
    
}
