import 'package:url_launcher/url_launcher.dart';

class ApplicationUrlService {
  static void launchWhatsApp({String phone, String message}) async {
    String url() {
      return "whatsapp://send?phone=$phone";
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
  }

  static void launchPhone({String phoneNumber}) async {
    String url() {
      return "tel:$phoneNumber";
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
  }
}
