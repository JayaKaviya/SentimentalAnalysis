import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';



void main() => runApp(TherapyPage4());

class Doctor {
  final String name;
  final String details;
  final String photoAssetPath;
  final String experience;
  final String workLocation;
 


  Doctor({required this.name, required this.details, required this.photoAssetPath,required this.experience,
    required this.workLocation,});
}

List<Doctor> doctors = [  Doctor(  name: "Dr. John Doe",details: "Life Coach",photoAssetPath: "assets/images/new1.jpg",experience:"5 yrs+ ",
    workLocation:"Chennai", 
    ), 
 Doctor(      name: "Dr. Sanjana", details: "Counsellor", photoAssetPath: "assets/images/d3.webp",experience:"7 yrs+ ", workLocation:"Hyderabad"),  
 Doctor(      name: "Dr. Michael Lee", details: "Medidation Instructor", photoAssetPath: "assets/images/d2.webp",experience:"4 yrs ", workLocation:"Bangalore"),];


class TherapyPage4 extends StatelessWidget {
  @override

   Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Our Experts',
      home: Scaffold(   resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Our Experts',  style: TextStyle(fontFamily: 'Merriweather-Italic') ),
        ),
        body: ListView.builder(
          itemCount: doctors.length,
          itemBuilder: (BuildContext context, int index) {
            return SizedBox(
              width: 50.0,
              height: 300.0,
              child: Card(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 120.0,
                      child: Image.asset(
                        doctors[index].photoAssetPath,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            doctors[index].name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,fontFamily: 'Merriweather-Italic', fontSize: 15.0),
                          ),
                          SizedBox(height: 10.0),
                          Text(doctors[index].details,  style: TextStyle(fontFamily: 'Merriweather-Italic') ),
                          SizedBox(height: 10.0),
                            Text('Experience: ${doctors[index].experience}',  style: TextStyle(fontFamily: 'Merriweather-Italic') ),
              SizedBox(height: 10.0),
              Text('Work Location: ${doctors[index].workLocation}',  style: TextStyle(fontFamily: 'Merriweather-Italic') ),
              SizedBox(height: 10.0),
                          ElevatedButton(
                            onPressed: () 
                            
                            async {
                              var url = Uri.parse("mailto:kavyamanz@gmail.com");
                               if (await canLaunchUrl(url)) {
                                  await launchUrl(url);
                                  } else {
                               throw 'Could not launch $url';
                              }
                             },
                          
                            
                            child: Text('Mail', 
                             style: TextStyle(
                               
                                 fontFamily: 'Merriweather-Italic')),
                          ),
                          SizedBox(height: 10.0),
                      
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}






