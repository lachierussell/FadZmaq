class AccountSettings {
  final int distanceSetting;

  AccountSettings({
    this.distanceSetting,
  });

  factory AccountSettings.fromJson(Map<String, dynamic> json) =>
      _fromJson(json);
}

AccountSettings _fromJson(Map<String, dynamic> json) {
  return AccountSettings(
    distanceSetting: json['distance_setting'],
  );
}
