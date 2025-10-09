import Foundation
import LoggingTime

public enum DateCoder {
    private static let dateFormats = ["yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ", "yyyy-MM-dd'T'HH:mm:ssZ"]

    public static func decode(from dateString: String) throws -> Date {
        for format in dateFormats {
            if let date = dateFormatter(with: format).date(from: dateString) { return date }
        }
        throw DecodingError.dataCorrupted(
            .init(codingPath: [], debugDescription: "Invalid date format: \(dateString)")
        )
    }

    public static func encode(_ date: Date) -> String {
        dateFormatter(with: dateFormats[0]).string(from: date)
    }

    private static func dateFormatter(with format: String) -> DateFormatter {
        let f = DateFormatter()
        f.timeZone = TimeZone(secondsFromGMT: 0)
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = format
        return f
    }
}

public enum StandardJSONCoder {
    public static let decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.keyDecodingStrategy = .convertFromSnakeCase
        d.dateDecodingStrategy = .custom {
            try DateCoder.decode(from: try $0.singleValueContainer().decode(String.self))
        }
        return d
    }()

    public static let encoder: JSONEncoder = {
        let e = JSONEncoder()
        e.keyEncodingStrategy = .convertToSnakeCase
        e.dateEncodingStrategy = .custom {
            var c = $1.singleValueContainer()
            try c.encode(DateCoder.encode($0))
        }
        return e
    }()
}
