import 'package:firebase_database/firebase_database.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:vutha_admin_app/src/Utils/Common.dart';

class HomePageController {
  
  HomePageController(){
    
  }
  
  
  suspendAccount(user_number){
    
    FirebaseDatabase.instance.reference().child(Common.User).child(user_number).child("master_code").remove();
    
  }
  
}
