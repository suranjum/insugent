class InsuranceBrand {
  String brandId;
  String brandName;

  InsuranceBrand(this.brandId, this.brandName);

  InsuranceBrand.fromJson(Map<String, dynamic> json)
      : brandId = json['brand_id'],
        brandName = json['brand_name'];
}
