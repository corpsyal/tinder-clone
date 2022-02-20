//
//  SettingsCell.swift
//  Tinder
//
//  Created by Anthony Lahlah on 10.09.21.
//

import UIKit


protocol SettingCellDelegate: AnyObject {
    func settingsCell(_ cell: SettingsCell, wantsToUpdateUserWith value: String, for section: SettingsSections)
    func settingsCell(_ cell: SettingsCell, wantsToUpdateAgeWith sender: UISlider)
}

class SettingsCell: UITableViewCell {
    
    var viewModel: SettingsViewModel! {
        didSet { configure() }
    }
    
    weak var delegate: SettingCellDelegate?
    
    lazy var input : UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        //tf.borderStyle = .none
        tf.font = .systemFont(ofSize: 16)
        
        let paddingView = UIView()
        paddingView.widthAnchor.constraint(equalToConstant: 28).isActive = true
        paddingView.heightAnchor.constraint(equalToConstant: 500).isActive = true
        tf.leftView = paddingView
        tf.leftViewMode = .always
        
        tf.returnKeyType = .done
        tf.delegate = self
        tf.addTarget(self, action: #selector(handleUserEditingEnd), for: .editingDidEnd)
        
        return tf
    }()
    
    var sliderStack = UIStackView()
    
    let minAgeLabel = UILabel()
    let maxAgeLabel = UILabel()
    
    lazy var minSlider = createSlider()
    lazy var maxSlider = createSlider()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(input)
        //addSubview(input)
        NSLayoutConstraint.activate([
            input.leadingAnchor.constraint(equalTo: leadingAnchor),
            input.trailingAnchor.constraint(equalTo: trailingAnchor),
            input.topAnchor.constraint(equalTo: topAnchor),
            input.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        
       // minAgeLabel.text = "Min: 18"
        //maxAgeLabel.text = "Max: 60"
        let minStack = UIStackView(arrangedSubviews: [minAgeLabel, minSlider])
        minStack.spacing = 24
        
        let maxStack = UIStackView(arrangedSubviews: [maxAgeLabel, maxSlider])
        maxStack.spacing = 24
        
        sliderStack = UIStackView(arrangedSubviews: [minStack, maxStack])
        sliderStack.axis = .vertical
        sliderStack.translatesAutoresizingMaskIntoConstraints = false
        sliderStack.spacing = 16
            
        contentView.addSubview(sliderStack)
        
        NSLayoutConstraint.activate([
            sliderStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            sliderStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            sliderStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(){
        sliderStack.isHidden = viewModel.shouldHideSlider
        input.isHidden = viewModel.shouldHideInput
        
        input.placeholder = viewModel.placeholderText
        input.text = viewModel.value
        
        minAgeLabel.text = viewModel.minAgeLabelText(for: viewModel.minAgeSliderValue)
        maxAgeLabel.text = viewModel.maxAgeLabelText(for: viewModel.maxAgeSliderValue)
        
        minSlider.setValue(viewModel.minAgeSliderValue, animated: true)
        maxSlider.setValue(viewModel.maxAgeSliderValue, animated: true)
    }
    
    func createSlider() -> UISlider {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 18
        slider.maximumValue = 60
        slider.addTarget(self, action: #selector(handleAgeChange), for: .valueChanged)
        
        return slider
    }
    
    @objc func handleAgeChange(sender: UISlider){
        if sender == minSlider {
            minAgeLabel.text = viewModel.minAgeLabelText(for: sender.value)
        } else {
            maxAgeLabel.text = viewModel.maxAgeLabelText(for: sender.value)
        }
        
        delegate?.settingsCell(self, wantsToUpdateAgeWith: sender)
        
    }
    
    @objc func handleUserEditingEnd(sender: UITextField){
        guard let value = sender.text else { return }
        delegate?.settingsCell(self, wantsToUpdateUserWith: value, for: viewModel.section)
    }
}

extension SettingsCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return true
    }
}
