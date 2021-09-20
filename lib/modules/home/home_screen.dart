import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.menu,
        ),
        title: Text('BMI calculator'),
        backgroundColor: Colors.red,
        elevation: 20,
        actions: [
          IconButton(
            icon: Icon(Icons.notification_important),
            onPressed: onNotification,
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
        centerTitle: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(20),
                  bottomEnd: Radius.circular(20),
                ),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  Image(
                    image: NetworkImage(
                      'https://occ-0-2794-2219.1.nflxso.net/dnm/api/v6/E8vDc_W8CLv7-yMQu8KMEC7Rrr8/AAAABUm3a5AE5Jkr0ayVJcsqj7DcTkGZ-eOJ1iNtpNO_iImNodQM3uJMlTZaGaqvIjdRhE96teXoqmQFvVQldfzRSp7mJwbA.jpg?r=685',
                    ),
                    fit: BoxFit.cover,
                    width: 300,
                    height: 200,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 5,
                    ),
                    width: 300,
                    color: Colors.black.withOpacity(.7),
                    child: Text(
                      'Death note',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onNotification() {
    print('notification');
  }
}
