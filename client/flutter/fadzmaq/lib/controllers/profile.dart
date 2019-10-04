import 'package:fadzmaq/models/profile.dart';

String getProfileField(ProfileData pd, String field) {
  if (pd == null) return null;
  if (pd.profileFields == null) return null;
  for (ProfileField pf in pd.profileFields) {
    if (pf.name == field) {
      return pf.displayValue;
    }
  }
  return null;
}
