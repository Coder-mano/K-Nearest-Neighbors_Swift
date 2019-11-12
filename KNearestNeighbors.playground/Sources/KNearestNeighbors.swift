//
//  KNearestNeighbors.swift
//
//
//  Created by Tomas Adam,  on 7/11/19.
//  Copyright © 2019. Kosice All rights reserved.
//

import Darwin
import Foundation

public class KNearestNeighbors {
  
  private let data:           [[Double]]
  private let labels:         [Int]
  private let nNeighbors:     Int
  private let rawLabels:      [Any]
  private let metrics:        Int
    
    public init(data:[[String]], labelIndex: Int, nNeighbors: Int,metrics: Int = 1) {
    
    self.metrics = metrics
    // Filter the numeric data
    self.data = data.map { row in
        return row.enumerated().filter { $0.offset != labelIndex }.map {
            if Double($0.element) == nil {
                fatalError("NAs introduced by coercion")
            }
            return Double($0.element)!
        }
    }

    // Find unique classes
    let sortedLabels = Array(Set(data.map { row in
        return row.enumerated().filter { $0.offset == labelIndex }.map { $0.element }[0]
    }))
    
    self.rawLabels = sortedLabels
    
    self.labels = data.map { row -> Int in
        let label = sortedLabels.firstIndex(of: row[labelIndex])
        return label!
    }
                
    self.nNeighbors = nNeighbors
    
    guard nNeighbors <= data.count && data.count == labels.count else {
        print(labels)
      fatalError("Error in dataset")
    }
  }
    
    
  public func predict(_ xTests: [[Double]]) -> [Any] {
    return xTests.map({
      let knn = kNearestNeighbors($0)
        
      return rawLabels[kNearestNeighborsMajority(knn)]
    })
  }
  
    
  private func kNearestNeighbors(_ xTest: [Double]) -> [(key: Double, value: Int)] {
      var NearestNeighbors = [Double : Int]()
      //get the distances
      for (index, xTrain) in data.enumerated() {
        NearestNeighbors[distance(xTrain, xTest)] = labels[index]
      }
      //sort and cut the first n neighbors
      let kNearestNeighborsSorted = Array(NearestNeighbors.sorted(by: { $0.0 < $1.0 }))[0...nNeighbors-1]

      return Array(kNearestNeighborsSorted)
   }
    
    
  private func distance(_ xTrain: [Double], _ xTest: [Double]) -> Double {
    
    //sqEukl
    if(metrics == 1){
        let distances = xTrain.enumerated().map { index, _ in
            //distances of attr //euklid
            return pow(xTrain[index] - xTest[index], 2)
        }
        
        //sum of partial results
        return distances.reduce(0, +)
    
    //Eukl
    }else if(metrics == 2){
        let distances = xTrain.enumerated().map { index, _ in
            //distances of attr //euklid
            return pow(xTrain[index] - xTest[index], 2)
        }
        
        //sum of partial results
        return distances.reduce(0, +).squareRoot()
        
    }else{
        return 0
    }
  }

    
  private func kNearestNeighborsMajority(_ knn: [(key: Double, value: Int)]) -> Int {
    var labels = [Int : Int]()
    
    //score the majority
    for neighbor in knn {
      labels[neighbor.value] = (labels[neighbor.value] ?? 0) + 1
    }
    
    for label in labels {
      if label.value == labels.values.max() {
        return label.key
      }
    }
    
    fatalError("Majority not finded")
  }
   
}
