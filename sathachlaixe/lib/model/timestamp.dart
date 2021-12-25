class TimeStampModel {
  late int? id;
  late int? create_time;
  late int? sync_time;
  late int? update_time;

  TimeStampModel({
    this.id,
    this.create_time,
    this.update_time,
    this.sync_time,
  });

  void getTimeStamp(Map json) {
    this.id = json["id"];
    this.create_time = json["create_time"];
    this.sync_time = json["sync_time"];
    this.update_time = json["update_time"];
  }

  void addTimeStamp(Map json) {
    json["id"] = id;
    json["create_time"] = create_time;
    json["sync_time"] = sync_time;
    json["update_time"] = update_time;
  }

  DateTime? get createTime => this.create_time == null
      ? null
      : DateTime.fromMillisecondsSinceEpoch(this.create_time!, isUtc: true)
          .toLocal();
  DateTime? get updateTime => this.update_time == null
      ? null
      : DateTime.fromMillisecondsSinceEpoch(this.update_time!, isUtc: true)
          .toLocal();
  DateTime? get syncTime => this.sync_time == null
      ? null
      : DateTime.fromMillisecondsSinceEpoch(this.sync_time!, isUtc: true)
          .toLocal();
}
