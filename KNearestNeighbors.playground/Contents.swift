//: Playground - noun: a place where people can play
//  Created by Tomas Adam,  on 7/11/19.
//  Copyright © 2019. Kosice All rights reserved.
//

import Foundation

let dataset = Dataset("Iris")
let dataSplit = dataset.split(trainSize:60)
let trainData = dataSplit.0
let testData = dataSplit.1

//IRIS 4 Glass 9
// Initialize the classifier with our data and labels
let knn = KNearestNeighbors(data: trainData, labelIndex: 4, nNeighbors: 7)


// Prediction
let predictionLabels = knn.predict(dataset.getNumeric(testData))



// Confusion matrix
var prediction: [String] = predictionLabels as! [String]
var test: [String] = dataset.getClases(testData,index:4)

let uniqueLabels = Array(Set(test))
let pairs: [(String, String)] = zip(prediction, test).map{ ($0.0, $0.1) }
var confusionMatrix = Array(repeating: Array(repeating: 0, count: uniqueLabels.count), count: uniqueLabels.count)

var tp = 0
var fp = 0

for (pred, test) in pairs {
    if(pred==test){
        confusionMatrix[uniqueLabels.firstIndex(of:pred) ?? 0][uniqueLabels.firstIndex(of:test) ?? 0] += 1
        tp += 1
    }else{
        confusionMatrix[uniqueLabels.firstIndex(of:pred) ?? 0][uniqueLabels.firstIndex(of:test) ?? 0] += 1
        fp += 1
    }
}

print("")

confusionMatrix.map({
    print($0)
})

// Precision
let precision = Double(tp)/Double(tp+fp)
print("\nPrecision \(precision)")
