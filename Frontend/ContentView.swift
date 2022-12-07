import SwiftUI
import AVFoundation
import Firebase
import FirebaseAuth

//Custom colors

let lightBlueColor = Color(red: 103/255, green: 153/255, blue: 154/255)
let darkBlueColor = Color(red: 49/255, green: 76/255, blue: 76/255)

struct ContentView: View {
    @State var showingLoginScreen = false
    var body: some View {
        
        return Group {
            if showingLoginScreen {
                homePage()
            }
            else { loginScreen(showingLoginScreen: $showingLoginScreen)
            }
        }
    }
}

struct homePage: View {
    @State private var sessionContext = ""
    @AppStorage("selection") var selection:String = "Dog 1"
    @AppStorage("lexigramAlbum")  var lexigramAlbum:String = "Assorted"
    @State private var nameOfDog: String = ""
    @State private var dogNames: [String] = []
    
    var body: some View {
        NavigationView{
            ZStack{
                Color(red: 103/255, green: 153/255, blue: 154/255)
                    .ignoresSafeArea()
                GeometryReader { geo in
                    Circle()
                        .scale(1.4)
                        .foregroundColor(darkBlueColor)
                        .frame(width: geo.size.width, height: geo.size.height)
                }
                
                Circle()
                    .scale(1)
                    .foregroundColor(.white)
                
                VStack (alignment: .leading){
                    Spacer()
                        .frame(height: -50)
                    Text("Let's get started")
                        .font(.system(size: 40))
                        .foregroundColor(Color.black)
                        .bold()
                        .padding()
                    
                    LazyHGrid(rows: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Rows@*/[GridItem(.fixed(20))]/*@END_MENU_TOKEN@*/) {
                        
                        Text("Select your test user:").foregroundColor(Color.black)
                        Text("                       ")
                        Menu (selection)
                        {
                            ForEach(dogNames, id: \.self) { dog in
                                Button(dog, action: {selection = dog})
                            }            } .onChange(of: selection) { newValue in
                                dogsForSession.append(selection)
                            }
                        Text("                       ")
                        NavigationLink(destination: AddDog()) {
                        Text("Add New Dog")
                        .foregroundColor(Color.white)
                        .frame(width: 300, height: 50)
                        .background(lightBlueColor
                        )
                        .cornerRadius(10)
                        }
                    }
                    Spacer()
                        .frame(height: -50)
                    LazyHGrid(rows: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Rows@*/[GridItem(.fixed(20))]/*@END_MENU_TOKEN@*/) {
                        Text("                              ")
                        Text("Lexigram Album:")
                            .foregroundColor(Color.black)
                        Menu(lexigramAlbum)
                        {
                            Button("Places", action: places)
                            Button("Things", action: things)
                            Button("Feelings", action: feelings)
                            Button("Actions", action: actions1)
                          //  Button("Assorted", action: assorted)
                        }
                    }
                    
                    TextField("Enter Session Context", text: $sessionContext)
                        .padding()
                        .frame(width: 300, height:50, alignment: .center)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                    
                    if lexigramAlbum == "Places"{
                        NavigationLink(destination: placesActivityPage()) {
                            Text("Begin")
                                .foregroundColor(Color.white)
                                .frame(width: 300, height: 50)
                                .background(lightBlueColor)
                                .cornerRadius(10)
                                .onDisappear() {
                                retrieveSessionContext()
                                }
                        }
                    }else if lexigramAlbum == "Things"{
                        NavigationLink(destination: thingsActivityPage()) {
                            Text("Begin")
                                .foregroundColor(Color.white)
                                .frame(width: 300, height: 50)
                                .background(lightBlueColor)
                                .cornerRadius(10)
                                .onDisappear() {
                                retrieveSessionContext()
                                }
                        }
                    }else if lexigramAlbum == "Feelings"{
                        NavigationLink(destination: feelingsActivityPage()) {
                            Text("Begin")
                                .foregroundColor(Color.white)
                                .frame(width: 300, height: 50)
                                .background(lightBlueColor)
                                .cornerRadius(10)
                                .onDisappear() {
                                retrieveSessionContext()
                                }
                        }
                    }else if lexigramAlbum == "Actions"{
                        NavigationLink(destination: actionsActivityPage()) {
                            Text("Begin")
                                .foregroundColor(Color.white)
                                .frame(width: 300, height: 50)
                                .background(lightBlueColor)
                                .cornerRadius(10)
                                .onDisappear() {
                                retrieveSessionContext()
                                }
                        }
                    }
                }
            }
        }
        .accentColor(darkBlueColor)
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
        .onAppear(){
            fetchDogs()
        }
    }
    func retrieveSessionContext(){
        sessionGoal = sessionContext
    }

    func dog1() {
        selection = "Dog 1"
    }
    func dog2() {
        selection = "Dog 2"
    }
    func dog3() {
        selection = "Dog 3"
    }
    
    
    func places() {
        lexigramAlbum  = "Places"
    }
    func things() {
        lexigramAlbum = "Things"
    }
    func feelings() {
        lexigramAlbum = "Feelings"
    }
    func actions1() {
        lexigramAlbum = "Actions"
    }
    //func assorted() {
      //  lexigramAlbum = "Assorted"
   // }
    func fetchDogs(){
        // Get the data from database
        let db = Firestore.firestore()
        
        db.collection("Dogs").getDocuments { snapshot, error in
            
            if error == nil && snapshot != nil{
                
                
                //Loop througn all the returned docs
                for doc in snapshot!.documents {
                    // Extract the file path
                    dogNames.append(doc["name"] as! String)
                }
                
                for name in dogNames{
                    print("\(name)")
                }
            }
        }
    }
}

struct loginScreen: View {
    @State private var email = ""
    @State private var password = ""
    @State private var wrongEmail = 0
    @State private var wrongPassword = 0
    @Binding var showingLoginScreen: Bool
    @State private var user = 0
    @State private var admin = 0
    
    //let images = ["Loading","Beach"] // Array of image names to show
    //@State var activeImageIndex = 0 // Index of the currently displayed image
    //let imageSwitchTimer = Timer.publish(every: 5, on: .main, in: .common)
    //.autoconnect()
    
    var body: some View {
        NavigationView{
            ZStack{
                
                Color(red: 103/255, green: 153/255, blue: 154/255)
                    .ignoresSafeArea()
                GeometryReader { geo in
                    Circle()
                        .scale(1.4)
                        .foregroundColor(darkBlueColor)
                        .frame(width: geo.size.width, height: geo.size.height)
                }
                
                Circle()
                    .scale(1)
                    .foregroundColor(.white)
                VStack{
                    Spacer()
                        .frame(height: 100)
                    /*if (activeImageIndex) <= 0 {
                     Spacer()
                     .frame(height: 680)
                     
                     Image(images[activeImageIndex])
                     .resizable()
                     .scaledToFit()
                     .frame(width: 2000, height: 2000)
                     .onReceive(imageSwitchTimer) { _ in
                     // Go to the next image. If this is the last image, go
                     // back to the image #0
                     self.activeImageIndex = (self.activeImageIndex + 1)
                     }
                     } else{
                     
                     }*/
                    Image("Logo")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                    Text("Login")
                        .font(.largeTitle)
                        .foregroundColor(Color.black)
                        .bold()
                        .padding()
                    TextField("Email", text: $email)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .border(.red,width: CGFloat(wrongEmail))
                    SecureField("Password", text: $password)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .border(.red,width: CGFloat(wrongPassword))
                    Button("Login"){
                        login()
                    }                    .foregroundColor(Color.white)
                    .frame(width: 300, height: 50)
                    .background(lightBlueColor)
                    .cornerRadius(10)
                    
                    NavigationLink(destination: newUser( )) {
                        Text("Register")
                            .foregroundColor(Color.white)
                            .frame(width: 300, height: 50)
                            .background(lightBlueColor)
                            .cornerRadius(10)
                    }
                    
                }
            }
            
        }
        .accentColor(lightBlueColor)
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
    }
    func login(){
        Auth.auth().signIn(withEmail: email, password: password){
            result, error in
            if error != nil{
                print(error!.localizedDescription)
            }
            else{showingLoginScreen = true}
        }
    }
}

struct lexigramSettings: View {
    
