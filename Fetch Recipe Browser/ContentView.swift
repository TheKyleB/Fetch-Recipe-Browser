//
//  ContentView.swift
//  Fetch Recipe Browser
//
//  Created by Kyle Brownell on 4/10/25.
//

import SwiftUI

struct RecipeResponse: Codable {
    var recipes: [Recipe]
}

struct Recipe: Codable, Equatable {
    var uuid: String
    var cuisine: String
    var name: String
    var photo_url_large: String?
    var photo_url_small: String?
    var source_url: String?
    var youtube_url: String?
    
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.cuisine == rhs.cuisine && lhs.name == rhs.name
    }
}

struct Cuisine: Identifiable {
    var id: String
    var isSelected = true
    
    static func == (lhs: Cuisine, rhs: Cuisine) -> Bool {
        return lhs.id == rhs.id
    }
}

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) ->UIVisualEffectView {
        UIVisualEffectView()
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) {
        uiView.effect = effect
    }
    
}

struct ContentView: View {
    
    private var apiKey: String = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    
    @State private var sortAlphabetically: Bool = true
    @State private var recipesByName = [Recipe]()
    @State private var recipesByCuisine = [Recipe]()
    @State private var showingFilters: Bool = false
    @State private var selectedRecipe: Recipe? = nil
    @State private var cuisines = [Cuisine]()
    @State private var searchQuery = ""
    @State private var dataLoaded = false
    @State private var displayMessage: String? = nil
    
    func getCuisines() -> [Cuisine] {
        var cuisines = [Cuisine]()
        var prevCuisine: String?
        for recipe in recipesByCuisine {
            if recipe.cuisine == prevCuisine { continue }
            prevCuisine = recipe.cuisine
            cuisines.append(Cuisine(id: recipe.cuisine))
        }
        return cuisines
    }
    
