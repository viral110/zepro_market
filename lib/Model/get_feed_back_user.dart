class GetFeedBack {
  List<Feebback> feebback;
  bool status;
  String url;

  GetFeedBack({this.feebback, this.status, this.url});

  GetFeedBack.fromJson(Map<String, dynamic> json) {
    if (json['feebback'] != null) {
      feebback = <Feebback>[];
      json['feebback'].forEach((v) {
        feebback.add(new Feebback.fromJson(v));
      });
    }
    status = json['status'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.feebback != null) {
      data['feebback'] = this.feebback.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['url'] = this.url;
    return data;
  }
}

class Feebback {
  String feedback;
  String feedbackDate;
  String feedbackId;
  List<dynamic> feedbackImages;

  Feebback(
      {this.feedback, this.feedbackDate, this.feedbackId, this.feedbackImages});

  Feebback.fromJson(Map<String, dynamic> json) {
    feedback = json['feedback'];
    feedbackDate = json['feedback_date'];
    feedbackId = json['feedback_id'];
    feedbackImages = json['feedback_images'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['feedback'] = this.feedback;
    data['feedback_date'] = this.feedbackDate;
    data['feedback_id'] = this.feedbackId;
    data['feedback_images'] = this.feedbackImages;
    return data;
  }
}