    var body: some View {
        ZStack{
            Color(red: 103/255, green: 153/255, blue: 154/255)
                .ignoresSafeArea()
            Circle()
                .scale(1.4)
                .foregroundColor(darkBlueColor)
            Circle()
                .scale(1)
                .foregroundColor(.white)
            VStack {
                Image(systemName: "gearshape.circle")
                    .foregroundColor(darkBlueColor)
                    .font(.system(size: 90))
                Text("Lexigram Options")
                    .font(.system(size: 60))
                    .bold()
                
                Spacer()
                    .frame(height: 50)
                
                NavigationLink(destination: lexigramAlbum( )) {
                    Text("Lexigram Albums")
                        .foregroundColor(Color.white)
                        .frame(width: 300, height: 50)
                        .background(lightBlueColor)
                        .cornerRadius(10)
                }
                
               /* NavigationLink(destination: arrangeLexigrams()) {
                    Text("Rearrange Lexigrams")
                        .foregroundColor(Color.white)
                        .frame(width: 300, height: 50)
                        .background(lightBlueColor)
                        .cornerRadius(10)
                }*/
                NavigationLink(destination: settingHome()) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(darkBlueColor)
                    Text("Settings")
                }
            }
            .navigationBarHidden(true)
            .navigationViewStyle(.stack)
            .accentColor(darkBlueColor)
        }
    }
}
struct audioSettings: View {
    var body: some View {
        ZStack{
            Color(red: 103/255, green: 153/255, blue: 154/255)
                .ignoresSafeArea()
            Circle()
                .scale(1.4)
                .foregroundColor(darkBlueColor)
            Circle()
                .scale(1)
                .foregroundColor(.white)
            VStack {
                Image(systemName: "speaker.wave.2")
                    .foregroundColor(darkBlueColor)
                    .font(.system(size: 90))
                Text("Audio Settings")
                    .font(.system(size: 60))
                    .bold()
                
                NavigationLink(destination: audioFiles()) {
                    Text("Audio Files")
                        .foregroundColor(Color.white)
                        .frame(width: 300, height: 50)
                        .background(lightBlueColor)
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: newAudio()) {
                    Text("Add New Files")
                        .foregroundColor(Color.white)
                        .frame(width: 300, height: 50)
                        .background(lightBlueColor)
                        .cornerRadius(10)
                }
                NavigationLink(destination: settingHome()) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(darkBlueColor)
                    Text("Settings")
                }
                
            }
            .navigationBarHidden(true)
            .navigationViewStyle(.stack)
            .accentColor(darkBlueColor)
        }
    }
}


var lexigrams: [String] = []
var sessionGoal: String = ""
var timeOfPress: [String] = []
var dogsForSession: [String] = []

func exportData(lexigramPressed: [String],sessionContext: String, dateTiime: [String],dogsSelected: [String]){
    let currentDateTime = Date()
    
    let formatter = DateFormatter()
    formatter.timeStyle = .medium
    formatter.dateStyle = .medium
    
    let dateTimeString = formatter.string(from: currentDateTime)
    print(NSHomeDirectory())
    // File Name
    let sFileName = "Session: \(dateTimeString).csv"
    
    let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    
    let documentURL = URL(fileURLWithPath: documentDirectoryPath).appendingPathComponent(sFileName)
    
    let output =  OutputStream.toMemory()
    
    let csvWriter = CHCSVWriter(outputStream: output, encoding: String.Encoding.utf8.rawValue, delimiter: ",".utf16.first!)
    
    //Header for the CSV file
 
    csvWriter?.writeField("Dogs_For_Session")
    csvWriter?.writeField("Session_Context")
    csvWriter?.writeField("Date_Time")
    csvWriter?.writeField("Lexigrams_Pressed")
    csvWriter?.finishLine()
    
    //Array to add data to add Users
    
    var arrOfUserData = [[String]]()
    let lexigramString = lexigrams.joined(separator: ",")
    let dateString = timeOfPress.joined(separator: ",")
    let dogString = dogsForSession.joined(separator: ",")
    
    arrOfUserData.append([dogString,sessionGoal,dateString,lexigramString])
    //arrOfUserData.append(["234","Johnson Doe","34","HR"])
    //arrOfUserData.append(["567","John Appleseed","40","Engg"])

    
   // arrOfUserData.append(lexigrams)
    
    //Employee_ID,Employee_Name,Employee_Age,Employee_Designation
    // 123          John Doe        30          Sys Analyst
    for(elements) in arrOfUserData.enumerated(){
        csvWriter?.writeField(elements.element[0]) // Dog_In_Session
        csvWriter?.writeField(elements.element[1]) // Session_Context
        csvWriter?.writeField(elements.element[2]) // Date/Time
        csvWriter?.writeField(elements.element[3]) // Lexigrams_Pressed
        csvWriter?.finishLine() //Creates a new line
    }
        csvWriter?.closeStream()
        
        let buffer = (output.property(forKey: .dataWrittenToMemoryStreamKey) as? Data)!
        
        do{
            try buffer.write(to: documentURL)
        }
        catch{
          print("error")
        }
}

struct exportPage: View {
    
    
    @AppStorage("selection") var selection:String = "All Users"
    @AppStorage("timePeriod") var timePeriod:String = "Last 30 days"
    @State private var showAlert = false
    
    var body: some View {
        NavigationView{
            ZStack{
                Color(red: 103/255, green: 153/255, blue: 154/255)
                    .ignoresSafeArea()
                Circle()
                    .scale(1.4)
                    .foregroundColor(darkBlueColor)
                Circle()
                    .scale(1)
                    .foregroundColor(.white)
                
                VStack {
                    Image(systemName: "square.and.arrow.down")
                        .foregroundColor(darkBlueColor)
                        .font(.system(size: 90))
                    Text("Export")
                        .font(.system(size: 60))
                        .bold()
                    Spacer()
                        .frame(height: -10)
                    LazyHGrid(rows: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Rows@*/[GridItem(.fixed(20))]/*@END_MENU_TOKEN@*/) {
                        
                        Text("User:")
                        Text("                       ")
                        Menu(selection){
                            Button("All Users", action: allUsers)
                            Button("User 1", action: user1)
                            Button("User 2", action: user2)
                            Button("User 3", action: user3)
                        }
                    }
                    
                    LazyHGrid(rows: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Rows@*/[GridItem(.fixed(20))]/*@END_MENU_TOKEN@*/) {
                        
                        Text("Time Period:")
                        Text("                       ")
                        Menu(timePeriod){
                            Button("Last 7 days", action: week)
                            Button("Last 30 days", action: month)
                            Button("Year to Date", action: year)
                        }
                    }
                    LazyHGrid(rows: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Rows@*/[GridItem(.fixed(20))]/*@END_MENU_TOKEN@*/) {
                        
                        Text("Format")
                        Text("                        ")
                        Button("Excel(.csv)") {
                            print("I love buttons")
                        }
                    }
                    Button("Export") {
                        exportData(lexigramPressed:lexigrams, sessionContext: sessionGoal, dateTiime: timeOfPress,dogsSelected: dogsForSession)
                        showAlert = true
                    }                    .foregroundColor(Color.white)
                    .frame(width: 300, height: 50)
                    .background(lightBlueColor)
                    .cornerRadius(10)
                    .alert("File for the current session has been saved.", isPresented: $showAlert) {
                        Button("OK", role: .cancel) { }
                    }
                    
                    NavigationLink(destination: settingHome()) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(darkBlueColor)
                        Text("Settings")
                    }
                }
                .accentColor(darkBlueColor)
            }
        }
        .navigationBarHidden(true)
        .navigationViewStyle(.stack)
    }
    
    func allUsers() {
        selection = "All Users"
    }
    func user1() {
        selection = "User 1"
    }
    func user2() {
        selection = "User 2"
    }
    func user3() {
        selection = "User 3"
    }
    
    func week() {
        timePeriod = "Last 7 days"
    }
    func  month() {
        timePeriod = "Last 30 days"
    }
    func year() {
        timePeriod = "Year to Date"
    }
}

struct newUser: View {
    @State var email = ""
    @State private var password1 = ""
    @State private var password2 = ""
    @State var passMatch: Bool = false
    @State var showingLoginScreen = true
    @State var userRegistered = false
    
