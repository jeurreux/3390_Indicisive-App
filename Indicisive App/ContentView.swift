//
//  ContentView.swift
//  Indicisive App
//
//  Created by Joshua on 2/17/25.
//

import SwiftUI
import UIKit

struct ContentView: View {

    @State private var choiceInput = ""
    @State private var weightInput = "1.0"
    @State private var choices: [WeightedChoice] = []
    @State private var selectedChoice: WeightedChoice? = nil
    @FocusState private var focus: Bool
    @State private var showResult: Bool = false
    @State private var randomChoice: String = ""
    @State private var weightedRandom = WeightedRandom<WeightedChoice>()
    
    var body: some View {
        
            NavigationView {
                ZStack{
                VStack {
                    headerView
                    listView
                    inputView
                    buttonView
                    Spacer()
                }
                .alert(isPresented: $showResult) {
                    Alert(
                        title: Text("Your Choice:"),
                        message: Text(randomChoice),
                        dismissButton: .default(Text("OK"))
                    )
                }
                .navigationTitle("Indecision App")
            }
           
        }
    }
    private var headerView: some View {
        Text("Choices")
            .font(.title2)
            .fontWeight(.bold)
            .foregroundColor(Color.red)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
    }
    
    private var listView: some View {
        List(selection: $selectedChoice) {
            ForEach(choices) { choice in
                Text("\(choice.name) (Weight: \(choice.weight))")
                    .tag(choice)
            }
        }
        .environment(\.editMode, .constant(.active))
        .frame(minHeight: 200)
        .listStyle(.insetGrouped)
        .background(Color.white.opacity(0.2).cornerRadius(5))
    }
    
    private var inputView: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Option:")
                TextField("Ex: Restaurant", text: $choiceInput)
                    .textFieldStyle(.roundedBorder)
                    .focused($focus)
            }
            HStack {
                Text("Weight:")
                TextField("e.g. 2.5", text: $weightInput)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
            }
        }
        .padding(.horizontal)
        .onAppear { focus = true }
    }
    
    private var buttonView: some View {
        HStack {
            Button("Add") { addChoice() }
                .buttonStyle(.borderedProminent)
                .tint(.green)
            
            Button("Remove") { removeChoice() }
                .buttonStyle(.bordered)
                .tint(.red)
            
            Button("Decide") { decideChoice() }
                .buttonStyle(.borderedProminent)
                .disabled(choices.isEmpty)
        }
    }
    
    private func addChoice() {
        guard !choiceInput.isEmpty else { return }
        let parsedWeight = Double(weightInput) ?? 1.0
        let newChoice = WeightedChoice(name: choiceInput, weight: parsedWeight)
        choices.append(newChoice)
        weightedRandom.elements = choices.map {
            WeightedRandom<WeightedChoice>.Element(item: $0, weight: $0.weight)
        }
        choiceInput = ""
        weightInput = "1.0"
    }
    
    private func removeChoice() {
        guard let selected = selectedChoice else { return }
        if let index = choices.firstIndex(of: selected) {
            choices.remove(at: index)
        }
        weightedRandom.elements = choices.map {
            WeightedRandom<WeightedChoice>.Element(item: $0, weight: $0.weight)
        }
        selectedChoice = nil
    }
    
    private func decideChoice() {
        guard let selected = weightedRandom.randomElement() else { return }
        randomChoice = "\(selected.name) (Weight: \(selected.weight))"
        showResult = true
    }
}

struct WeightedChoice: Identifiable, Equatable, Hashable {
    let id = UUID()
    let name: String
    let weight: Double

    static func == (lhs: WeightedChoice, rhs: WeightedChoice) -> Bool {
        lhs.id == rhs.id
    }
}



#Preview {
    ContentView()
}
