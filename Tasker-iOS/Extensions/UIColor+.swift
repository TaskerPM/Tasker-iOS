//
//  UIColor+.swift
//  Tasker-iOS
//
//  Created by mingmac on 2023/04/25.
//

import UIKit

enum AssetsColor {
    case basicBlack, basicRed, text, note
    case gray10, gray15, gray20, gray25, gray30, gray100,
         gray150, gray200, gray230, gray250, gray300,
         gray400, gray500, gray600, gray700, gray800,
         gray900, white, black, modalBackground
    case iphoneBule, error, teal
    case redBg, redText
    case orangeBg, orangeText
    case yellowBg, yellowText
    case greenBg, greenText
    case blueBg, blueText
    case purpleBg, purpleText
    
}

extension UIColor {
    static func setColor(_ name: AssetsColor) -> UIColor {
        switch name {
        case .basicBlack:
            return UIColor(red: 31/255.0, green: 31/255.0, blue: 31/255.0, alpha: 1)
        case .basicRed:
            return UIColor(red: 208/255.0, green: 93/255.0, blue: 77/255.0, alpha: 1)
        case .text:
            return UIColor(red: 89/255.0, green: 89/255.0, blue: 89/255.0, alpha: 1)
        case .note:
            return UIColor(red: 244/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
        case .gray10:
            return UIColor(red: 249/255.0, green: 249/255.0, blue: 249/255.0, alpha: 1)
        case .gray15:
            return UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1)
        case .gray20:
            return UIColor(red: 243/255.0, green: 243/255.0, blue: 243/255.0, alpha: 1)
        case .gray25:
            return UIColor(red: 239/255.0, green: 239/255.0, blue: 239/255.0, alpha: 1)
        case .gray30:
            return UIColor(red: 232/255.0, green: 232/255.0, blue: 232/255.0, alpha: 1)
        case .gray100:
            return UIColor(red: 226/255.0, green: 226/255.0, blue: 226/255.0, alpha: 1)
        case .gray150:
            return UIColor(red: 222/255.0, green: 222/255.0, blue: 222/255.0, alpha: 1)
        case .gray200:
            return UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1)
        case .gray230:
            return UIColor(red: 198/255.0, green: 198/255.0, blue: 198/255.0, alpha: 1)
        case .gray250:
            return UIColor(red: 182/255.0, green: 182/255.0, blue: 182/255.0, alpha: 1)
        case .gray300:
            return UIColor(red: 165/255.0, green: 165/255.0, blue: 165/255.0, alpha: 1)
        case .gray400:
            return UIColor(red: 156/255.0, green: 156/255.0, blue: 156/255.0, alpha: 1)
        case .gray500:
            return UIColor(red: 130/255.0, green: 130/255.0, blue: 130/255.0, alpha: 1)
        case .gray600:
            return UIColor(red: 107/255.0, green: 107/255.0, blue: 107/255.0, alpha: 1)
        case .gray700:
            return UIColor(red: 95/255.0, green: 95/255.0, blue: 95/255.0, alpha: 1)
        case .gray800:
            return UIColor(red: 86/255.0, green: 86/255.0, blue: 86/255.0, alpha: 1)
        case .gray900:
            return UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
        case .white:
            return UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
        case .black:
            return UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1)
        case .modalBackground:
            return UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.7)
        case .iphoneBule:
            return UIColor(red: 0/255.0, green: 121/255.0, blue: 253/255.0, alpha: 1)
        case .error:
            return UIColor(red: 248/255.0, green: 103/255.0, blue: 103/255.0, alpha: 1)
        case .teal:
            return UIColor(red: 100/255.0, green: 173/255.0, blue: 169/255.0, alpha: 1)
        case .redBg:
            return UIColor(red: 255/255.0, green: 229/255.0, blue: 229/255.0, alpha: 1)
        case .redText:
            return UIColor(red: 216/255.0, green: 122/255.0, blue: 122/255.0, alpha: 1)
        case .orangeBg:
            return UIColor(red: 251/255.0, green: 235/255.0, blue: 211/255.0, alpha: 1)
        case .orangeText:
            return UIColor(red: 222/255.0, green: 155/255.0, blue: 56/255.0, alpha: 1)
        case .yellowBg:
            return UIColor(red: 255/255.0, green: 249/255.0, blue: 198/255.0, alpha: 1)
        case .yellowText:
            return UIColor(red: 219/255.0, green: 174/255.0, blue: 15/255.0, alpha: 1)
        case .greenBg:
            return UIColor(red: 230/255.0, green: 251/255.0, blue: 205/255.0, alpha: 1)
        case .greenText:
            return UIColor(red: 134/255.0, green: 186/255.0, blue: 70/255.0, alpha: 1)
        case .blueBg:
            return UIColor(red: 218/255.0, green: 248/255.0, blue: 250/255.0, alpha: 1)
        case .blueText:
            return UIColor(red: 96/255.0, green: 185/255.0, blue: 191/255.0, alpha: 1)
        case .purpleBg:
            return UIColor(red: 242/255.0, green: 230/255.0, blue: 250/255.0, alpha: 1)
        case .purpleText:
            return UIColor(red: 171/255.0, green: 119/255.0, blue: 206/255.0, alpha: 1)
        }
    }
}
