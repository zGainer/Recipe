//
//  RecipeCell.swift
//  Recipe
//
//  Created by Eugene on 16.05.23.
//

import UIKit

final class RecipeCell: UICollectionViewCell {
    
    var recipePhoto: UIImageView!
    
    var recipeCaption: UILabel!
    
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
        
        createViews()
        
        addViews()
        
        configure()
        
        layout()
    }
    
    func createViews() {
        
        recipePhoto = UIImageView(frame: contentView.bounds)
        recipeCaption = UILabel()
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
    
    func layout() {
        
        recipeCaption.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            recipeCaption.bottomAnchor.constraint(equalTo: recipePhoto.bottomAnchor),
            recipeCaption.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1)
        ])
    }
}
