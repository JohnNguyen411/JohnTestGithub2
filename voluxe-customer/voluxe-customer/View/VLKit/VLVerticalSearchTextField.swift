//
//  VLVerticalSearchTextField.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 2/12/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

/**
 Should be created with a height of 75 in constraints of the caller. LuxeVerticalTextField.verticalHeight
 */
class VLVerticalSearchTextField : VLVerticalTextField {
    
    public static let defaultCellHeight: CGFloat = 30

    open var delegate: VLVerticalSearchTextFieldDelegate?
    /// Maximum number of results to be shown in the suggestions list
    open var maxNumberOfResults = 0
    
    // Move the table around to customize for your layout
    open var tableXOffset: CGFloat = 0.0
    open var tableYOffset: CGFloat = 0.0
    open var tableCornerRadius: CGFloat = 2.0
    open var tableBottomMargin: CGFloat = 10.0
    
    /// Indicate if this field has been interacted with yet
    open var interactedWith = false
    /// Maximum height of the results list
    open var maxResultsListHeight = 0
    
    /// Force no filtering (display the entire filtered data source)
    open var forceNoFiltering: Bool = false
    
    fileprivate var tableView: UITableView?
    fileprivate var shadowView: UIView?
    fileprivate static let cellIdentifier = "VLVerticalSearchTextField"
    
    fileprivate var filteredResults = [SearchTextFieldItem]()
    

    /// Set your custom visual theme, or just choose between pre-defined SearchTextFieldTheme.lightTheme() and SearchTextFieldTheme.darkTheme() themes
    open var theme = SearchTextFieldTheme.lightTheme() {
        didSet {
            tableView?.reloadData()
        }
    }
    
    // Clean filtered results
    public func clearResults() {
        filteredResults.removeAll()
        tableView?.removeFromSuperview()
    }
    
    public func closeAutocomplete() {
        tableView?.removeFromSuperview()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        buildSearchTableView()
    }
    
    /// Set an array of SearchTextFieldItem's to be used for suggestions
    open func filteredItems(_ items: [SearchTextFieldItem]) {
        if items.count > 0 {
            interactedWith = true
        }
        if tableView?.superview == nil {
            buildSearchTableView()
        }
        filteredResults = items
        redrawSearchTableView()
    }
    
    /// Set an array of strings to be used for suggestions
    open func filteredStrings(_ strings: [String]) {
        var items = [SearchTextFieldItem]()
        
        for value in strings {
            items.append(SearchTextFieldItem(title: value))
        }
        
        filteredItems(items)
    }
    
   
    
    // Create the filter table and shadow view
    fileprivate func buildSearchTableView() {
        if let tableView = tableView, let shadowView = shadowView {
            tableView.layer.masksToBounds = true
            tableView.layer.borderWidth = theme.borderWidth > 0 ? theme.borderWidth : 0.5
            tableView.dataSource = self
            tableView.delegate = self
            tableView.separatorInset = UIEdgeInsets.zero
            
            shadowView.backgroundColor = UIColor.lightText
            shadowView.layer.shadowColor = UIColor.black.cgColor
            shadowView.layer.shadowOffset = CGSize.zero
            shadowView.layer.shadowOpacity = 1
            
            self.window?.addSubview(tableView)
        } else {
            tableView = UITableView(frame: CGRect.zero)
            shadowView = UIView(frame: CGRect.zero)
        }
        
        redrawSearchTableView()
    }
    
    
    // Re-set frames and theme colors
    fileprivate func redrawSearchTableView() {
        if let tableView = tableView {
            guard let frame = self.superview?.convert(self.frame, to: nil) else { return }
            
            var tableHeight = min((tableView.contentSize.height), (UIScreen.main.bounds.size.height - frame.origin.y - frame.height))
            
            if maxResultsListHeight > 0 {
                tableHeight = min(tableHeight, CGFloat(maxResultsListHeight))
            }
            
            // Set a bottom margin of 10p
            if tableHeight < tableView.contentSize.height {
                tableHeight -= tableBottomMargin
            }
            
            var tableViewFrame = CGRect(x: 0, y: 0, width: frame.size.width - 4, height: tableHeight)
            tableViewFrame.origin = self.convert(tableViewFrame.origin, to: nil)
            tableViewFrame.origin.x += 2 + tableXOffset
            tableViewFrame.origin.y += frame.size.height + 2 + tableYOffset
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.tableView?.frame = tableViewFrame
            })
            
