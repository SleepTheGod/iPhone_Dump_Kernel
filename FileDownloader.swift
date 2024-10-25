import Foundation

// URL of the file to download
guard let url = URL(string: "https://example.com/path/to/file") else {
    print("Invalid URL.")
    exit(1)
}

// Create a URLSession configuration with a background session
let configuration = URLSessionConfiguration.default
let session = URLSession(configuration: configuration)

// Create a URLSessionDownloadTask to download the file
let task = session.downloadTask(with: url) { location, response, error in
    // Check for errors
    if let error = error {
        print("Download failed with error: \(error.localizedDescription)")
        return
    }

    // Ensure the temporary download location exists
    guard let location = location else {
        print("Download failed: No temporary location.")
        return
    }

    do {
        // Destination URL for the file
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationURL = documentsURL.appendingPathComponent(url.lastPathComponent)

        // Remove any existing file at the destination URL
        if FileManager.default.fileExists(atPath: destinationURL.path) {
            try FileManager.default.removeItem(at: destinationURL)
        }

        // Move the downloaded file to the destination URL
        try FileManager.default.moveItem(at: location, to: destinationURL)
        print("File downloaded to: \(destinationURL.path)")
    } catch {
        print("Download failed with error: \(error.localizedDescription)")
    }
}

// Start the download task
task.resume()

// Keep the command line tool running until the download completes
RunLoop.main.run()
