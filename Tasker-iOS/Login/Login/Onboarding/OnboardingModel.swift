//
//  OnboardingModel.swift
//  Tasker-iOS
//
//  Created by mingmac on 2023/05/05.
//

import Foundation

struct OnboardingModel {
    let imageName: String
}

extension OnboardingModel {
    static let imageArray: [OnboardingModel] = [
        OnboardingModel(imageName: "onboarding1"),
        OnboardingModel(imageName: "onboarding2"),
        OnboardingModel(imageName: "onboarding3")
    ]
}
