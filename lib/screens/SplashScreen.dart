import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
static const routeName = '/splash';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(108, 149, 213, 3),
      body: Center(
        child: Column(
          children: <Widget>[
            Image.asset(
                    'images/logo_flowerz.JPG',
                    fit: BoxFit.cover,
                  ),
            Divider(color: Colors.white,thickness: 3,),
            Text('Loading...',style: TextStyle(fontSize: 20,fontStyle: FontStyle.italic

            ),),
          ],
        ),
      ),
    );
  }
}
