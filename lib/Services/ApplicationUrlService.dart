import 'package:url_launcher/url_launcher.dart';

class ApplicationUrlService {
  static void launchWhatsApp() async {
    String url() {
      return "whatsapp://send?phone=+919477014134";
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
  }

  static void launchPhone() async {
    String url() {
      return "tel:+919477014134";
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
  }
}
