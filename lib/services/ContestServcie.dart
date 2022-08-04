import 'package:qq/models/Contestdata.dart';


class ContestService{

  Contestdata _contestdata = new Contestdata("", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "");
  late String _walletAmount;
  late String _totalTicket;
  late bool _userBooked;
  late bool _isparticipated;

  setContestdata(Contestdata contestdata ,  String walletAmount , String totalTicket ,bool userBooked,bool participated) {
    _contestdata = contestdata;
    _walletAmount = walletAmount;
    _totalTicket = totalTicket;
    _userBooked = userBooked;
    _isparticipated = participated;
  }

  Contestdata? get contestdata => _contestdata;
  String get walletAmount => _walletAmount;
  String get totalTicket => _totalTicket;
  bool get userBooked => _userBooked;
  bool get participated => _isparticipated;
}