class SettingModel {
  int? status;
  Data? data;

  SettingModel({this.status, this.data});

  SettingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  int? id;
  String? logo;
  String? footerLogo;
  String? adImage;
  String? facebook;
  String? siteNameAr;
  String? siteNameEn;
  String? siteDesAr;
  String? siteDesEn;
  String? email;
  String? twitter;
  String? googlePlus;
  String? youtube;
  String? whatsapp;
  String? iosLink;
  String? androidLink;
  String? instagram;
  String? telegram;
  String? phone;
  int? internationalShipping;
  int? internationalShipping2;
  int? isFreeShop;
  String? activeDeleteAccount;
  int? isTabbyActive;
  String? leftAdImage;
  String? leftAdTitleAr;
  String? leftAdTitleEn;
  String? leftAdDetailsAr;
  String? leftAdDetailsEn;
  String? leftAdLinkType;
  String? leftAdLinkReference;
  String? rightAdImage;
  String? rightAdTitleAr;
  String? rightAdTitleEn;
  String? rightAdDetailsAr;
  String? rightAdDetailsEn;
  String? rightAdLinkType;
  String? rightAdLinkReference;

  Data({
    this.id,
    this.logo,
    this.footerLogo,
    this.adImage,
    this.facebook,
    this.siteNameAr,
    this.siteNameEn,
    this.siteDesAr,
    this.siteDesEn,
    this.email,
    this.twitter,
    this.googlePlus,
    this.youtube,
    this.whatsapp,
    this.iosLink,
    this.androidLink,
    this.instagram,
    this.telegram,
    this.phone,
    this.internationalShipping,
    this.internationalShipping2,
    this.isFreeShop,
    this.activeDeleteAccount,
    this.isTabbyActive,
    this.leftAdImage,
    this.leftAdTitleAr,
    this.leftAdTitleEn,
    this.leftAdDetailsAr,
    this.leftAdDetailsEn,
    this.leftAdLinkType,
    this.leftAdLinkReference,
    this.rightAdImage,
    this.rightAdTitleAr,
    this.rightAdTitleEn,
    this.rightAdDetailsAr,
    this.rightAdDetailsEn,
    this.rightAdLinkType,
    this.rightAdLinkReference,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    logo = json['logo'];
    footerLogo = json['footer_logo'];
    adImage = json['ad_image'];
    facebook = json['facebook'];
    siteNameAr = json['site_name_ar'];
    siteNameEn = json['site_name_en'];
    siteDesAr = json['site_des_ar'];
    siteDesEn = json['site_des_en'];
    email = json['email'];
    twitter = json['twitter'];
    googlePlus = json['google_plus'];
    youtube = json['youtube'];
    whatsapp = json['whatsapp'];
    iosLink = json['ios_link'];
    androidLink = json['android_link'];
    instagram = json['instagram'];
    telegram = json['telegram'];
    phone = json['phone'];
    internationalShipping = json['international_shipping'];
    internationalShipping2 = json['international_shipping_2'];
    isFreeShop = json['is_free_shop'];
    activeDeleteAccount = json['active_delete_acount'];
    isTabbyActive = json['is_tabby_active'];
    leftAdImage = json['left_ad_image'];
    leftAdTitleAr = json['left_ad_title_ar'];
    leftAdTitleEn = json['left_ad_title_en'];
    leftAdDetailsAr = json['left_ad_details_ar'];
    leftAdDetailsEn = json['left_ad_details_en'];
    leftAdLinkType = json['left_ad_link_type'];
    leftAdLinkReference = json['left_ad_link_reference'];
    rightAdImage = json['right_ad_image'];
    rightAdTitleAr = json['right_ad_title_ar'];
    rightAdTitleEn = json['right_ad_title_en'];
    rightAdDetailsAr = json['right_ad_details_ar'];
    rightAdDetailsEn = json['right_ad_details_en'];
    rightAdLinkType = json['right_ad_link_type'];
    rightAdLinkReference = json['right_ad_link_reference'];
  }
}
