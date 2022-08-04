import 'package:formz/formz.dart';

enum AmountMoneyValidationError { invalid }

class AmountMoney extends FormzInput<String, AmountMoneyValidationError> {
  const AmountMoney.pure([String value = '']) : super.pure(value);
  const AmountMoney.dirty([String value = '']) : super.dirty(value);



  @override
  AmountMoneyValidationError? validator(String? value) {
    return value!.isNotEmpty
        ? null
        : AmountMoneyValidationError.invalid;
  }
}