    var body: some View {
        NavigationView{
            ZStack{
                Color(red: 103/255, green: 153/255, blue: 154/255)
                    .ignoresSafeArea()
                Circle()
                    .scale(1.4)
                    .foregroundColor(darkBlueColor)
                Circle()
                    .scale(1)
                    .foregroundColor(.white)
                
                VStack{
                    Image(systemName: "pawprint.circle")
                        .foregroundColor(lightBlueColor)
                        .font(.system(size: 90))
                    Text("Welcome!")
                        .font(.system(size: 60))
                        .foregroundColor(Color.black)
                        .bold()
                        .padding()
                    Text("Define user creditials below")
                
                TextField("Email", text: $email)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(10)
                
                SecureField("Password", text: $password1)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(10)

                Spacer()
                    .frame(height: 50)
                if email != "" && password1 != ""
                {
                    Spacer()
                        .frame(height: 40)
                    Text("Please re-enter your password")
                        .foregroundColor(.gray)
                    
                    SecureField("Password", text: $password2)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                    
                    if password2 != ""
                    {
                        if password1 != password2 {
                            Text("Passwords do not match")
                                .foregroundColor(.red)
                        } else if password1 == password2 && email != ""{
                            Button("Save") {( passMatch.toggle())
                                register()
                                userRegistered = true
                            } .alert(email + " was created", isPresented: $userRegistered) {
                                Button("OK", role: .cancel) { }
                                    .foregroundColor(Color.white)
                                    .frame(width: 300, height: 50)
                                    .background(lightBlueColor)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    
                    
                    
                }
                NavigationLink(destination: ContentView()) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(darkBlueColor)
                    Text("Return to Login")
                }
            }
            .accentColor(darkBlueColor)
        }
        }
        .navigationBarHidden(true)
        .navigationViewStyle(.stack)
    }
    func register(){
        Auth.auth().createUser(withEmail: email, password: password1){
            result, error in
            if error  != nil {
                print(error!.localizedDescription)
            }
        }
    }
}

struct lexigramAlbum: View {
    
    var body: some View {
        NavigationView{
            ZStack{
                Color(red: 103/255, green: 153/255, blue: 154/255)
                    .ignoresSafeArea()
                Circle()
                    .scale(1.4)
                    .foregroundColor(darkBlueColor)
                Circle()
                    .scale(1)
                    .foregroundColor(.white)
                VStack(alignment: .leading){
                    Text("Albums")
                        .font(.system(size: 80))
                    
                    Spacer()
                        .frame(height:95)
                    LazyHGrid(rows: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Rows@*/[GridItem(.fixed(20))]/*@END_MENU_TOKEN@*/) {
                        NavigationLink(destination: places()) {
                            Image(systemName: "mappin.circle")
                                .font(.system(size: 90))
                                .frame(width: 250, height: 250)
                                .foregroundColor(Color.white)
                                .background(lightBlueColor)
                                .cornerRadius(10)
                        }
                        Text("                       ")
                        NavigationLink(destination: things()){
                            Image(systemName: "lasso")
                                .font(.system(size: 90))
                                .frame(width: 250, height: 250)
                                .foregroundColor(Color.white)
                                .background(lightBlueColor)
                                .cornerRadius(10)
                        }
                    }
                    .frame(height: 125)
                    
                    LazyHGrid(rows: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Rows@*/[GridItem(.fixed(20))]/*@END_MENU_TOKEN@*/) {
                        NavigationLink(destination: places()) {
                            Text("Places")
                                .font(.system(size: 20))
                                .foregroundColor(darkBlueColor)
                        }
                        Text("                                                                   ")
                        NavigationLink(destination: things()) {
                            Text("Things")
                                .font(.system(size: 20))
                                .foregroundColor(darkBlueColor)
                        }
                    }
                    .frame(height: 150)
                    Spacer()
                        .frame(height:30)
                    LazyHGrid(rows: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Rows@*/[GridItem(.fixed(20))]/*@END_MENU_TOKEN@*/) {
                        NavigationLink(destination: feelings1()){
                            Image(systemName: "theatermasks")
                                .font(.system(size: 90))
                                .frame(width: 250, height: 250)
                                .foregroundColor(.white)
                                .background(lightBlueColor)
                                .cornerRadius(10)
                        }
                        Text("                       ")
                        NavigationLink(destination: actions1()){
                            Image(systemName: "hare")
                                .font(.system(size: 90))
                                .frame(width: 250, height: 250)
                                .foregroundColor(.white)
                                .background(lightBlueColor)
                                .cornerRadius(10)
                        }
                    }
                    .frame(height: 130)
                    LazyHGrid(rows: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Rows@*/[GridItem(.fixed(20))]/*@END_MENU_TOKEN@*/) {
                        NavigationLink(destination: feelings1()) {
                            Text("Feelings")
                                .font(.system(size: 20))
                                .foregroundColor(darkBlueColor)
                        }
                        Text("                                                                ")
                        NavigationLink(destination: actions1()) {
                            Text("Actions")
                                .font(.system(size: 20))
                                .foregroundColor(darkBlueColor)
                        }
                    }
                    .frame(height: 150)
                    
                    NavigationLink(destination: lexigramSettings()) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(darkBlueColor)
                        Text("Lexigram Options")
                    }
                    Spacer()
                        .frame(height:100)
                }
                .accentColor(darkBlueColor)
            }
        }
        .navigationViewStyle(.stack)
        .navigationBarHidden(true)
    }
}

struct places: View {
    var body: some View {
        
        NavigationView{
            ZStack{
                Color(red: 103/255, green: 153/255, blue: 154/255)
                    .ignoresSafeArea()
                VStack{
                    ZStack(alignment: .center){
                        
                        Circle()
                            .scale(1.4)
                            .foregroundColor(darkBlueColor)
                        Circle()
                            .scale(1.1)
                            .foregroundColor(.white)
                        VStack(alignment: .center){
                            Text("Places")
                                .font(.system(size: 70))
                                .frame(maxWidth: 700, alignment: .leading)
                            Spacer()
                                .frame(height: -50)
                            placesView()
                                .frame(maxWidth: 700, maxHeight: 600)
                        }
                    }
                    NavigationLink(destination: lexigramAlbum()) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(darkBlueColor)
                        Text("Albums")
                            .foregroundColor(darkBlueColor)
                    }
                    Spacer()
                        .frame(height:250)
                }
            }
        }
        .navigationBarHidden(true)
        .navigationViewStyle(.stack)
    }
}
struct things: View {
    var body: some View {
        
        NavigationView{
            ZStack{
                Color(red: 103/255, green: 153/255, blue: 154/255)
                    .ignoresSafeArea()
                VStack{
                    ZStack(alignment: .center){
                        
                        Circle()
                            .scale(1.4)
                            .foregroundColor(darkBlueColor)
                        Circle()
                            .scale(1.1)
                            .foregroundColor(.white)
                        VStack(alignment: .center){
                            Text("Things")
                                .font(.system(size: 70))
                                .frame(maxWidth: 700, alignment: .leading)
                            Spacer()
                                .frame(height: -50)
                            thingsView()
                                .frame(maxWidth: 700, maxHeight: 600)
                        }
                    }
                    NavigationLink(destination: lexigramAlbum()) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(darkBlueColor)
                        Text("Albums")
                            .foregroundColor(darkBlueColor)
                    }
                    Spacer()
                        .frame(height:250)
                }
            }
        }
        .navigationBarHidden(true)
        .navigationViewStyle(.stack)
    }
}

struct feelings1: View {
    var body: some View {
        
        NavigationView{
            ZStack{
                Color(red: 103/255, green: 153/255, blue: 154/255)
                    .ignoresSafeArea()
                VStack{
                    ZStack(alignment: .center){
                        
                        Circle()
                            .scale(1.4)
                            .foregroundColor(darkBlueColor)
                        Circle()
                            .scale(1.1)
                            .foregroundColor(.white)
                        VStack(alignment: .center){
                            Text("Feelings")
                                .font(.system(size: 70))
                                .frame(maxWidth: 700, alignment: .leading)
                            Spacer()
                                .frame(height: -50)
                            feelingsView()
                                .frame(maxWidth: 700, maxHeight: 600)
                        }
                    }
                    NavigationLink(destination: lexigramAlbum()) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(darkBlueColor)
                        Text("Albums")
                            .foregroundColor(darkBlueColor)
                    }
                    Spacer()
                        .frame(height:250)
                }
            }
        }
        .navigationBarHidden(true)
        .navigationViewStyle(.stack)
    }
}

struct actions1: View {
    var body: some View {
        
        NavigationView{
            ZStack{
                Color(red: 103/255, green: 153/255, blue: 154/255)
                    .ignoresSafeArea()
                VStack{
                    ZStack(alignment: .center){
                        
                        Circle()
                            .scale(1.5)
                            .foregroundColor(darkBlueColor)
                        Circle()
                            .scale(1.1)
                            .foregroundColor(.white)
                        VStack(alignment: .center){
                            Text("Actions")
                                .font(.system(size: 70))
                                .frame(maxWidth: 700, alignment: .leading)
                            Spacer()
                                .frame(height: -50)
                            actionsView()
                                .frame(maxWidth: 700, maxHeight: 600)
                        }
                    }
                    NavigationLink(destination: lexigramAlbum()) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(darkBlueColor)
                        Text("Albums")
                            .foregroundColor(darkBlueColor)
                    }
                    Spacer()
                        .frame(height:250)
                }
            }
        }
        .navigationBarHidden(true)
        .navigationViewStyle(.stack)
    }
}

