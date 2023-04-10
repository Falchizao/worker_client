class Offer {
  final int id;
  final double salary;
  final String createdDate;
  final String content;
  final String employer;
  final String title;
  final double hours;

  Offer(
      {required this.id,
      required this.salary,
      required this.createdDate,
      required this.content,
      required this.employer,
      required this.title,
      required this.hours});

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
        id: json['id'],
        salary: json['salary'],
        createdDate: json['createdDate'],
        content: json['content'],
        title: json['title'],
        hours: json['hours'],
        employer: json['employer']);
  }
}
