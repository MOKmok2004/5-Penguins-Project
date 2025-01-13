//
//  ContentView.swift
//  5 Penguins Project
//
//  Created by Mok Wen Cong on 4/1/25.
//

import SwiftUI
import MapKit
import CoreLocation

struct ContentView: View {
    @State private var isLoading = true
    @State private var isMenuOpen = false
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.1, green: 0.2, blue: 0.4)
                .ignoresSafeArea()
            
            if isLoading {
                LoadingView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                isLoading = false
                            }
                        }
                    }
            } else {
                HomeView(isMenuOpen: $isMenuOpen)
            }
        }
    }
}

struct HomeView: View {
    @Binding var isMenuOpen: Bool
    @State private var currentPage: String = "Home"
    
    // Updated sample posts data with AI-generated images
    let posts = [
        Post(
            userImage: "user1",
            username: "Sarah Chen",
            activityTitle: "Beach Volleyball Tournament",
            caption: "Perfect weather for our weekend tournament! 🏐 Join us next time for some fun in the sun! #BeachVolleyball #WeekendFun",
            image: "beach-volleyball-post",
            likes: 124,
            shares: 18,
            rating: 4.5,
            timestamp: "2 hours ago"
        ),
        Post(
            userImage: "user2",
            username: "Mike Rodriguez",
            activityTitle: "Mountain Trail Adventure",
            caption: "Epic hiking day at Mount Rainier! The views were absolutely breathtaking 🏃‍♂️🌲 #Hiking #Nature",
            image: "hiking-trail-post",
            likes: 89,
            shares: 12,
            rating: 5.0,
            timestamp: "5 hours ago"
        ),
        Post(
            userImage: "user3",
            username: "Emma Wilson",
            activityTitle: "Sunset Yoga Session",
            caption: "Finding peace at our beachside yoga session 🧘‍♀️ #YogaLife #SunsetVibes",
            image: "sunset-yoga-post",
            likes: 156,
            shares: 23,
            rating: 4.8,
            timestamp: "7 hours ago"
        ),
        Post(
            userImage: "user4",
            username: "Alex Thompson",
            activityTitle: "Rock Climbing Workshop",
            caption: "First time climbing outdoors! Amazing experience with great instructors 🧗‍♂️ #RockClimbing",
            image: "rock-climbing-post",
            likes: 92,
            shares: 15,
            rating: 4.7,
            timestamp: "1 day ago"
        )
    ]
    
    // Define grid layout
    private let gridLayout = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Header
                HeaderView(isMenuOpen: $isMenuOpen, currentPage: $currentPage)
                
                // Main content area
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Spotlight Section
                        VStack(alignment: .leading) {
                            Text("Spotlight")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            SpotlightActivitiesView()
                        }
                        .padding(.top)
                        
                        // Activity Feed Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Recent Activities")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            LazyVGrid(columns: gridLayout, spacing: 16) {
                                ForEach(posts) { post in
                                    PostView(post: post)
                                }
                            }
                        }
                        .padding(.top)
                    }
                }
            }
            
            // Side Menu
            if isMenuOpen {
                SideMenuView(isMenuOpen: $isMenuOpen, currentPage: $currentPage)
                    .transition(.move(edge: .leading))
            }
        }
    }
}

struct SpotlightActivitiesView: View {
    @State private var currentIndex = 0
    @State private var timer: Timer?
    
    // Updated spotlight items with AI-generated banner images
    let spotlightItems = [
        SpotlightItem(
            title: "Summer Beach Olympics",
            description: "Join the biggest beach sports event of the season! Volleyball, frisbee, and more!",
            image: "beach-olympics-banner", // Updated image name
            date: "This Weekend"
        ),
        SpotlightItem(
            title: "Sunset Yoga Retreat",
            description: "Relax and rejuvenate with our expert instructors by the ocean",
            image: "sunset-yoga-banner", // Updated image name
            date: "Next Friday"
        ),
        SpotlightItem(
            title: "Mountain Adventure Week",
            description: "Experience hiking, climbing, and camping in the wilderness",
            image: "mountain-adventure-banner", // Updated image name
            date: "Starting July 15"
        )
    ]
    
    // Update this to use ActivityItem instead of Activity
    let activities = [
        ActivityItem(
            title: "Beach Volleyball",
            price: 25.0,
            rating: 4.7,
            description: "Join us for beach volleyball this weekend!",
            image: "beach-volleyball",
            category: .outdoor,
            tags: [.sports]
        ),
        ActivityItem(
            title: "Movie Night",
            price: 15.0,
            rating: 4.5,
            description: "Watch the latest blockbuster with friends",
            image: "movie-night",
            category: .indoor,
            tags: [.entertainment]
        ),
        ActivityItem(
            title: "Hiking Adventure",
            price: 35.0,
            rating: 4.8,
            description: "Explore nature trails together",
            image: "hiking",
            category: .outdoor,
            tags: [.adventure, .sports]
        )
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    ForEach(0..<spotlightItems.count, id: \.self) { index in
                        SpotlightBanner(item: spotlightItems[index])
                            .frame(width: geometry.size.width)
                    }
                }
                .offset(x: -CGFloat(currentIndex) * geometry.size.width)
                .animation(.easeInOut, value: currentIndex)
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            let threshold: CGFloat = 50
                            if value.translation.width > threshold {
                                previousItem()
                            } else if value.translation.width < -threshold {
                                nextItem()
                            }
                        }
                )
            }
            .frame(height: 200)
            
            // Navigation controls
            HStack {
                // Previous button
                Button(action: previousItem) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                // Page indicators
                HStack(spacing: 8) {
                    ForEach(0..<spotlightItems.count, id: \.self) { index in
                        Circle()
                            .fill(currentIndex == index ? Color.white : Color.white.opacity(0.5))
                            .frame(width: 8, height: 8)
                            .onTapGesture {
                                currentIndex = index
                            }
                    }
                }
                
                Spacer()
                
                // Next button
                Button(action: nextItem) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.white)
                }
            }
            .padding(.top, 8)
            .padding(.horizontal)
        }
        .onAppear {
            startAutoScroll()
        }
        .onDisappear {
            stopAutoScroll()
        }
    }
    
    private func nextItem() {
        currentIndex = (currentIndex + 1) % spotlightItems.count
    }
    
    private func previousItem() {
        currentIndex = currentIndex > 0 ? currentIndex - 1 : spotlightItems.count - 1
    }
    
    private func startAutoScroll() {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            nextItem()
        }
    }
    
    private func stopAutoScroll() {
        timer?.invalidate()
        timer = nil
    }
}

struct SpotlightBanner: View {
    let item: SpotlightItem
    
