//
//  TabControlView.swift
//  Nick Fedoroff
//
//  Created by Nick Fedoroff on 10/17/16.
//  Copyright © 2016 Nick Fedoroff. All rights reserved.
//


import UIKit


public protocol NFTabControlViewDelegate {
    func tabControlView(controlView: NFTabControlView, didSelectTabAt index: Int)
}

public enum NFTabControlViewIndicatorStyle {
    case tabWidth
    case dot
}

public class NFTabControlView: UIView {
    
    private let nibName = String(describing: NFTabControlView.self)
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var segmentedControl: BorderlessSegmentedControl!
    @IBOutlet weak var indicator: UIView!
    @IBOutlet weak var indicatorHorizPositionConstraint: NSLayoutConstraint!
    @IBOutlet weak var indicatorVertPositionConstraint: NSLayoutConstraint!
    @IBOutlet weak var indicatorWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var indicatorHeightConstraint: NSLayoutConstraint!
    
    public private(set) var color: UIColor? {
        didSet {
            segmentedControl.tintColor = color
            indicator.backgroundColor = color
        }
    }
    
    public private(set) var indicatorStyle: NFTabControlViewIndicatorStyle? {
        didSet {
            guard let indicatorStyle = indicatorStyle else { return }
            
            switch indicatorStyle {
            case .dot:
                indicatorWidthConstraint.constant = indicatorHeightConstraint.constant
                indicator.layer.cornerRadius = indicatorHeightConstraint.constant / 2
                indicator.layer.masksToBounds = true
            case .tabWidth:
                print("max")
            }
        }
    }
    
    public var delegate: NFTabControlViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    private func commonInit() {
        Bundle(for: NFTabControlView.self).loadNibNamed(nibName, owner: self, options: nil)
        guard let content = view else { return }
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(content)
        
        view.backgroundColor = .clear
        segmentedControl.selectedSegmentIndex = 0

        NotificationCenter.default.addObserver(self, selector: #selector(NFTabControlView.respondToOrientationChange(notification:)), name: Notification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    // Public Methods
    
    public func setIndicator(style: NFTabControlViewIndicatorStyle) {
        indicatorStyle = style
    }
    
    public func setNormal(font: UIFont) {
        segmentedControl.setTitleTextAttributes([NSFontAttributeName: font], for: .normal)
    }
    
    public func setSelected(font: UIFont) {
        segmentedControl.setTitleTextAttributes([NSFontAttributeName: font], for: .selected)
    }
    
    public func set(tabs: [String]) {
        segmentedControl.removeAllSegments()
        for (index, tab) in tabs.enumerated() {
            segmentedControl.insertSegment(withTitle: tab, at: index, animated: false)
        }
        segmentedControl.selectedSegmentIndex = 0
    }
    
    public func set(color: UIColor) {
        self.color = color
    }
    
    // Private/Internal Methods
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if indicatorStyle == .some(.tabWidth) {
            indicatorWidthConstraint.constant = view.bounds.width / CGFloat(segmentedControl.numberOfSegments)
        }
    }
    
    @objc private func respondToOrientationChange(notification: Notification) {
        setIndicatorPosition(forSegmentAt: segmentedControl.selectedSegmentIndex, animated: false)
    }
    
    override public func draw(_ rect: CGRect) {
        setIndicatorPosition(forSegmentAt: segmentedControl.selectedSegmentIndex, animated: false)
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        delegate?.tabControlView(controlView: self, didSelectTabAt: sender.selectedSegmentIndex)
        setIndicatorPosition(forSegmentAt: sender.selectedSegmentIndex, animated: true)
    }
    
    public func setIndicatorPosition(forSegmentAt index: Int, animated: Bool) {
        let segmentWidth = bounds.width / CGFloat(segmentedControl.numberOfSegments)
        let index = CGFloat(index + 1)
        let indicatorWidth = indicator.frame.width
        let position = index * segmentWidth - (segmentWidth / 2) - (indicatorWidth / 2)
        
        indicatorHorizPositionConstraint.constant = position
        if animated == true {
            UIView.animate(withDuration: 0.25, delay: 0.0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}


class BorderlessSegmentedControl: UISegmentedControl {
    
    override func draw(_ rect: CGRect) {
        removeBorders()
    }
    
    private func removeBorders() {
        let clearImage = imageWithColor(color: .clear)
        setBackgroundImage(clearImage, for: .normal, barMetrics: .default)
        setBackgroundImage(clearImage, for: .selected, barMetrics: .default)
        setDividerImage(clearImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
    
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
    
}
