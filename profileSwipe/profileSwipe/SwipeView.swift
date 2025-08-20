import SwiftUI

struct SwipeView: View {
    @State private var users = User.sampleUsers
    @State private var likedUsers: [User] = []
    @State private var dislikedUsers: [User] = []
    @State private var superLikedUsers: [User] = []
    @State private var recentlyRemovedUser: User?
    
    @State private var selectedUser: User?
    @State private var showingProfileDetail = false
    @State private var showingMatchesView = false
    @State private var showingFilters = false
    
    @State private var showUndoButton = false
    @State private var undoTimer: Timer?
    @State private var showingPremiumBoost = false
    
    @Namespace private var profileImageID
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.pink.opacity(0.1),
                        Color.purple.opacity(0.1),
                        Color.blue.opacity(0.1)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Top Navigation Bar
                    HStack {
                        Text("Discover")
                            .font(.title.bold())
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Button(action: {
                            showingMatchesView = true
                        }) {
                            ZStack {
                                Image(systemName: "bubble.left.and.bubble.right")
                                    .font(.title2)
                                    .foregroundColor(.primary)
                                
                                if !likedUsers.isEmpty {
                                    Circle()
                                        .fill(Color.red)
                                        .frame(width: 8, height: 8)
                                        .offset(x: 10, y: -10)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    // Card Stack Area
                    ZStack {
                        if users.isEmpty {
                            // No more profiles view
                            VStack(spacing: 20) {
                                Image(systemName: "heart.circle")
                                    .font(.system(size: 80))
                                    .foregroundColor(.gray.opacity(0.5))
                                
                                Text("No more profiles")
                                    .font(.title2.bold())
                                    .foregroundColor(.primary)
                                
                                Text("Check back later for new people!")
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                
                                Button(action: {
                                    refreshProfiles()
                                }) {
                                    HStack {
                                        Image(systemName: "arrow.clockwise")
                                        Text("Refresh")
                                    }
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(25)
                                }
                            }
                            .padding()
                        } else {
                            ForEach(Array(users.enumerated().reversed()), id: \.element.id) { index, user in
                                SwipeCard(
                                    user: user,
                                    onRemove: { removedUser in
                                        removeUser(removedUser)
                                    },
                                    onTap: { tappedUser in
                                        selectedUser = tappedUser
                                        showingProfileDetail = true
                                    },
                                    onLike: { likedUser in
                                        handleLike(likedUser)
                                    },
                                    onDislike: { dislikedUser in
                                        handleDislike(dislikedUser)
                                    },
                                    onSuperLike: { superLikedUser in
                                        handleSuperLike(superLikedUser)
                                    }
                                )
                                .frame(
                                    width: geometry.size.width - 40,
                                    height: geometry.size.height * 0.75
                                )
                                .scaleEffect(getScaleForIndex(index))
                                .offset(y: getOffsetForIndex(index))
                                .zIndex(Double(users.count - index))
                                .animation(.spring(), value: users.count)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    // Action Buttons
                    HStack(spacing: 35) {
                        // Undo Button (conditional)
                        if showUndoButton {
                            Button(action: {
                                handleUndo()
                            }) {
                                Image(systemName: "arrow.uturn.left")
                                    .font(.title2.bold())
                                    .foregroundColor(.gray)
                                    .frame(width: 50, height: 50)
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                            }
                            .transition(.scale.combined(with: .opacity))
                        }
                        
                        // Dislike Button
                        Button(action: {
                            if let user = users.first {
                                handleDislike(user)
                                removeUser(user)
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
                        .disabled(users.isEmpty)
                        .opacity(users.isEmpty ? 0.5 : 1.0)
                        
                        // Super Like Button
                        Button(action: {
                            if let user = users.first {
                                handleSuperLike(user)
                                removeUser(user)
                            }
                        }) {
                            Image(systemName: "star.fill")
                                .font(.title2.bold())
                                .foregroundColor(.blue)
                                .frame(width: 50, height: 50)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                        }
                        .disabled(users.isEmpty)
                        .opacity(users.isEmpty ? 0.5 : 1.0)
                        
                        // Like Button
                        Button(action: {
                            if let user = users.first {
                                handleLike(user)
                                removeUser(user)
                            }
                        }) {
                            Image(systemName: "heart.fill")
                                .font(.title2.bold())
                                .foregroundColor(.green)
                                .frame(width: 60, height: 60)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                        }
                        .disabled(users.isEmpty)
                        .opacity(users.isEmpty ? 0.5 : 1.0)
                        
                        // Boost Button (premium feature hint)
                        Button(action: {
                            showingPremiumBoost = true
                        }) {
                            Image(systemName: "bolt.fill")
                                .font(.title2.bold())
                                .foregroundColor(.purple)
                                .frame(width: 50, height: 50)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.purple.opacity(0.2), Color.pink.opacity(0.2)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                    .animation(.easeInOut, value: showUndoButton)
                }
            }
        }
        .fullScreenCover(isPresented: $showingProfileDetail) {
            if let user = selectedUser {
                ProfileDetailView(user: user, isPresented: $showingProfileDetail)
            }
        }
        .sheet(isPresented: $showingMatchesView) {
            MatchesView(likedUsers: likedUsers, superLikedUsers: superLikedUsers)
        }
        .overlay(
            Group {
                if showingPremiumBoost {
                    PremiumBoostView(isPresented: $showingPremiumBoost)
                }
            }
        )
    }
    
    private func getScaleForIndex(_ index: Int) -> CGFloat {
        let maxScale: CGFloat = 1.0
        let minScale: CGFloat = 0.95
        let scaleDecrement: CGFloat = 0.02
        
        if index == users.count - 1 {
            return maxScale // Top card
        } else if index == users.count - 2 {
            return maxScale - scaleDecrement // Second card
        } else {
            return minScale // Background cards
        }
    }
    
    private func getOffsetForIndex(_ index: Int) -> CGFloat {
        let maxOffset: CGFloat = 0
        let offsetIncrement: CGFloat = 10
        
        if index == users.count - 1 {
            return maxOffset // Top card
        } else if index == users.count - 2 {
            return offsetIncrement // Second card
        } else {
            return offsetIncrement * 2 // Background cards
        }
    }
    
    private func removeUser(_ user: User) {
        withAnimation(.spring()) {
            if let index = users.firstIndex(where: { $0.id == user.id }) {
                users.remove(at: index)
                recentlyRemovedUser = user
                showUndoButton = true
                
                // Hide undo button after 3 seconds
                undoTimer?.invalidate()
                undoTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
                    withAnimation(.easeOut) {
                        showUndoButton = false
                        recentlyRemovedUser = nil
                    }
                }
            }
        }
    }
    
    private func handleLike(_ user: User) {
        likedUsers.append(user)
        // Simulate match chance (20%)
        if Double.random(in: 0...1) < 0.2 {
            // Show match animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                // Present match view
            }
        }
    }
    
    private func handleDislike(_ user: User) {
        dislikedUsers.append(user)
    }
    
    private func handleSuperLike(_ user: User) {
        superLikedUsers.append(user)
        // Higher match chance for super likes (50%)
        if Double.random(in: 0...1) < 0.5 {
            // Show match animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                // Present match view
            }
        }
    }
    
    private func handleUndo() {
        guard let user = recentlyRemovedUser else { return }
        
        withAnimation(.spring()) {
            users.insert(user, at: 0)
            
            // Remove from action arrays
            likedUsers.removeAll { $0.id == user.id }
            dislikedUsers.removeAll { $0.id == user.id }
            superLikedUsers.removeAll { $0.id == user.id }
            
            showUndoButton = false
            recentlyRemovedUser = nil
        }
        
        undoTimer?.invalidate()
    }
    
    private func refreshProfiles() {
        withAnimation(.spring()) {
            users = User.sampleUsers.shuffled()
        }
    }
}

// MARK: - MatchesView
struct MatchesView: View {
    let likedUsers: [User]
    let superLikedUsers: [User]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 15) {
                    ForEach(likedUsers + superLikedUsers, id: \.id) { user in
                        VStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(height: 200)
                                
                                Image(systemName: user.primaryImage)
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray)
                                
                                if superLikedUsers.contains(where: { $0.id == user.id }) {
                                    VStack {
                                        HStack {
                                            Spacer()
                                            Image(systemName: "star.fill")
                                                .foregroundColor(.blue)
                                                .background(Circle().fill(Color.white).frame(width: 25, height: 25))
                                                .padding(5)
                                        }
                                        Spacer()
                                    }
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.name)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                Text("\(user.age) • \(user.distance) km")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Matches")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
