class PaymentModel {
  String? key;
  String refNo;
  String method;
  String type;
  String description;
  double value;
  String currency;
  String createdAt;
  String? updatedAt;
  String? timestamp;
  String userId;
  String userIdPackage;
  dynamic dataUser;
  String? response;

  PaymentModel({
    this.key,
    required this.refNo,
    required this.value,
    required this.currency,
    required this.method, // payment type
    required this.type, // package type
    required this.description,
    required this.createdAt,
    required this.userId,
    required this.userIdPackage,
    required this.timestamp,
    this.updatedAt,
    this.dataUser,
    this.response,
  });

  factory PaymentModel.fromJson(Map<dynamic, dynamic> json) => PaymentModel(
        key: json["id_payment_package"],
        refNo: json["ref_no"],
        userId: json["id_user"],
        userIdPackage: json["id_user_package"],
        method: json["code_method"],
        type: json["code_package"],
        description: json["description"],
        value: json["price"] != null
            ? double.parse(json["price"].toString())
            : 0.0,
        currency: json["currency"],
        timestamp: json["date_payment"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        dataUser: json["user"],
        response: json["response_api"],
      );

  Map<String, dynamic> toJson() => {
        "id_payment_package": key,
        "ref_no": refNo,
        "id_user": userId,
        "id_user_package": userIdPackage,
        "code_method": method,
        "code_package": type,
        "description": description,
        "price": value,
        "date_payment": timestamp,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "user": dataUser,
        "response_api": response
      };
}