struct feelingsView: View {
    var body: some View {
        ZStack{
            Color(red: 103/255, green: 153/255, blue: 154/255)
                .ignoresSafeArea()
            NavigationView{
                VStack{
                    ScrollView {
                        VStack{
                            LazyVGrid(columns: [.init(.adaptive(minimum: 300, maximum: .infinity), spacing: 30)], spacing:80) {
                                ForEach(1..<3) { ix in
                                    Image("feeling_\(ix)")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .aspectRatio(1, contentMode: .fit)
                                        .border(darkBlueColor)
                                        .frame(width:200, height: 200)
                                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                    
                                }
                            }
                        }
                    }
                }
                Spacer()
                    .frame(height:50)
            }
            .navigationBarHidden(true)
            .navigationViewStyle(.stack)
        }
    }
}

struct thingsView: View {
    var body: some View {
        ZStack{
            Color(red: 103/255, green: 153/255, blue: 154/255)
                .ignoresSafeArea()
            NavigationView{
                VStack{
                    ScrollView {
                        VStack{
                            LazyVGrid(columns: [.init(.adaptive(minimum: 300, maximum: .infinity), spacing: 30)], spacing:80) {
                                ForEach(1..<7) { ix in
                                    Image("thing_\(ix)")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .aspectRatio(1, contentMode: .fit)
                                        .border(darkBlueColor)
                                        .frame(width:200, height: 200)
                                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                    
                                }
                            }
                        }
                    }
                }
                Spacer()
                    .frame(height:50)
            }
            .navigationBarHidden(true)
            .navigationViewStyle(.stack)
        }
    }
}


struct actionsView: View {
    var body: some View {
        ZStack{
            Color(red: 103/255, green: 153/255, blue: 154/255)
                .ignoresSafeArea()
            NavigationView{
                VStack{
                    ScrollView {
                        VStack{
                            LazyVGrid(columns: [.init(.adaptive(minimum: 300, maximum: .infinity), spacing: 30)], spacing:80) {
                                ForEach(1..<3) { ix in
                                    Image("action_\(ix)")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .aspectRatio(1, contentMode: .fit)
                                        .border(darkBlueColor)
                                        .frame(width:200, height: 200)
                                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                    
                                }
                            }
                        }
                    }
                }
                Spacer()
                    .frame(height:50)
            }
            .navigationBarHidden(true)
            .navigationViewStyle(.stack)
        }
    }
}
struct placesView: View {
    var body: some View {
        ZStack{
            Color(red: 103/255, green: 153/255, blue: 154/255)
                .ignoresSafeArea()
            NavigationView{
                VStack{
                    ScrollView {
                        VStack{
                            LazyVGrid(columns: [.init(.adaptive(minimum: 300, maximum: .infinity), spacing: 30)], spacing:80) {
                                ForEach(1..<7) { ix in
                                    Image("place_\(ix)")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .aspectRatio(1, contentMode: .fit)
                                        .border(darkBlueColor)
                                        .frame(width:200, height: 200)
                                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                    
                                }
                            }
                        }
                    }
                }
                Spacer()
                    .frame(height:50)
            }
            .navigationBarHidden(true)
            .navigationViewStyle(.stack)
        }
    }
    
}








struct arrangeLexigrams: View {
    
    var body: some View {
        Text("hola")
            .accentColor(darkBlueColor)
            .navigationTitle("Rearrange Lexigrams")
    }
}

