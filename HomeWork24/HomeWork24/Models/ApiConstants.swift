//
//  ApiConstants.swift
//  HomeWork24
//
//  Created by  NovA on 11.10.23.
//

import Foundation

struct ApiConstants {
    /// Local server path
    static let serverPath = "http://localhost:3000/"
    /// Users
    static let usersPath = serverPath + "users"
    static let usersURL = URL(string: usersPath)

    /// Posts
    static let postsPath = serverPath + "posts"
    static let postsURL = URL(string: postsPath)
    /// ToDo-s
    static let todosPath = serverPath + "todos"
    static let todosURL = URL(string: todosPath)
    /// Albums
    static let albumsPath = serverPath + "albums"
    static let albumsURL = URL(string: albumsPath)
    /// Photos
    static let photosPath = serverPath + "photos"
    static let photosURL = URL(string: photosPath)
    /// Comments
    static let commentsPath = serverPath + "comments"
    static let commentsURL = URL(string: commentsPath)
}