    var body: some View {
        Button(action: {
            // Navigate to detail view
            print("Navigating to: \(item.title)")
        }) {
            ZStack(alignment: .bottomLeading) {
                // Banner Image
                Image(item.image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()
                
                // Gradient overlay
                LinearGradient(
                    gradient: Gradient(colors: [.black.opacity(0.7), .clear]),
                    startPoint: .bottom,
                    endPoint: .top
                )
                
                // Content
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(item.description)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                    
                    Text(item.date)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.top, 4)
                }
                .padding()
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SpotlightItem {
    let title: String
    let description: String
    let image: String
    let date: String
}

struct HeaderView: View {
    @Binding var isMenuOpen: Bool
    @Binding var currentPage: String
    @State private var showProfile = false
    
    var body: some View {
        HStack {
            // Left side - Menu button
            Button(action: {
                withAnimation {
                    isMenuOpen.toggle()
                }
            }) {
                Image(systemName: "line.horizontal.3")
                    .font(.title2)
                    .foregroundColor(.white)
            }
            .padding(.leading)
            
            Spacer()
            
            // Center - Logo/Home button
            Button(action: {
                currentPage = "Home"
            }) {
                Image("penguin-logo") // Using existing logo image
                    .resizable()
                    .scaledToFit()
                    .frame(height: 40)
            }
            
            Spacer()
            
            // Right side - Profile button
            Button(action: {
                showProfile = true
            }) {
                Image(systemName: "person.circle")
                    .font(.title2)
                    .foregroundColor(.white)
            }
            .padding(.trailing)
        }
        .frame(height: 60)
        .background(Color(red: 0.08, green: 0.15, blue: 0.3))
        .sheet(isPresented: $showProfile) {
            ProfileView()
        }
    }
}

struct SideMenuView: View {
    @Binding var isMenuOpen: Bool
    @Binding var currentPage: String
    @State private var showDicePlanner = false
    @State private var showActivities = false
    @State private var showMapPlanner = false
    
    // Add Map Planner to menu items
    let menuItems = ["Dice Planner", "Map Planner", "Activities", "Friends", "Settings"]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Semi-transparent background
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isMenuOpen = false
                        }
                    }
                
                HStack {
                    // Menu content
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(menuItems, id: \.self) { item in
                            Button(action: {
                                switch item {
                                case "Dice Planner":
                                    showDicePlanner = true
                                case "Map Planner":
                                    showMapPlanner = true
                                case "Activities":
                                    showActivities = true
                                case "Friends", "Settings":
                                    // Handle other menu items
                                    break
                                default:
                                    break
                                }
                                currentPage = item
                                withAnimation {
                                    isMenuOpen = false
                                }
                            }) {
                                HStack {
                                    Image(systemName: getMenuIcon(for: item))
                                        .foregroundColor(.white)
                                    Text(item)
                                        .foregroundColor(.white)
                                        .font(.title3)
                                }
                                .padding(.leading)
                            }
                        }
                        Spacer()
                    }
                    .padding(.top, 60)
                    .frame(width: geometry.size.width * 0.6)
                    .background(Color(red: 0.08, green: 0.15, blue: 0.3))
                    .edgesIgnoringSafeArea(.vertical)
                    
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $showDicePlanner) {
            DicePlannerWindowView()
        }
        .sheet(isPresented: $showMapPlanner) {
            MapPlannerView()
        }
        .sheet(isPresented: $showActivities) {
            ActivitiesView()
        }
    }
    
    // Update getMenuIcon function
    private func getMenuIcon(for item: String) -> String {
        switch item {
        case "Dice Planner":
            return "dice.fill"
        case "Map Planner":
            return "map.fill"
        case "Activities":
            return "figure.run"
        case "Friends":
            return "person.2.fill"
        case "Settings":
            return "gearshape.fill"
        default:
            return "circle"
        }
    }
}

struct DicePlannerWindowView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            DicePlannerView()
            
            // Close button
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                Spacer()
            }
            .padding()
        }
        .frame(minWidth: 800, minHeight: 600)
    }
}

struct LoadingView: View {
    @State private var rotation: Double = 0
    @State private var dots = ""
    
    var body: some View {
        VStack {
            // Penguin image
            Image(systemName: "bird.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.white)
                .rotationEffect(.degrees(rotation))
                .onAppear {
                    withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
                        rotation = 360
                    }
                }
            
            // Loading text
            Text("Loading\(dots)")
                .font(.title2)
                .foregroundColor(.white)
                .onAppear {
                    Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
                        if dots.count == 3 {
                            dots = ""
                        } else {
                            dots += "."
                        }
                    }
                }
        }
    }
}

struct Post: Identifiable {
    let id = UUID()
    let userImage: String
    let username: String
    let activityTitle: String
    let caption: String
    let image: String
    let likes: Int
    let shares: Int
    let rating: Double
    let timestamp: String
}

// Update PostView to be clickable
struct PostView: View {
    let post: Post
    @State private var isLiked = false
    @State private var showDetail = false
    
    var body: some View {
        Button(action: {
            showDetail = true
        }) {
            VStack(alignment: .leading, spacing: 8) {
                // User info header
                HStack {
                    Image(post.userImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text(post.username)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                        Text(post.timestamp)
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    // Star rating
                    HStack(spacing: 1) {
                        ForEach(0..<5) { index in
                            Image(systemName: index < Int(post.rating) ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                                .font(.caption2)
                        }
                    }
                }
                
                // Activity title
                Text(post.activityTitle)
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                // Activity image
                Image(post.image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 120)
                    .clipped()
                    .cornerRadius(8)
                
                // Caption
                Text(post.caption)
                    .font(.caption)
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .padding(.vertical, 2)
                
                // Interaction buttons
                HStack(spacing: 16) {
                    Button(action: { isLiked.toggle() }) {
                        HStack(spacing: 4) {
                            Image(systemName: isLiked ? "heart.fill" : "heart")
                                .foregroundColor(isLiked ? .red : .white)
                            Text("\(post.likes)")
                                .font(.caption)
                        }
                    }
                    
                    Button(action: {}) {
                        HStack(spacing: 4) {
                            Image(systemName: "square.and.arrow.up")
                            Text("\(post.shares)")
                                .font(.caption)
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "ellipsis")
                            .font(.caption)
                    }
                }
                .foregroundColor(.white)
            }
            .padding(12)
            .background(Color(red: 0.15, green: 0.25, blue: 0.45))
            .cornerRadius(12)
            .padding(.horizontal, 8)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showDetail) {
            PostDetailView(post: post)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// Add LocationManager class
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 1.3521, longitude: 103.8198),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first?.coordinate else { return }
        userLocation = location
        region = MKCoordinateRegion(
            center: location,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
}

// Add MRTStation model
struct MRTStation: Identifiable {
    let id = UUID()
    let name: String
    let line: String
    let order: Int // Station order in the line
}

// Update DicePlannerView
struct DicePlannerView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var diceResult = 0
    @State private var isRolling = false
    @State private var destinationStation: MRTStation?
    @State private var nearestStation: MRTStation?
    @State private var showResult = false
    
    // Sample MRT stations with their order in the line
    let stations = [
        MRTStation(name: "Jurong East", line: "NS/EW", order: 1),
        MRTStation(name: "Bukit Batok", line: "NS", order: 2),
        MRTStation(name: "Bukit Gombak", line: "NS", order: 3),
        MRTStation(name: "Choa Chu Kang", line: "NS", order: 4),
        MRTStation(name: "Yew Tee", line: "NS", order: 5),
        MRTStation(name: "Kranji", line: "NS", order: 6),
        MRTStation(name: "Marsiling", line: "NS", order: 7),
        MRTStation(name: "Woodlands", line: "NS", order: 8),
        // Add more stations...
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            // Title
            Text("MRT Adventure Planner")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            // MRT Map
            ZStack {
                Image("singapore-mrt-map") // Add this to assets
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
                
                // Show current location marker if available
                if let currentStation = nearestStation {
                    Text("You are here")
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(6)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            
            // Current Station
            if let current = nearestStation {
                Text("Current Station: \(current.name)")
                    .foregroundColor(.white)
                    .padding(.vertical)
            }
            
            // Dice and Spin Button
            VStack(spacing: 30) {
                DiceView(number: diceResult, isRolling: isRolling)
                    .frame(width: 100, height: 100)
                
                Button(action: rollDice) {
                    Text("SPIN")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(width: 120, height: 44)
                        .background(Color.blue)
                        .cornerRadius(22)
                        .overlay(
                            RoundedRectangle(cornerRadius: 22)
                                .stroke(Color.white, lineWidth: 2)
                        )
                }
                .disabled(isRolling)
            }
            
            // Result Section
            if showResult {
                VStack(spacing: 15) {
                    Text("Take \(diceResult) stations")
                        .font(.title2)
                        .foregroundColor(.white)
                    
                    if let destination = destinationStation {
                        VStack(spacing: 8) {
                            Text("Your destination:")
                                .foregroundColor(.white)
                            Text(destination.name)
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.yellow)
                            Text("Line: \(destination.line)")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding()
                        .background(Color(red: 0.15, green: 0.25, blue: 0.45))
                        .cornerRadius(15)
                    }
                }
                .transition(.scale.combined(with: .opacity))
            }
            
            Spacer()
        }
        .padding()
        .background(Color(red: 0.1, green: 0.2, blue: 0.4))
        .onAppear {
            updateNearestStation()
        }
    }
    
    private func rollDice() {
        guard !isRolling else { return }
        
        isRolling = true
        showResult = false
        
        // Animate dice rolling
        withAnimation(.easeInOut(duration: 2.0)) {
            for _ in 1...20 { // More iterations for longer animation
                diceResult = Int.random(in: 1...6)
            }
        }
        
        // Calculate destination after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if let current = nearestStation {
                destinationStation = findDestinationStation(from: current, stops: diceResult)
            }
            withAnimation {
                showResult = true
            }
            isRolling = false
        }
    }
    
    private func updateNearestStation() {
        // In a real app, calculate nearest station based on location
        // For demo, set a default station
        nearestStation = stations.first
    }
    
    private func findDestinationStation(from station: MRTStation, stops: Int) -> MRTStation {
        // Find station that's 'stops' number of stations away
        let targetOrder = station.order + stops
        return stations.first { $0.order == targetOrder } ?? stations.last!
    }
}

// Update DiceView animation
struct DiceView: View {
    let number: Int
    let isRolling: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(radius: 10)
            
            Text("\(number)")
                .font(.system(size: 50, weight: .bold))
                .foregroundColor(.blue)
        }
        .rotation3DEffect(
            .degrees(isRolling ? 3600 : 0), // Multiple rotations for more dramatic effect
            axis: (x: 1.0, y: 1.0, z: 1.0)
        )
        .animation(
            isRolling ?
                Animation.easeInOut(duration: 2.0) :
                .default,
            value: isRolling
        )
    }
}

