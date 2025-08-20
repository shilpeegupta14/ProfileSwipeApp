import SwiftUI

// MARK: - Particle Effect for Matches
struct ParticleEffect: View {
    @State private var animate = false
    let color: Color
    
    var body: some View {
        ZStack {
            ForEach(0..<20, id: \.self) { _ in
                Circle()
                    .fill(color)
                    .frame(width: CGFloat.random(in: 4...12))
                    .scaleEffect(animate ? CGFloat.random(in: 0.1...1.0) : 1.0)
                    .opacity(animate ? 0 : 1)
                    .offset(
                        x: animate ? CGFloat.random(in: -200...200) : 0,
                        y: animate ? CGFloat.random(in: -200...200) : 0
                    )
                    .animation(
                        Animation.easeOut(duration: Double.random(in: 1...3))
                            .repeatCount(1, autoreverses: false),
                        value: animate
                    )
            }
        }
        .onAppear {
            animate = true
        }
    }
}

// MARK: - Haptic Feedback Manager
class HapticManager {
    static let shared = HapticManager()
    
    private let impactLight = UIImpactFeedbackGenerator(style: .light)
    private let impactMedium = UIImpactFeedbackGenerator(style: .medium)
    private let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
    private let notificationFeedback = UINotificationFeedbackGenerator()
    
    func prepare() {
        impactLight.prepare()
        impactMedium.prepare()
        impactHeavy.prepare()
        notificationFeedback.prepare()
    }
    
    func lightImpact() {
        impactLight.impactOccurred()
    }
    
    func mediumImpact() {
        impactMedium.impactOccurred()
    }
    
    func heavyImpact() {
        impactHeavy.impactOccurred()
    }
    
    func successFeedback() {
        notificationFeedback.notificationOccurred(.success)
    }
    
    func errorFeedback() {
        notificationFeedback.notificationOccurred(.error)
    }
}

// MARK: - Premium Boost View
struct PremiumBoostView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
                .onTapGesture {
                    isPresented = false
                }
            
            VStack(spacing: 30) {
                // Premium icon with gradient
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.purple, Color.pink, Color.orange]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                }
                .scaleEffect(1.2)
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: true)
                
                VStack(spacing: 15) {
                    Text("Get Profile Boost")
                        .font(.title.bold())
                        .foregroundColor(.white)
                    
                    Text("Be seen by more people for 30 minutes")
                        .font(.body)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                VStack(spacing: 15) {
                    PremiumFeatureRow(
                        icon: "eye.fill",
                        title: "10x more profile views",
                        description: "Skip the line and be one of the top profiles"
                    )
                    
                    PremiumFeatureRow(
                        icon: "heart.fill",
                        title: "More matches",
                        description: "Increase your chances of finding someone special"
                    )
                    
                    PremiumFeatureRow(
                        icon: "clock.fill",
                        title: "30 minutes boost",
                        description: "Stay at the top for maximum visibility"
                    )
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal)
                
                VStack(spacing: 12) {
                    Button(action: {
                        // Handle premium purchase
                        isPresented = false
                    }) {
                        Text("Boost My Profile - $4.99")
                            .font(.headline.bold())
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.purple, Color.pink]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(25)
                    }
                    
                    Button(action: {
                        isPresented = false
                    }) {
                        Text("Maybe Later")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
                .padding(.horizontal)
            }
            .padding()
        }
    }
}

struct PremiumFeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.purple)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
        }
    }
}

// MARK: - Quick Reactions Feature
struct QuickReactionsView: View {
    let user: User
    let onReaction: (String) -> Void
    @State private var selectedReaction: String? = nil
    
    let reactions = ["😍", "🔥", "😘", "💯", "😎", "💪"]
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(reactions, id: \.self) { reaction in
                Button(action: {
                    selectedReaction = reaction
                    onReaction(reaction)
                    HapticManager.shared.lightImpact()
                }) {
                    Text(reaction)
                        .font(.title)
                        .scaleEffect(selectedReaction == reaction ? 1.2 : 1.0)
                        .background(
                            Circle()
                                .fill(Color.white.opacity(0.9))
                                .frame(width: 45, height: 45)
                                .opacity(selectedReaction == reaction ? 1 : 0)
                        )
                }
                .animation(.spring(), value: selectedReaction)
            }
        }
        .padding()
        .background(Color.black.opacity(0.6))
        .cornerRadius(25)
    }
}

// MARK: - Profile Statistics View
struct ProfileStatsView: View {
    let user: User
    @State private var animateStats = false
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Profile Insights")
                .font(.title2.bold())
                .foregroundColor(.primary)
            
            HStack(spacing: 20) {
                StatItem(
                    title: "Profile Views",
                    value: "\(Int.random(in: 50...500))",
                    icon: "eye.fill",
                    color: .blue,
                    animate: animateStats
                )
                
                StatItem(
                    title: "Likes Received",
                    value: "\(Int.random(in: 10...100))",
                    icon: "heart.fill",
                    color: .red,
                    animate: animateStats
                )
                
                StatItem(
                    title: "Super Likes",
                    value: "\(Int.random(in: 1...20))",
                    icon: "star.fill",
                    color: .yellow,
                    animate: animateStats
                )
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(15)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                animateStats = true
            }
        }
    }
}

struct StatItem: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    let animate: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .scaleEffect(animate ? 1.1 : 0.8)
                .animation(.spring().delay(Double.random(in: 0...0.5)), value: animate)
            
            Text(value)
                .font(.headline.bold())
                .foregroundColor(.primary)
                .opacity(animate ? 1.0 : 0.0)
                .animation(.easeInOut.delay(0.3), value: animate)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Photo Verification Badge
struct VerificationBadgeView: View {
    let isVerified: Bool
    @State private var pulse = false
    
    var body: some View {
        if isVerified {
            ZStack {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 30, height: 30)
                    .scaleEffect(pulse ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 1.5).repeatForever(), value: pulse)
                
                Image(systemName: "checkmark")
                    .font(.caption.bold())
                    .foregroundColor(.white)
            }
            .onAppear {
                pulse = true
            }
        }
    }
}

// MARK: - Distance Filter Animation
struct DistanceRadarView: View {
    @State private var radarSweep = false
    let maxDistance: Double
    
    var body: some View {
        ZStack {
            // Radar circles
            ForEach(1...3, id: \.self) { ring in
                Circle()
                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                    .frame(width: CGFloat(ring * 40))
            }
            
            // Sweep line
            Rectangle()
                .fill(Color.blue.opacity(0.6))
                .frame(width: 2, height: 60)
                .offset(y: -30)
                .rotationEffect(.degrees(radarSweep ? 360 : 0))
                .animation(.linear(duration: 2).repeatForever(autoreverses: false), value: radarSweep)
            
            // Center dot
            Circle()
                .fill(Color.blue)
                .frame(width: 6, height: 6)
        }
        .onAppear {
            radarSweep = true
        }
    }
} 