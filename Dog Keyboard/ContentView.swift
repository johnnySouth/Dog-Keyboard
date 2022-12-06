//
//  ContentView.swift
//  Shared
//
//  Created by Johnny Archard on 11/8/22.
//

import SwiftUI
import AVFoundation
import Firebase
import FirebaseStorage
import FirebaseAuth
import UIKit
import MediaPlayer

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
let lightBlueColor = Color(red: 103/255, green: 153/255, blue: 154/255)
let darkBlueColor = Color(red: 49/255, green: 76/255, blue: 76/255)


var lexigrams: [String] = []
var sessionGoal: String = ""
var timeOfPress: [String] = []
var dogsForSession: [String] = []

func exportData(lexigramPressed: [String],sessionContext: String, dateTiime: [String],dogsSelected: [String]){
    let user = Auth.auth().currentUser
    let email = user?.email ?? ""
    let uid = user?.uid ?? ""
    print(NSHomeDirectory())
    // File Name
    let sFileName = "testExportv9©.csv"
    
    let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    
    let documentURL = URL(fileURLWithPath: documentDirectoryPath).appendingPathComponent(sFileName)
    
    let output =  OutputStream.toMemory()
    
    let csvWriter = CHCSVWriter(outputStream: output, encoding: String.Encoding.utf8.rawValue, delimiter: ",".utf16.first!)
    
    //Header for the CSV file
    csvWriter?.writeField("User_ID")
    csvWriter?.writeField("User_Email")
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
    
    arrOfUserData.append([uid,email,dogString,sessionGoal,dateString,lexigramString])
    //arrOfUserData.append(["234","Johnson Doe","34","HR"])
    //arrOfUserData.append(["567","John Appleseed","40","Engg"])

    
   // arrOfUserData.append(lexigrams)
    
    //Employee_ID,Employee_Name,Employee_Age,Employee_Designation
    // 123          John Doe        30          Sys Analyst
    for(elements) in arrOfUserData.enumerated(){
        csvWriter?.writeField(elements.element[0]) // UserId
        csvWriter?.writeField(elements.element[1]) // User_Email
        csvWriter?.writeField(elements.element[2]) // Dogs_In_Session
        csvWriter?.writeField(elements.element[3]) // Session_Context
        csvWriter?.writeField(elements.element[4]) // Date/Time
        csvWriter?.writeField(elements.element[5]) // Lexigram Pressed
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

struct homePage: View {
    @State private var sessionContext = ""
    @State private var nameOfDog: String = ""
    @State private var dogNames: [String] = []
    @AppStorage("selection") var selection:String = "Select Dog"
    @AppStorage("lexigramAlbum")  var lexigramAlbum:String = "Assorted"
   
    
    
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
             }
                    Spacer()
                        .frame(height: -50)
                    LazyHGrid(rows: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Rows@*/[GridItem(.fixed(20))]/*@END_MENU_TOKEN@*/) {
                        Text("Lexigram Album:")
                            .foregroundColor(Color.black)
                        Text("                              ")
                        Menu(lexigramAlbum)
                        {
                            Button("Places", action: places)
                            Button("Things", action: things)
                            Button("Feelings", action: feelings)
                            Button("Actions", action: actions1)
                            Button("Assorted", action: assorted)
                        }
                    }
                    
                    TextField("Enter Session Context", text: $sessionContext)
                        .padding()
                        .frame(width: 300, height:50, alignment: .center)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
             
             TextField("Enter dog name", text: $nameOfDog)
             .padding()
             .frame(width: 300, height:50, alignment: .center)
             .background(Color.black.opacity(0.05))
             .cornerRadius(10)
             Button("Add dog Name"){
             addDogNames()
             }
             
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
             .background(lightBlueColor
             )
             .cornerRadius(10)
             }
             }else if lexigramAlbum == "Feelings"{
             NavigationLink(destination: feelingsActivityPage()) {
             Text("Begin")
             .foregroundColor(Color.white)
             .frame(width: 300, height: 50)
             .background(lightBlueColor)
             .cornerRadius(10)
             
             }
             }else if lexigramAlbum == "Actions"{
             NavigationLink(destination: actionsActivityPage()) {
             Text("Begin")
             .foregroundColor(Color.white)
             .frame(width: 300, height: 50)
             .background(lightBlueColor)
             .cornerRadius(10)
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
    
    func dogsInSession(){
        print("Hello")
    }
    func retrieveSessionContext(){
        sessionGoal = sessionContext
    }
    func dog1() {
        selection = "Dog 1"
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
    func assorted() {
        lexigramAlbum = "Assorted"
    }
    func addDogNames(){
        let db = Firestore.firestore()
        let dogName = nameOfDog
        
        // Add a new document with a generated id.
        var ref: DocumentReference? = nil
        ref = db.collection("Dogs").addDocument(data: [
            "name": dogName,
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
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
    
  //  let images = ["Loading", "Beach"] // Array of image names to show
 //   @State var activeImageIndex = 0 // Index of the currently displayed image
  //  let imageSwitchTimer = Timer.publish(every: 5, on: .main, in: .common)
   //     .autoconnect()
    
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
                /*    Spacer()
                        .frame(height: 100)
                    if (activeImageIndex) <= 0 {
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
                    }
                    .foregroundColor(Color.white)
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
                
                NavigationLink(destination: arrangeLexigrams()) {
                    Text("Rearrange Lexigrams")
                        .foregroundColor(Color.white)
                        .frame(width: 300, height: 50)
                        .background(lightBlueColor)
                        .cornerRadius(10)
                }
                NavigationLink(destination: testContentView()) {
                    Text("Add Lexigrams")
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

struct exportPage: View {
    
    @AppStorage("selection") var selection:String = "All Users"
    @AppStorage("timePeriod") var timePeriod:String = "Last 30 days"
    
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
                }
                .foregroundColor(Color.white)
                .frame(width: 300, height: 50)
                .background(lightBlueColor)
                .cornerRadius(10)
                
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
                            }
                            .foregroundColor(Color.white)
                            .frame(width: 300, height: 50)
                            .background(lightBlueColor)
                            .cornerRadius(10)
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
    @State var retrievedImages = [UIImage]()
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
    func retrievePhotos() {
        // Get the data from database
        let db = Firestore.firestore()
        
        db.collection("images").getDocuments { snapshot, error in
            
            if error == nil && snapshot != nil{
                
                var paths = [String]()
                
                //Loop througn all the returned docs
                for doc in snapshot!.documents {
                    // Extract the file path
                    paths.append(doc["url"] as! String)
                }
                
                //Loop through each file path and fetch the data from storage
                for path in paths {
                    // Get a reference to storage
                    let storageRef = Storage.storage().reference()
                  
                    // Specify the path
                    let fileRef = storageRef.child(path)
                    
                    // Retrieve the data
                    fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                       
                        // Check for erros
                        if error == nil && data != nil {
                            
                            // Create a UiImage and put it into our array for display
                            if  let image = UIImage(data: data!){
                                
                                DispatchQueue.main.async {
                                    retrievedImages.append(image)
                                }
                            }
                        }
                    } // End of Loop through paths
                }
            }
        }
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
    
    @State var retrievedImages = [UIImage]()
    var body: some View {
        ZStack{
            Color(red: 103/255, green: 153/255, blue: 154/255)
                .ignoresSafeArea()
            NavigationView{
                VStack{
                    ScrollView {
                        VStack{
                            LazyVGrid(columns: [.init(.adaptive(minimum: 300, maximum: .infinity), spacing: 30)], spacing:80) {
                                ForEach(retrievedImages, id: \.self){image in
                                    Image(uiImage: image)
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
            .onAppear{
                retrieveFeelings()
            }
        }
    }
    func retrieveFeelings() {
        // Get the data from database
        let db = Firestore.firestore()
        
        db.collection("Feelings").getDocuments { snapshot, error in
            
            if error == nil && snapshot != nil{
                
                var paths = [String]()
                
                //Loop througn all the returned docs
                for doc in snapshot!.documents {
                    // Extract the file path
                    paths.append(doc["url"] as! String)
                }
                
                //Loop through each file path and fetch the data from storage
                for path in paths {
                    // Get a reference to storage
                    let storageRef = Storage.storage().reference()
                  
                    // Specify the path
                    let fileRef = storageRef.child(path)
                    
                    // Retrieve the data
                    fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                       
                        // Check for erros
                        if error == nil && data != nil {
                            
                            // Create a UiImage and put it into our array for display
                            if  let image = UIImage(data: data!){
                                
                                DispatchQueue.main.async {
                                    retrievedImages.append(image)
                                }
                            }
                        }
                    } // End of Loop through paths
                }
            }
        }
    }
}

struct thingsView: View {
    @State var retrievedImages = [UIImage]()
    var body: some View {
        ZStack{
            Color(red: 103/255, green: 153/255, blue: 154/255)
                .ignoresSafeArea()
            NavigationView{
                VStack{
                    ScrollView {
                        VStack{
                            LazyVGrid(columns: [.init(.adaptive(minimum: 300, maximum: .infinity), spacing: 30)], spacing:80) {
                                ForEach(retrievedImages, id: \.self){image in
                                    Image(uiImage: image)
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
            .onAppear{
                retrieveThings()
            }
        }
    }
    func retrieveThings() {
        // Get the data from database
        let db = Firestore.firestore()
        
        db.collection("Things").getDocuments { snapshot, error in
            
            if error == nil && snapshot != nil{
                
                var paths = [String]()
                
                //Loop througn all the returned docs
                for doc in snapshot!.documents {
                    // Extract the file path
                    paths.append(doc["url"] as! String)
                }
                
                //Loop through each file path and fetch the data from storage
                for path in paths {
                    // Get a reference to storage
                    let storageRef = Storage.storage().reference()
                  
                    // Specify the path
                    let fileRef = storageRef.child(path)
                    
                    // Retrieve the data
                    fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                       
                        // Check for erros
                        if error == nil && data != nil {
                            
                            // Create a UiImage and put it into our array for display
                            if  let image = UIImage(data: data!){
                                
                                DispatchQueue.main.async {
                                    retrievedImages.append(image)
                                }
                            }
                        }
                    } // End of Loop through paths
                }
            }
        }
    }
}

struct actionsView: View {
    @State var retrievedImages = [UIImage]()
    var body: some View {
        ZStack{
            Color(red: 103/255, green: 153/255, blue: 154/255)
                .ignoresSafeArea()
            NavigationView{
                VStack{
                    ScrollView {
                        VStack{
                            LazyVGrid(columns: [.init(.adaptive(minimum: 300, maximum: .infinity), spacing: 30)], spacing:80) {
                                ForEach(retrievedImages, id: \.self){image in
                                    Image(uiImage: image)
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
            .onAppear(){
                retrieveActions()
            }
        }
    }
    func retrieveActions() {
        // Get the data from database
        let db = Firestore.firestore()
        
        db.collection("Actions").getDocuments { snapshot, error in
            
            if error == nil && snapshot != nil{
                
                var paths = [String]()
                
                //Loop througn all the returned docs
                for doc in snapshot!.documents {
                    // Extract the file path
                    paths.append(doc["url"] as! String)
                }
                
                //Loop through each file path and fetch the data from storage
                for path in paths {
                    // Get a reference to storage
                    let storageRef = Storage.storage().reference()
                  
                    // Specify the path
                    let fileRef = storageRef.child(path)
                    
                    // Retrieve the data
                    fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                       
                        // Check for erros
                        if error == nil && data != nil {
                            
                            // Create a UiImage and put it into our array for display
                            if  let image = UIImage(data: data!){
                                
                                DispatchQueue.main.async {
                                    retrievedImages.append(image)
                                }
                            }
                        }
                    } // End of Loop through paths
                }
            }
        }
    }
}
struct placesView: View {
    @State var retrievedImages = [UIImage]()
    var body: some View {
        ZStack{
            Color(red: 103/255, green: 153/255, blue: 154/255)
                .ignoresSafeArea()
            NavigationView{
                VStack{
                    ScrollView {
                        VStack{
                    LazyVGrid(columns: [.init(.adaptive(minimum: 300, maximum: .infinity), spacing: 30)], spacing:80) {
                        ForEach(retrievedImages, id: \.self){image in
                            Image(uiImage: image)
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
        .onAppear(){
            retrievePlaces()
        }
    }
}
    func retrievePlaces() {
        // Get the data from database
        let db = Firestore.firestore()
        
        db.collection("Places").getDocuments { snapshot, error in
            
            if error == nil && snapshot != nil{
                
                var paths = [String]()
                
                //Loop througn all the returned docs
                for doc in snapshot!.documents {
                    // Extract the file path
                    paths.append(doc["url"] as! String)
                }
                
                //Loop through each file path and fetch the data from storage
                for path in paths {
                    // Get a reference to storage
                    let storageRef = Storage.storage().reference()
                  
                    // Specify the path
                    let fileRef = storageRef.child(path)
                    
                    // Retrieve the data
                    fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                       
                        // Check for erros
                        if error == nil && data != nil {
                            
                            // Create a UiImage and put it into our array for display
                            if  let image = UIImage(data: data!){
                                
                                DispatchQueue.main.async {
                                    retrievedImages.append(image)
                                }
                            }
                        }
                    
                    } // End of Loop through paths
                }
            }
            
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
    
    let beachImages = ["beach1", "beach2", "beach3", "beach4"] // Array of image names to show
    @State var activeImageIndex = 0 // Index of the currently displayed image
    let imageSwitchTimer = Timer.publish(every: 3, on: .main, in: .common)
        .autoconnect()
    
    let imageAppearTimer = Timer.publish(every: 3, on: .main, in: .common)
        .autoconnect()
    
    @State  var pressed = false
    @State  var beachP = false
    @State  var imageAppear = 3
    @State var woodsP = false
    @State var dpP = false
    @State var cratep = false
    @State var insidep = false
    @State var outsidep = false

    @State  var retrievedImages = [UIImage]()
    
    var body: some View {
        
        NavigationView{
            VStack {
                Text("Places")
                    .font(.system(size: 70))
                    .frame(maxWidth: 700, alignment: .leading)
                LazyVGrid(columns: [.init(.adaptive(minimum: 300, maximum: .infinity), spacing: 30)], spacing:80) {
                    
                    ForEach(retrievedImages, id: \.self){image in
                        Button(action: {
                            let beach = AVSpeechUtterance(string: "Beach")
                            beach.voice = AVSpeechSynthesisVoice(language: "en-US")
                            beach.rate = 0.4
                            lexigramTracker()
                            
                            let synthesizer = AVSpeechSynthesizer()
                            synthesizer.speak(beach)
                            pressed = true
                            beachP = true
                            imageAppear = 3
                        }) {
                            Image(uiImage:image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .aspectRatio(1, contentMode: .fit)
                                .border(darkBlueColor)
                                .frame(width:220, height: 220)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        } }
                    
                    if pressed == true && beachP == true && imageAppear == 3{
                        VStack{
                         
                            GeometryReader { geo in
                                Image(uiImage: retrievedImages[activeImageIndex])
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
                                    }
                                }
                            }
                            Spacer()
                                .frame(height: 100)
                      //  }
                    }
                }
                .background(.red.opacity(0))
                .clipped()
               
            }
        }
        .navigationBarHidden(true)
        .accentColor(darkBlueColor)
        .navigationViewStyle(.stack)
        .onAppear(){
            retrievePlaces()
        }
    }

    func lexigramTracker(){
        var lexigramName = "Beach"
        let currentDateTime = Date()
        
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .long
        
        let dateTimeString = formatter.string(from: currentDateTime)
        
        
        timeOfPress.append(dateTimeString)
        lexigrams.append(lexigramName)
        
    }
    func retrievePlaces() {
        // Get the data from database
        let db = Firestore.firestore()
        
        db.collection("Places").getDocuments { snapshot, error in
            
            if error == nil && snapshot != nil{
                
                var paths = [String]()
                
                //Loop througn all the returned docs
                for doc in snapshot!.documents {
                    // Extract the file path
                    paths.append(doc["url"] as! String)
                }
                
                //Loop through each file path and fetch the data from storage
                for path in paths {
                    // Get a reference to storage
                    let storageRef = Storage.storage().reference()
                  
                    // Specify the path
                    let fileRef = storageRef.child(path)
                    
                    // Retrieve the data
                    fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                       
                        // Check for erros
                        if error == nil && data != nil {
                            
                            // Create a UiImage and put it into our array for display
                            if  let image = UIImage(data: data!){
                                
                                DispatchQueue.main.async {
                                    retrievedImages.append(image)
                                }
                         let randomPhoto = retrievedImages.randomElement()
                            }
    
                        }
                    
                    } // End of Loop through paths
                }
            }
            
        }
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
                                .foregroundColor(.yellow)
                                .background(Color.mint)
                                .font(.system(size: 95))
                                .cornerRadius(10)
                        }
                        Spacer()
                            .frame(width: 700)
                        NavigationLink(destination: settingHome()) {
                            Image(systemName: "gearshape.circle")
                                .foregroundColor(.yellow)
                                .background(Color.mint)
                                .font(.system(size: 95))
                                .cornerRadius(10)
                            
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
    
    
    @State  var retrievedThings = [UIImage]()
    @State  var imageAppear = 3
    
    
    
    var body: some View {
        
        NavigationView{
            VStack {
                Text("Things")
                    .font(.system(size: 70))
                    .frame(maxWidth: 700, alignment: .leading)
                
                ZStack{
                    LazyVGrid(columns: [.init(.adaptive(minimum: 300, maximum: .infinity), spacing: 30)], spacing:80) {
                        ForEach(retrievedThings, id: \.self){image in
                            Button(action: {
                                let sound = AVSpeechUtterance(string: "Toy")
                                sound.voice = AVSpeechSynthesisVoice(language: "en-US")
                                sound.rate = 0.4
                                lexigramTracker()
                                
                                let synthesizer = AVSpeechSynthesizer()
                                synthesizer.speak(sound)
                                
                                let toyP = true
                                imageAppear = 3
                            }) {
                                Image(uiImage:image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .aspectRatio(1, contentMode: .fit)
                                    .border(darkBlueColor)
                                    .frame(width:220, height: 220)
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                            } }
                    }
                    //ball images appear
                    if ballp == true && imageAppear == 3{
                        VStack{
                            GeometryReader { geo in
                                Image(uiImage:retrievedThings[activeImageIndex])
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
                    //end
                }
                .background(.red.opacity(0))
                .clipped()
                
            }
            
        }
        .navigationBarHidden(true)
        .accentColor(darkBlueColor)
        .navigationViewStyle(.stack)
        .onAppear(){
            retrieveThings()
        }
        
    }
    func lexigramTracker(){
        var lexigramName = "Beach"
        let currentDateTime = Date()
        
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .long
        
        let dateTimeString = formatter.string(from: currentDateTime)
        
        
        timeOfPress.append(dateTimeString)
        lexigrams.append(lexigramName)
        
    }
    func retrieveThings() {
        // Get the data from database
        let db = Firestore.firestore()
        
        db.collection("Things").getDocuments { snapshot, error in
            
            if error == nil && snapshot != nil{
                
                var paths = [String]()
                
                //Loop througn all the returned docs
                for doc in snapshot!.documents {
                    // Extract the file path
                    paths.append(doc["url"] as! String)
                }
                
                //Loop through each file path and fetch the data from storage
                for path in paths {
                    // Get a reference to storage
                    let storageRef = Storage.storage().reference()
                  
                    // Specify the path
                    let fileRef = storageRef.child(path)
                    
                    // Retrieve the data
                    fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                       
                        // Check for erros
                        if error == nil && data != nil {
                            
                            // Create a UiImage and put it into our array for display
                            if  let image = UIImage(data: data!){
                                
                                DispatchQueue.main.async {
                                    retrievedThings.append(image)
                                }
                            }
    
                        }
                    
                    } // End of Loop through paths
                }
            }
            
        }
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
    
    let hungryImages = ["food1", "food2", "food3", "food4"] // Array of beach images to show
    //let ouchImages = ["ouch1", "ouch2", "ouch3", "ouch4"] // Array of woods image to show
    
    @State  var retrievedFeelings = [UIImage]()
    @State var activeImageIndex = 0 // Index of the currently displayed image
    let imageSwitchTimer = Timer.publish(every: 3, on: .main, in: .common)
        .autoconnect()
    
    let imageAppearTimer = Timer.publish(every: 3, on: .main, in: .common)
        .autoconnect()
    
    @State  var hungryp = false
    //@State var ouchp = false
    
    @State  var imageAppear = 3
    
    
    var body: some View {
        
        NavigationView{
            VStack {
                Text("Feelings")
                    .font(.system(size: 70))
                    .frame(maxWidth: 700, alignment: .leading)
                ZStack{
                    LazyVGrid(columns: [.init(.adaptive(minimum: 300, maximum: .infinity), spacing: 30)], spacing:80) {
                        ForEach(retrievedFeelings, id: \.self){image in
                            Button(action: {
                                let sound = AVSpeechUtterance(string: "hungry")
                                sound.voice = AVSpeechSynthesisVoice(language: "en-US")
                                sound.rate = 0.4
                                lexigramTracker()
                                
                                let synthesizer = AVSpeechSynthesizer()
                                synthesizer.speak(sound)
                                hungryp = true
                                
                                imageAppear = 3
                            }) {
                                Image(uiImage:image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .aspectRatio(1, contentMode: .fit)
                                    .border(darkBlueColor)
                                    .frame(width:220, height: 220)
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                            } }
                        
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
        var lexigramName = "Beach"
        let currentDateTime = Date()
        
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .long
        
        let dateTimeString = formatter.string(from: currentDateTime)
        
        
        timeOfPress.append(dateTimeString)
        lexigrams.append(lexigramName)
        
    }
    func retrievefeelings() {
        // Get the data from database
        let db = Firestore.firestore()
        
        db.collection("Feelings").getDocuments { snapshot, error in
            
            if error == nil && snapshot != nil{
                
                var paths = [String]()
                
                //Loop througn all the returned docs
                for doc in snapshot!.documents {
                    // Extract the file path
                    paths.append(doc["url"] as! String)
                }
                
                //Loop through each file path and fetch the data from storage
                for path in paths {
                    // Get a reference to storage
                    let storageRef = Storage.storage().reference()
                  
                    // Specify the path
                    let fileRef = storageRef.child(path)
                    
                    // Retrieve the data
                    fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                       
                        // Check for erros
                        if error == nil && data != nil {
                            
                            // Create a UiImage and put it into our array for display
                            if  let image = UIImage(data: data!){
                                
                                DispatchQueue.main.async {
                                    retrievedFeelings.append(image)
                                }
                            }
    
                        }
                    
                    } // End of Loop through paths
                }
            }
            
        }
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
        
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