// Add MRT station connection data
struct MRTConnection {
    let fromStation: String
    let toStation: String
    let line: String
}

// Add AuthState enum
enum AuthState {
    case signIn
    case signUp
}

// Update ProfileView
struct ProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showCustomization = false
    @State private var showShop = false
    @State private var isAuthenticated = false
    @State private var authState: AuthState = .signIn
    @State private var username = ""
    @State private var password = ""
    
    // Add recentTrips property
    private let recentTrips = [
        TripActivity(
            title: "Beach Volleyball Tournament",
            date: "Yesterday",
            location: "Sentosa Beach",
            pointsEarned: 150,
            image: "beach-volleyball",
            category: "Sports",
            rating: 4.8
        ),
        TripActivity(
            title: "Coffee Workshop",
            date: "3 days ago",
            location: "Artisan Cafe",
            pointsEarned: 100,
            image: "coffee-workshop",
            category: "Workshop",
            rating: 4.5
        ),
        TripActivity(
            title: "Go-Karting Adventure",
            date: "Last week",
            location: "MaxKart Racing",
            pointsEarned: 200,
            image: "go-karting",
            category: "Adventure",
            rating: 4.7
        ),
        TripActivity(
            title: "Rock Climbing Class",
            date: "2 weeks ago",
            location: "Boulder World",
            pointsEarned: 180,
            image: "rock-climbing",
            category: "Sports",
            rating: 4.6
        ),
        TripActivity(
            title: "Pottery Workshop",
            date: "Last month",
            location: "Creative Studio",
            pointsEarned: 120,
            image: "pottery-workshop",
            category: "Workshop",
            rating: 4.9
        )
    ]
    
    var body: some View {
        ZStack {
            Color(red: 0.1, green: 0.2, blue: 0.4)
                .ignoresSafeArea()
            
            if isAuthenticated {
                authenticatedContent
            } else {
                authenticationContent
            }
        }
    }
    
    private var authenticationContent: some View {
        VStack(spacing: 20) {
            // Logo
            Image("penguin-logo")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            
            // Title
            Text(authState == .signIn ? "Welcome Back!" : "Create Account")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            // Form Fields
            VStack(spacing: 15) {
                TextField("Username", text: $username)
                    .textFieldStyle(AuthTextFieldStyle())
                
                SecureField("Password", text: $password)
                    .textFieldStyle(AuthTextFieldStyle())
            }
            .padding(.horizontal)
            
            // Action Button
            Button(action: handleAuthAction) {
                Text(authState == .signIn ? "Sign In" : "Sign Up")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            // Toggle Auth State
            Button(action: toggleAuthState) {
                Text(authState == .signIn ? 
                    "Don't have an account? Sign Up" : 
                    "Already have an account? Sign In")
                    .foregroundColor(.white.opacity(0.8))
            }
            
            // Close Button
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.white)
            }
            .padding(.top, 20)
        }
        .padding()
    }
    
    private var authenticatedContent: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Header with Sign Out
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Text("Welcome, \(username)")
                        .foregroundColor(.white)
                        .font(.headline)
                    
                    Spacer()
                    
                    Button(action: signOut) {
                        Text("Sign Out")
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.red.opacity(0.8))
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
                
                // Updated Penguin Character Section
                VStack(spacing: 15) {
                    Text("Your Penguin")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    ZStack {
                        // Background for penguin
                        Circle()
                            .fill(Color(red: 0.15, green: 0.25, blue: 0.45))
                            .frame(width: 250, height: 250)
                        
                        // Base penguin character
                        Image("base-penguin") // Add this to assets
                            .resizable()
                            .scaledToFit()
                            .frame(height: 220)
                            .shadow(radius: 5)
                    }
                    .padding()
                    
                    // Points Display
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text("1,250 points")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(Color(red: 0.12, green: 0.22, blue: 0.42))
                    .cornerRadius(20)
                    
                    // Customize and Shop Buttons
                    HStack(spacing: 20) {
                        Button(action: { showCustomization = true }) {
                            HStack {
                                Image(systemName: "paintbrush.fill")
                                Text("Customize")
                            }
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 150)
                            .background(Color.blue)
                            .cornerRadius(10)
                        }
                        
                        Button(action: { showShop = true }) {
                            HStack {
                                Image(systemName: "cart.fill")
                                Text("Shop")
                            }
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 150)
                            .background(Color.green)
                            .cornerRadius(10)
                        }
                    }
                }
                .padding()
                .background(Color(red: 0.1, green: 0.2, blue: 0.4))
                .cornerRadius(20)
                .shadow(radius: 5)
                
                // Recent Trips Section
                VStack(alignment: .leading, spacing: 15) {
                    Text("Recent Trips")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                    
                    ForEach(recentTrips) { trip in
                        TripCard(trip: trip)
                    }
                }
                .padding(.top)
            }
            .padding(.vertical)
        }
        .sheet(isPresented: $showCustomization) {
            CustomizationView()
        }
        .sheet(isPresented: $showShop) {
            ShopView(userPoints: 1250)
        }
    }
    
    private func handleAuthAction() {
        // Simulate authentication
        withAnimation {
            isAuthenticated = true
        }
    }
    
    private func toggleAuthState() {
        withAnimation {
            authState = authState == .signIn ? .signUp : .signIn
        }
    }
    
    private func signOut() {
        withAnimation {
            isAuthenticated = false
            username = ""
            password = ""
        }
    }
}

