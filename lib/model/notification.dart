class Notification {
  bool? isViewed;
  bool? isDeleted;
  String? customerId;
  String? title;
  String? description;
  String? date;
  String? id;

  Notification(
      {this.isViewed,
      this.isDeleted,
      this.customerId,
      this.title,
      this.description,
      this.date,
      this.id});

  Notification.fromJson(Map<String, dynamic> json) {
    isViewed = json['isViewed'];
    isDeleted = json['isDeleted'];
    customerId = json['customerId'];
    title = json['title'];
    description = json['description'];
    date = json['date'];
    id = json['id'];
  }
}
