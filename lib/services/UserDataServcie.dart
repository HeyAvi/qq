import 'package:qq/models/Userdata.dart';

class UserDataService{

  late Userdata _userdata;
  late String _walletAmount;
  late String _totalTickets;
  late String _totalParticipation;

  setUserdata(Userdata userdata,String wallet_amount,String totalTickets,String totalParticipation) {
    _userdata = userdata;
    _walletAmount = wallet_amount;
    _totalTickets = totalTickets;
    _totalParticipation = totalParticipation;
  }

  Userdata get userData => _userdata;
  String get walletAmount => _walletAmount;
  String get totalTickets => _totalTickets;
  String get totalParticipation => _totalParticipation;
}