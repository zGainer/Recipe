//
//  CategoryCell.swift
//  Recipe
//
//  Created by Eugene on 19.05.23.
//

import UIKit

final class CategoryCell: UICollectionViewCell {
    
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

private extension CategoryCell {
    
    func setupUI() {
        
        addViews()
        
        configure()
        
        layout()
    }
    
    func addViews() {
        
        contentView.addSubview(recipePhoto)
        contentView.addSubview(caption)
        contentView.addSubview(numberOfRecipes)
    }
    
    func configure() {
        
        self.layer.cornerRadius = Setting.cornerRadius
        self.layer.masksToBounds = true
        
        self.backgroundColor = .systemCyan
        
        caption.backgroundColor = .systemMint
    }
}

// MARK: - Layout

extension CategoryCell {
    
    func layout() {
        
        [recipePhoto, caption, numberOfRecipes].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            
            recipePhoto.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            recipePhoto.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            recipePhoto.topAnchor.constraint(equalTo: contentView.topAnchor),
            recipePhoto.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            caption.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            caption.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            numberOfRecipes.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            numberOfRecipes.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
