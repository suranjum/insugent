class InsuranceBrand {
  String brandCode;
  String brandName;

  InsuranceBrand(this.brandCode, this.brandName);

  InsuranceBrand.fromJson(Map<String, dynamic> json)
      : brandCode = json['brandcode'],
        brandName = json['brandname'];
}
