//
//  RecipeCell.swift
//  Recipe
//
//  Created by Eugene on 16.05.23.
//

import UIKit

final class RecipeCell: UICollectionViewCell {
    
    var recipePhoto = UIImageView()
    
    var recipeCaption = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup View

private extension RecipeCell {
    
    func setupUI() {
        
        addViews()
        
        configure()
        
        layout()
    }
    
    func addViews() {
        
        contentView.addSubview(recipePhoto)
        contentView.addSubview(recipeCaption)
    }
    
    func configure() {
        
        self.layer.cornerRadius = Setting.cornerRadius
        self.layer.masksToBounds = true
        
        self.backgroundColor = .systemCyan
        
        recipeCaption.backgroundColor = .systemMint
    }
}

// MARK: - Layout

extension RecipeCell {
    
    func layout() {
        
        [recipePhoto, recipeCaption].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            
            recipePhoto.topAnchor.constraint(equalTo: contentView.topAnchor),
            recipePhoto.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            recipePhoto.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            recipePhoto.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            recipeCaption.bottomAnchor.constraint(equalTo: recipePhoto.bottomAnchor),
            recipeCaption.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1)
        ])
    }
}