struct audioFiles: View {
    var body: some View {
        NavigationView{
            ZStack(alignment: .center){
                Color(red: 103/255, green: 153/255, blue: 154/255)
                    .ignoresSafeArea()
                Circle()
                    .scale(1.6)
                    .foregroundColor(darkBlueColor)
                Circle()
                    .scale(1.27)
                    .foregroundColor(.white)
                VStack(alignment: .leading){
                    Spacer()
                        .frame(height: 200)
                    Text("Audio Files")
                        .font(.system(size: 90))
                    List{
                        Section(header: Text("Places")) {
                            Button("Beach") {
                                let beach = AVSpeechUtterance(string: "Beach")
                                beach.voice = AVSpeechSynthesisVoice(language: "en-US")
                                beach.rate = 0.4
                                
                                let synthesizer = AVSpeechSynthesizer()
                                synthesizer.speak(beach)
                            }
                            
                            Button("Crate") {
                                let crate = AVSpeechUtterance(string: "Crate")
                                crate.voice = AVSpeechSynthesisVoice(language: "en-US")
                                crate.rate = 0.4
                                
                                let synthesizer = AVSpeechSynthesizer()
                                synthesizer.speak(crate)
                            }
                            
                            Button("Dog Park") {
                                let dp = AVSpeechUtterance(string: "Dog Park")
                                dp.voice = AVSpeechSynthesisVoice(language: "en-US")
                                dp.rate = 0.4
                                
                                let synthesizer = AVSpeechSynthesizer()
                                synthesizer.speak(dp)
                            }
                            Button("Inside") {
                                let inside = AVSpeechUtterance(string: "Inside")
                                inside.voice = AVSpeechSynthesisVoice(language: "en-US")
                                inside.rate = 0.4
                                
                                let synthesizer = AVSpeechSynthesizer()
                                synthesizer.speak(inside)
                            }
                            Button("Outside") {
                                let outside = AVSpeechUtterance(string: "Outside")
                                outside.voice = AVSpeechSynthesisVoice(language: "en-US")
                                outside.rate = 0.4
                                
                                let synthesizer = AVSpeechSynthesizer()
                                synthesizer.speak(outside)
                            }
                            Button("Woods") {
                                let woods = AVSpeechUtterance(string: "Woods")
                                woods.voice = AVSpeechSynthesisVoice(language: "en-US")
                                woods.rate = 0.4
                                
                                let synthesizer = AVSpeechSynthesizer()
                                synthesizer.speak(woods)
                            }
                        }
                        Section(header: Text("Things")) {
                            Button("Ball") {
                                let ball = AVSpeechUtterance(string: "Ball")
                                ball.voice = AVSpeechSynthesisVoice(language: "en-US")
                                ball.rate = 0.4
                                
                                let synthesizer = AVSpeechSynthesizer()
                                synthesizer.speak(ball)
                            }
                            Button("Food") {
                                let food = AVSpeechUtterance(string: "Food")
                                food.voice = AVSpeechSynthesisVoice(language: "en-US")
                                food.rate = 0.4
                                
                                let synthesizer = AVSpeechSynthesizer()
                                synthesizer.speak(food)
                            }
                            Button("Kong") {
                                let kong = AVSpeechUtterance(string: "Kong")
                                kong.voice = AVSpeechSynthesisVoice(language: "en-US")
                                kong.rate = 0.4
                                
                                let synthesizer = AVSpeechSynthesizer()
                                synthesizer.speak(kong)
                            }
                            Button("Rope") {
                                let rope = AVSpeechUtterance(string: "Rope")
                                rope.voice = AVSpeechSynthesisVoice(language: "en-US")
                                rope.rate = 0.4
                                
                                let synthesizer = AVSpeechSynthesizer()
                                synthesizer.speak(rope)
                            }
                            Button("Treat") {
                                let treat = AVSpeechUtterance(string: "Treat")
                                treat.voice = AVSpeechSynthesisVoice(language: "en-US")
                                treat.rate = 0.4
                                
                                let synthesizer = AVSpeechSynthesizer()
                                synthesizer.speak(treat)
                            }
                            Button("Toy") {
                                let toy = AVSpeechUtterance(string: "Toy")
                                toy.voice = AVSpeechSynthesisVoice(language: "en-US")
                                toy.rate = 0.4
                                
                                let synthesizer = AVSpeechSynthesizer()
                                synthesizer.speak(toy)
                            }
                            
                        }
                        Section(header: Text("Places")) {
                            Button("Hungry") {
                                let hungry = AVSpeechUtterance(string: "Hungry")
                                hungry.voice = AVSpeechSynthesisVoice(language: "en-US")
                                hungry.rate = 0.4
                                
                                let synthesizer = AVSpeechSynthesizer()
                                synthesizer.speak(hungry)
                            }
                            Button("Ouch") {
                                let ouch = AVSpeechUtterance(string: "Ouch")
                                ouch.voice = AVSpeechSynthesisVoice(language: "en-US")
                                ouch.rate = 0.4
                                
                                let synthesizer = AVSpeechSynthesizer()
                                synthesizer.speak(ouch)
                            }
                        }
                        Section(header: Text("Actions")) {
                            Button("Chew") {
                                let chew = AVSpeechUtterance(string: "Chew")
                                chew.voice = AVSpeechSynthesisVoice(language: "en-US")
                                chew.rate = 0.4
                                
                                let synthesizer = AVSpeechSynthesizer()
                                synthesizer.speak(chew)
                            }
                            Button("Petting") {
                                let petting = AVSpeechUtterance(string: "Petting")
                                petting.voice = AVSpeechSynthesisVoice(language: "en-US")
                                petting.rate = 0.4
                                
                                let synthesizer = AVSpeechSynthesizer()
                                synthesizer.speak(petting)
                            }
                        }
                    }
                    
                    .frame(width:600, height: 600)
                    .clipped()
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(10)
                    
                    NavigationLink(destination: audioSettings()) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(darkBlueColor)
                        Text("Settings")
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .navigationViewStyle(.stack)
    }
}

struct newAudio: View {
    
    var body: some View {
        Text("hola")
            .accentColor(darkBlueColor)
            .navigationTitle("Add New Files")
    }
}


struct settingHome: View {
    var body: some View {
        NavigationView {
            ZStack{
                Color(red: 103/255, green: 153/255, blue: 154/255)
                    .ignoresSafeArea()
                Circle()
                    .scale(1.4)
                    .foregroundColor(darkBlueColor)
                Circle()
                    .scale(1)
                    .foregroundColor(.white)
                VStack {
                    Image(systemName: "gearshape.circle")
                        .foregroundColor(darkBlueColor)
                        .font(.system(size: 90))
                    Text("Settings")
                        .font(.system(size: 60))
                        .bold()
                    
                    Spacer()
                        .frame(height: 50)
                    NavigationLink(destination: lexigramSettings()){
                        Text("Lexigram Options")
                            .foregroundColor(Color.white)
                            .frame(width: 300, height: 50)
                            .background(lightBlueColor)
                            .cornerRadius(10)
                    }
                    
                    NavigationLink(destination: audioSettings()) {
                        Text("Audio Settings")
                            .foregroundColor(Color.white)
                            .frame(width: 300, height: 50)
                            .background(lightBlueColor)
                            .cornerRadius(10)
                    }
                    
                    NavigationLink(destination: exportPage()) {
                        Text("Export Data")
                            .foregroundColor(Color.white)
                            .frame(width: 300, height: 50)
                            .background(lightBlueColor)
                            .cornerRadius(10)
                    }
                    Spacer()
                        .frame(height: 400)
                    
                    NavigationLink(destination: ContentView()) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(darkBlueColor)
                        Text("Save and Exit")
                    }
                    Spacer()
                        .frame(height: 50)
                }
            }
        }
        .navigationViewStyle(.stack)
        .navigationBarHidden(true)
        .accentColor(darkBlueColor)
    }
    
}



struct placesActivityView: View {
    
    let beachImages = ["beach1", "beach2", "beach3", "beach4"] // Array of beach images to show
    let woodsImages = ["woods1", "woods2", "woods3", "woods4"] // Array of woods image to show
    let dpImages = ["dogpark1", "dogpark2", "dogpark3", "dogpark4"] // Array of dogpark image to show
    let crateImages = ["crate1", "crate2", "crate3", "crate4"] // Array of crate image to show
    let insideImages = ["inside1", "inside2", "inside3", "inside4"] // Array of inside image to show
    let outsideImages = ["outside1", "outside2", "outside3", "outside4"] // Array of inside image to show
    
    
    @State var activeImageIndex = 0 // Index of the currently displayed image
    let imageSwitchTimer = Timer.publish(every: 3, on: .main, in: .common)
        .autoconnect()
    
    let imageAppearTimer = Timer.publish(every: 3, on: .main, in: .common)
        .autoconnect()
    
    @State  var beachP = false
    @State var woodsP = false
    @State var dpP = false
    @State var cratep = false
    @State var insidep = false
    @State var outsidep = false
    @State var lexigramName = ""
    
    
    
    @State  var imageAppear = 3
    
    
    var body: some View {
        
        
        
        NavigationView{
            VStack {
                Text("Places")
                    .font(.system(size: 70))
                    .frame(maxWidth: 700, alignment: .leading)
                ZStack{
                    LazyVGrid(columns: [.init(.adaptive(minimum: 300, maximum: .infinity), spacing: 30)], spacing:80) {
                        
                        Button(action: {
                            woodsP = true
                            imageAppear = 3
                            
                            let woods = AVSpeechUtterance(string: "Woods")
                            woods.voice = AVSpeechSynthesisVoice(language: "en-US")
                            woods.rate = 0.4
                            
                            let synthesizer = AVSpeechSynthesizer()
                            synthesizer.speak(woods)
                            lexigramName = "Woods"
                            lexigramTracker()
                            
                        }) {
                            Image("place_1")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .aspectRatio(1, contentMode: .fit)
                                .border(darkBlueColor)
                                .frame(width:220, height: 220)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        }
                        Button(action: {
                            let beach = AVSpeechUtterance(string: "Beach")
                            beach.voice = AVSpeechSynthesisVoice(language: "en-US")
                            beach.rate = 0.4
                            
                            let synthesizer = AVSpeechSynthesizer()
                            synthesizer.speak(beach)
                            beachP = true
                            imageAppear = 3
                            lexigramName = "Beach"
                            lexigramTracker()
                        }) {
                            Image("place_2")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .aspectRatio(1, contentMode: .fit)
                                .border(darkBlueColor)
                                .frame(width:220, height: 220)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        }
                        
                        Button(action: {
                            let dogpark = AVSpeechUtterance(string: "Dog Park")
                            dogpark.voice = AVSpeechSynthesisVoice(language: "en-US")
                            dogpark.rate = 0.4
                            
                            let synthesizer = AVSpeechSynthesizer()
                            synthesizer.speak(dogpark)
                            
                            dpP = true
                            imageAppear = 3
                            lexigramName = "Dog Park"
                            lexigramTracker()
                            
                        }) {
                            Image("place_3")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .aspectRatio(1, contentMode: .fit)
                                .border(darkBlueColor)
                                .frame(width:220, height: 220)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        }
                        
                        Button(action: {
                            let crate = AVSpeechUtterance(string: "Crate")
                            crate.voice = AVSpeechSynthesisVoice(language: "en-US")
                            crate.rate = 0.4
                            
                            let synthesizer = AVSpeechSynthesizer()
                            synthesizer.speak(crate)
                            
                            
                            cratep = true
                            imageAppear = 3
                            lexigramName = "Crate"
                            lexigramTracker()
                            
                        }) {
                            Image("place_4")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .aspectRatio(1, contentMode: .fit)
                                .border(darkBlueColor)
                                .frame(width:220, height: 220)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        }
                        Button(action: {
                            let inside = AVSpeechUtterance(string: "Inside")
                            inside.voice = AVSpeechSynthesisVoice(language: "en-US")
                            inside.rate = 0.4
                            
                            let synthesizer = AVSpeechSynthesizer()
                            synthesizer.speak(inside)
                            
                            insidep = true
                            imageAppear = 3
                            lexigramName = "Inside"
                            lexigramTracker()
                            
                        }) {
                            Image("place_5")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .aspectRatio(1, contentMode: .fit)
                                .border(darkBlueColor)
                                .frame(width:220, height: 220)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        }
                        Button(action: {
                            let outside = AVSpeechUtterance(string: "Outside")
                            outside.voice = AVSpeechSynthesisVoice(language: "en-US")
                            outside.rate = 0.4
                            
                            let synthesizer = AVSpeechSynthesizer()
                            synthesizer.speak(outside)
                            
                            outsidep = true
                            imageAppear = 3
                            lexigramName = "Outside"
                            lexigramTracker()
                        }) {
                            Image("place_6")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .aspectRatio(1, contentMode: .fit)
                                .border(darkBlueColor)
                                .frame(width:220, height: 220)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        }
                    }
                    
                    //beach images appear
                    if beachP == true && imageAppear == 3{
                        VStack{
                            GeometryReader { geo in
                                Image(beachImages[activeImageIndex])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 800, height: 1100)
                                    .frame(width: geo.size.width, height: geo.size.height)
                                    .onReceive(imageSwitchTimer) { _ in
                                        // Go to the next image. If this is the last image, go
                                        // back to the image #0
                                        self.activeImageIndex = (self.activeImageIndex + 1) % self.beachImages.count
                                    }
                                    .onReceive(imageAppearTimer){ _ in
                                        self.imageAppear = self.imageAppear - 3
                                        beachP = false
                                    }
                            }
                            Spacer()
                                .frame(height: 100)
                        }
                    }
                    //woods images appear
                    if woodsP == true && imageAppear == 3{
                        VStack{
                            GeometryReader { geo in
                                Image(woodsImages[activeImageIndex])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 800, height: 1100)
                                    .frame(width: geo.size.width, height: geo.size.height)
                                    .onReceive(imageSwitchTimer) { _ in
                                        // Go to the next image. If this is the last image, go
                                        // back to the image #0
                                        self.activeImageIndex = (self.activeImageIndex + 1) % self.woodsImages.count
                                    }
                                    .onReceive(imageAppearTimer){ _ in
                                        self.imageAppear = self.imageAppear - 3
                                        woodsP = false
                                    }
                            }
                            Spacer()
                                .frame(height: 100)
                        }
                    }
                    
                    //dp images appear
                    if dpP == true && imageAppear == 3{
                        VStack{
                            GeometryReader { geo in
                                Image(dpImages[activeImageIndex])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 800, height: 1100)
                                    .frame(width: geo.size.width, height: geo.size.height)
                                    .onReceive(imageSwitchTimer) { _ in
                                        // Go to the next image. If this is the last image, go
                                        // back to the image #0
                                        self.activeImageIndex = (self.activeImageIndex + 1) % self.dpImages.count
                                    }
                                    .onReceive(imageAppearTimer){ _ in
                                        self.imageAppear = self.imageAppear - 3
                                        dpP = false
                                    }
                            }
                            Spacer()
                                .frame(height: 100)
                        }
                    }
                    //crate images appear
                    if cratep == true && imageAppear == 3{
                        VStack{
                            GeometryReader { geo in
                                Image(crateImages[activeImageIndex])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 800, height: 1100)
                                    .frame(width: geo.size.width, height: geo.size.height)
                                    .onReceive(imageSwitchTimer) { _ in
                                        // Go to the next image. If this is the last image, go
                                        // back to the image #0
                                        self.activeImageIndex = (self.activeImageIndex + 1) % self.crateImages.count
                                    }
                                    .onReceive(imageAppearTimer){ _ in
                                        self.imageAppear = self.imageAppear - 3
                                        cratep = false
                                    }
                            }
                            Spacer()
                                .frame(height: 100)
                        }
                    }
                    //inside images appear
                    
                    if insidep == true && imageAppear == 3{
                        VStack{
                            GeometryReader { geo in
                                Image(insideImages[activeImageIndex])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 800, height: 1100)
                                    .frame(width: geo.size.width, height: geo.size.height)
                                    .onReceive(imageSwitchTimer) { _ in
                                        // Go to the next image. If this is the last image, go
                                        // back to the image #0
                                        self.activeImageIndex = (self.activeImageIndex + 1) % self.insideImages.count
                                    }
                                    .onReceive(imageAppearTimer){ _ in
                                        self.imageAppear = self.imageAppear - 3
                                        insidep = false
                                    }
                            }
                            Spacer()
                                .frame(height: 100)
                        }
                    }
                    //outside image appear
                    
                    if outsidep == true && imageAppear == 3{
                        VStack{
                            GeometryReader { geo in
                                Image(outsideImages[activeImageIndex])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 800, height: 1100)
                                    .frame(width: geo.size.width, height: geo.size.height)
                                    .onReceive(imageSwitchTimer) { _ in
                                        // Go to the next image. If this is the last image, go
                                        // back to the image #0
                                        self.activeImageIndex = (self.activeImageIndex + 1) % self.outsideImages.count
                                    }
                                    .onReceive(imageAppearTimer){ _ in
                                        self.imageAppear = self.imageAppear - 3
                                        outsidep = false
                                    }
                            }
                            Spacer()
                                .frame(height: 100)
                        }
                    }
                    //end
                }
                .background(.red.opacity(0))
                .clipped()
            }
        }
        
        .navigationBarHidden(true)
        .accentColor(darkBlueColor)
        .navigationViewStyle(.stack)
    }
    func lexigramTracker(){
        let lexigramName = lexigramName
        let currentDateTime = Date()
        
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .long
        
        let dateTimeString = formatter.string(from: currentDateTime)
        
        
        timeOfPress.append(dateTimeString)
        lexigrams.append(lexigramName)
        
        
    }
}


