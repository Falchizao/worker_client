class Offer {
  final int id;
  final double salary;
  final String createdDate;
  final String content;
  final String employer;
  final String title;
  final double hours;
  final String location;
  final String requirements;
  final bool remote;

  Offer(
      {required this.id,
      required this.salary,
      required this.createdDate,
      required this.content,
      required this.employer,
      required this.title,
      required this.hours,
      required this.location,
      required this.requirements,
      required this.remote});

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
        id: json['id'],
        salary: json['salary'],
        createdDate: json['createdDate'],
        content: json['content'],
        title: json['title'],
        hours: json['hours'],
        employer: json['employer'],
        location: json['location'],
        requirements: json['requirements'],
        remote: json['remote']);
  }
}
