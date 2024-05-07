//import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'therapy1.dart';
import 'therapy2.dart';
import 'therapy3.dart';
import 'therapy4.dart';

void main() {
  runApp(MyApp());
}
class TweetData {
  final List<String> tweets;
  final List<double> subjectivity;
  final List<double> polarity;
  final List<String> analysis;

  TweetData({required this.tweets, required this.subjectivity, required this.polarity, required this.analysis});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Mental Health App',
      home: ResultScreen(),

  routes: {
    '/therapy1': (context) => TherapyPage1(),
    '/therapy2': (context) => TherapyPage2(),
    '/therapy3': (context) => TherapyPage3(),
    '/therapy4': (context) => TherapyPage4(),
  },
  // other app configurations
        

    );
  }
}


class ResultScreen extends StatelessWidget {
  final double? negative;
  final double? neutral;
  final double? positive;
  final TweetData? tweetData;
  final String? message;

   ResultScreen({
    Key? key,
    this.negative,
    this.neutral,
    this.positive, 
   this.tweetData,
    this.message,
   
  }) : super(key: key); 
  

  @override
  Widget build(BuildContext context) {

  if (message != null) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Analysis Result', 
           style: TextStyle(fontFamily: 'Merriweather-Italic') 
           ),
        ),
        body:  SingleChildScrollView(
            child :Column(
               
          children:[
                SizedBox(height: 150.0),
              
             Center( 
           
            child: Text(message!, style: const TextStyle(
                    fontWeight: FontWeight.w300,
                     fontFamily: 'Merriweather-Italic',
                    fontSize: 20,
                  ),),
          ), 
          ],
            ),
        ),
      );
    } else if (negative != null && neutral != null && positive != null) {
      final Map<String, double> dataMap = {
        'Negative': negative!,
        'Neutral': neutral!,
        'Positive': positive!,
      };
      final List<Color> colorList = [
        Color.fromARGB(255, 242, 11, 65),
        Color.fromARGB(255, 240, 236, 20),
        Color.fromARGB(255, 8, 255, 20),
      ];

      String? sentimentText;
    if (negative! >= 90 && negative! > neutral! && negative! > positive!) {
      sentimentText = 'You seem to have Severe Emotional Distress. It is in \"Strongly Concerned Stage\"';
    } 
    else if(negative! >=50  ) 
    { 
      sentimentText = 'You seem to have Anxiety issues & Sleep difficulties. It is in \"Concerned Stage\"';
    } 
    else if (neutral! > positive! && neutral! > negative! && neutral!>=50 ){ 
      sentimentText='\tYou seem to have a Mood Swings & Lack of interests.\n\n\t You can develop your mental health by \n\n 1)Managing Stress,\n\n 2)Building Social Connections, \n\n 3)Practicing Self-care, \n \n 4)Pursuing Personal Interests';
    } 
    else 
    { 
      sentimentText="\tYou seem to have a \"Good Mental Health\".\n\n \t You can maintain it by \n\n 1)Cultivating Gratitude,\n\n 2)Helping Social well-beings,\n\n 3) Maintaining Good Family Relationships";
    }

      return Scaffold(
         resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Analysis Result'),
        ),
        body: SingleChildScrollView( 
         
          child: Column (
                     children: [ 

              

               if (tweetData != null)
                Column(
                  children: [
                    
                    
                    
                  SizedBox(height: 24.0),
                   Text('Sample Table of Sentimental Analysis', 
                   textAlign: TextAlign.left,
  style: TextStyle(
    fontWeight: FontWeight.bold, 
     fontFamily: 'Merriweather-Italic', 
     
    color: Colors.black,
    fontSize: 20.0,),),
                    SizedBox(height: 8.0),
                    DataTable(
                      columns: [
                        DataColumn(label: Text('Tweet')),
                        DataColumn(label: Text('Subjectivity')),
                        DataColumn(label: Text('Polarity')),
                        DataColumn(label: Text('Analysis')),
                      ],
                      rows: tweetData!.tweets.asMap().entries.map((entry) {
                        final index = entry.key;
                        final tweet = entry.value;
                        final subjectivity = tweetData!.subjectivity[index];
                        final polarity = tweetData!.polarity[index];
                        final analysis = tweetData!.analysis[index];
                        return DataRow(
                          cells: [
                            DataCell(Text(tweet)),
                            DataCell(Text(subjectivity.toString())),
                            DataCell(Text(polarity.toString())),
                            DataCell(Text(analysis)),
                          ],
                        ); 
                       
                      }).toList(),
                       dividerThickness :2, 
                       showBottomBorder: true, 
                       headingTextStyle: TextStyle(fontWeight: FontWeight.bold, 
                         fontSize: 18.0, 
                           fontFamily: 'Merriweather-Italic',
                       color: Colors.blue ), 
                       dataTextStyle: TextStyle(
                         fontFamily: 'Merriweather-Italic',
                          color: Color.fromARGB(255, 3, 3, 3)
                       ), 
                      //  border: TableBorder(),
                    ),
                     SizedBox(height: 16.0),
                  ],
                ),
                SizedBox(height: 30.0),
                    Text('Sentimental Pie Chart',style: TextStyle(
    fontWeight: FontWeight.bold, 
     fontFamily: 'Merriweather-Italic',
    
    color: Color.fromARGB(255, 56, 194, 253),
    fontSize: 20.0,),),
                    
                SizedBox(height: 22.0),
              
              
              
              PieChart(
              dataMap: dataMap,
              colorList: colorList,
              chartType: ChartType.ring,
              baseChartColor: Color.fromARGB(210, 255, 124, 124)!.withOpacity(0.15),
              chartRadius: MediaQuery.of(context).size.width / 5,
              legendOptions: const LegendOptions(
                showLegendsInRow: true,
                legendPosition: LegendPosition.bottom,
                showLegends: true,
              ),
              chartValuesOptions: const ChartValuesOptions(
                showChartValueBackground: true,
                showChartValues: true,
                showChartValuesInPercentage: true,
                showChartValuesOutside: false,
              ),
              centerText: "Analysis Score", 
              centerTextStyle: TextStyle(
                  fontFamily: 'Merriweather-Italic',
                   color: Color.fromARGB(255, 3, 3, 3)
              ),
              
              ringStrokeWidth: 25,
            ),
             SizedBox(height: 8.0),
             if (sentimentText != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  sentimentText!,
                  style: const TextStyle( 
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.w300,
                     fontFamily: 'Merriweather-Italic',
                    fontSize: 15,
                  ),
                ), 
                
              ),

               SizedBox(height: 8.0),
              ElevatedButton(
          onPressed: () {
            if (negative! >= 90 && negative! > neutral! && negative! > positive!) {
              Navigator.push(
    context,
    MaterialPageRoute(builder: (context) =>  TherapyPage1()),
  );
             // Navigator.pushNamed(context, '/therapy1');
            } else if (negative! >= 50) {
              Navigator.push(
    context,
    MaterialPageRoute(builder: (context) =>  TherapyPage2()),
  );
              //Navigator.pushNamed(context, '/therapy2');
            } else if (neutral! > positive! && neutral! > negative!) {

              Navigator.push(
    context,
    MaterialPageRoute(builder: (context) =>  TherapyPage3()),
  );
            // Navigator.pushNamed(context, '/therapy3');
            } else {
              Navigator.push(context,MaterialPageRoute(builder: (context) => TherapyPage4()),
  );
             // Navigator.pushNamed(context, '/therapy4');
            }
          },
           child: Text(
              'Therapists',
              style: TextStyle(
                color: Colors.white, 
                fontSize: 18.0, 
                 fontFamily: 'Merriweather-Italic',
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.blue, 
              fixedSize: Size(122.0, 50.0), 
            ),
        ), 
         SizedBox(height: 16.0),
        
            ], 
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: Center(
          child: const Text('Invalid response received from server'),
        ),
      );
    }
  }
}
