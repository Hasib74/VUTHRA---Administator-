import 'package:mailer/mailer.dart';
import 'package:http/http.dart' as http;
import 'package:mailer/smtp_server/gmail.dart';

Future<bool> sendMasterCode(number, code, email) async {
  bool status = false;
  String username = 'hasibakon6174@gmail.com';
  String password = 'haibakonjoy';

  final smtpServer = gmail(username, password);
  // Use the SmtpServer class to configure an SMTP server:
  // final smtpServer = SmtpServer('smtp.domain.com');
  // See the named arguments of SmtpServer for further configuration
  // options.

  // Create our message.
  final message = Message()
    ..from = Address(username, 'Hasib Akon')
    ..recipients.add('${email}')
    //  ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
    //..bccRecipients.add(Address('bccAddress@example.com'))
    ..subject = 'Vutha App'
    ..text = 'Master Code  : ${code}';
  // ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";

  await send(message, smtpServer).then((value) {
    status = true;

    print("Email ==> ${value.mail} ");
  }).catchError((e) {
    print("Email ==>    Error is  ${e}");

    status = false;
  });

  return status;
}
