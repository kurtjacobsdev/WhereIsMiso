//
//  File.swift
//  
//
//  Created by Kurt Jacobs on 2022/10/28.
//

import Foundation

public protocol DataRepositoryDocument: Codable {
    var documentId: String { get }
}

public enum DataRepositoryCollection: String {
    case location
}

public protocol DataRepository { 
    func getDocuments<Document: DataRepositoryDocument>(collection: DataRepositoryCollection) async throws -> [Document]
    func updateDocument<Document: DataRepositoryDocument>(collection: DataRepositoryCollection, document: Document) async throws
    func deleteDocument<Document: DataRepositoryDocument>(collection: DataRepositoryCollection, document: Document) async throws
}
