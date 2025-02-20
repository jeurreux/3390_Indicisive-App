//
//  Weighted.swift
//  Indicisive App
//
//  Created by Joshua on 2/19/25.
//

// WeightedRandom.swift

import Foundation

class WeightedRandom<T> {
    var elements: [Element]
    
    init(elements: [Element] = []) {
        self.elements = elements
    }
    
    struct Element {
        let item: T
        let weight: Double
    }
    
    func randomElement() -> T? {
        guard !elements.isEmpty else { return nil }
        
       
        var cumulativeWeights: [Double] = []
        var totalWeight: Double = 0.0

       
        for element in elements {
            totalWeight += element.weight
            cumulativeWeights.append(totalWeight)
        }
        
 
        let randomValue = Double.random(in: 0..<totalWeight)

     
        for i in 0..<elements.count {
            if randomValue <= cumulativeWeights[i] {
                return elements[i].item
            }
        }
        return nil
    }
}
