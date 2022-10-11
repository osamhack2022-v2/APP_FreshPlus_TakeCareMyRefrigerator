import 'package:helloworld/firebase/controller/ctrl_exception.dart';
import '/firebase/repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as FireAuth;

//UserDTO로 변경 요구
Future<User> getLogInUser() async {
  if(FireAuth.FirebaseAuth.instance.currentUser==null) throw CtrlException('no-login');
  try{
    var uid = FireAuth.FirebaseAuth.instance.currentUser!.uid;
    var user = await UserRepository().getUser(uid);
    return user;
  } on UserRepositoryException catch(e){
    throw CtrlException('no-user');
  }
}