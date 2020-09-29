import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_complete_guide/models/http_exception.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _sessionTimer;



String get userId{
  return _userId;
}
  bool get isAuth{
return token!=null;

  }

  String get token{
if(_expiryDate!=null &&_expiryDate.isAfter(DateTime.now()) &&_token!=null){
return _token;

}
return null;

  }

  Future<void> _authenticate(String email, String password,String urlSegment) async{
try{
final response = await http.post(urlSegment,
        body: json.encode(
            {'email': email, 'password': password, 'returnSecureToken': true}));

final responseData=json.decode(response.body);

print(json.decode(response.body));
if(responseData['error']!=null){
throw HttpException(responseData['error']['message']);
}

_token=responseData['idToken'];
_userId=responseData['localId'];
_expiryDate=DateTime.now().add(Duration(seconds:int.parse(responseData['expiresIn'])));
_automaticLogout();
notifyListeners();
final preferences= await SharedPreferences.getInstance();
final userCredentials=json.encode({'token':_token,'userId':_userId,'expiryDate': _expiryDate.toIso8601String()});
preferences.setString('userCredentials',userCredentials);



}catch(err){
throw err;

}
 
  
  }

Future<bool> autoLogin() async{

  final preferences= await SharedPreferences.getInstance();
  if(!preferences.containsKey('userCredentials')){
    return false;
  }
  final credData=json.decode(preferences.getString('userCredentials')) as Map<String,Object>;
  final expiryDate=DateTime.parse(credData['expiryDate']);
  if(expiryDate.isBefore(DateTime.now())){
      return false;
  }
  _token=credData['token'];
  _userId=credData['userId'];
  _expiryDate=expiryDate;
  notifyListeners();
  _automaticLogout();
  return true;
}

  Future<void> signup(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=[API_KEY]';
   return _authenticate(email,  password, url);
   
   }

  Future<void> login(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=[API_KEY]';
    return _authenticate(email,  password, url);

}

Future<void> logout() async {
  _token=null;
  _userId=null;
  _expiryDate=null;
  if(_sessionTimer!=null){
_sessionTimer.cancel();
_sessionTimer=null;
  }
  
  notifyListeners();
  final preferences=await SharedPreferences.getInstance();
  preferences.remove('userCredentials');
}

void _automaticLogout(){
  if(_sessionTimer==null){
 final timerExpiry=_expiryDate.difference(DateTime.now()).inSeconds;
  _sessionTimer=Timer(Duration(seconds:timerExpiry),logout);
  }else{
    _sessionTimer.cancel();
  }
 
}

}
