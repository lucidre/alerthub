enum AccountType { user, healthcare, ambulance }

final accountTypes = [
  AccountType.user,
  AccountType.healthcare,
  // AccountType.ambulance,
];

extension AccountTypeExtensions on AccountType {
  String get dropDownName {
    if (this == AccountType.user) {
      return 'User';
    } else if (this == AccountType.healthcare) {
      return 'Healthcare';
    } else {
      return 'Not Defined';
    }
  }
}