    func loadData() async {
        displayMessage = nil
        dataLoaded = false
        let (byName, byCuisine) = await APIService().fetchData(urlString: apiKey)
        if (byName != nil) && (byCuisine != nil){
            recipesByName = byName!
            recipesByCuisine = byCuisine!
            cuisines = getCuisines()
            dataLoaded = true
        } else {
            displayMessage = "Failed to load recipes."
            print("Finished Failing")
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack(){
                    Text("Recipe Browser")
                        .font(.title)
                    Spacer()
                    Button("Update List"){
                        Task{
                            await loadData()
                        }
                    }.buttonStyle(.bordered)
                }.padding()
                Divider()
                HStack(){
                    TextField("Search", text: $searchQuery)
                    Text("Sort:")
                    Button{
                        sortAlphabetically = !sortAlphabetically
                    } label: {
                        if sortAlphabetically {
                            Image(systemName: "character.book.closed.fill")
                            
                        }else{
                            Image(systemName: "map.fill")
                        }
                    }
                    Button("Filter"){
                        showingFilters.toggle()
                    }
                }.padding()
                Divider()
                
                // Recipe display list, basically choses which list to display: Alphabetical or ByCuisine, while also applying the filtering from the search bar and toggled cuisine types from the filter menu.
                
                if displayMessage != nil {
                    Text(displayMessage!).padding(40).font(.headline)
                }
                let visibleRecipes = (sortAlphabetically ? (searchQuery.isEmpty ? recipesByName
                                                            : (recipesByName.filter{$0.name.contains(searchQuery)}))
                                      : (searchQuery.isEmpty ? recipesByCuisine
                                         : (recipesByCuisine.filter{$0.name.contains(searchQuery)})))
                                    .filter{
                                        let selectedCuisines = cuisines.filter{ $0.isSelected }.map{ $0.id }
                                        return selectedCuisines.contains($0.cuisine)}
                if visibleRecipes.isEmpty && dataLoaded {
                    VStack{
                        HStack{
                            Image(systemName: "magnifyingglass")
                            Text(" No recipes found")
                        }.padding(40)
                        Spacer()
                    }
                } else {
                    List(visibleRecipes, id: \.uuid) { recipeItem in
                        LazyVStack(alignment: .leading){
                            ZStack {
                                HStack{
                                    AsyncImage(url: URL(string: recipeItem.photo_url_small ?? "")){
                                        image in
                                        image.image?.resizable().scaledToFit()
                                    }
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(5)
                                    .clipped().padding(10)
                                    VStack
                                    {
                                        Spacer()
                                        HStack{
                                            Text(recipeItem.name)
                                                .font(.headline)
                                                .padding(.bottom, 3)
                                            Spacer()
                                        }
                                        HStack{
                                            Text(recipeItem.cuisine)
                                                .font(.subheadline)
                                            Spacer()
                                        }
                                        Spacer()
                                    }
                                }
                                Button(action: {
                                    selectedRecipe = recipeItem
                                }) {
                                    
                                }
                            }//.frame(height:100)
                        }
                    }.task {
                        await loadData()
                    }.frame(maxHeight: .infinity)
                }
            }
            
            VisualEffectView(effect: UIBlurEffect(style: .light)).edgesIgnoringSafeArea(.all).opacity((showingFilters || selectedRecipe != nil) ? 1 : 0)
            
            ViewThatFits(in: /*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/) {
                VStack(alignment: .leading) {
                    HStack {
                        Label("Filter by cuisine", systemImage: "line.horizontal.3")
                        Spacer()
                    }
                    ScrollView {
                        ForEach($cuisines){ $cuisine in
                            VStack(spacing: 0) {
                                Toggle(cuisine.id, isOn: $cuisine.isSelected).tint(Color.blue)
                            }.padding(.horizontal)
                        }
                    }
                    HStack {
                        Spacer()
                        Button("Apply"){
                            showingFilters = false
                        }.buttonStyle(.borderedProminent).disabled(showingFilters == false)
                        Spacer()
                    }
                }
            }.padding(50).cornerRadius(10).opacity(showingFilters ? 1 : 0)
            
            ViewThatFits(in: /*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/) {
                VStack {
                    HStack {
                        Button("Back to Recipes"){
                            selectedRecipe = nil
                        }.buttonStyle(.bordered)
                        Spacer()
                    }
                    Divider()
                    HStack {
                        Spacer()
                        Text(selectedRecipe?.name ?? "").font(.title)
                        Spacer()
                    }.padding(10)
                    
                    GeometryReader{ geometry in
                        HStack{
                            Spacer()
                            let url = URL(string: selectedRecipe?.photo_url_large ?? (selectedRecipe?.photo_url_small ?? ""))
                            AsyncImage(url: url){
                                image in
                                image.resizable().scaledToFit()
                            } placeholder:{
                                ProgressView()
                            }.frame(width: geometry.size.width * 0.9, height: geometry.size.width * 0.9).cornerRadius(10).clipped()
                
                            Spacer()
                        }
                    }.frame(height: UIScreen.main.bounds.width * 0.8)
                    Spacer().frame(maxHeight: 20)
                    HStack {
                        Spacer()
                        Text("Cuisine: " + (selectedRecipe?.cuisine ?? "Unknown")).font(.headline)
                        Spacer()
                    }
                    HStack{
                        Spacer()
                        Button("Recipe Instructions"){
                            if let url = URL(string: selectedRecipe?.source_url ?? "") {
                                if UIApplication.shared.canOpenURL(url) {
                                    UIApplication.shared.open(url)
                                }
                            }
                        }.buttonStyle(.borderedProminent).opacity((selectedRecipe?.source_url ?? nil) != nil ? 1 : 0)
                        Spacer()
                    }.padding(10)
                    HStack{
                        Spacer()
                        Button("Video Tutorial"){
                            if let url = URL(string: selectedRecipe?.youtube_url ?? "") {
                                if UIApplication.shared.canOpenURL(url) {
                                    UIApplication.shared.open(url)
                                }
                            }
                        }.buttonStyle(.borderedProminent).opacity((selectedRecipe?.youtube_url ?? nil) != nil ? 1 : 0)
                        Spacer()
                    }
                    Spacer()
                }
            }.padding(20).cornerRadius(10).disabled(selectedRecipe == nil).opacity((selectedRecipe != nil) ? 1 : 0)
        }
    }
}

class APIService {
    func fetchData(urlString: String) async -> ([Recipe]?, [Recipe]?) {
        guard let url = URL(string: urlString)
        else {
            print("Provided API URL is not valid.")
            return (nil, nil)
        }
        print("URL Found")
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            print("Data Found")
            //print("---> data: \n \(String(data: data, encoding: .utf8) as AnyObject) \n")
            let recipeResponse = try JSONDecoder().decode(RecipeResponse.self, from: data)
            let recipesByName = recipeResponse.recipes.sorted { $0.name < $1.name}
            let recipesByCuisine = (recipeResponse.recipes.sorted {$0.name < $1.name}).sorted{$0.cuisine < $1.cuisine}
            return (recipesByName, recipesByCuisine)
        } catch {
            print(error)
        }
        return (nil, nil)
    }
}

#Preview {
    ContentView()
}
