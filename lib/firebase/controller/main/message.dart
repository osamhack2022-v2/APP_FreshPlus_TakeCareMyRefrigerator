import 'main_ctrl.dart';
import 'general/dto.dart';
import '/firebase/repository/user_repository.dart';

class MessageController {
  late String uid;
  late UserRepository userRepo;
  init() async {
    var user = await getLogInUser();
    uid = user.uid;
    userRepo = UserRepository();
  }

  Future<List<MessageDTO>> getMessages() async {}
}
