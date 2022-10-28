//
//  File.swift
//  
//
//  Created by Kurt Jacobs on 2022/10/11.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseAuth

enum FirebaseFirestoreDataRepositoryError: Error {
    case userNotLoggedIn
}

public class FirebaseFirestoreDataRepository: DataRepository {
    let firestore = Firestore.firestore()
    let auth = Auth.auth()
    
    public init() { }
    
    public func getDocuments<Document: DataRepositoryDocument>(collection: DataRepositoryCollection) async throws -> [Document] {
        let snapshot = try await firestore.collection(collection.rawValue).getDocuments()
        let documents: [Document] = try snapshot.documents.map { try $0.data(as: Document.self) }
        return documents
    }
    
    public func updateDocument<Document: DataRepositoryDocument>(collection: DataRepositoryCollection, document: Document) async throws {
        guard let userId = auth.currentUser?.uid else {
            throw FirebaseFirestoreDataRepositoryError.userNotLoggedIn
        }
        
        if document.documentId.isEmpty {
            let writeableDocument = firestore.collection(collection.rawValue).document()
            try writeableDocument.setData(from: document)
            try await writeableDocument.updateData(["userId": userId, "documentId": writeableDocument.documentID])
        } else {
            let writeableDocument = firestore.collection(collection.rawValue).document(document.documentId)
            try writeableDocument.setData(from: document)
            try await writeableDocument.updateData(["userId": userId])
        }
    }
    
    public func deleteDocument<Document: DataRepositoryDocument>(collection: DataRepositoryCollection, document: Document) async throws {
        let document = firestore.collection(collection.rawValue).document(document.documentId)
        try await document.delete()
    }
}
