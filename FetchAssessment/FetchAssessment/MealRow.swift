//
//  MealRow.swift
//  FetchAssessment
//
//  Created by Sparsh Ramchandani on 5/30/24.
//

import Foundation
import SwiftUI
struct MealRow: View {
    let meal: Meal

    var body: some View {
        HStack {
            if let imageUrl = meal.strMealThumb, let url = URL(string: imageUrl) {
                AsyncImageView(url: url)
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                Image(systemName: "photo")
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            Text(meal.strMeal)
        }
    }
}
