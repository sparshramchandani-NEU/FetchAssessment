//
//  ViewModel.swift
//  FetchAssessment
//
//  Created by Sparsh Ramchandani on 5/30/24.
//

import Foundation
import SwiftUI
import Combine

struct AsyncImageView: View {
    @StateObject private var imageLoader = ImageLoader()
    let url: URL?

    var body: some View {
        Group {
            if let url = url {
                if let image = imageLoader.image {
                    Image(uiImage: image)
                        .resizable()
                } else {
                    ProgressView()
                        .onAppear {
                            imageLoader.loadImage(from: url)
                        }
                }
            } else {
                Image(systemName: "photo")
            }
        }
        .frame(width: 50, height: 50)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}


class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private var cancellable: AnyCancellable?

    func loadImage(from url: URL) {
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }
}

struct Meal: Identifiable, Decodable {
    var id: String { idMeal }
    let idMeal: String
    let strMeal: String
    let strMealThumb: String?
}

struct MealDetail: Decodable {
    let idMeal: String
    let strMeal: String
    let strMealThumb: String?
    let strInstructions: String
    let strIngredient1: String?
    let strIngredient2: String?
    let strIngredient3: String?
    let strIngredient4: String?
    let strIngredient5: String?
    let strIngredient6: String?
    let strIngredient7: String?
    let strIngredient8: String?
    let strIngredient9: String?
    let strIngredient10: String?
    let strIngredient11: String?
    let strIngredient12: String?
    let strIngredient13: String?
    let strIngredient14: String?
    let strIngredient15: String?
    let strIngredient16: String?
    let strIngredient17: String?
    let strIngredient18: String?
    let strIngredient19: String?
    let strIngredient20: String?
    let strMeasure1: String?
    let strMeasure2: String?
    let strMeasure3: String?
    let strMeasure4: String?
    let strMeasure5: String?
    let strMeasure6: String?
    let strMeasure7: String?
    let strMeasure8: String?
    let strMeasure9: String?
    let strMeasure10: String?
    let strMeasure11: String?
    let strMeasure12: String?
    let strMeasure13: String?
    let strMeasure14: String?
    let strMeasure15: String?
    let strMeasure16: String?
    let strMeasure17: String?
    let strMeasure18: String?
    let strMeasure19: String?
    let strMeasure20: String?
    
    func ingredients() -> [(String, String)] {
        let ingredients = [
            strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5,
            strIngredient6, strIngredient7, strIngredient8, strIngredient9, strIngredient10,
            strIngredient11, strIngredient12, strIngredient13, strIngredient14, strIngredient15,
            strIngredient16, strIngredient17, strIngredient18, strIngredient19, strIngredient20
        ]
        let measures = [
            strMeasure1, strMeasure2, strMeasure3, strMeasure4, strMeasure5,
            strMeasure6, strMeasure7, strMeasure8, strMeasure9, strMeasure10,
            strMeasure11, strMeasure12, strMeasure13, strMeasure14, strMeasure15,
            strMeasure16, strMeasure17, strMeasure18, strMeasure19, strMeasure20
        ]
        
        var result: [(String, String)] = []
        for (ingredient, measure) in zip(ingredients, measures) {
            if let ingredient = ingredient, !ingredient.isEmpty, let measure = measure, !measure.isEmpty {
                result.append((ingredient, measure))
            }
        }
        return result
    }
}

class MealViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    @Published var mealDetail: MealDetail?

    private var cancellables = Set<AnyCancellable>()

    func fetchMeals() {
        let url = URL(string: "https://www.themealdb.com/api/json/v1/1/filter.php?c=Dessert")!
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [String: [Meal]].self, decoder: JSONDecoder())
            .map { $0["meals"] ?? [] }
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.meals = $0.sorted(by: { $0.strMeal < $1.strMeal }) }
            .store(in: &cancellables)
    }

    func fetchMealDetail(mealId: String) {
        let url = URL(string: "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(mealId)")!
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [String: [MealDetail]].self, decoder: JSONDecoder())
            .map { $0["meals"]?.first }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.mealDetail = $0 }
            .store(in: &cancellables)
    }
}
