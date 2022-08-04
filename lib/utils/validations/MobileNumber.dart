import 'package:formz/formz.dart';

enum MobileNumberValidationError { invalid }

class MobileNumber extends FormzInput<String, MobileNumberValidationError> {
  const MobileNumber.pure([String value = '']) : super.pure(value);
  const MobileNumber.dirty([String value = '']) : super.dirty(value);



  static final _mobileRegex = RegExp(
    r'(^(?:[+0])?[0-9]{8,12}$)',
  );

  @override
  MobileNumberValidationError? validator(String? value) {
    return _mobileRegex.hasMatch(value ?? '')
        ? null
        : MobileNumberValidationError.invalid;
  }
}