// Add custom text field style
struct AuthTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.white)
            .cornerRadius(8)
            .foregroundColor(.black)
    }
}

// Add supporting views and models
struct UserActivity: Identifiable {
    let id = UUID()
    let description: String
    let pointsEarned: Int
    let date: String
}

struct ActivityRow: View {
    let activity: UserActivity
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(activity.description)
                    .foregroundColor(.white)
                Text(activity.date)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            Text("+\(activity.pointsEarned)")
                .fontWeight(.bold)
                .foregroundColor(.yellow)
        }
        .padding()
        .background(Color(red: 0.15, green: 0.25, blue: 0.45))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

// Add placeholder views for customization and shop
struct CustomizationView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedCategory: OutfitCategory = .hats
    @State private var equippedOutfits: [OutfitCategory: Outfit] = [:]
    
    enum OutfitCategory: String, CaseIterable {
        case hats = "Hats"
        case clothes = "Clothes"
        case accessories = "Accessories"
    }
    
    struct Outfit: Identifiable {
        let id = UUID()
        let name: String
        let image: String
        let category: OutfitCategory
        let isOwned: Bool
    }
    
    // Sample outfits data
    let outfits = [
        Outfit(name: "Party Hat", image: "party-hat", category: .hats, isOwned: true),
        Outfit(name: "Crown", image: "crown", category: .hats, isOwned: true),
        Outfit(name: "T-Shirt", image: "tshirt", category: .clothes, isOwned: true),
        Outfit(name: "Hoodie", image: "hoodie", category: .clothes, isOwned: true),
        Outfit(name: "Sunglasses", image: "sunglasses", category: .accessories, isOwned: true),
        Outfit(name: "Bowtie", image: "bowtie", category: .accessories, isOwned: true)
    ]
    
    var body: some View {
        ZStack {
            Color(red: 0.1, green: 0.2, blue: 0.4)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Text("Customize Your Penguin")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding()
                
                // Updated Penguin Preview
                ZStack {
                    // Background circle
                    Circle()
                        .fill(Color(red: 0.15, green: 0.25, blue: 0.45))
                        .frame(width: 280, height: 280)
                    
                    // Base penguin with equipped items
                    ZStack {
                        Image("base-penguin")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 250)
                        
                        // Equipped items overlay
                        if let hat = equippedOutfits[.hats] {
                            Image(hat.image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 100)
                                .offset(y: -60)
                        }
                        
                        if let clothes = equippedOutfits[.clothes] {
                            Image(clothes.image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 150)
                                .offset(y: 20)
                        }
                        
                        if let accessory = equippedOutfits[.accessories] {
                            Image(accessory.image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 80)
                        }
                    }
                }
                .padding()
                
                // Category Selector
                HStack {
                    ForEach(OutfitCategory.allCases, id: \.self) { category in
                        Button(action: {
                            selectedCategory = category
                        }) {
                            Text(category.rawValue)
                                .foregroundColor(selectedCategory == category ? .white : .white.opacity(0.7))
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(selectedCategory == category ? Color.blue : Color.clear)
                                .cornerRadius(8)
                        }
                    }
                }
                
                // Outfits Grid
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        ForEach(outfits.filter { $0.category == selectedCategory }) { outfit in
                            OutfitItemView(
                                outfit: outfit,
                                isEquipped: equippedOutfits[outfit.category]?.id == outfit.id,
                                onTap: {
                                    if equippedOutfits[outfit.category]?.id == outfit.id {
                                        equippedOutfits.removeValue(forKey: outfit.category)
                                    } else {
                                        equippedOutfits[outfit.category] = outfit
                                    }
                                }
                            )
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

struct OutfitItemView: View {
    let outfit: CustomizationView.Outfit
    let isEquipped: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack {
                Image(outfit.image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 60)
                    .padding(8)
                    .background(isEquipped ? Color.blue.opacity(0.3) : Color(red: 0.15, green: 0.25, blue: 0.45))
                    .cornerRadius(10)
                
                Text(outfit.name)
                    .font(.caption)
                    .foregroundColor(.white)
            }
        }
    }
}

// Update ShopView
struct ShopView: View {
    let userPoints: Int
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedCategory: CustomizationView.OutfitCategory = .hats
    
    // Sample shop items
    let shopItems = [
        ShopItem(name: "Royal Crown", image: "crown-premium", category: .hats, price: 500),
        ShopItem(name: "Winter Coat", image: "winter-coat", category: .clothes, price: 300),
        ShopItem(name: "Gold Chain", image: "gold-chain", category: .accessories, price: 400)
    ]
    
    var body: some View {
        ZStack {
            Color(red: 0.1, green: 0.2, blue: 0.4)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Text("Shop")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text("\(userPoints)")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    }
                }
                .padding()
                
                // Category Selector
                HStack {
                    ForEach(CustomizationView.OutfitCategory.allCases, id: \.self) { category in
                        Button(action: {
                            selectedCategory = category
                        }) {
                            Text(category.rawValue)
                                .foregroundColor(selectedCategory == category ? .white : .white.opacity(0.7))
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(selectedCategory == category ? Color.blue : Color.clear)
                                .cornerRadius(8)
                        }
                    }
                }
                
                // Shop Items Grid
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        ForEach(shopItems.filter { $0.category == selectedCategory }) { item in
                            ShopItemView(item: item, canAfford: userPoints >= item.price)
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

struct ShopItem: Identifiable {
    let id = UUID()
    let name: String
    let image: String
    let category: CustomizationView.OutfitCategory
    let price: Int
}

struct ShopItemView: View {
    let item: ShopItem
    let canAfford: Bool
    
    var body: some View {
        VStack {
            Image(item.image)
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .padding()
                .background(Color(red: 0.15, green: 0.25, blue: 0.45))
                .cornerRadius(15)
            
            Text(item.name)
                .font(.headline)
                .foregroundColor(.white)
            
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                Text("\(item.price)")
                    .foregroundColor(.white)
            }
            
            Button(action: {}) {
                Text(canAfford ? "Purchase" : "Not Enough Points")
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(canAfford ? Color.green : Color.gray)
                    .cornerRadius(8)
            }
            .disabled(!canAfford)
        }
        .padding()
        .background(Color(red: 0.12, green: 0.22, blue: 0.42))
        .cornerRadius(15)
    }
}

// Add ActivityItem model
struct ActivityItem: Identifiable {
    let id = UUID()
    let title: String
    let price: Double
    let rating: Double
    let description: String
    let image: String
    let category: ActivityCategory
    let tags: Set<ActivityTag>
}

enum ActivityCategory: String, CaseIterable {
    case food = "Food"
    case indoor = "Indoor"
    case outdoor = "Outdoor"
}

enum ActivityTag: String, CaseIterable {
    case cafe = "Café"
    case sports = "Sports"
    case adventure = "Adventure"
    case gaming = "Gaming"
    case dining = "Dining"
    case entertainment = "Entertainment"
}

// Add ActivitiesView
struct ActivitiesView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedCategory: ActivityCategory?
    @State private var selectedTags: Set<ActivityTag> = []
    @State private var priceRange: ClosedRange<Double> = 0...200
    @State private var showFilters = true
    
