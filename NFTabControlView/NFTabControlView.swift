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
    
    /// Determines the number and titles of tabs.
    /// Tabs are arranged in the order provided in the array.
    func tabControlView(titlesForTabsIn controlView: NFTabControlView) -> [String]
    
    /// Sets the color of the text and indicator
    func tabControlView(colorFor controlView: NFTabControlView) -> UIColor
    
    /// Sets the font of the tab titles
    func tabControlView(fontFor controlView: NFTabControlView) -> UIFont?
    func tabControlView(fontForselectedTabIn controlView: NFTabControlView) -> UIFont?
    
    /// Sets the width of the indicator
    func tabControlView(indicatorStyleFor controlView: NFTabControlView) -> NFTabControlViewIndicatorStyle?
}

public extension NFTabControlViewDelegate {
    func tabControlView(fontFor controlView: NFTabControlView) -> UIFont? {
        return UIFont.systemFont(ofSize: 13)
    }
    func tabControlView(fontForselectedTabIn controlView: NFTabControlView) -> UIFont? {
        return UIFont.boldSystemFont(ofSize: 13)
    }
    func tabControlView(indicatorStyleFor controlView: NFTabControlView) -> NFTabControlViewIndicatorStyle? {
        return nil
    }
}

public enum NFTabControlViewIndicatorStyle {
    case tabWidth
    case dot
}

public class NFTabControlView: UIView, UIGestureRecognizerDelegate {
    
    private let nibName = String(describing: NFTabControlView.self)
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var segmentedControl: BorderlessSegmentedControl!
    @IBOutlet weak var indicator: UIView!
    @IBOutlet weak var indicatorHorizPositionConstraint: NSLayoutConstraint!
    @IBOutlet weak var indicatorVertPositionConstraint: NSLayoutConstraint!
    @IBOutlet weak var indicatorWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var indicatorHeightConstraint: NSLayoutConstraint!
    
    private var color: UIColor? {
        didSet {
            if let color = color {
                segmentedControl.tintColor = color
                indicator.backgroundColor = color
            }
        }
    }
    
    private var indicatorStyle: NFTabControlViewIndicatorStyle? {
        didSet {
            guard let indicatorStyle = indicatorStyle else {
                return
            }
            
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
    
    public var delegate: NFTabControlViewDelegate? {
        didSet {
            setup()
        }
    }
    
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

    }
    
    ///Apply delegate settings
    private func setup() {
        guard let delegate = delegate else {
            return
        }
        
        // Set up tabs
        segmentedControl.removeAllSegments()
        let titles = delegate.tabControlView(titlesForTabsIn: self)
        for (index, title) in titles.enumerated() {
            segmentedControl.insertSegment(withTitle: title, at: index, animated: false)
        }
        segmentedControl.selectedSegmentIndex = 0
        
        // Color
        self.color = delegate.tabControlView(colorFor: self)
        
        // Font
        let font = delegate.tabControlView(fontFor: self)!
        segmentedControl.setTitleTextAttributes([NSFontAttributeName: font], for: .normal)
        
        let selectedFont = delegate.tabControlView(fontForselectedTabIn: self)!
        segmentedControl.setTitleTextAttributes([NSFontAttributeName: selectedFont], for: .selected)
        
        
        // Indicator Style
        if let style = delegate.tabControlView(indicatorStyleFor: self) {
            indicatorStyle = style
        }
        
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if indicatorStyle == .some(.tabWidth) {
            indicatorWidthConstraint.constant = view.bounds.width / CGFloat(segmentedControl.numberOfSegments)
        }
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
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
