import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'analyze.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Mental Health App' ,
      theme: ThemeData(fontFamily: 'Merriweather-Italic'),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _sendData() async {
    final String url = 'http://127.0.0.1:5000/processjson';
    final String username = _controller.text;

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
      }),
    );


   if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    if (data.containsKey('positive') && data.containsKey('negative') && data.containsKey('neutral')&& data.containsKey('tweet')) {
      final double negative = data['negative'];
      final double neutral = data['neutral'];
      final double positive = data['positive'];

       final tweetDataJson = jsonDecode(data['tweet']);

      final List<String> tweets = List<String>.from(tweetDataJson['Tweets'].values);
      final List<double> subjectivity = List<double>.from(tweetDataJson['Subjectivity'].values);
      final List<double> polarity = List<double>.from(tweetDataJson['Polarity'].values);
      final List<String> analysis = List<String>.from(tweetDataJson['Analysis'].values);
      final TweetData tweetData = TweetData(tweets: tweets, subjectivity: subjectivity, polarity: polarity, analysis: analysis);


      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            negative: negative,
            neutral: neutral,
            positive: positive,
          tweetData: tweetData,

          ),
        ),
      );
    } else if (data.containsKey('req')) {
      final String req = data['req'];
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            message: req,
          ),
        ),
      );
    } else {
      throw Exception('Unexpected server response');
    }
  } else {
    throw Exception('Failed to send data');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
       resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title:  Text('Mental Health App'),  
        textTheme:TextTheme(titleMedium: TextStyle(fontFamily: 'Merriweather-Italic'))
      ),
      body:    

      // Stack(
      //   children: <Widget>[
          // Positioned.fill(
          //   child: Image.asset(
          //     'assets/images/m9.jpg',
          //     fit: BoxFit.cover,
          //   ),
          // ),


      SingleChildScrollView(
  // child: Container( 

          
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage('assets/images/mental2.jpg'),
        //  fit: BoxFit.cover,
        //   ),
        // ),












   child:  Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'WELCOME!',
            style: TextStyle(
              fontSize: 60.0, 
              fontFamily: 'Merriweather-Italic',
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          SizedBox(height: 2.0),
          Image.asset(
            'assets/images/m10.jpg',
            width: 500.0,
            height: 350.0,
          ),
          SizedBox(height: 32.0), // Updated SizedBox height
          SizedBox( 
            width:410.0,
            height: 90.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.blue, width: 2,)
                  ),
                  hintText: '@username',
                  hintStyle: TextStyle(
                    color: Color.fromARGB(255, 59, 55, 55), 
                     fontFamily: 'Merriweather-Italic', 
                    fontStyle: FontStyle.normal, 
                    fontWeight: FontWeight.bold
                  ),
                  labelText: 'Enter your Twitter handle', 
                  labelStyle: TextStyle(
                       fontFamily: 'Merriweather-Italic',
                  ),
                  border: OutlineInputBorder( 
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 0, 0, 0)
                    )
                  ),
                ),
                keyboardType: TextInputType.name ,
                maxLength: 15,
                cursorColor: Colors.blue,
              ),
            ),
          ),
          SizedBox(height: 2.0), // Updated SizedBox height
          ElevatedButton( 
            
            onPressed: _sendData,
            child: Text(
              'Analyze Tweets',
              style: TextStyle(
                color: Colors.white, 
                fontSize: 18.0, 
                 fontFamily: 'Merriweather-Italic',
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.blue, 
              fixedSize: Size(180.0, 50.0), 
            ),
          ),
          SizedBox(height: 22.0),
          Text(
            '\" Take care of your mind and the rest will follow \"',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0, 
               fontFamily: 'Merriweather-Italic',
             
              color: Color.fromARGB(255, 34, 34, 34), 

            ),
          ),
        ],
      ),
    
),


      ),
      //   ], 
      // ),


    );
      
      

    
  }
}
 
 



