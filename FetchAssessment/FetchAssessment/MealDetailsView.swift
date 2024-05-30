//
//  MealDetailsView.swift
//  FetchAssessment
//
//  Created by Sparsh Ramchandani on 5/30/24.
//

import Foundation
import SwiftUI

struct MealDetailView: View {
    let mealId: String
    @StateObject private var viewModel = MealViewModel()
    @State private var mealTitle: String = ""

    var body: some View {
        VStack {
            if let meal = viewModel.mealDetail {
                ScrollView {
                    VStack {
                        if let imageUrl = meal.strMealThumb, let url = URL(string: imageUrl) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(width: 200, height: 200)
                                case .success(let image):
                                    image.resizable()
                                        .frame(width: 200, height: 200)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                case .failure:
                                    Image(systemName: "photo")
                                        .frame(width: 200, height: 200)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        }

                        Text("Cooking Instructions")
                            .font(.title3)
                            .underline()
                        
                        // Split instructions into steps
                        let steps = meal.strInstructions.components(separatedBy: "\r\n").filter { !$0.isEmpty }
                        
                        ForEach(0..<steps.count, id: \.self) { index in
                            Text("Step \(index + 1): \(steps[index])")
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading) // Ensure equal spacing on both sides
                        }

                        Text("Ingredients")
                            .font(.title3)
                            .underline()

                        VStack(alignment: .leading) {
                            ForEach(meal.ingredients(), id: \.0) { ingredient, measure in
                                Text("\(ingredient): \(measure)")
                            }
                        }
                        .padding()
                    }
                }
            } else {
                ProgressView()
                    .onAppear {
                        viewModel.fetchMealDetail(mealId: mealId)
                    }
            }
        }
        .navigationTitle(mealTitle)
        .navigationBarTitleDisplayMode(.inline)
        .onReceive(viewModel.$mealDetail) { mealDetail in
            if let mealDetail = mealDetail {
                mealTitle = mealDetail.strMeal
            }
        }
    }
}
