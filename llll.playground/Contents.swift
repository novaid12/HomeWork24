import UIKit

struct ApiConstants {
    static let serverPath = "http://localhost:3000/"
    static let photosPath = serverPath + "photos"
    static let photosURL = URL(string: photosPath)
}

struct Photo: Codable {
    let albumId: Int?
    let id: Int
    let title: String?
    let url: String?
    let thumbnailUrl: String?
}

var photos: [Photo] = []

private func fetchPhotos() {
    guard let photosURL = ApiConstants.photosURL else { return }

    URLSession.shared.dataTask(with: photosURL) { data, _, error in

        if let error = error {
            print(error)
        }

        if let data = data {
            do {
                photos = try JSONDecoder().decode([Photo].self, from: data)
                print(photos)
            } catch {
                print(error)
            }
        }

    }.resume()
}

fetchPhotos()


print(photos)
