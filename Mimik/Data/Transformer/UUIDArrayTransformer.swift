//
//  UUIDArrayTransformer.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 27/11/25.
//


import Foundation
import CoreData

@objc(UUIDArrayTransformer)
class UUIDArrayTransformer: ValueTransformer {

    // MARK: - Allow secure coding
    override class func allowsReverseTransformation() -> Bool {
        return true
    }

    override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }

    // MARK: - Transform [UUID] -> Data
    override func transformedValue(_ value: Any?) -> Any? {
        guard let uuids = value as? [UUID] else { return nil }
        // Convert UUIDs to array of Strings, then encode
        let stringArray = uuids.map { $0.uuidString }
        do {
            let data = try JSONEncoder().encode(stringArray)
            return data
        } catch {
            print("UUIDArrayTransformer encoding error: \(error)")
            return nil
        }
    }

    // MARK: - Transform Data -> [UUID]
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        do {
            let stringArray = try JSONDecoder().decode([String].self, from: data)
            let uuidArray = stringArray.compactMap { UUID(uuidString: $0) }
            return uuidArray
        } catch {
            print("UUIDArrayTransformer decoding error: \(error)")
            return nil
        }
    }
}
