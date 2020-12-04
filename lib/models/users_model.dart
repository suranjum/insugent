class User {
  String userId;
  String userMobile;
  String userEmail;
  String userFullName;
  String userAddress;
  String userImage;
  String userProfile;
  String userInActive;
  String userExpireDate;
  String userModified;
  String userPassword;

  User(
      this.userId,
      this.userMobile,
      this.userEmail,
      this.userFullName,
      this.userAddress,
      this.userImage,
      this.userProfile,
      this.userInActive,
      this.userExpireDate,
      this.userModified,
      this.userPassword);

  User.fromJson(Map<String, dynamic> json)
      : userId = json['userid'],
        userMobile = json['usermobile'],
        userEmail = json['useremail'],
        userFullName = json['userfullname'],
        userAddress = json['useraddress'],
        userImage = json['userimage'],
        userProfile = json['userprofile'],
        userInActive = json['userinactive'],
        userExpireDate = json['userexpiredate'],
        userPassword = json['userpassword'];
}
