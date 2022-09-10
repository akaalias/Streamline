//
//  TextHelper.swift
//  RageEditor
//
//  Created by Alexis Rondeau on 24.08.22.
//

import Foundation

class TextHelper {
    
    static func latestCharacters(characters: [String], keep: Int, skip: Int) -> [String] {
        
        if(characters.count <= 0) { return [] }
        
        if(characters.count <= keep) {
            if(skip > 0) {
                return Array(characters.dropLast(skip))
            }
            return characters
        }
        
        let array:[String] = Array(characters.dropFirst(characters.count - keep))
        
        if(skip > 0) {
            return Array(array.dropLast(skip))
        }

        return array
    }
}
