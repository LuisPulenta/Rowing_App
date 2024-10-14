class User2 {
  String? document;
  String? firstName;
  String? lastName;
  int? userType;
  String? codigo;
  String? grupo;
  String? fullName;
  String? fullNameWithDocument;
  String? id;
  String? userName;
  String? normalizedUserName;
  String? email;
  String? normalizedEmail;
  bool? emailConfirmed;
  String? passwordHash;
  String? securityStamp;
  String? concurrencyStamp;
  String? phoneNumber;
  bool? phoneNumberConfirmed;
  bool? twoFactorEnabled;
  bool? lockoutEnd;
  bool? lockoutEnabled;
  int? accessFailedCount;
  int? nroCausante;
  String? lastLogin;
  String? changePassword;

  User2(
      {this.document,
      this.firstName,
      this.lastName,
      this.userType,
      this.codigo,
      this.grupo,
      this.fullName,
      this.fullNameWithDocument,
      this.id,
      this.userName,
      this.normalizedUserName,
      this.email,
      this.normalizedEmail,
      this.emailConfirmed,
      this.passwordHash,
      this.securityStamp,
      this.concurrencyStamp,
      this.phoneNumber,
      this.phoneNumberConfirmed,
      this.twoFactorEnabled,
      this.lockoutEnd,
      this.lockoutEnabled,
      this.accessFailedCount,
      this.nroCausante,
      this.lastLogin,
      this.changePassword});

  User2.fromJson(Map<String, dynamic> json) {
    document = json['document'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    userType = json['userType'];
    codigo = json['codigo'];
    grupo = json['grupo'];
    fullName = json['fullName'];
    fullNameWithDocument = json['fullNameWithDocument'];
    id = json['id'];
    userName = json['userName'];
    normalizedUserName = json['normalizedUserName'];
    email = json['email'];
    normalizedEmail = json['normalizedEmail'];
    emailConfirmed = json['emailConfirmed'];
    passwordHash = json['passwordHash'];
    securityStamp = json['securityStamp'];
    concurrencyStamp = json['concurrencyStamp'];
    phoneNumber = json['phoneNumber'];
    phoneNumberConfirmed = json['phoneNumberConfirmed'];
    twoFactorEnabled = json['twoFactorEnabled'];
    lockoutEnd = json['lockoutEnd'];
    lockoutEnabled = json['lockoutEnabled'];
    accessFailedCount = json['accessFailedCount'];
    nroCausante = json['nroCausante'];
    lastLogin = json['lastLogin'];
    changePassword = json['changePassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['document'] = document;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['userType'] = userType;
    data['codigo'] = codigo;
    data['grupo'] = grupo;
    data['fullName'] = fullName;
    data['fullNameWithDocument'] = fullNameWithDocument;
    data['id'] = id;
    data['userName'] = userName;
    data['normalizedUserName'] = normalizedUserName;
    data['email'] = email;
    data['normalizedEmail'] = normalizedEmail;
    data['emailConfirmed'] = emailConfirmed;
    data['passwordHash'] = passwordHash;
    data['securityStamp'] = securityStamp;
    data['concurrencyStamp'] = concurrencyStamp;
    data['phoneNumber'] = phoneNumber;
    data['phoneNumberConfirmed'] = phoneNumberConfirmed;
    data['twoFactorEnabled'] = twoFactorEnabled;
    data['lockoutEnd'] = lockoutEnd;
    data['lockoutEnabled'] = lockoutEnabled;
    data['accessFailedCount'] = accessFailedCount;
    data['nroCausante'] = nroCausante;
    data['lastLogin'] = lastLogin;
    data['changePassword'] = changePassword;
    return data;
  }
}
