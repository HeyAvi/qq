import 'package:qq/models/Contestdata.dart';

class ContestService {
  Contestdata _contestdata = Contestdata(
      "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "");
  String? _walletAmount;
  String? _totalTicket;
  bool? _userBooked;
  bool? _isparticipated;

  setContestdata(Contestdata contestdata, String walletAmount,
      String totalTicket, bool userBooked, bool participated) {
    _contestdata = contestdata;
    _walletAmount = walletAmount;
    _totalTicket = totalTicket;
    _userBooked = userBooked;
    _isparticipated = participated;
  }

  Contestdata? get contestdata => _contestdata;

  String get walletAmount => _walletAmount ?? '0';

  String get totalTicket => _totalTicket ?? '';

  bool get userBooked => _userBooked ?? false;

  bool get participated => _isparticipated ?? false; // todo crash here
}

class ContestExampleService {
  Contestdata _contestdata = Contestdata(
      "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "");
  String? _walletAmount;
  String? _totalTicket;
  bool? _userBooked;
  bool? _isparticipated;

  setContestExample(Contestdata contestdata, String walletAmount,
      String totalTicket, bool userBooked, bool participated) {
    _contestdata = contestdata;
    _walletAmount = walletAmount;
    _totalTicket = totalTicket;
    _userBooked = userBooked;
    _isparticipated = participated;
  }

  Contestdata? get contestdata => _contestdata;

  String get walletAmount => _walletAmount ?? '0';

  String get totalTicket => _totalTicket ?? '';

  bool get userBooked => _userBooked ?? false;

  bool get participated => _isparticipated ?? false; // todo crash here
}
