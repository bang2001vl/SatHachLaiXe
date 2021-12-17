class TimeStampModel {
  late int? id;
  late DateTime? create_time;
  late DateTime? update_time;
  int? accountID;

  TimeStampModel(
      {this.id = null,
      this.create_time = null,
      this.update_time = null,
      this.accountID = null}) {}

  TimeStampModel.fromJSON(json) {
    this.id = json["id"] == null ? null : json["id"];
    this.create_time = json["create_time"] == null ? null : json["create_time"];
    this.update_time = json["update_time"] == null ? null : json["update_time"];
    this.accountID = json["accountID"] == null ? null : json["accountID"];
  }
}
