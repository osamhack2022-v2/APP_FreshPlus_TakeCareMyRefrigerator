import '/firebase/controller/ctrl_exception.dart';
import '/firebase/repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as FireAuth;
import 'general/dto.dart';

//UserDTO로 변경 요구
Future<UserDTO> getLogInUser() async {
  if (FireAuth.FirebaseAuth.instance.currentUser == null)
    throw CtrlException('no-login');
  try {
    var uid = FireAuth.FirebaseAuth.instance.currentUser!.uid;
    var user = await UserRepository().getUser(uid);
    String userType = "user";
    switch (user.type) {
      case (UserType.master):
        userType = "master";
        break;
      case (UserType.manager):
        userType = "manager";
        break;
      default:
        userType = "user";
        break;
    }
    return UserDTO(uid, user.userName, user.unitID, user.fridgeID, userType);
  } on UserRepositoryException catch (e) {
    throw CtrlException('no-user');
  }
}
