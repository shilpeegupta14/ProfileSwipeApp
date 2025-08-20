import Foundation

struct User: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let age: Int
    let profileImages: [String]
    let bio: String
    let distance: Int
    let occupation: String
    let interests: [String]
    let isVerified: Bool
    let education: String
    let location: String
    let height: String
    
    var primaryImage: String {
        profileImages.first ?? "person.circle.fill"
    }
}

extension User {
    static let sampleUsers: [User] = [
        User(
            name: "Emma",
            age: 25,
            profileImages: ["person.circle.fill", "person.circle.fill", "person.circle.fill"],
            bio: "Adventure seeker 🏔️ Coffee enthusiast ☕ Dog lover 🐕 Always up for trying new restaurants!",
            distance: 2,
            occupation: "Product Designer",
            interests: ["Hiking", "Photography", "Yoga", "Travel", "Coffee"],
            isVerified: true,
            education: "Stanford University",
            location: "San Francisco, CA",
            height: "5'6\""
        ),
        User(
            name: "Alex",
            age: 28,
            profileImages: ["person.circle.fill", "person.circle.fill"],
            bio: "Software engineer by day, chef by night 👨‍🍳 Love creating new dishes and exploring the city!",
            distance: 5,
            occupation: "Software Engineer",
            interests: ["Cooking", "Rock Climbing", "Gaming", "Music", "Tech"],
            isVerified: false,
            education: "UC Berkeley",
            location: "Oakland, CA",
            height: "6'1\""
        ),
        User(
            name: "Sofia",
            age: 23,
            profileImages: ["person.circle.fill", "person.circle.fill", "person.circle.fill", "person.circle.fill"],
            bio: "Artist 🎨 Dancer 💃 Spreading positivity wherever I go ✨ Let's create beautiful memories together!",
            distance: 8,
            occupation: "Graphic Artist",
            interests: ["Art", "Dancing", "Fashion", "Movies", "Music"],
            isVerified: true,
            education: "Art Institute",
            location: "San Jose, CA",
            height: "5'4\""
        ),
        User(
            name: "Marcus",
            age: 30,
            profileImages: ["person.circle.fill", "person.circle.fill", "person.circle.fill"],
            bio: "Fitness enthusiast 💪 Marathon runner 🏃‍♂️ Always training for the next challenge!",
            distance: 12,
            occupation: "Personal Trainer",
            interests: ["Fitness", "Running", "Nutrition", "Outdoors", "Sports"],
            isVerified: true,
            education: "SF State University",
            location: "Palo Alto, CA",
            height: "5'10\""
        ),
        User(
            name: "Zoe",
            age: 26,
            profileImages: ["person.circle.fill", "person.circle.fill"],
            bio: "Bookworm 📚 Tea lover 🍵 Aspiring novelist working on my first book. Love deep conversations!",
            distance: 15,
            occupation: "Content Writer",
            interests: ["Reading", "Writing", "Literature", "Tea", "Poetry"],
            isVerified: false,
            education: "UCLA",
            location: "Mountain View, CA",
            height: "5'7\""
        ),
        User(
            name: "Jordan",
            age: 29,
            profileImages: ["person.circle.fill", "person.circle.fill", "person.circle.fill"],
            bio: "Music producer 🎵 Guitar player 🎸 Always jamming and discovering new sounds!",
            distance: 6,
            occupation: "Music Producer",
            interests: ["Music", "Guitar", "Recording", "Concerts", "Vinyl"],
            isVerified: true,
            education: "Berkeley",
            location: "San Francisco, CA",
            height: "5'9\""
        )
    ]
} 