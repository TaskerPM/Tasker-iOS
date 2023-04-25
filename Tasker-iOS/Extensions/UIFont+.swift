//
//  UIFont+.swift
//  Tasker-iOS
//
//  Created by mingmac on 2023/04/25.
//

import UIKit

extension UIFont {
    enum FontType {
//        enum Pretentdard: String {
//            case bold = "Pretendard-Bold"
//            case extraBold = "Pretendard-ExtraBold"
//            case light = "Pretendard-Light"
//            case medium = "Pretendard-Medium"
//            case regular = "Pretendard-Regular"
//            case semiBold = "Pretendard-semiBold"
//        }
        
        enum Mattone: String {
            case regular = "Mattone-Regular"
        }
        
        enum SansCaption: String {
            case regular = "PTSans-Caption"
            case bold = "PTSans-CaptionBold"
        }
    }
    
//    static func pretendardFont(size: CGFloat, style: FontType.Pretentdard) -> UIFont {
//        return UIFont(name: style.rawValue, size: size)!
//    }
//
    static func mattoneFont(size: CGFloat, style: FontType.Mattone) -> UIFont {
        return UIFont(name: style.rawValue, size: size) ?? .systemFont(ofSize: size, weight: .regular)
    }
    
    static func sansCaptionFont(size: CGFloat, style: FontType.SansCaption) -> UIFont {
        return UIFont(name: style.rawValue, size: size) ?? .systemFont(ofSize: size, weight: .regular)
    }
    
    static func printAll() {
        familyNames.sorted().forEach { familyName in
            print("*** \(familyName) ***")
            fontNames(forFamilyName: familyName).sorted().forEach { fontName in
                print("\(fontName)")
            }
        }
    }
}
