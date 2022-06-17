//
//  NSMutableAttributedString+weight.swift
//  Pics
//
//  Created by Eduardo Vital Alencar Cunha on 17/06/2022.
//

import UIKit

extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String, color: UIColor? = nil, size: CGFloat = UIFont.systemFontSize) -> NSMutableAttributedString {
           var attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: size)
           ]
           if let color = color {
               attrs[.foregroundColor] = color
           }
           let boldString = NSMutableAttributedString(string: text, attributes: attrs)
           append(boldString)
           return self
       }

       @discardableResult func normal(_ text: String, color: UIColor? = nil, size: CGFloat = UIFont.systemFontSize) -> NSMutableAttributedString {
           var attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: size)
           ]
           if let color = color {
               attrs[.foregroundColor] = color
           }
           let normal = NSMutableAttributedString(string: text, attributes: attrs)
           append(normal)
           return self
       }
}
