//
//  ContentView.swift
//  Json
//
//  Created by Mohammed Alsaleh on 13/11/1443 AH.
//

import SwiftUI

struct ContentView: View {
    @State var jsonData : [Any] = []
    @State var question = ""
    @State var array = ["أ","ب","ج","د"]
    @State var a = ""
    @State var b = ""
    @State var c = ""
    @State var d = ""
    @State var correctAnswer = ""
    var correctAnswerArabic :String? {
        var output : String?
        if correctAnswer == "A" {
            output = "أ"
        } else if correctAnswer == "B" {
            output = "ب"
        } else if correctAnswer == "C" {
            output = "ج"
        } else if correctAnswer == "D" {
            output = "د"
        }
        return output
    }
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    TextField("السؤال",text: $question)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    ForEach(array,id: \.self) { data in
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(lineWidth: 5)
                            HStack {
                                ZStack {
                                    if self.correctAnswerArabic == data {
                                        Circle()
                                            .fill(.green)
                                            .overlay(Text(data))
                                    } else {
                                        Circle()
                                            .stroke()
                                            .overlay(Text(data))
                                        
                                    }
                                }.frame(width: 30).onTapGesture {
                                    withAnimation {
                                        if data == "أ" {
                                            self.correctAnswer = "A"
                                        } else if data == "ب" {
                                            self.correctAnswer = "B"
                                        } else if data == "ج" {
                                            self.correctAnswer = "C"
                                        } else if data == "د" {
                                            self.correctAnswer = "D"
                                        }
                                    }
                                }
                                if data == "أ" {
                                    TextField("اختيار (\(data))",text: $a)
                                } else if data == "ب" {
                                    TextField("اختيار (\(data))",text: $b)
                                } else if data == "ج" {
                                    TextField("اختيار (\(data))",text: $d)
                                } else if data == "د" {
                                    TextField("اختيار (\(data))",text: $c)
                                }
                                Spacer()
                            }.frame(maxWidth:.infinity).padding()
                        }.frame(height:60)
                    }
                    if self.correctAnswerArabic != nil {
                        Text("الجواب الصحيح هو: \(correctAnswerArabic!)")
                    }
                    Button("اكتب سؤال ثاني") {
                        self.jsonData.append([
                            "question" : question,
                            "choices" : [
                                "A" : a,
                                "B" : b,
                                "D" : d,
                                "C" : c
                            ],
                            "correct_Answer" : correctAnswer
                        ])
                        self.question = ""
                        self.a = ""
                        self.b = ""
                        self.c = ""
                        self.d = ""
                        self.correctAnswer = ""
                    }
                    Button("أحصل على الإسئلة") {
                        self.jsonData.append([
                            "question" : question,
                            "choices" : [
                                "A" : a,
                                "B" : b,
                                "D" : d,
                                "C" : c
                            ],
                            "correct_Answer" : correctAnswer
                        ])
                        DispatchQueue.main.async {
                            if let jsonData = try? JSONSerialization.data(withJSONObject: self.jsonData) {
                                if let jsonString = String(data: jsonData, encoding: .utf8) {
                                    let documentsDirectoryURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                                    let file2ShareURL = documentsDirectoryURL.appendingPathComponent("\(Date()).json")
                                    do {
                                        try jsonString.write(to: file2ShareURL, atomically: false, encoding: .utf8)
                                    } catch {
                                        print(error)
                                    }
                                    
                                    do {
                                        let _ = try Data(contentsOf: file2ShareURL)
                                        let activityController = UIActivityViewController(activityItems: [file2ShareURL], applicationActivities: nil)
                                        UIApplication.shared.windows.first?.rootViewController!.present(activityController, animated: true, completion: nil)
                                    } catch {
                                        print(error)
                                    }
                                    
                                }
                            }
                        }
                    }
                }.padding().navigationTitle("كتابة الإسئلة")
            }
        }.environment(\.layoutDirection, .rightToLeft)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 13 Pro")
    }
}
