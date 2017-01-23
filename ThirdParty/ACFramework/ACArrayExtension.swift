//
//  ACArrayExtension.swift
//  Extends the Swift Array class
//
//  Created by Alex on 13/9/15.
//  Copyright (c) 2015 Colectivo Coffee Roasters Inc. All rights reserved.
//

import Foundation

extension Array {
    
    /*!
       @method randomItem()
       @discussion Returns a random element from inside the array
    
        let testArray = ["Alex", "Pepe", "Manolo", "Antonio", "Gonzalo", "Alberto", "Felix"]
        testArray.randomItem() // Retornará, algún nombre :-)
        testArray.randomItem() // Retornará, algún nombre :-)
        testArray.randomItem() // Retornará, algún nombre :-)
    */
    func randomItem() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}