    // Add the activities data
    private let activities = [
        ActivityItem(
            title: "Universal Studios",
            price: 88.0,
            rating: 4.8,
            description: "Experience thrilling rides and shows at Southeast Asia's first Hollywood movie theme park.",
            image: "universal-studios-sg", // Updated image name
            category: .outdoor,
            tags: [.entertainment, .adventure]
        ),
        ActivityItem(
            title: "Gardens by the Bay",
            price: 28.0,
            rating: 4.7,
            description: "Visit the iconic Supertree Grove and explore the stunning indoor gardens.",
            image: "gardens-bay-sg", // Updated image name
            category: .outdoor,
            tags: [.entertainment]
        ),
        ActivityItem(
            title: "ArtScience Museum",
            price: 21.0,
            rating: 4.5,
            description: "Immerse yourself in digital art installations and interactive exhibits.",
            image: "artscience-museum-sg", // Updated image name
            category: .indoor,
            tags: [.entertainment]
        ),
        ActivityItem(
            title: "Singapore Zoo",
            price: 48.0,
            rating: 4.6,
            description: "Get up close with wildlife in an open, natural setting.",
            image: "singapore-zoo-sg", // Updated image name
            category: .outdoor,
            tags: [.entertainment, .adventure]
        ),
        ActivityItem(
            title: "Indoor Skydiving",
            price: 89.0,
            rating: 4.7,
            description: "Experience the thrill of flying in a safe indoor environment.",
            image: "indoor-skydiving-sg", // Updated image name
            category: .indoor,
            tags: [.adventure, .sports]
        ),
        ActivityItem(
            title: "Jewel Changi",
            price: 0.0,
            rating: 4.9,
            description: "Visit the world's tallest indoor waterfall and explore the nature-themed mall.",
            image: "jewel-changi-sg", // Updated image name
            category: .indoor,
            tags: [.entertainment, .dining]
        )
    ]
    
    var body: some View {
        ZStack {
            Color(red: 0.1, green: 0.2, blue: 0.4)
                .ignoresSafeArea()
            
            HStack(spacing: 0) {
                // Filters sidebar
                if showFilters {
                    FilterSidebar(
                        selectedCategory: $selectedCategory,
                        selectedTags: $selectedTags,
                        priceRange: $priceRange
                    )
                    .frame(width: 250)
                    .background(Color(red: 0.12, green: 0.22, blue: 0.42))
                }
                
                // Main content
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Button(action: {
                            withAnimation {
                                showFilters.toggle()
                            }
                        }) {
                            Image(systemName: "line.3.horizontal.decrease")
                                .foregroundColor(.white)
                                .imageScale(.large)
                        }
                        
                        Text("Singapore Activities")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.white)
                                .imageScale(.large)
                        }
                    }
                    .padding()
                    .background(Color(red: 0.08, green: 0.15, blue: 0.3))
                    
                    // Activities grid
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 16),
                            GridItem(.flexible(), spacing: 16)
                        ], spacing: 16) {
                            ForEach(filteredActivities) { activity in
                                ActivityCard(activity: activity)
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .frame(minWidth: 800, minHeight: 600)
    }
    
    private var filteredActivities: [ActivityItem] {
        activities.filter { activity in
            let categoryMatch = selectedCategory == nil || activity.category == selectedCategory
            let tagMatch = selectedTags.isEmpty || !selectedTags.isDisjoint(with: activity.tags)
            let priceMatch = priceRange.contains(activity.price)
            return categoryMatch && tagMatch && priceMatch
        }
    }
}

// Add FilterSidebar
struct FilterSidebar: View {
    @Binding var selectedCategory: ActivityCategory?
    @Binding var selectedTags: Set<ActivityTag>
    @Binding var priceRange: ClosedRange<Double>
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Categories
                VStack(alignment: .leading, spacing: 10) {
                    Text("Categories")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    ForEach(ActivityCategory.allCases, id: \.self) { category in
                        CategoryButton(
                            title: category.rawValue,
                            isSelected: selectedCategory == category,
                            action: {
                                if selectedCategory == category {
                                    selectedCategory = nil
                                } else {
                                    selectedCategory = category
                                }
                            }
                        )
                    }
                }
                
                // Tags
                VStack(alignment: .leading, spacing: 10) {
                    Text("Tags")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    ForEach(ActivityTag.allCases, id: \.self) { tag in
                        CategoryButton(
                            title: tag.rawValue,
                            isSelected: selectedTags.contains(tag),
                            action: {
                                if selectedTags.contains(tag) {
                                    selectedTags.remove(tag)
                                } else {
                                    selectedTags.insert(tag)
                                }
                            }
                        )
                    }
                }
                
                // Price Range
                VStack(alignment: .leading, spacing: 10) {
                    Text("Price Range")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text("$\(Int(priceRange.lowerBound)) - $\(Int(priceRange.upperBound))")
                        .foregroundColor(.white)
                    
                    Slider(value: Binding(
                        get: { priceRange.lowerBound },
                        set: { priceRange = $0...priceRange.upperBound }
                    ), in: 0...200)
                    .tint(.blue)
                    
                    Slider(value: Binding(
                        get: { priceRange.upperBound },
                        set: { priceRange = priceRange.lowerBound...$0 }
                    ), in: 0...200)
                    .tint(.blue)
                }
            }
            .padding()
        }
    }
}

// Update ActivityCard
struct ActivityCard: View {
    let activity: ActivityItem
    @State private var showingDetail = false
    
    var body: some View {
        Button(action: {
            showingDetail = true
        }) {
            VStack(alignment: .leading, spacing: 12) {
                // Activity Image
                Image(activity.image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)  // Increased height
                    .clipped()
                    .cornerRadius(15)
                
                // Title and Price
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(activity.title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        // Rating
                        HStack(spacing: 4) {
                            ForEach(0..<5) { index in
                                Image(systemName: index < Int(activity.rating) ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                                    .font(.caption)
                            }
                            Text(String(format: "%.1f", activity.rating))
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    
                    Spacer()
                    
                    // Price
                    Text(activity.price == 0 ? "Free" : "$\(String(format: "%.2f", activity.price))")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.yellow)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.blue.opacity(0.3))
                        .cornerRadius(10)
                }
                
                // Description preview
                Text(activity.description)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(2)
                
                // Tags
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(Array(activity.tags), id: \.self) { tag in
                            Text(tag.rawValue)
                                .font(.caption)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(15)
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .padding()
            .background(Color(red: 0.15, green: 0.25, blue: 0.45))
            .cornerRadius(20)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingDetail) {
            ActivityDetailView(activity: activity)
        }
    }
}

// Add ActivityDetailView
struct ActivityDetailView: View {
    let activity: ActivityItem
    @Environment(\.presentationMode) var presentationMode
    @State private var showingSplitBillSheet = false
    @State private var showingReservationSheet = false
    @State private var selectedDate = Date()
    @State private var numberOfPeople = 1
    
    // Sample comments data
    private let comments = [
        Comment(
            username: "John Lee",
            rating: 4.5,
            text: "Amazing experience! The staff was very friendly and professional.",
            date: "2 days ago"
        ),
        Comment(
            username: "Sarah Tan",
            rating: 5.0,
            text: "Worth every penny! Will definitely come back again.",
            date: "1 week ago"
        ),
        Comment(
            username: "Mike Chen",
            rating: 4.0,
            text: "Great activity for families. My kids loved it!",
            date: "2 weeks ago"
        )
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header Image
                Image(activity.image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 300)
                    .clipped()
                
                VStack(alignment: .leading, spacing: 20) {
                    // Title and Rating
                    HStack {
                        VStack(alignment: .leading) {
                            Text(activity.title)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            HStack(spacing: 4) {
                                ForEach(0..<5) { index in
                                    Image(systemName: index < Int(activity.rating) ? "star.fill" : "star")
                                        .foregroundColor(.yellow)
                                }
                                Text(String(format: "%.1f", activity.rating))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }
                        
                        Spacer()
                        
                        Text(activity.price == 0 ? "Free" : "$\(String(format: "%.2f", activity.price))")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.yellow)
                    }
                    
                    // Tags
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(Array(activity.tags), id: \.self) { tag in
                                Text(tag.rawValue)
                                    .font(.subheadline)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.blue.opacity(0.3))
                                    .cornerRadius(20)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    
                    // Description
                    VStack(alignment: .leading, spacing: 10) {
                        Text("About")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text(activity.description)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    
                    // Location
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Location")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        HStack {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(.red)
                            Text("8 Sentosa Gateway, Singapore 098269")
                                .foregroundColor(.white.opacity(0.9))
                        }
                    }
                    
                    // Action Buttons
                    HStack(spacing: 20) {
                        Button(action: {
                            showingReservationSheet = true
                        }) {
                            HStack {
                                Image(systemName: "calendar")
                                Text("Reserve")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        
                        Button(action: {
                            showingSplitBillSheet = true
                        }) {
                            HStack {
                                Image(systemName: "person.2.fill")
                                Text("Split Bill")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                    
                    // Reviews Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Reviews")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        ForEach(comments) { comment in
                            CommentView(comment: comment)
                        }
                    }
                }
                .padding()
            }
        }
        .background(Color(red: 0.1, green: 0.2, blue: 0.4))
        .sheet(isPresented: $showingReservationSheet) {
            ReservationView(activity: activity)
        }
        .sheet(isPresented: $showingSplitBillSheet) {
            SplitBillView(activity: activity)
        }
    }
}

// Add Comment model and view
struct Comment: Identifiable {
    let id = UUID()
    let username: String
    let rating: Double
    let text: String
    let date: String
}

struct CommentView: View {
    let comment: Comment
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(comment.username)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(comment.date)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
            }
            
            HStack(spacing: 4) {
                ForEach(0..<5) { index in
                    Image(systemName: index < Int(comment.rating) ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                        .font(.caption)
                }
            }
            
            Text(comment.text)
                .foregroundColor(.white.opacity(0.9))
        }
        .padding()
        .background(Color(red: 0.15, green: 0.25, blue: 0.45))
        .cornerRadius(10)
    }
}

