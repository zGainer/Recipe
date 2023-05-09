//
//  RecipeModel.swift
//  Recipe
//
//  Created by Eugene on 7.04.23.
//

import Foundation

struct RecipeModel {
    let name: String
    let category: Category
    let source: String
    let notes: String
    let ingredients: String
    let directions: String
    let photo: Data?
}
