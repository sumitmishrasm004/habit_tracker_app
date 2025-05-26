import 'package:hooks_riverpod/hooks_riverpod.dart';

final verificationIdProvider = NotifierProvider<VerificationIdNotifier, String>(VerificationIdNotifier.new);

class VerificationIdNotifier extends Notifier<String> {
  @override
  String build() => '';

  void updateVerificationIdValue(String verificationId) => (state = verificationId);
}