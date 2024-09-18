import SwiftUI
import Combine

// MARK: - Image Cache

class ImageCache {
    private var cache = NSCache<NSString, UIImage>()

    static let shared = ImageCache()

    private init() {}

    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: NSString(string: key))
    }

    func saveImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: NSString(string: key))
    }
}

// MARK: - Async Image Loader

class AsyncImageLoader: ObservableObject {
    @Published var image: UIImage?
    private var cancellable: AnyCancellable?

    func load(from url: URL) {
        let cacheKey = url.absoluteString

        // Check cache first
        if let cachedImage = ImageCache.shared.getImage(forKey: cacheKey) {
            self.image = cachedImage
        } else {
            // Download image
            cancellable = URLSession.shared.dataTaskPublisher(for: url)
                .map { UIImage(data: $0.data) }
                .replaceError(with: nil)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] downloadedImage in
                    if let downloadedImage = downloadedImage {
                        ImageCache.shared.saveImage(downloadedImage, forKey: cacheKey)
                    }
                    self?.image = downloadedImage
                }
        }
    }

    deinit {
        cancellable?.cancel()
    }
}

// MARK: - Cached Async Image View

struct CachedAsyncImage: View {
    @StateObject private var imageLoader = AsyncImageLoader()
    let url: URL
    let width: CGFloat
    let height: CGFloat
    let isCircle: Bool

    var body: some View {
        Group {
            if let image = imageLoader.image {
                if isCircle {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: width, height: height)
                        .clipShape(.circle )
                } else {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: width, height: height)
                        .clipShape(.rect )
                }
            } else {
                ProgressView()
                    .frame(width: width, height: height)
            }
        }
        .onAppear {
            imageLoader.load(from: url)
        }
    }
}
