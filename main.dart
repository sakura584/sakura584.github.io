import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});



  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 229, 238, 136)),
      ),
      home: const MyHomePage(title: 'Books Library'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String search='';
  String bookTitle='';
  String bookAuthor='';
  String bookImage='';
  String secureUrl='';
Future<http.Response> fetchBooks(String keyword) {
  return http.get(Uri.parse('https://www.googleapis.com/books/v1/volumes?q=flutter&maxResults=40'));
}

Map<String, dynamic> parseBooks(String responseBody) {
  final parsed = jsonDecode(responseBody);
  return parsed;
}

Future<dynamic> displayBooks(String keyword) async {
  try {
    final response = await fetchBooks(keyword);

    if (response.statusCode == 200) {
      final Map<String, dynamic> books = parseBooks(response.body);
      print(response.body);
      // Display the books in a Flutter widget.
    return books;} else {
      throw Exception('Failed to load books');
    }
  ;} catch (e) {
    
    // Handle the exception.
  }
}

int i = 0;

 void _incrementCounter(){
     setState(() {
      if (0 <= i && i <= 39)
       {i++;
       writeBook();} 
     });
 }
 void _decrementCounter(){
    setState(() {
      if (1 <= i && i <= 40)
       {i--;
       writeBook();} 
     });
 }

void writeBook ()async{
  print('writebook');
    final books =await displayBooks('flutter');
    print(books);
    
    
    dynamic item=books['items'][i];
    setState(() {
      

    bookTitle=item['volumeInfo']['title'];
    bookAuthor=item['volumeInfo']['authors'].join(',');
    bookImage=item['volumeInfo']['imageLinks']['thumbnail']; 
    secureUrl = bookImage.replaceFirst('http://', 'https://');
    

    });
  }
 

  @override
  void initState(){
    super.initState();
    writeBook();
    

  }

  
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
       
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
       
        title: Text(widget.title),
      ),
      body: Container(
        color: const Color.fromARGB(255, 242, 236, 204),
        child:Column
        (mainAxisAlignment: MainAxisAlignment.start,
         
        children: [
          Column(crossAxisAlignment:CrossAxisAlignment.start,
          children: [
          Padding(padding: const EdgeInsets.symmetric(
            vertical:14,
            horizontal: 36,
          ),
          child:TextField(
            
            onSubmitted: (value){
              search = value;
              print(search);
            } ,
            style: TextStyle(
              fontSize:18,
              color: Colors.black
            ),
          decoration: InputDecoration(
            hintText: "どのジャンルの本を検索したいですか？"
          ),
          ),
          )],
          ),
          
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child:Text(bookTitle.toString(),
              textAlign: TextAlign.center,
            style:TextStyle(
              fontSize: 40
            )),                        
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child:Text(bookAuthor.toString(),
              textAlign: TextAlign.center,
            style:TextStyle(
              fontSize: 25
            )),                        
            ),
          ),
       

      SizedBox(height: 80,),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(child: const Text('←'),
  style: ElevatedButton.styleFrom(fixedSize: Size(10,10),
    shape: const CircleBorder(
      side: BorderSide(
        color: Colors.black,
        width: 1,
        style: BorderStyle.solid,
      ),
    ),
  ),
  onPressed: () {
  _decrementCounter(); 
  print(i); 
  },
),
          Align(
                alignment: Alignment.bottomCenter,
                child: Image.network(
                  secureUrl,
                  webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
                errorBuilder: (context, error, stackTrace) {
                  return const Text("画像の読み込みに失敗しました");
                },
                )
              ),
          ElevatedButton(child: const Text('→'),
  style: ElevatedButton.styleFrom(
    shape: const CircleBorder(
      side: BorderSide(
        color: Colors.black,
        width: 1,
        style: BorderStyle.solid,
      ),
    ),
  ),
  onPressed: () {
    _incrementCounter();
    print(i);},
),              
            ],
          ),

          SizedBox(height: 70,),
          
          ElevatedButton(child: const Text('♡',
          style: TextStyle(color: Color.fromARGB(221, 236, 25, 25)),),
  style: ElevatedButton.styleFrom(
    shape: const CircleBorder(
      side: BorderSide(
        color: Colors.black,
        width: 1,
        style: BorderStyle.solid,
      ),
    ),
  ),
  onPressed: () {
    
  },
),              
          
        ],


        )

      
       
      ),
      
    );
  }
}
