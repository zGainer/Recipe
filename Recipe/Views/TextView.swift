//
//  TextView.swift
//  Recipe
//
//  Created by Eugene on 29.04.23.
//

import UIKit

final class TextView: UITextView {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        layer.cornerRadius = Setting.cornerRadius
    }
}

// MARK: - Text View Placeholder

extension TextView {
    
    var placeholder: String? {
        get {
            return (self.viewWithTag(100) as? UILabel)?.text
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                let placeholderLabel = UILabel()
                
                placeholderLabel.text = newValue
                placeholderLabel.tag = 100
                placeholderLabel.textColor = .placeholderText
                placeholderLabel.numberOfLines = 0
                placeholderLabel.sizeToFit()
                placeholderLabel.isHidden = !self.text.isEmpty
                
                self.addSubview(placeholderLabel)
                self.resizePlaceholder()
            }
        }
    }
    
    func resizePlaceholder() {
        
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            let labelX = self.textContainerInset.left + 4.0
            let labelY = self.textContainerInset.top
            let labelWidth = self.frame.width - labelX - self.textContainerInset.right - 4.0
            let labelHeight = placeholderLabel.frame.height
            
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
}
