import 'package:payhere_mobilesdk_flutter/payhere_mobilesdk_flutter.dart';
import '../models/order.dart';

class PaymentService {
  // TODO: Replace with your actual Merchant ID and Secret
  static const String merchantId = '1230986';
  static const String merchantSecret =
      'Mzk0MzkzNzY1OTI3NDI3NzU3MjEwNjU5MDY4MDcxMjU0ODU0MjQ0';

  Future<void> startPayment({
    required Order order,
    required String userEmail,
    required String userName,
    required String userPhone,
    required String userAddress,
    required String userCity,
    required Function(String) onSuccess,
    required Function(String) onError,
    required Function() onDismissed,
  }) async {
    final paymentObject = {
      "sandbox": true, // Set to false for production
      "merchant_id": merchantId,
      "merchant_secret": merchantSecret,
      "notify_url":
          "https://ent13zfbu633b.x.pipedream.net/", // Replace with your backend notify URL
      "order_id": order.orderNumber,
      "items": "Order from DreamyBloom",
      "amount": order.totalAmount,
      "currency": "LKR",
      "first_name": userName,
      "last_name": "",
      "email": userEmail,
      "phone": userPhone,
      "address": userAddress,
      "city": userCity,
      "country": "Sri Lanka",
      "delivery_address": userAddress,
      "delivery_city": userCity,
      "delivery_country": "Sri Lanka",
      "custom_1": "",
      "custom_2": ""
    };

    try {
      PayHere.startPayment(
        paymentObject,
        (paymentId) {
          print("One Time Payment Success. Payment Id: $paymentId");
          onSuccess(paymentId);
        },
        (error) {
          print("One Time Payment Failed. Error: $error");
          onError(error);
        },
        () {
          print("One Time Payment Dismissed");
          onDismissed();
        },
      );
    } catch (e) {
      print("Error starting PayHere payment: $e");
      onError(e.toString());
    }
  }
}