struct placesActivityPage: View {
    var body: some View {
        
        NavigationView{
            ZStack{
                Color.white
                    .ignoresSafeArea()
                VStack{
                    ZStack(alignment: .center){
                        VStack(alignment: .center){
                            placesActivityView()
                                .frame(maxWidth: 800, maxHeight: 1100)
                        }
                    }
                    
                    NavigationLink(destination: ContentView()) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(darkBlueColor)
                            .font(.system(size: 20))
                        Text("Save and Logout")
                            .font(.system(size: 20))
                    }
                    
                    HStack {
                        NavigationLink(destination: homePage()) {
                            Image(systemName: "house.circle")
                                .foregroundColor(darkBlueColor)
                                .background(.white)
                                .font(.system(size: 80))
                            
                        }
                        Spacer()
                            .frame(width: 700)
                        NavigationLink(destination: settingHome()) {
                            Image(systemName: "gearshape.circle")
                                .foregroundColor(darkBlueColor)
                                .background(.white)
                                .font(.system(size: 80))
                            
                        }
                    }
                }
            }
            .navigationViewStyle(.stack)
        }
        .navigationViewStyle(.stack)
        .navigationBarHidden(true)
    }
}

struct thingsActivityView: View {
    
    
    let ballImages = ["ball1", "ball2", "ball3", "ball4"] // Array of beach images to show
    let ropeImages = ["rope1", "rope2", "rope3", "rope4"] // Array of woods image to show
    let kongImages = ["kong1", "kong2", "kong3", "kong4"] // Array of dogpark image to show
    let toyImages = ["toy1", "toy2", "toy3", "toy4"] // Array of crate image to show
    let treatImages = ["treat1", "treat2", "treat3", "treat4"] // Array of inside image to show
    let foodImages = ["food1", "food2", "food3", "food4"] // Array of inside image to show
    
    
    @State var activeImageIndex = 0 // Index of the currently displayed image
    let imageSwitchTimer = Timer.publish(every: 3, on: .main, in: .common)
        .autoconnect()
    
    let imageAppearTimer = Timer.publish(every: 3, on: .main, in: .common)
        .autoconnect()
    
    @State  var ballp = false
    @State var ropep = false
    @State var kongp = false
    @State var toyp = false
    @State var treatp = false
    @State var foodp = false
    @State var lexigramName = ""
    
    
    
    @State  var imageAppear = 3
    
    
    
