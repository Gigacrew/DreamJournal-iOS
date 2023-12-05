import FirebaseFirestoreSwift  // Import for Codable support with Firestore
import FirebaseFirestore
import Foundation

struct Dream: Codable {
    var dreamId: String?  // This field is equivalent to the document ID in Firestore
    var title: String
    var dreamDescription: String
    var userId: String
    var date: Date?
    var feeling: [String]
    var category: String
    var recurringDream: Bool
    var imageURL: String

    enum CodingKeys: String, CodingKey {
        case dreamId
        case title
        case dreamDescription
        case userId
        case date
        case feeling
        case category
        case recurringDream
        case imageURL
    }
    init(dreamId: String?, title: String, dreamDescription: String, userId: String, date: Date?, feeling: [String], category: String, recurringDream: Bool, imageURL: String) {
           self.dreamId = dreamId
           self.title = title
           self.dreamDescription = dreamDescription
           self.userId = userId
           self.date = date
           self.feeling = feeling
           self.category = category
           self.recurringDream = recurringDream
           self.imageURL = imageURL
       }

    // Custom Decoder to handle Firestore Timestamp for Decodable
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        dreamDescription = try container.decode(String.self, forKey: .dreamDescription)
        userId = try container.decode(String.self, forKey: .userId)
        feeling = try container.decode([String].self, forKey: .feeling)
        category = try container.decode(String.self, forKey: .category)
        recurringDream = try container.decode(Bool.self, forKey: .recurringDream)
        imageURL = try container.decode(String.self, forKey: .imageURL)

        // Convert the date string from Firestore to a Date object
//        let dateString = try container.decode(String.self, forKey: .date)
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
//        if let date = formatter.date(from: dateString) {
//            self.date = date
//        } else {
//            self.date = nil
//        }
        let timestamp = try? container.decode(Timestamp.self, forKey: .date)
                date = timestamp?.dateValue()
    }

    // Custom Encoder to handle Firestore Timestamp for Encodable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(dreamDescription, forKey: .dreamDescription)
        try container.encode(userId, forKey: .userId)
        try container.encode(feeling, forKey: .feeling)
        try container.encode(category, forKey: .category)
        try container.encode(recurringDream, forKey: .recurringDream)
        try container.encode(imageURL, forKey: .imageURL)

//        // Convert the Date object to a date string for Firestore
//        if let date = date {
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
//            let dateString = formatter.string(from: date)
//            try container.encode(dateString, forKey: .date)
//        }
        if let date = date {
                    let timestamp = Timestamp(date: date)
                    try container.encode(timestamp, forKey: .date)
                }
    }
}
