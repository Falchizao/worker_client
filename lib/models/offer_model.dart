import 'package:scarlet_graph/models/user_model.dart';

class Offer {
  final String salary;
  final String createdDate;
  final String content;
  final String employer;
  final String title;

  Offer(
      {required this.salary,
      required this.createdDate,
      required this.content,
      required this.employer,
      required this.title});
}
