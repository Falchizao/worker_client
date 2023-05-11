import '../models/offer_model.dart';
import '../utils/constants.dart';
import '../utils/handler.dart';
import '../utils/requests.dart';
import 'jwtservice.dart';
import "package:http/http.dart" as http;

void deleteJobOffer(final Offer offer) async {
  var token = await JwtService().getToken();
  var response = await http.delete(
    Uri.parse('$BASE_URL/$OFFER/${offer.id}'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
  );

  if (response.statusCode == 204) {
    handleToast("Offer deleted with success!");
  } else {
    handleToast("Erro while trying to remove offer!");
  }
}
