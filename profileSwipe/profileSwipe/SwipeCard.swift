import SwiftUI

struct SwipeCard: View {
    let user: User
    let onRemove: (User) -> Void
    let onTap: (User) -> Void
    let onLike: (User) -> Void
    let onDislike: (User) -> Void
    let onSuperLike: (User) -> Void
    
    @State private var offset = CGSize.zero
    @State private var rotation = 0.0
    @State private var isShowingReaction = false
    @State private var reactionType: ReactionType = .none
    @State private var currentImageIndex = 0
    
    @Namespace private var imageID
    
    enum ReactionType {
        case like, dislike, superLike, none
        
        var color: Color {
            switch self {
            case .like: return .green
            case .dislike: return .red
            case .superLike: return .blue
            case .none: return .clear
            }
        }
        
        var title: String {
            switch self {
            case .like: return "LIKE"
            case .dislike: return "NOPE"
            case .superLike: return "SUPER LIKE"
            case .none: return ""
            }
        }
        
        var systemImage: String {
            switch self {
            case .like: return "heart.fill"
            case .dislike: return "xmark"
            case .superLike: return "star.fill"
            case .none: return ""
            }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Main card
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                
                VStack(spacing: 0) {
                    // Profile images section
                    ZStack {
                        TabView(selection: $currentImageIndex) {
                            ForEach(Array(user.profileImages.enumerated()), id: \.offset) { index, imageName in
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.gray.opacity(0.2))
                                    
                                    Image(systemName: imageName)
                                        .font(.system(size: 60))
                                        .foregroundColor(.gray)
                                }
                                .matchedGeometryEffect(id: "profileImage_\(user.id)", in: imageID)
                                .tag(index)
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        .frame(height: geometry.size.height * 0.65)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        
                        // Image indicators
                        if user.profileImages.count > 1 {
                            VStack {
                                HStack {
                                    ForEach(0..<user.profileImages.count, id: \.self) { index in
                                        Rectangle()
                                            .fill(currentImageIndex == index ? Color.white : Color.white.opacity(0.5))
                                            .frame(height: 3)
                                            .cornerRadius(1.5)
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.top, 8)
                                Spacer()
                            }
                        }
                        
                        // Verification badge
                        if user.isVerified {
                            VStack {
                                HStack {
                                    Spacer()
                                    Image(systemName: "checkmark.seal.fill")
                                        .font(.title2)
                                        .foregroundColor(.blue)
                                        .background(Circle().fill(Color.white))
                                        .padding(.trailing, 15)
                                        .padding(.top, 15)
                                }
                                Spacer()
                            }
                        }
                        
                        // Reaction overlay
                        if isShowingReaction && reactionType != .none {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(reactionType.color.opacity(0.8))
                                
                                VStack {
                                    Image(systemName: reactionType.systemImage)
                                        .font(.system(size: 50, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                    Text(reactionType.title)
                                        .font(.title.bold())
                                        .foregroundColor(.white)
                                }
                            }
                            .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isShowingReaction)
                        }
                    }
                    
                    // Profile info section
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            HStack(spacing: 8) {
                                Text(user.name)
                                    .font(.title2.bold())
                                    .foregroundColor(.primary)
                                
                                Text("\(user.age)")
                                    .font(.title2)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            HStack(spacing: 4) {
                                Image(systemName: "location.fill")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("\(user.distance) km away")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Text(user.occupation)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text(user.bio)
                            .font(.body)
                            .foregroundColor(.primary)
                            .lineLimit(3)
                        
                        // Interest tags
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(user.interests.prefix(4), id: \.self) { interest in
                                    Text(interest)
                                        .font(.caption)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color.blue.opacity(0.1))
                                        .foregroundColor(.blue)
                                        .cornerRadius(15)
                                }
                            }
                            .padding(.horizontal, 1)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .offset(offset)
        .rotationEffect(.degrees(rotation))
        .scaleEffect(getScaleAmount())
        .opacity(getOpacity())
        .gesture(
            DragGesture()
                .onChanged { value in
                    withAnimation(.interactiveSpring()) {
                        offset = value.translation
                        rotation = Double(value.translation.width / 10)
                    }
                    
                    // Show reaction based on drag direction
                    if abs(value.translation.width) > 50 {
                        if value.translation.width > 0 {
                            reactionType = .like
                        } else {
                            reactionType = .dislike
                        }
                        
                        if !isShowingReaction {
                            withAnimation(.spring()) {
                                isShowingReaction = true
                            }
                            HapticManager.shared.lightImpact()
                        }
                    } else if abs(value.translation.height) > 80 && value.translation.height < 0 {
                        reactionType = .superLike
                        if !isShowingReaction {
                            withAnimation(.spring()) {
                                isShowingReaction = true
                            }
                            HapticManager.shared.mediumImpact()
                        }
                    } else {
                        if isShowingReaction {
                            withAnimation(.spring()) {
                                isShowingReaction = false
                                reactionType = .none
                            }
                        }
                    }
                }
                .onEnded { value in
                    withAnimation(.spring()) {
                        isShowingReaction = false
                        reactionType = .none
                    }
                    
                    if abs(value.translation.width) > 100 {
                        // Swipe threshold met
                        if value.translation.width > 0 {
                            // Liked
                            withAnimation(.easeOut(duration: 0.3)) {
                                offset = CGSize(width: 500, height: value.translation.height)
                                rotation = 15
                            }
                            HapticManager.shared.successFeedback()
                            onLike(user)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                onRemove(user)
                            }
                        } else {
                            // Disliked
                            withAnimation(.easeOut(duration: 0.3)) {
                                offset = CGSize(width: -500, height: value.translation.height)
                                rotation = -15
                            }
                            HapticManager.shared.lightImpact()
                            onDislike(user)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                onRemove(user)
                            }
                        }
                    } else if value.translation.height < -120 {
                        // Super like
                        withAnimation(.easeOut(duration: 0.3)) {
                            offset = CGSize(width: value.translation.width, height: -800)
                            rotation = 0
                        }
                        HapticManager.shared.heavyImpact()
                        onSuperLike(user)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            onRemove(user)
                        }
                    } else {
                        // Snap back
                        withAnimation(.spring()) {
                            offset = .zero
                            rotation = 0
                        }
                    }
                }
        )
        .onTapGesture {
            onTap(user)
        }
    }
    
    private func getScaleAmount() -> CGFloat {
        let max = UIScreen.main.bounds.width / 2
        let currentAmount = abs(offset.width)
        let percentage = currentAmount / max
        return 1.0 - min(percentage, 0.5) * 0.3
    }
    
    private func getOpacity() -> Double {
        let max = UIScreen.main.bounds.width / 2
        let currentAmount = abs(offset.width)
        let percentage = currentAmount / max
        return 1.0 - min(percentage, 0.5) * 0.8
    }
} 