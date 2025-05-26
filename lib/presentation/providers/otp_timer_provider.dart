import 'package:hooks_riverpod/hooks_riverpod.dart';

final otpTimerProvider = NotifierProvider<OtpTimerNotifier , bool>(OtpTimerNotifier.new);

class OtpTimerNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void updateProgressValue(bool progressValue) => (state = progressValue);
}