    var body: some View {
        
        NavigationView{
            VStack {
                Text("Things")
                    .font(.system(size: 70))
                    .frame(maxWidth: 700, alignment: .leading)
                
                ZStack{
                    LazyVGrid(columns: [.init(.adaptive(minimum: 300, maximum: .infinity), spacing: 30)], spacing:80) {
                        
                        Button(action: {
                            let thing = AVSpeechUtterance(string: "Ball")
                            thing.voice = AVSpeechSynthesisVoice(language: "en-US")
                            thing.rate = 0.4
                            
                            let synthesizer = AVSpeechSynthesizer()
                            synthesizer.speak(thing)
                            ballp = true
                            imageAppear = 3
                            lexigramName = "Ball"
                            lexigramTracker()
                        }) {
                            Image("thing_1")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .aspectRatio(1, contentMode: .fit)
                                .border(darkBlueColor)
                                .frame(width:220, height: 220)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        }
                        Button(action: {
                            let rope = AVSpeechUtterance(string: "Rope")
                            rope.voice = AVSpeechSynthesisVoice(language: "en-US")
                            rope.rate = 0.4
                            
                            let synthesizer = AVSpeechSynthesizer()
                            synthesizer.speak(rope)
                            ropep = true
                            imageAppear = 3
                            lexigramName = "Rope"
                            lexigramTracker()
                        }) {
                            Image("thing_2")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .aspectRatio(1, contentMode: .fit)
                                .border(darkBlueColor)
                                .frame(width:220, height: 220)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        }
                        
                        Button(action: {
                            let kong = AVSpeechUtterance(string: "Kong")
                            kong.voice = AVSpeechSynthesisVoice(language: "en-US")
                            kong.rate = 0.4
                            
                            let synthesizer = AVSpeechSynthesizer()
                            synthesizer.speak(kong)
                            kongp = true
                            imageAppear = 3
                            lexigramName = "Kong"
                            lexigramTracker()
                        }) {
                            Image("thing_3")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .aspectRatio(1, contentMode: .fit)
                                .border(darkBlueColor)
                                .frame(width:220, height: 220)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        }
                        
                        Button(action: {
                            let toy = AVSpeechUtterance(string: "Toy")
                            toy.voice = AVSpeechSynthesisVoice(language: "en-US")
                            toy.rate = 0.4
                            
                            let synthesizer = AVSpeechSynthesizer()
                            synthesizer.speak(toy)
                            toyp = true
                            imageAppear = 3
                            lexigramName = "Toy"
                            lexigramTracker()
                        }) {
                            Image("thing_4")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .aspectRatio(1, contentMode: .fit)
                                .border(darkBlueColor)
                                .frame(width:220, height: 220)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        }
                        Button(action: {
                            let treat = AVSpeechUtterance(string: "Treat")
                            treat.voice = AVSpeechSynthesisVoice(language: "en-US")
                            treat.rate = 0.4
                            
                            let synthesizer = AVSpeechSynthesizer()
                            synthesizer.speak(treat)
                            treatp = true
                            imageAppear = 3
                            lexigramName = "Treat"
                            lexigramTracker()
                        }) {
                            Image("thing_5")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .aspectRatio(1, contentMode: .fit)
                                .border(darkBlueColor)
                                .frame(width:220, height: 220)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        }
                        Button(action: {
                            let food = AVSpeechUtterance(string: "Food")
                            food.voice = AVSpeechSynthesisVoice(language: "en-US")
                            food.rate = 0.4
                            
                            let synthesizer = AVSpeechSynthesizer()
                            synthesizer.speak(food)
                            foodp = true
                            imageAppear = 3
                            lexigramName = "Food"
                            lexigramTracker()
                        }) {
                            Image("thing_6")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .aspectRatio(1, contentMode: .fit)
                                .border(darkBlueColor)
                                .frame(width:220, height: 220)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        }
                    }
                    
                    //ball images appear
                    if ballp == true && imageAppear == 3{
                        VStack{
                            GeometryReader { geo in
                                Image(ballImages[activeImageIndex])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 800, height: 1100)
                                    .frame(width: geo.size.width, height: geo.size.height)
                                    .onReceive(imageSwitchTimer) { _ in
                                        // Go to the next image. If this is the last image, go
                                        // back to the image #0
                                        self.activeImageIndex = (self.activeImageIndex + 1) % self.ballImages.count
                                    }
                                    .onReceive(imageAppearTimer){ _ in
                                        self.imageAppear = self.imageAppear - 3
                                        ballp = false
                                    }
                            }
                            Spacer()
                                .frame(height: 100)
                        }
                    }
                    //rope images appear
                    if ropep == true && imageAppear == 3{
                        VStack{
                            GeometryReader { geo in
                                Image(ropeImages[activeImageIndex])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 800, height: 1100)
                                    .frame(width: geo.size.width, height: geo.size.height)
                                    .onReceive(imageSwitchTimer) { _ in
                                        // Go to the next image. If this is the last image, go
                                        // back to the image #0
                                        self.activeImageIndex = (self.activeImageIndex + 1) % self.ropeImages.count
                                    }
                                    .onReceive(imageAppearTimer){ _ in
                                        self.imageAppear = self.imageAppear - 3
                                        ropep = false
                                    }
                            }
                            Spacer()
                                .frame(height: 100)
                        }
                    }
                    
                    //kong images appear
                    if kongp == true && imageAppear == 3{
                        VStack{
                            GeometryReader { geo in
                                Image(kongImages[activeImageIndex])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 800, height: 1100)
                                    .frame(width: geo.size.width, height: geo.size.height)
                                    .onReceive(imageSwitchTimer) { _ in
                                        // Go to the next image. If this is the last image, go
                                        // back to the image #0
                                        self.activeImageIndex = (self.activeImageIndex + 1) % self.kongImages.count
                                    }
                                    .onReceive(imageAppearTimer){ _ in
                                        self.imageAppear = self.imageAppear - 3
                                        kongp = false
                                    }
                            }
                            Spacer()
                                .frame(height: 100)
                        }
                    }
                    //toy images appear
                    if toyp == true && imageAppear == 3{
                        VStack{
                            GeometryReader { geo in
                                Image(toyImages[activeImageIndex])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 800, height: 1100)
                                    .frame(width: geo.size.width, height: geo.size.height)
                                    .onReceive(imageSwitchTimer) { _ in
                                        // Go to the next image. If this is the last image, go
                                        // back to the image #0
                                        self.activeImageIndex = (self.activeImageIndex + 1) % self.toyImages.count
                                    }
                                    .onReceive(imageAppearTimer){ _ in
                                        self.imageAppear = self.imageAppear - 3
                                        toyp = false
                                    }
                            }
                            Spacer()
                                .frame(height: 100)
                        }
                    }
                    //treat images appear
                    
                    if treatp == true && imageAppear == 3{
                        VStack{
                            GeometryReader { geo in
                                Image(treatImages[activeImageIndex])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 800, height: 1100)
                                    .frame(width: geo.size.width, height: geo.size.height)
                                    .onReceive(imageSwitchTimer) { _ in
                                        // Go to the next image. If this is the last image, go
                                        // back to the image #0
                                        self.activeImageIndex = (self.activeImageIndex + 1) % self.treatImages.count
                                    }
                                    .onReceive(imageAppearTimer){ _ in
                                        self.imageAppear = self.imageAppear - 3
                                        treatp = false
                                    }
                            }
                            Spacer()
                                .frame(height: 100)
                        }
                    }
                    //food image appear
                    
                    if foodp == true && imageAppear == 3{
                        VStack{
                            GeometryReader { geo in
                                Image(foodImages[activeImageIndex])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 800, height: 1100)
                                    .frame(width: geo.size.width, height: geo.size.height)
                                    .onReceive(imageSwitchTimer) { _ in
                                        // Go to the next image. If this is the last image, go
                                        // back to the image #0
                                        self.activeImageIndex = (self.activeImageIndex + 1) % self.foodImages.count
                                    }
                                    .onReceive(imageAppearTimer){ _ in
                                        self.imageAppear = self.imageAppear - 3
                                        foodp = false
                                    }
                            }
                            Spacer()
                                .frame(height: 100)
                        }
                        
                    }
                    //end
                }
                .background(.red.opacity(0))
                .clipped()
                
            }
            
        }
        .navigationBarHidden(true)
        .accentColor(darkBlueColor)
        .navigationViewStyle(.stack)
        
    }
    func lexigramTracker(){
        let lexigramName = lexigramName
        let currentDateTime = Date()
        
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .long
        
        let dateTimeString = formatter.string(from: currentDateTime)
        
        
        timeOfPress.append(dateTimeString)
        lexigrams.append(lexigramName)
        
    }
    
}

struct thingsActivityPage: View {
    var body: some View {
        
        NavigationView{
            ZStack{
                Color.white
                    .ignoresSafeArea()
                VStack{
                    ZStack(alignment: .center){
                        VStack(alignment: .center){
                            thingsActivityView()
                                .frame(maxWidth: 800, maxHeight: 1100)
                        }
                    }
                    
                    NavigationLink(destination: ContentView()) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(darkBlueColor)
                            .font(.system(size: 20))
                        Text("Save and Logout")
                            .font(.system(size: 20))
                    }
                    
                    HStack {
                        NavigationLink(destination: homePage()) {
                            Image(systemName: "house.circle")
                                .foregroundColor(darkBlueColor)
                                .background(.white)
                                .font(.system(size: 80))
                            
                        }
                        Spacer()
                            .frame(width: 700)
                        NavigationLink(destination: settingHome()) {
                            Image(systemName: "gearshape.circle")
                                .foregroundColor(darkBlueColor)
                                .background(.white)
                                .font(.system(size: 80))
                            
                        }
                    }
                }
            }
            
            
            .navigationViewStyle(.stack)
        }
        .navigationViewStyle(.stack)
        .navigationBarHidden(true)
    }
    
}

struct feelingsActivityView: View {
    
    let hungryImages = ["food1", "food2", "food3", "food4"] // Array of hungry images to show
    let ouchImages = ["ouch1", "ouch2", "ouch3", "ouch4"] // Array of ouch image to show
    
    
    @State var activeImageIndex = 0 // Index of the currently displayed image
    let imageSwitchTimer = Timer.publish(every: 3, on: .main, in: .common)
        .autoconnect()
    
    let imageAppearTimer = Timer.publish(every: 3, on: .main, in: .common)
        .autoconnect()
    
    @State  var hungryp = false
    @State var ouchp = false
    @State  var imageAppear = 3
    @State var lexigramName = ""
    