// Add ActivityAvailability struct
struct ActivityAvailability {
    let date: Date
    let totalSpots: Int
    let spotsRemaining: Int
    
    var isSoldOut: Bool {
        spotsRemaining == 0
    }
}

// Update ReservationView
struct ReservationView: View {
    let activity: ActivityItem
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedDate = Date()
    @State private var numberOfPeople = 1
    
    // Sample availability data - In a real app, this would come from a backend
    let availabilityData: [ActivityAvailability] = [
        ActivityAvailability(
            date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
            totalSpots: 20,
            spotsRemaining: 5
        ),
        ActivityAvailability(
            date: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
            totalSpots: 20,
            spotsRemaining: 0
        ),
        ActivityAvailability(
            date: Calendar.current.date(byAdding: .day, value: 3, to: Date())!,
            totalSpots: 20,
            spotsRemaining: 15
        )
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white)
                        .imageScale(.large)
                }
                
                Spacer()
                
                Text("Make Reservation")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding()
            .background(Color(red: 0.08, green: 0.15, blue: 0.3))
            
            ScrollView {
                VStack(spacing: 20) {
                    // Activity Info
                    VStack(alignment: .leading, spacing: 8) {
                        Text(activity.title)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("$\(String(format: "%.2f", activity.price)) per person")
                            .foregroundColor(.yellow)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    
                    // Calendar View
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Select Date")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        CustomDatePicker(
                            selectedDate: $selectedDate,
                            availabilityData: availabilityData
                        )
                    }
                    .padding()
                    .background(Color(red: 0.15, green: 0.25, blue: 0.45))
                    .cornerRadius(15)
                    
                    // Availability Legend
                    HStack(spacing: 20) {
                        AvailabilityIndicator(color: .green, text: "Available")
                        AvailabilityIndicator(color: .orange, text: "Limited")
                        AvailabilityIndicator(color: .red, text: "Sold Out")
                    }
                    .padding()
                    
                    // Number of People
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Number of People")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        HStack {
                            ForEach(1...6, id: \.self) { number in
                                Button(action: {
                                    numberOfPeople = number
                                }) {
                                    Text("\(number)")
                                        .font(.headline)
                                        .frame(width: 40, height: 40)
                                        .background(numberOfPeople == number ? Color.blue : Color(red: 0.2, green: 0.3, blue: 0.5))
                                        .foregroundColor(.white)
                                        .cornerRadius(20)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color(red: 0.15, green: 0.25, blue: 0.45))
                    .cornerRadius(15)
                    
                    // Total Price
                    VStack(spacing: 8) {
                        HStack {
                            Text("Total Price")
                            Spacer()
                            Text("$\(String(format: "%.2f", Double(numberOfPeople) * activity.price))")
                                .fontWeight(.bold)
                        }
                        .foregroundColor(.white)
                        
                        if let availability = getAvailability(for: selectedDate) {
                            Text("\(availability.spotsRemaining) spots remaining")
                                .font(.caption)
                                .foregroundColor(availability.spotsRemaining < 5 ? .orange : .green)
                        }
                    }
                    .padding()
                    .background(Color(red: 0.15, green: 0.25, blue: 0.45))
                    .cornerRadius(15)
                    
                    // Reserve Button
                    Button(action: {
                        // Handle reservation
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Confirm Reservation")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isDateAvailable ? Color.blue : Color.gray)
                            .cornerRadius(10)
                    }
                    .disabled(!isDateAvailable)
                    .padding()
                }
            }
            .background(Color(red: 0.1, green: 0.2, blue: 0.4))
        }
    }
    
    private var isDateAvailable: Bool {
        if let availability = getAvailability(for: selectedDate) {
            return availability.spotsRemaining >= numberOfPeople
        }
        return false
    }
    
    private func getAvailability(for date: Date) -> ActivityAvailability? {
        availabilityData.first { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
}

// Add CustomDatePicker
struct CustomDatePicker: View {
    @Binding var selectedDate: Date
    let availabilityData: [ActivityAvailability]
    
    var body: some View {
        DatePicker(
            "Select Date",
            selection: $selectedDate,
            in: Date()...,
            displayedComponents: [.date]
        )
        .datePickerStyle(.graphical)
        .accentColor(.blue)
        .colorScheme(.dark)
        .onChange(of: selectedDate) { newDate in
            // Ensure selected date is available
            if let availability = getAvailability(for: newDate),
               availability.isSoldOut {
                // Find next available date
                if let nextAvailable = availabilityData.first(where: { !$0.isSoldOut }) {
                    selectedDate = nextAvailable.date
                }
            }
        }
    }
    
    private func getAvailability(for date: Date) -> ActivityAvailability? {
        availabilityData.first { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
}

// Add AvailabilityIndicator
struct AvailabilityIndicator: View {
    let color: Color
    let text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            
            Text(text)
                .font(.caption)
                .foregroundColor(.white)
        }
    }
}

// Add TripActivity struct
struct TripActivity: Identifiable {
    let id = UUID()
    let title: String
    let date: String
    let location: String
    let pointsEarned: Int
    let image: String
    let category: String
    let rating: Double
}

// Add TripCard view
struct TripCard: View {
    let trip: TripActivity
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                // Activity Image
                Image(trip.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(trip.title)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text(trip.location)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text(trip.date)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                    
                    // Rating
                    HStack(spacing: 4) {
                        ForEach(0..<5) { index in
                            Image(systemName: index < Int(trip.rating) ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                                .font(.caption2)
                        }
                        Text(String(format: "%.1f", trip.rating))
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                
                Spacer()
                
                // Points Badge
                VStack {
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                        Text("\(trip.pointsEarned)")
                            .font(.callout)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.3))
                    .cornerRadius(8)
                    
                    Text(trip.category)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.top, 4)
                }
            }
        }
        .padding()
        .background(Color(red: 0.15, green: 0.25, blue: 0.45))
        .cornerRadius(15)
        .padding(.horizontal)
    }
}

