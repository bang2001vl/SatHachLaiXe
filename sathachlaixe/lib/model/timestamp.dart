class TimeStampModel {
  late int? id;
  late DateTime? create_time;
  late DateTime? sync_time;
  int? accountID;

  TimeStampModel(
      {this.id = null,
      this.create_time = null,
      this.sync_time = null,
      this.accountID = null}) ;
}
