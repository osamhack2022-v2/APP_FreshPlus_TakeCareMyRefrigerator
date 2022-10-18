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

  Future<List<MessageDTO>> getMessages() async {
    var unread = await userRepo.getUnreadMessage(uid);
    var read = await userRepo.getReadMessage(uid);
    List<MessageDTO> unreadDTO = unread.map((value) {
      return MessageDTO(value, false);
    }).toList();
    List<MessageDTO> readDTO = read.map((value) {
      return MessageDTO(value, true);
    }).toList();
    unreadDTO.addAll(readDTO);
    return unreadDTO;
  }
}