// Add CategoryButton
struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(isSelected ? .white : .white.opacity(0.7))
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(isSelected ? Color.blue : Color.clear)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue, lineWidth: 1)
                )
        }
    }
}

// Add PaymentStatus enum if not already present
enum PaymentStatus {
    case unpaid
    case paid
    case pending
}

// Add ParticipantPayment struct if not already present
struct ParticipantPayment: Identifiable {
    let id = UUID()
    let name: String
    var status: PaymentStatus
    let amount: Double
}

// Add SplitBillView
struct SplitBillView: View {
    let activity: ActivityItem
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedDate = Date()
    @State private var payments: [ParticipantPayment]
    
    init(activity: ActivityItem) {
        self.activity = activity
        let initialPayments = [
            ParticipantPayment(name: "You", status: .unpaid, amount: activity.price / 2),
            ParticipantPayment(name: "John", status: .paid, amount: activity.price / 2),
            ParticipantPayment(name: "Sarah", status: .pending, amount: activity.price / 2),
            ParticipantPayment(name: "Mike", status: .unpaid, amount: activity.price / 2)
        ]
        _payments = State(initialValue: initialPayments)
    }
    
    var totalPaid: Double {
        payments.filter { $0.status == .paid }.reduce(0) { $0 + $1.amount }
    }
    
    var totalUnpaid: Double {
        payments.filter { $0.status != .paid }.reduce(0) { $0 + $1.amount }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 16) {
                Text(activity.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(selectedDate.formatted(date: .long, time: .shortened))
                    .foregroundColor(.white.opacity(0.8))
                
                // Bill Summary Card
                VStack(spacing: 12) {
                    Text("Bill Summary")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Divider()
                        .background(Color.white.opacity(0.3))
                    
                    HStack {
                        Text("Total Bill")
                        Spacer()
                        Text("$\(String(format: "%.2f", activity.price))")
                            .fontWeight(.bold)
                    }
                    .foregroundColor(.white)
                    
                    HStack {
                        Text("Amount Paid")
                        Spacer()
                        Text("$\(String(format: "%.2f", totalPaid))")
                            .foregroundColor(.green)
                    }
                    .foregroundColor(.white)
                    
                    HStack {
                        Text("Amount Remaining")
                        Spacer()
                        Text("$\(String(format: "%.2f", totalUnpaid))")
                            .foregroundColor(.red)
                    }
                    .foregroundColor(.white)
                }
                .padding()
                .background(Color(red: 0.15, green: 0.25, blue: 0.45))
                .cornerRadius(15)
            }
            .padding()
            .background(Color(red: 0.1, green: 0.2, blue: 0.4))
            
            // Participants List
            ScrollView {
                VStack(spacing: 16) {
                    Text("Participants")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    ForEach(payments) { payment in
                        ParticipantPaymentRow(payment: payment)
                    }
                }
                .padding(.vertical)
            }
            .background(Color(red: 0.12, green: 0.22, blue: 0.42))
        }
    }
}

// Add ParticipantPaymentRow if not already present
struct ParticipantPaymentRow: View {
    let payment: ParticipantPayment
    
