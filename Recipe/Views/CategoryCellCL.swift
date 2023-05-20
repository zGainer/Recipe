//
//  CategoryCellCL.swift
//  Recipe
//
//  Created by Eugene on 19.05.23.
//

import UIKit

final class CategoryCellCL: UICollectionViewCell {
    
    private let stackView = UIStackView()
    
    var recipePhoto = UIImageView()
    
    var caption = UILabel()
    var numberOfRecipes = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup View

private extension CategoryCellCL {
    
    func setupUI() {
        
        addViews()
        
        configure()
        
        layout()
    }
    
    func addViews() {
        
        contentView.addSubview(recipePhoto)
        stackView.addSubview(caption)
        stackView.addSubview(numberOfRecipes)
    }
    
    func configure() {
        
        self.layer.cornerRadius = Setting.cornerRadius
        self.layer.masksToBounds = true
        
        self.backgroundColor = .systemCyan
        
        caption.backgroundColor = .systemMint
    }
    
    func layout() {
        
        [recipePhoto, caption].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            
            recipePhoto.topAnchor.constraint(equalTo: contentView.topAnchor),
            recipePhoto.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            recipePhoto.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            recipePhoto.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
//            caption.bottomAnchor.constraint(equalTo: recipePhoto.bottomAnchor),
//            caption.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1)
        ])
    }
}

