//
//  SettingsViewModel.swift
//  Tinder
//
//  Created by Anthony Lahlah on 10.09.21.
//

import Foundation

enum SettingsSections: Int, CaseIterable {
    case name, profession, age, bio, ageRange
    
    var description: String {
        switch self {
            case .name: return "Name"
            case .profession: return "Profession"
            case .age: return "Age"
            case .bio: return "Bio"
            case .ageRange: return "Seeking age range"
        }
    }
}

struct SettingsViewModel {
    
    private let user: User
    let section: SettingsSections
    
    let placeholderText: String
    
    var value: String?
    
    var shouldHideInput: Bool {
        return self.section == SettingsSections.ageRange
    }
    
    var shouldHideSlider: Bool {
        return self.section != SettingsSections.ageRange
    }
    
     var minAgeSliderValue: Float {
        return Float(user.minSeekAge)
    }
    
    var maxAgeSliderValue: Float {
        return Float(user.maxSeekAge)
    }
    
    func minAgeLabelText(for value: Float) -> String {
        return "Min: \(Int(value))"
    }
    
    func maxAgeLabelText(for value: Float) -> String {
        return "Max: \(Int(value))"
    }
    
    init(user: User, section: SettingsSections){
        self.user = user
        self.section = section
        
        self.placeholderText = "Enter \(section.description.lowercased())..."
        
        switch section {
            case .name:
                value = user.name
            case .profession:
                value = user.profession
            case .age:
                value = "\(user.age)"
            case .bio:
                value = user.bio
            case .ageRange:
                break
        }
    }
    
    
    
}
