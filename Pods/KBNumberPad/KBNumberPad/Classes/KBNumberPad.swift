//
//  KBNumberPad.swift
//  Pods
//
//  Created by Kirill Biakov on 01/21/2017.
//  Copyright (c) 2017 Kirill Biakov. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Delegate

public protocol KBNumberPadDelegate {

    func onNumberClicked(numberPad: KBNumberPad, number: Int);
    func onDoneClicked(numberPad: KBNumberPad);
    func onClearClicked(numberPad: KBNumberPad);
}

// MARK: - View

public class KBNumberPad: UIView {


    private static let nibName = "KBNumberPad"
    private static let clearSymbolIconName = "ClearSymbolIcon"
    private static let clearSymbolFilledIconName = "ClearSymbolFilledIcon"
    
    private static let estimatedWidth = Int(UIScreen.main.bounds.width)
    private static var estimatedHeight = 226
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var numberButtons: [UIButton]!
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var clearButton: UIButton!
    

    
    public var delegate: KBNumberPadDelegate?
    
    // MARK: - Init
    
    convenience init() {
        self.init(frame: KBNumberPad.defaultRect())
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupViewFromXib()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViewFromXib()
    }
    
    deinit {
        delegate = nil
    }
    
    private func setupViewFromXib() {
        let nib = UINib(nibName: KBNumberPad.nibName, bundle: bundle())
            .instantiate(withOwner: self, options: nil)
        
        let view = nib.first as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    fileprivate func loadIcon(name: String) -> UIImage? {
        let image = UIImage(named: name, in: bundle(), compatibleWith: nil)
        let colorable = UIImage.RenderingMode.alwaysTemplate
        return image?.withRenderingMode(colorable)
    }
    
    private static func defaultRect() -> CGRect {
        
        let deviceModelName = UIDevice.current.modelName
        if deviceModelName == "iPhone X" {
            KBNumberPad.estimatedHeight = 291
        }
        print("디바이스 네임 :::::::::::::::::::::::::::::::::::::::")
        print(deviceModelName)
        print(KBNumberPad.estimatedHeight)
        print("디바이스 네임 :::::::::::::::::::::::::::::::::::::::")
        return CGRect(x: 0,
                      y: 0,
                      width: KBNumberPad.estimatedWidth,
                      height: KBNumberPad.estimatedHeight)
    }
    
    private func bundle() -> Bundle {
        return Bundle(for: type(of: self))
    }
    
    // MARK: - Public methods
    
    public func setDelimiterColor(_ color: UIColor) {
        containerView.backgroundColor = color
    }
    
    public func setButtonsColor(_ color: UIColor) {
        setNumberButtonsColor(color)
        setDoneButtonColor(color)
        setClearButtonColor(color)
    }
    
    public func setButtonsBackgroundColor(_ color: UIColor) {
        [numberButtons, [doneButton, clearButton]].joined().forEach {
            $0.backgroundColor = color
        }
    }
    
    // - Number buttons
    
    public func setNumberButtonsColor(_ color: UIColor) {
        numberButtons.forEach {
            $0.setTitleColor(color, for: UIControl.State.normal)
        }
    }
    
    public func setNumberButtonsFont(_ font: UIFont) {
        numberButtons.forEach {
            $0.titleLabel?.font = font
        }
    }
    
    // - Done button
    
    public func setDoneButtonColor(_ color: UIColor) {
        doneButton.setTitleColor(color, for: UIControl.State.normal)
    }
    
    public func setDoneButtonFont(_ font: UIFont) {
        doneButton.titleLabel?.font = font
    }
    
    public func setDoneButtonTitle(_ title: String) {
        doneButton.titleLabel?.text = title
    }
    
    public func setDoneButtonBackgroundColor(_ color: UIColor) {
        doneButton.backgroundColor = color
    }
    
    // - Clear button
    
    public func setClearButtonColor(_ color: UIColor) {
        clearButton.tintColor = color
    }
    
    public func setClearButtonImage(_ image: UIImage) {
        clearButton.imageView?.image = image
    }
    
    public func setClearButtonBackgroundColor(_ color: UIColor) {
        clearButton.backgroundColor = color
    }
    
    public func resetClearButtonImage(isFilled: Bool = false) {
        let iconName = isFilled ?
            KBNumberPad.clearSymbolFilledIconName :
            KBNumberPad.clearSymbolIconName
        
        let image = loadIcon(name: iconName)
        
        setClearButtonImage(image!)
    }
    
    // MARK: - IBActions
    
    @IBAction func onNumberClicked(_ sender: UIButton) {
        let number = Int((sender.titleLabel?.text)!)
        delegate?.onNumberClicked(numberPad: self, number: number!)
    }
    
    @IBAction func onDoneClicked(_ sender: UIButton) {
        delegate?.onDoneClicked(numberPad: self)
    }
    
    @IBAction func onClearClicked(_ sender: UIButton) {
        delegate?.onClearClicked(numberPad: self)
    }
}

public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad6,11", "iPad6,12":                    return "iPad 5"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
        case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9 Inch 2. Generation"
        case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5 Inch"
        case "AppleTV5,3":                              return "Apple TV"
        case "AppleTV6,2":                              return "Apple TV 4K"
        case "AudioAccessory1,1":                       return "HomePod"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
}



