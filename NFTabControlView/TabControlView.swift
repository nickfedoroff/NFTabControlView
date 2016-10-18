//
//  TabControlView.swift
//  Nick Fedoroff
//
//  Created by Nick Fedoroff on 10/17/16.
//  Copyright © 2016 Nick Fedoroff. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit


protocol TabControlViewDelegate {
    
    func tabControlView(controlView: TabControlView, didSelectTabAt index: Int)
    /// Determines the number and titles of tabs.
    /// Tabs are arranged in the order provided in the array.
    func tabControlView(titlesForTabsIn controlView: TabControlView) -> [String]
    /// Sets the color of the text and indicator
    func tabControlView(colorFor controlView: TabControlView) -> UIColor
    /// Sets the font of the tab titles
    func tabControlView(fontFor controlView: TabControlView) -> UIFont?
}

extension TabControlViewDelegate {
    func tabControlView(fontFor controlView: TabControlView) -> UIFont? {
        return nil
    }
}

class TabControlView: UIView {
    
    let nibName = String(describing: TabControlView.self)
    @IBOutlet var view: UIView!
    @IBOutlet weak var segmentedControl: BorderlessSegmentedControl!
    @IBOutlet weak var indicator: UIView!
    @IBOutlet weak var indicatorHorizPositionConstraint: NSLayoutConstraint!
    
    public var color: UIColor? {
        didSet {
            if let color = color {
                segmentedControl.tintColor = color
                indicator.backgroundColor = color
            }
        }
    }
    
    var delegate: TabControlViewDelegate? {
        didSet {
            commonInit()
        }
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    private func commonInit() {
        Bundle(for: TabControlView.self).loadNibNamed(nibName, owner: self, options: nil)
        guard let content = view else { return }
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(content)
        
        // custom code
        view.backgroundColor = .clear
//        indicator.layer.cornerRadius = 1.5
//        indicator.layer.masksToBounds = true
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
        if let font = delegate.tabControlView(fontFor: self) {
            segmentedControl.setTitleTextAttributes([NSFontAttributeName: font], for: .normal)
        } else {
            let font = UIFont.systemFont(ofSize: 13)
            segmentedControl.setTitleTextAttributes([NSFontAttributeName: font], for: .normal)
        }
        
    }
    
    override func draw(_ rect: CGRect) {
        setIndicatorPosition(forSegmentAt: segmentedControl.selectedSegmentIndex, animated: false)
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        delegate?.tabControlView(controlView: self, didSelectTabAt: sender.selectedSegmentIndex)
        setIndicatorPosition(forSegmentAt: sender.selectedSegmentIndex, animated: true)
    }
    
    private func setIndicatorPosition(forSegmentAt index: Int, animated: Bool) {
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

    
    
}
