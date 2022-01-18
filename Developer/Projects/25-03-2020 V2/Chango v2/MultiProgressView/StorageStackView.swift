//
//  StorageTypeView.swift
//  MultiProgressViewExample
//
//  Created by Mac Gallagher on 1/5/19.
//  Copyright © 2019 Mac Gallagher. All rights reserved.
//

import UIKit

class StorageStackView: UIStackView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()
    
    private lazy var colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = colorViewHeight / 4
        view.layer.masksToBounds = true
        return view
    }()
    
    private let colorViewHeight: CGFloat = 11
    
    init(storageType: StorageType, votesCompleted: String, votesRequired: String) {
        super.init(frame: .zero)
        alignment = .fill
        spacing = 6
        
        addArrangedSubview(colorView)
        colorView.anchor(width: colorViewHeight, height: colorViewHeight)
        
        addArrangedSubview(titleLabel)
        
        colorView.backgroundColor = storageType.color
        titleLabel.text = storageType.description(votesCompleted: votesCompleted, votesRequired: votesRequired)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