    var body: some View {
        HStack {
            // Profile Picture or Initial
            Circle()
                .fill(Color.blue.opacity(0.3))
                .frame(width: 40, height: 40)
                .overlay(
                    Text(payment.name.prefix(1))
                        .foregroundColor(.white)
                        .font(.headline)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(payment.name)
                    .foregroundColor(.white)
                    .font(.headline)
                
                Text("$\(String(format: "%.2f", payment.amount))")
                    .foregroundColor(.white.opacity(0.8))
                    .font(.subheadline)
            }
            
            Spacer()
            
            // Payment Status
            PaymentStatusView(status: payment.status)
        }
        .padding()
        .background(Color(red: 0.15, green: 0.25, blue: 0.45))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

// Add PaymentStatusView if not already present
struct PaymentStatusView: View {
    let status: PaymentStatus
    
    var body: some View {
        HStack {
            Image(systemName: statusIcon)
            Text(statusText)
                .font(.caption)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(statusColor.opacity(0.2))
        .cornerRadius(20)
        .foregroundColor(statusColor)
    }
    
    private var statusIcon: String {
        switch status {
        case .paid:
            return "checkmark.circle.fill"
        case .pending:
            return "clock.fill"
        case .unpaid:
            return "circle"
        }
    }
    
    private var statusText: String {
        switch status {
        case .paid:
            return "Paid"
        case .pending:
            return "Pending"
        case .unpaid:
            return "Unpaid"
        }
    }
    
    private var statusColor: Color {
        switch status {
        case .paid:
            return .green
        case .pending:
            return .yellow
        case .unpaid:
            return .red
        }
    }
}

// Add Location model for map annotations
struct Location: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

// Add PlannedActivity model
struct PlannedActivity: Identifiable {
    let id = UUID()
    let name: String
    let location: CLLocationCoordinate2D
    let duration: TimeInterval // in minutes
    let startTime: Date
    var participants: [String]
}

// Add TravelInfo model
struct TravelInfo {
    let duration: TimeInterval // in minutes
    let mode: TransportMode
    let route: [CLLocationCoordinate2D]
}

enum TransportMode: String {
    case mrt = "train.side.front.car"
    case bus = "bus"
    case walk = "figure.walk"
}

// Update MapPlannerView
struct MapPlannerView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var locationManager = LocationManager()
    @State private var showManageActivities = false
    @State private var showCollaborators = false
    @State private var plannedActivities: [PlannedActivity] = []
    @State private var collaborators: [String] = ["John", "Sarah", "Mike"]
    
    // Sample data
    let sampleActivities = [
        PlannedActivity(
            name: "Universal Studios",
            location: CLLocationCoordinate2D(latitude: 1.2540, longitude: 103.8238),
            duration: 240, // 4 hours
            startTime: Calendar.current.date(bySettingHour: 10, minute: 0, second: 0, of: Date())!,
            participants: ["You", "John", "Sarah"]
        ),
        PlannedActivity(
            name: "Marina Bay Sands Lunch",
            location: CLLocationCoordinate2D(latitude: 1.2847, longitude: 103.8610),
            duration: 90, // 1.5 hours
            startTime: Calendar.current.date(bySettingHour: 14, minute: 30, second: 0, of: Date())!,
            participants: ["You", "John", "Sarah", "Mike"]
        ),
        PlannedActivity(
            name: "Gardens by the Bay",
            location: CLLocationCoordinate2D(latitude: 1.2816, longitude: 103.8636),
            duration: 180, // 3 hours
            startTime: Calendar.current.date(bySettingHour: 16, minute: 0, second: 0, of: Date())!,
            participants: ["You", "Sarah"]
        )
    ]
    
    var body: some View {
        ZStack {
            Color(red: 0.1, green: 0.2, blue: 0.4)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Text("Trip Planner")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding()
                .background(Color(red: 0.08, green: 0.15, blue: 0.3))
                
                // Map with route
                Map(coordinateRegion: $locationManager.region,
                    showsUserLocation: true,
                    annotationItems: plannedActivities) { activity in
                    MapAnnotation(coordinate: activity.location) {
                        VStack {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(.red)
                                .font(.title)
                            
                            Text(activity.name)
                                .font(.caption)
                                .padding(4)
                                .background(Color.white)
                                .cornerRadius(4)
                        }
                    }
                }
                .overlay(
                    TimelineOverlay(activities: plannedActivities)
                        .padding()
                    , alignment: .topLeading
                )
                .cornerRadius(15)
                .padding()
                
                // Action Buttons
                HStack(spacing: 20) {
                    Button(action: {
                        showManageActivities = true
                    }) {
                        HStack {
                            Image(systemName: "list.bullet")
                            Text("Manage Activities")
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                    }
                    
                    Button(action: {
                        showCollaborators = true
                    }) {
                        HStack {
                            Image(systemName: "person.2.fill")
                            Text("Collaborators")
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                    }
                }
                .padding()
            }
        }
        .frame(minWidth: 800, minHeight: 600)
        .sheet(isPresented: $showManageActivities) {
            ManageActivitiesView(activities: $plannedActivities)
        }
        .sheet(isPresented: $showCollaborators) {
            CollaboratorsView(collaborators: $collaborators)
        }
        .onAppear {
            // Load sample data
            plannedActivities = sampleActivities
        }
    }
}

// Add TimelineOverlay view
struct TimelineOverlay: View {
    let activities: [PlannedActivity]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Timeline")
                .font(.headline)
                .foregroundColor(.white)
            
            ForEach(activities) { activity in
                VStack(alignment: .leading, spacing: 4) {
                    Text(activity.name)
                        .font(.subheadline)
                        .foregroundColor(.white)
                    
                    Text(formatTime(activity.startTime))
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text("\(Int(activity.duration)) minutes")
                        .font(.caption)
                        .foregroundColor(.yellow)
                    
                    // Participants
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(activity.participants, id: \.self) { participant in
                                Text(participant)
                                    .font(.caption2)
                                    .padding(4)
                                    .background(Color.blue.opacity(0.3))
                                    .cornerRadius(4)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
                .padding(8)
                .background(Color.black.opacity(0.5))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.black.opacity(0.3))
        .cornerRadius(12)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// Add ManageActivitiesView
struct ManageActivitiesView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var activities: [PlannedActivity]
    @State private var newActivityName = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(activities) { activity in
                    PlannedActivityRow(activity: activity) // Changed from ActivityRow to PlannedActivityRow
                }
                .onDelete(perform: deleteActivity)
                
                // Add new activity section
                Section(header: Text("Add New Activity")) {
                    TextField("Activity Name", text: $newActivityName)
                    Button("Add Activity") {
                        addActivity()
                    }
                }
            }
            .navigationTitle("Manage Activities")
            .toolbar {
                Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
    
    private func deleteActivity(at offsets: IndexSet) {
        activities.remove(atOffsets: offsets)
    }
    
    private func addActivity() {
        if !newActivityName.isEmpty {
            let newActivity = PlannedActivity(
                name: newActivityName,
                location: CLLocationCoordinate2D(latitude: 1.3521, longitude: 103.8198),
                duration: 60,
                startTime: Date(),
                participants: ["You"]
            )
            activities.append(newActivity)
            newActivityName = ""
        }
    }
}

// Add CollaboratorsView
struct CollaboratorsView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var collaborators: [String]
    @State private var newCollaborator = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(collaborators, id: \.self) { collaborator in
                    HStack {
                        Text(collaborator)
                        Spacer()
                        Button(action: {
                            removeCollaborator(collaborator)
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                    }
                }
                
                Section(header: Text("Add Collaborator")) {
                    TextField("Name", text: $newCollaborator)
                    Button("Add") {
                        addCollaborator()
                    }
                }
            }
            .navigationTitle("Collaborators")
            .toolbar {
                Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
    
    private func addCollaborator() {
        if !newCollaborator.isEmpty {
            collaborators.append(newCollaborator)
            newCollaborator = ""
        }
    }
    
    private func removeCollaborator(_ collaborator: String) {
        collaborators.removeAll { $0 == collaborator }
    }
}

// Replace the existing ActivityRow with PlannedActivityRow
struct PlannedActivityRow: View {
    let activity: PlannedActivity
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(activity.name)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(formatTime(activity.startTime))
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                
                Text("\(Int(activity.duration)) minutes")
                    .font(.caption)
                    .foregroundColor(.blue)
                
                // Participants
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(activity.participants, id: \.self) { participant in
                            Text(participant)
                                .font(.caption2)
                                .padding(4)
                                .background(Color.blue.opacity(0.3))
                                .cornerRadius(4)
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            
            Spacer()
            
            // Participants count
            HStack {
                Image(systemName: "person.2")
                Text("\(activity.participants.count)")
            }
            .foregroundColor(.white.opacity(0.7))
        }
        .padding()
        .background(Color(red: 0.15, green: 0.25, blue: 0.45))
        .cornerRadius(10)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// Add PostDetailView
struct PostDetailView: View {
    let post: Post
    @Environment(\.presentationMode) var presentationMode
    
    // Sample comments
    let comments = [
        PostComment(
            username: "JohnDoe",
            text: "This looks amazing! How was the weather?",
            timestamp: "2 hours ago"
        ),
        PostComment(
            username: "SarahLee",
            text: "Great photos! Would love to join next time!",
            timestamp: "1 hour ago"
        ),
        PostComment(
            username: "MikeWong",
            text: "The view is breathtaking! 😍",
            timestamp: "30 minutes ago"
        )
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header with close button
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                }
                .padding()
                
                // User info
                HStack {
                    Image(post.userImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading) {
                        Text(post.username)
                            .font(.headline)
                            .foregroundColor(.white)
                        Text(post.timestamp)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    // Rating
                    HStack {
                        ForEach(0..<5) { index in
                            Image(systemName: index < Int(post.rating) ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                        }
                        Text(String(format: "%.1f", post.rating))
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal)
                
                // Activity Title
                Text(post.activityTitle)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                
                // Main Image
                Image(post.image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 400)
                    .cornerRadius(15)
                    .padding(.horizontal)
                
                // Caption and Description
                VStack(alignment: .leading, spacing: 15) {
                    Text(post.caption)
                        .font(.body)
                        .foregroundColor(.white)
                    
                    Divider()
                        .background(Color.white.opacity(0.3))
                    
                    // Activity Details
                    Group {
                        DetailRow(icon: "mappin.circle.fill", text: "Marina Bay Sands, Singapore")
                        DetailRow(icon: "dollarsign.circle.fill", text: "$88 per person")
                        DetailRow(icon: "clock.fill", text: "Duration: 2 hours")
                    }
                }
                .padding(.horizontal)
                
                // Comments Section
                VStack(alignment: .leading, spacing: 15) {
                    Text("Comments")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    ForEach(comments) { comment in
                        CommentRow(comment: comment)
                    }
                    
                    // Add Comment TextField
                    HStack {
                        TextField("Add a comment...", text: .constant(""))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button(action: {}) {
                            Image(systemName: "paperplane.fill")
                                .foregroundColor(.blue)
                        }
                    }
                }
                .padding()
            }
        }
        .background(Color(red: 0.1, green: 0.2, blue: 0.4))
    }
}

// Add supporting views
struct DetailRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
            Text(text)
                .foregroundColor(.white)
        }
    }
}

struct PostComment: Identifiable {
    let id = UUID()
    let username: String
    let text: String
    let timestamp: String
}

struct CommentRow: View {
    let comment: PostComment
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(comment.username)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(comment.timestamp)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Text(comment.text)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.9))
        }
        .padding()
        .background(Color(red: 0.15, green: 0.25, blue: 0.45))
        .cornerRadius(10)
    }
}