            Logger.print("tableViewFrame \(tableViewFrame)")
            
            var shadowFrame = CGRect(x: 0, y: 0, width: frame.size.width - 6, height: 1)
            shadowFrame.origin = self.convert(shadowFrame.origin, to: nil)
            shadowFrame.origin.x += 3
            shadowFrame.origin.y = tableView.frame.origin.y
            shadowView!.frame = shadowFrame
            
            superview?.bringSubview(toFront: tableView)
            superview?.bringSubview(toFront: shadowView!)
            
            if self.isFirstResponder {
                superview?.bringSubview(toFront: self)
            }
            
            tableView.layer.borderColor = theme.borderColor.cgColor
            tableView.layer.cornerRadius = tableCornerRadius
            tableView.separatorColor = theme.separatorColor
            tableView.backgroundColor = theme.bgColor
            
            tableView.reloadData()
        }
    }
}


extension VLVerticalSearchTextField: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.isHidden = !interactedWith || (filteredResults.count == 0)
        shadowView?.isHidden = !interactedWith || (filteredResults.count == 0)
        
        if maxNumberOfResults > 0 {
            return min(filteredResults.count, maxNumberOfResults)
        } else {
            return filteredResults.count
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: VLVerticalSearchTextField.cellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: VLVerticalSearchTextField.cellIdentifier)
        }
        
        if filteredResults.count > indexPath.row {
            
            cell!.backgroundColor = UIColor.clear
            cell!.layoutMargins = UIEdgeInsets.zero
            cell!.preservesSuperviewLayoutMargins = false
            cell!.textLabel?.font = theme.font
            cell!.textLabel?.textColor = theme.fontColor
            
            cell!.textLabel?.text = filteredResults[(indexPath as NSIndexPath).row].title
            //cell!.textLabel?.attributedText = filteredResults[(indexPath as NSIndexPath).row].attributedTitle
            
            cell!.selectionStyle = .none
        }
        
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return theme.cellHeight
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.text = filteredResults[(indexPath as NSIndexPath).row].title
        if let delegate = delegate {
            delegate.onAutocompleteSelected(selectedIndex: indexPath.row)
        }
        clearResults()
    }
}


////////////////////////////////////////////////////////////////////////
// Search Text Field Theme
public struct SearchTextFieldTheme {
    public var cellHeight: CGFloat
    public var bgColor: UIColor
    public var borderColor: UIColor
    public var borderWidth : CGFloat = 0
    public var separatorColor: UIColor
    public var font: UIFont
    public var fontColor: UIColor
    public var subtitleFontColor: UIColor
    public var placeholderColor: UIColor?
    
    init(cellHeight: CGFloat, bgColor:UIColor, borderColor: UIColor, separatorColor: UIColor, font: UIFont, fontColor: UIColor, subtitleFontColor: UIColor? = nil) {
        self.cellHeight = cellHeight
        self.borderColor = borderColor
        self.separatorColor = separatorColor
        self.bgColor = bgColor
        self.font = font
        self.fontColor = fontColor
        self.subtitleFontColor = subtitleFontColor ?? fontColor
    }
    
    public static func lightTheme() -> SearchTextFieldTheme {
        return SearchTextFieldTheme(cellHeight: VLVerticalSearchTextField.defaultCellHeight, bgColor: UIColor (red: 1, green: 1, blue: 1, alpha: 1.0), borderColor: UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0), separatorColor: UIColor.clear, font: UIFont.systemFont(ofSize: 10), fontColor: UIColor.black)
    }
    
    public static func darkTheme() -> SearchTextFieldTheme {
        return SearchTextFieldTheme(cellHeight: VLVerticalSearchTextField.defaultCellHeight, bgColor: UIColor (red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0), borderColor: UIColor (red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0), separatorColor: UIColor.clear, font: UIFont.systemFont(ofSize: 10), fontColor: UIColor.white)
    }
}

////////////////////////////////////////////////////////////////////////
// Filter Item
open class SearchTextFieldItem {
    
    // Public interface
    public var title: String
    public var subtitle: String?
    
    public init(title: String, subtitle: String?) {
        self.title = title
        self.subtitle = subtitle
    }
    
    public init(title: String) {
        self.title = title
    }
}

// MARK: protocol onSelectionChanged
protocol VLVerticalSearchTextFieldDelegate {
    func onAutocompleteSelected(selectedIndex: Int)
}
