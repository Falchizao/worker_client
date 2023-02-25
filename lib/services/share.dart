import 'package:scarlet_graph/utils/handler.dart';
import 'package:url_launcher/url_launcher.dart';

void shareViaWhatsApp(final String msg) async {
  final url = 'whatsapp://send?text=$msg%2C%20World!';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    handleToast('Could not launch $url');
  }
}
