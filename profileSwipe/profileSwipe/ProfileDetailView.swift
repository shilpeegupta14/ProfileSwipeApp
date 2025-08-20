import SwiftUI

struct ProfileDetailView: View {
    let user: User
    @Binding var isPresented: Bool
    @State private var currentImageIndex = 0
    @State private var showFullBio = false
    @State private var isLiked = false
    @State private var isSuperLiked = false
    @State private var showMatchAnimation = false
    
    @Namespace private var imageNamespace
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // Profile Images Section
                    ZStack {
                        TabView(selection: $currentImageIndex) {
                            ForEach(Array(user.profileImages.enumerated()), id: \.offset) { index, imageName in
                                ZStack {
                                    Rectangle()
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [Color.purple.opacity(0.3), Color.pink.opacity(0.3)]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                    
                                    Image(systemName: imageName)
                                        .font(.system(size: 80))
                                        .foregroundColor(.white)
                                }
                                .matchedGeometryEffect(id: "profileImage_\(user.id)", in: imageNamespace)
                                .tag(index)
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        .frame(height: 500)
                        
                        // Image indicators
                        if user.profileImages.count > 1 {
                            VStack {
                                HStack {
                                    ForEach(0..<user.profileImages.count, id: \.self) { index in
                                        Rectangle()
                                            .fill(currentImageIndex == index ? Color.white : Color.white.opacity(0.5))
                                            .frame(width: 40, height: 4)
                                            .cornerRadius(2)
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.top, 20)
                                Spacer()
                            }
                        }
                        
                        // Back button and actions
                        VStack {
                            HStack {
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        isPresented = false
                                    }
                                }) {
                                    Image(systemName: "chevron.left")
                                        .font(.title2)
                                        .foregroundColor(.white)
                                        .frame(width: 44, height: 44)
                                        .background(Color.black.opacity(0.5))
                                        .clipShape(Circle())
                                }
                                
                                Spacer()
                                
                                HStack(spacing: 15) {
                                    Button(action: {}) {
                                        Image(systemName: "ellipsis")
                                            .font(.title2)
                                            .foregroundColor(.white)
                                            .frame(width: 44, height: 44)
                                            .background(Color.black.opacity(0.5))
                                            .clipShape(Circle())
                                    }
                                    
                                    Button(action: {}) {
                                        Image(systemName: "square.and.arrow.up")
                                            .font(.title2)
                                            .foregroundColor(.white)
                                            .frame(width: 44, height: 44)
                                            .background(Color.black.opacity(0.5))
                                            .clipShape(Circle())
                                    }
                                }
                            }
                            .padding()
                            .padding(.top, 40)
                            Spacer()
                        }
                        
                        // Verification badge (larger for detail view)
                        if user.isVerified {
                            VStack {
                                HStack {
                                    Spacer()
                                    VStack {
                                        Image(systemName: "checkmark.seal.fill")
                                            .font(.title)
                                            .foregroundColor(.blue)
                                            .background(Circle().fill(Color.white).frame(width: 35, height: 35))
                                        Text("Verified")
                                            .font(.caption.bold())
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Color.blue)
                                            .cornerRadius(10)
                                    }
                                    .padding(.trailing, 20)
                                    .padding(.top, 80)
                                }
                                Spacer()
                            }
                        }
                    }
                    
                    // Profile Information Section
                    VStack(alignment: .leading, spacing: 20) {
                        // Name and basic info
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                HStack(spacing: 12) {
                                    Text(user.name)
                                        .font(.largeTitle.bold())
                                        .foregroundColor(.primary)
                                    
                                    Text("\(user.age)")
                                        .font(.largeTitle)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 4) {
                                    HStack(spacing: 6) {
                                        Image(systemName: "location.fill")
                                            .font(.subheadline)
                                            .foregroundColor(.blue)
                                        Text("\(user.distance) km away")
                                            .font(.subheadline)
                                            .foregroundColor(.primary)
                                    }
                                    
                                    Text("Active 2 hours ago")
                                        .font(.caption)
                                        .foregroundColor(.green)
                                }
                            }
                            
                            HStack(spacing: 15) {
                                Label(user.occupation, systemImage: "briefcase.fill")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Label(user.education, systemImage: "graduationcap.fill")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Label(user.location, systemImage: "house.fill")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Divider()
                        
                        // Bio Section
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("About \(user.name)")
                                    .font(.title2.bold())
                                    .foregroundColor(.primary)
                                Spacer()
                            }
                            
                            Text(user.bio)
                                .font(.body)
                                .foregroundColor(.primary)
                                .lineLimit(showFullBio ? nil : 4)
                            
                            if user.bio.count > 150 {
                                Button(action: {
                                    withAnimation(.easeInOut) {
                                        showFullBio.toggle()
                                    }
                                }) {
                                    Text(showFullBio ? "Show Less" : "Show More")
                                        .font(.subheadline.bold())
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        
                        Divider()
                        
                        // Interests Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Interests")
                                .font(.title2.bold())
                                .foregroundColor(.primary)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 2), spacing: 8) {
                                ForEach(user.interests, id: \.self) { interest in
                                    HStack {
                                        Image(systemName: getInterestIcon(for: interest))
                                            .font(.subheadline)
                                            .foregroundColor(.blue)
                                        Text(interest)
                                            .font(.subheadline)
                                            .foregroundColor(.primary)
                                        Spacer()
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(12)
                                }
                            }
                        }
                        
                        Divider()
                        
                        // Profile Statistics
                        ProfileStatsView(user: user)
                        
                        Divider()
                        
                        // Stats Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Details")
                                .font(.title2.bold())
                                .foregroundColor(.primary)
                            
                            VStack(spacing: 12) {
                                HStack {
                                    Label("Height", systemImage: "ruler")
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text(user.height)
                                        .foregroundColor(.primary)
                                }
                                
                                HStack {
                                    Label("Looking for", systemImage: "heart")
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text("Long-term relationship")
                                        .foregroundColor(.primary)
                                }
                                
                                HStack {
                                    Label("Languages", systemImage: "globe")
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text("English, Spanish")
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                    }
                    .padding()
                    
                    // Bottom spacing for action buttons
                    Spacer(minLength: 100)
                }
            }
            .navigationBarHidden(true)
            .ignoresSafeArea(edges: .top)
        }
        .overlay(
            // Action buttons at bottom
            VStack {
                Spacer()
                HStack(spacing: 30) {
                    // Dislike button
                    Button(action: {
                        withAnimation(.spring()) {
                            isPresented = false
                        }
                    }) {
                        Image(systemName: "xmark")
                            .font(.title2.bold())
                            .foregroundColor(.red)
                            .frame(width: 60, height: 60)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                    }
                    
                    // Super like button
                    Button(action: {
                        withAnimation(.spring()) {
                            isSuperLiked = true
                            showMatchAnimation = true
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            showMatchAnimation = false
                            isPresented = false
                        }
                    }) {
                        Image(systemName: "star.fill")
                            .font(.title2.bold())
                            .foregroundColor(.blue)
                            .frame(width: 50, height: 50)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                            .scaleEffect(isSuperLiked ? 1.2 : 1.0)
                    }
                    
                    // Like button
                    Button(action: {
                        withAnimation(.spring()) {
                            isLiked = true
                            showMatchAnimation = true
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            showMatchAnimation = false
                            isPresented = false
                        }
                    }) {
                        Image(systemName: "heart.fill")
                            .font(.title2.bold())
                            .foregroundColor(.green)
                            .frame(width: 60, height: 60)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                            .scaleEffect(isLiked ? 1.2 : 1.0)
                    }
                }
                .padding(.bottom, 40)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.clear, Color.white.opacity(0.9), Color.white]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 120)
                )
            }
        )
        .overlay(
            // Match animation overlay
            Group {
                if showMatchAnimation {
                    ZStack {
                        Color.black.opacity(0.8)
                            .ignoresSafeArea()
                        
                        VStack(spacing: 30) {
                            Text("It's a Match! 🎉")
                                .font(.largeTitle.bold())
                                .foregroundColor(.white)
                                .scaleEffect(showMatchAnimation ? 1.0 : 0.5)
                                .opacity(showMatchAnimation ? 1.0 : 0.0)
                            
                            HStack(spacing: 20) {
                                // User's avatar
                                Circle()
                                    .fill(Color.blue.opacity(0.3))
                                    .frame(width: 80, height: 80)
                                    .overlay(
                                        Image(systemName: "person.circle.fill")
                                            .font(.system(size: 40))
                                            .foregroundColor(.white)
                                    )
                                    .scaleEffect(showMatchAnimation ? 1.0 : 0.0)
                                
                                Image(systemName: "heart.fill")
                                    .font(.title)
                                    .foregroundColor(.pink)
                                    .scaleEffect(showMatchAnimation ? 1.2 : 0.0)
                                
                                // Profile user's avatar
                                Circle()
                                    .fill(Color.purple.opacity(0.3))
                                    .frame(width: 80, height: 80)
                                    .overlay(
                                        Image(systemName: user.primaryImage)
                                            .font(.system(size: 40))
                                            .foregroundColor(.white)
                                    )
                                    .scaleEffect(showMatchAnimation ? 1.0 : 0.0)
                            }
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: showMatchAnimation)
                        }
                    }
                    .animation(.easeInOut(duration: 0.3), value: showMatchAnimation)
                }
            }
        )
    }
    
    private func getInterestIcon(for interest: String) -> String {
        switch interest.lowercased() {
        case "hiking": return "mountain.2"
        case "photography": return "camera"
        case "yoga": return "figure.mind.and.body"
        case "travel": return "airplane"
        case "coffee": return "cup.and.saucer"
        case "cooking": return "frying.pan"
        case "rock climbing": return "mountain.2"
        case "gaming": return "gamecontroller"
        case "music": return "music.note"
        case "tech": return "laptopcomputer"
        case "art": return "paintpalette"
        case "dancing": return "figure.dance"
        case "fashion": return "tshirt"
        case "movies": return "film"
        case "fitness": return "dumbbell"
        case "running": return "figure.run"
        case "nutrition": return "leaf"
        case "outdoors": return "tree"
        case "sports": return "sportscourt"
        case "reading": return "book"
        case "writing": return "pencil"
        case "literature": return "books.vertical"
        case "tea": return "cup.and.saucer"
        case "poetry": return "quote.bubble"
        case "guitar": return "guitars"
        case "recording": return "waveform"
        case "concerts": return "music.mic"
        case "vinyl": return "opticaldisc"
        default: return "heart"
        }
    }
} 