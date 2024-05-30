import SwiftUI
import Foundation
import Combine

struct ContentView: View {
    @StateObject private var viewModel = MealViewModel()
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)

                List(filteredMeals) { meal in
                    NavigationLink(destination: MealDetailView(mealId: meal.idMeal)) {
                        MealRow(meal: meal)
                    }
                }
                .navigationTitle("Desserts")
                .onAppear {
                    viewModel.fetchMeals()
                }
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            }
        }
    }

    private var filteredMeals: [Meal] {
        if searchText.isEmpty {
            return viewModel.meals
        } else {
            return viewModel.meals.filter { $0.strMeal.lowercased().contains(searchText.lowercased()) }
        }
    }
}

#Preview {
    ContentView()
}



