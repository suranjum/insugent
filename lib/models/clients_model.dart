class Client {
  String clientId;
  String clientName;
  String clientAddress;
  String clientMobile;
  String clientEmail;
  String clientRemarks;
  String clientInActive;
  String clientModified;

  Client(
      this.clientId,
      this.clientName,
      this.clientAddress,
      this.clientMobile,
      this.clientEmail,
      this.clientRemarks,
      this.clientInActive,
      this.clientModified);

  Client.fromJson(Map<String, dynamic> json)
      : clientId = json['client_id'],
        clientName = json['client_name'],
        clientAddress = json['client_address'],
        clientMobile = json['client_mobile'],
        clientEmail = json['client_email'],
        clientRemarks = json['clientremarks'],
        clientInActive = json['client_inactive'],
        clientModified = json['client_modified'];
}
