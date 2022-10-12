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

public protocol FirestoreDocument: Codable {
    var documentId: String { get }
}


public enum FirebaseFirestoreRepositoryCollection: String {
    case location
}

enum FirebaseFirestoreRepositoryError: Error {
    case userNotLoggedIn
}

public class FirebaseFirestoreRepository {
    let firestore = Firestore.firestore()
    let auth = Auth.auth()
    
    public init() { }
    
    public func getDocuments<Document: FirestoreDocument>(collection: FirebaseFirestoreRepositoryCollection) async throws -> [Document] {
        let snapshot = try await firestore.collection(collection.rawValue).getDocuments()
        let documents: [Document] = try snapshot.documents.map { try $0.data(as: Document.self) }
        return documents
    }
    
    public func updateDocument<Document: FirestoreDocument>(collection: FirebaseFirestoreRepositoryCollection, document: Document) async throws {
        guard let userId = auth.currentUser?.uid else {
            throw FirebaseFirestoreRepositoryError.userNotLoggedIn
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
    
    public func deleteDocument<Document: FirestoreDocument>(collection: FirebaseFirestoreRepositoryCollection, document: Document) async throws {
        let document = firestore.collection(collection.rawValue).document(document.documentId)
        try await document.delete()
    }
}
