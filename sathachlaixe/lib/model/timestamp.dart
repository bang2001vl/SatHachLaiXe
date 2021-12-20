class TimeStampModel {
  late int? id;
  late DateTime? create_time;
  late DateTime? sync_time;
  late DateTime? update_time;

  TimeStampModel({
    this.id = null,
    this.create_time = null,
    this.update_time = null,
    this.sync_time = null,
  });

  void getTimeStamp(Map json) {
    this.id = json["id"] == null ? null : json["id"];
    this.create_time = json["create_time"] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(json["create_time"], isUtc: true)
            .toLocal();
    this.sync_time = json["sync_time"] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(json["sync_time"], isUtc: true)
            .toLocal();
    this.update_time = json["update_time"] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(json["update_time"], isUtc: true)
            .toLocal();
  }

  void addTimeStamp(Map json) {
    json["id"] = id;
    json["create_time"] = create_time;
    json["sync_time"] = sync_time;
    json["update_time"] = update_time;
  }
}
