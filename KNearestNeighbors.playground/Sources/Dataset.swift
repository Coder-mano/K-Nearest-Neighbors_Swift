//
//  Dataset.swift
//
//
//  Created by Tomas Adam,  on 7/11/19.
//  Copyright © 2019. Kosice All rights reserved.
//

import Foundation

public class Dataset {

    var dataset: [[String]]
    
    public init(_ name: String){
    
        //Open the CSV file
        guard let irisCSV = Bundle.main.path(forResource: name, ofType: "csv") else {
            fatalError("Resource could not be found!")
        }
    
        //Read the CSV file
        guard let csv = try? String(contentsOfFile: irisCSV) else {
            fatalError("File could not be read!")
        }
    
        // Parse the CSV split the lines with the character `\n` and create an array
        let rows = csv.split(separator: "\n").map { String($0) }
    
        // Split values in row with the character `,` and create an array
        self.dataset = rows.map { row -> [String] in
            let split = row.split(separator: ",")
            return split.map { String($0) }
        }
    }
    
    public func getDS() -> [[String]] {
        return dataset
    }


    public func split(trainSize:Int) -> ([[String]], [[String]]) {
        dataset.shuffle()
        return dataset.splitted(trainSize: trainSize)
    }
    
    public func getNumeric(_ array: [[String]]) -> [[Double]]{
           return array.map { row in
               return row.enumerated().filter { Double($0.element) != nil }.map {
                   return Double($0.element)!
               }
           }
       }

    public func getClases(_ array: [[String]], index:Int) -> [String]{
              return array.map { row in
                return row.enumerated().filter { $0.offset == index }.map { $0.element }[0]
                  }
              }
}

extension Array {
    func splitted(trainSize: Int) -> ([Element], [Element]) {
        
        let half = count * trainSize/100
        let head = self[0..<half]
        let tail = self[half..<count]
        
        return (Array(head), Array(tail))
    }
}
