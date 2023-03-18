import 'package:scarlet_graph/models/user_model.dart';

class Offer {
  String salary;
  DateTime createdDate;
  String content;
  User employer;

  Offer(this.salary, this.createdDate, this.content, this.employer);
}