    var body: some View {
        
        NavigationView{
            VStack {
                Text("Feelings")
                    .font(.system(size: 70))
                    .frame(maxWidth: 700, alignment: .leading)
                ZStack{
                    LazyVGrid(columns: [.init(.adaptive(minimum: 300, maximum: .infinity), spacing: 30)], spacing:80) {
                        
                        Button(action: {
                            let hungry = AVSpeechUtterance(string: "Hungry")
                            hungry.voice = AVSpeechSynthesisVoice(language: "en-US")
                            hungry.rate = 0.4
                            
                            let synthesizer = AVSpeechSynthesizer()
                            synthesizer.speak(hungry)
                            hungryp = true
                            imageAppear = 3
                            lexigramName = "Hungry"
                            lexigramTracker()
                            
                        }) {
                            Image("feeling_1")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .aspectRatio(1, contentMode: .fit)
                                .border(darkBlueColor)
                                .frame(width:220, height: 220)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        }
                        Button(action: {
                            let ouch = AVSpeechUtterance(string: "Ouch")
                            ouch.voice = AVSpeechSynthesisVoice(language: "en-US")
                            ouch.rate = 0.4
                            
                            let synthesizer = AVSpeechSynthesizer()
                            synthesizer.speak(ouch)
                            ouchp = true
                            imageAppear = 3
                            lexigramName = "Ouch"
                            lexigramTracker()
                        }) {
                            Image("feeling_2")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .aspectRatio(1, contentMode: .fit)
                                .border(darkBlueColor)
                                .frame(width:220, height: 220)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        }
                        
                    }
                    // hungry images
                    if hungryp == true && imageAppear == 3{
                        VStack{
                            GeometryReader { geo in
                                Image(hungryImages[activeImageIndex])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 800, height: 1100)
                                    .frame(width: geo.size.width, height: geo.size.height)
                                    .onReceive(imageSwitchTimer) { _ in
                                        // Go to the next image. If this is the last image, go
                                        // back to the image #0
                                        self.activeImageIndex = (self.activeImageIndex + 1) % self.hungryImages.count
                                    }
                                    .onReceive(imageAppearTimer){ _ in
                                        self.imageAppear = self.imageAppear - 3
                                        hungryp = false
                                    }
                            }
                            Spacer()
                                .frame(height: 100)
                        }
                    }
                    //ouch images appear
                    if ouchp == true && imageAppear == 3{
                        VStack{
                            GeometryReader { geo in
                                Image(ouchImages[activeImageIndex])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 800, height: 1100)
                                    .frame(width: geo.size.width, height: geo.size.height)
                                    .onReceive(imageSwitchTimer) { _ in
                                      //  Go to the next image. If this is the last image, go
                                       // back to the image #0
                                        self.activeImageIndex = (self.activeImageIndex + 1) % self.ouchImages.count
                                    }
                                    .onReceive(imageAppearTimer){ _ in
                                        self.imageAppear = self.imageAppear - 3
                                        ouchp = false
                                    }
                            }
                            Spacer()
                                .frame(height: 100)
                        }
                    }
                    //  end
                
                }
                .background(.red.opacity(0))
                .clipped()
            }
            
        }
        
        .navigationBarHidden(true)
        .accentColor(darkBlueColor)
        .navigationViewStyle(.stack)
        
    }
    func lexigramTracker(){
        let lexigramName = lexigramName
        let currentDateTime = Date()
        
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .long
        
        let dateTimeString = formatter.string(from: currentDateTime)
        
        
        timeOfPress.append(dateTimeString)
        lexigrams.append(lexigramName)
        
    }
}


struct feelingsActivityPage: View {
    var body: some View {
        
        NavigationView{
            ZStack{
                Color.white
                    .ignoresSafeArea()
                VStack{
                    ZStack(alignment: .center){
                        VStack(alignment: .center){
                            feelingsActivityView()
                                .frame(maxWidth: 900, maxHeight: 1100)
                        }
                    }
                    
                    NavigationLink(destination: ContentView()) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(darkBlueColor)
                            .font(.system(size: 20))
                        Text("Save and Logout")
                            .font(.system(size: 20))
                    }
                    
                    HStack {
                        NavigationLink(destination: homePage()) {
                            Image(systemName: "house.circle")
                                .foregroundColor(darkBlueColor)
                                .background(.white)
                                .font(.system(size: 80))
                            
                        }
                        Spacer()
                            .frame(width: 700)
                        NavigationLink(destination: settingHome()) {
                            Image(systemName: "gearshape.circle")
                                .foregroundColor(darkBlueColor)
                                .background(.white)
                                .font(.system(size: 80))
                            
                        }
                    }
                }
            }
            
            
            .navigationViewStyle(.stack)
        }
        .navigationViewStyle(.stack)
        .navigationBarHidden(true)
    }
    
}



struct actionsActivityView: View {
    
    let chewImages = ["chew1", "chew2", "chew3", "chew4"] // Array of beach images to show
    let pettingImages = ["petting1", "petting2", "petting3", "petting4"] // Array of woods image to show
    
    
    @State var activeImageIndex = 0 // Index of the currently displayed image
    let imageSwitchTimer = Timer.publish(every: 3, on: .main, in: .common)
        .autoconnect()
    
    let imageAppearTimer = Timer.publish(every: 3, on: .main, in: .common)
        .autoconnect()
    
    @State  var chewp = false
    @State var pettingp = false
    @State  var imageAppear = 3
    @State var lexigramName = ""
    
    var body: some View {
        
        NavigationView{
            VStack {
                Text("Actions")
                    .font(.system(size: 70))
                    .frame(maxWidth: 700, alignment: .leading)
                ZStack{
                    LazyVGrid(columns: [.init(.adaptive(minimum: 300, maximum: .infinity), spacing: 30)], spacing:80) {
                        
                        Button(action: {
                            let chew = AVSpeechUtterance(string: "Chew")
                            chew.voice = AVSpeechSynthesisVoice(language: "en-US")
                            chew.rate = 0.4
                            
                            let synthesizer = AVSpeechSynthesizer()
                            synthesizer.speak(chew)
                            chewp = true
                            imageAppear = 3
                            lexigramName = "Chew"
                            lexigramTracker()
                        }) {
                            Image("action_1")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .aspectRatio(1, contentMode: .fit)
                                .border(darkBlueColor)
                                .frame(width:220, height: 220)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        }
                        Button(action: {
                            let petting = AVSpeechUtterance(string: "Petting")
                            petting.voice = AVSpeechSynthesisVoice(language: "en-US")
                            petting.rate = 0.4
                            
                            let synthesizer = AVSpeechSynthesizer()
                            synthesizer.speak(petting)
                            pettingp = true
                            imageAppear = 3
                            lexigramName = "Petting"
                            lexigramTracker()
                        }) {
                            Image("action_2")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .aspectRatio(1, contentMode: .fit)
                                .border(darkBlueColor)
                                .frame(width:220, height: 220)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        }
                        
                    }
                    
                    // chew images
                    if chewp == true && imageAppear == 3{
                        VStack{
                            GeometryReader { geo in
                                Image(chewImages[activeImageIndex])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 800, height: 1100)
                                    .frame(width: geo.size.width, height: geo.size.height)
                                    .onReceive(imageSwitchTimer) { _ in
                                        // Go to the next image. If this is the last image, go
                                        // back to the image #0
                                        self.activeImageIndex = (self.activeImageIndex + 1) % self.chewImages.count
                                    }
                                    .onReceive(imageAppearTimer){ _ in
                                        self.imageAppear = self.imageAppear - 3
                                        chewp = false
                                    }
                            }
                            Spacer()
                                .frame(height: 100)
                        }
                    }
                    //petting images appear
                    if pettingp == true && imageAppear == 3{
                        VStack{
                            GeometryReader { geo in
                                Image(pettingImages[activeImageIndex])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 800, height: 1100)
                                    .frame(width: geo.size.width, height: geo.size.height)
                                    .onReceive(imageSwitchTimer) { _ in
                                        // Go to the next image. If this is the last image, go
                                        // back to the image #0
                                        self.activeImageIndex = (self.activeImageIndex + 1) % self.pettingImages.count
                                    }
                                    .onReceive(imageAppearTimer){ _ in
                                        self.imageAppear = self.imageAppear - 3
                                        pettingp = false
                                    }
                            }
                            Spacer()
                                .frame(height: 100)
                        }
                    }
                    //end
                    
                }
                .background(.red.opacity(0))
                .clipped()
            }
            
            
        }
        .navigationBarHidden(true)
        .accentColor(darkBlueColor)
        .navigationViewStyle(.stack)
        
    }
    func lexigramTracker(){
        let lexigramName = lexigramName
        let currentDateTime = Date()
        
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .long
        
        let dateTimeString = formatter.string(from: currentDateTime)
        
        
        timeOfPress.append(dateTimeString)
        lexigrams.append(lexigramName)
        
    }
}


struct actionsActivityPage: View {
    var body: some View {
        
        NavigationView{
            ZStack{
                Color.white
                    .ignoresSafeArea()
                VStack{
                    ZStack(alignment: .center){
                        VStack(alignment: .center){
                            actionsActivityView()
                                .frame(maxWidth: 800, maxHeight: 1100)
                        }
                    }
                    
                    NavigationLink(destination: ContentView()) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(darkBlueColor)
                            .font(.system(size: 20))
                        Text("Save and Logout")
                            .font(.system(size: 20))
                    }
                    
                    HStack {
                        NavigationLink(destination: homePage()) {
                            Image(systemName: "house.circle")
                                .foregroundColor(darkBlueColor)
                                .background(.white)
                                .font(.system(size: 80))
                        }
                        Spacer()
                            .frame(width: 700)
                        NavigationLink(destination: settingHome()) {
                            Image(systemName: "gearshape.circle")
                                .foregroundColor(darkBlueColor)
                                .background(.white)
                                .font(.system(size: 80))
                            
                        }
                    }
                }
                
            }
        }
        .navigationViewStyle(.stack)
        .navigationBarHidden(true)
    }
    
}
