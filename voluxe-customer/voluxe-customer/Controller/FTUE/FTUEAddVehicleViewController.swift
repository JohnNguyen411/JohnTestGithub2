//
//  FTUEAddVehicleViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 3/1/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD
import RealmSwift

class FTUEAddVehicleViewController: FTUEChildViewController, FTUEProtocol, UITextFieldDelegate {
    
    enum PickerType {
        case year
        case model
        case color
    }
    
    let colors = [Color(baseColor: "beige", color: "Beige"), Color(baseColor: "black", color: "Black"), Color(baseColor: "blue", color: "Blue"), Color(baseColor: "brown", color: "Brown"), Color(baseColor: "copper", color: "Copper"), Color(baseColor: "gold", color: "Gold"), Color(baseColor: "green", color: "Green"), Color(baseColor: "grey", color: "Grey"), Color(baseColor: "orange", color: "Orange"), Color(baseColor: "purple", color: "Purple"), Color(baseColor: "red", color: "Red"), Color(baseColor: "sand", color: "Sand"), Color(baseColor: "silver", color: "Silver"), Color(baseColor: "white", color: "White"), Color(baseColor: "yellow", color: "Yellow")]
    let years = [2018, 2017, 2016, 2015, 2014, 2013, 2012, 2011, 2010, 2009, 2008, 2007, 2006, 2005, 2004, 2003, 2002, 2001, 2000, 1999, 1998, 1997, 1996, 1995]
    let models = [VehicleModel(make: "Volvo", model: "XC90"), VehicleModel(make: "Volvo", model: "XC60"), VehicleModel(make: "Volvo", model: "XC40"), VehicleModel(make: "Volvo", model: "S90"), VehicleModel(make: "Volvo", model: "S60")]
    
    var realm: Realm?
    
    let label: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.text = .SelectYourVehicle
        textView.font = .volvoSansLight(size: 18)
        textView.textColor = .luxeDarkGray()
        textView.backgroundColor = .clear
        textView.numberOfLines = 0
        return textView
    }()
    
    var pickerType = PickerType.year
    
    var selectedYear = -1
    var selectedModel = -1
    var selectedColor = -1
    
    let yearLabel = VLVerticalTextField(title: .Year, placeholder: .YearPlaceholder)
    let modelLabel = VLVerticalTextField(title: .Model, placeholder: .ModelPlaceholder)
    let colorLabel = VLVerticalTextField(title: .Color, placeholder: .ColorPlaceholder)
    
    var pickerView: UIPickerView!
    let pickerToolBar = UIToolbar(frame: .zero)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        realm = try? Realm()
       
        yearLabel.textField.delegate = self
        modelLabel.textField.delegate = self
        colorLabel.textField.delegate = self

        setupViews()
        
        canGoNext(nextEnabled: false)
    }
    
    private func setupViews() {
        self.view.addSubview(label)
        self.view.addSubview(yearLabel)
        self.view.addSubview(modelLabel)
        self.view.addSubview(colorLabel)
        
        
        label.snp.makeConstraints { (make) -> Void in
            make.left.top.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
        
        yearLabel.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(label)
            make.top.equalTo(label.snp.bottom).offset(10)
            make.height.equalTo(VLVerticalTextField.height)
        }
        
        modelLabel.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(label)
            make.top.equalTo(yearLabel.snp.bottom).offset(20)
            make.height.equalTo(VLVerticalTextField.height)
        }
        
        colorLabel.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(label)
            make.top.equalTo(modelLabel.snp.bottom).offset(20)
            make.height.equalTo(VLVerticalTextField.height)
        }
    }
    
    @objc func donePicker() {
        let row = pickerView.selectedRow(inComponent: 0)
        if pickerType == .year {
            selectedYear = row
            yearLabel.textField.text = "\(years[row])"
        } else if pickerType == .model {
            selectedModel = row
            modelLabel.textField.text = models[row].model
        } else {
            selectedColor = row
            colorLabel.textField.text = colors[row].color
        }
        cancelPicker()
        _ = checkTextFieldsValidity()
    }
    
    @objc func cancelPicker() {
        if pickerType == .year {
            yearLabel.textField.resignFirstResponder()
        } else if pickerType == .model {
            modelLabel.textField.resignFirstResponder()
        } else {
            colorLabel.textField.resignFirstResponder()
        }
    }

    
    func pickUp(_ textField : UITextField){
        
        // UIPickerView
        self.pickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerView.backgroundColor = UIColor.white
        textField.inputView = self.pickerView
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: .Done, style: .plain, target: self, action: #selector(FTUEAddVehicleViewController.donePicker))
        doneButton.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.luxeDarkBlue()], for: .normal)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: .Cancel, style: .plain, target: self, action: #selector(FTUEAddVehicleViewController.cancelPicker))
        cancelButton.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.luxeDarkBlue()], for: .normal)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
        // select default value
        if pickerType == .year && selectedYear >= 0 {
            pickerView.selectRow(selectedYear, inComponent: 0, animated: false)
        } else if pickerType == .model && selectedModel >= 0 {
            pickerView.selectRow(selectedModel, inComponent: 0, animated: false)
        } else if pickerType == .color && selectedColor >= 0 {
            pickerView.selectRow(selectedColor, inComponent: 0, animated: false)
        }
    }
    
    func didSelectPage() {
    }
    
    func nextButtonTap() -> Bool {
        return true
    }
    
    override func checkTextFieldsValidity() -> Bool {
        let enabled = selectedColor >= 0 && selectedYear >= 0 && selectedModel >= 0
        canGoNext(nextEnabled: enabled)
        return enabled
    }
}

extension FTUEAddVehicleViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerType == .year {
            return years.count
        } else if pickerType == .model {
            return models.count
        } else {
            return colors.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerType == .year {
            return "\(years[row])"
        } else if pickerType == .model {
            return models[row].model
        } else {
            return colors[row].color
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == yearLabel.textField {
            pickerType = .year
        } else if textField == modelLabel.textField {
            pickerType = .model
        } else {
            pickerType = .color
        }
        
        pickUp(textField)

        return true
    }
    
    
}
