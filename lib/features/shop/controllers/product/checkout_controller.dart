import 'package:ecommerce_app/common/widgets/list_tiles/payment_tile.dart';
import 'package:ecommerce_app/common/widgets/text/section_heading.dart';
import 'package:ecommerce_app/features/shop/models/payment_method_model.dart';
import 'package:ecommerce_app/util/constants/image_strings.dart';
import 'package:ecommerce_app/util/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutController extends GetxController {
  static CheckoutController get instance => Get.find();

  final Rx<PaymentMethodModel> selectedPaymentMethod =
      PaymentMethodModel.empty().obs;

  @override
  void onInit() {
    selectedPaymentMethod.value =
        PaymentMethodModel(image: EImages.paypal, name: 'Paypal');
    super.onInit();
  }

  Future<dynamic> selectPaymentMethod(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (_) => SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(ESizes.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ESectionHeading(
                title: 'Select Payment Method',
                showActionButton: false,
              ),
              const SizedBox(
                height: ESizes.spaceBtSections,
              ),
              EPaymentTile(
                paymentMethod:
                    PaymentMethodModel(image: EImages.paypal, name: 'Paypal'),
              ),
              const SizedBox(
                height: ESizes.spaceBtItems / 2,
              ),
              EPaymentTile(
                paymentMethod: PaymentMethodModel(
                    image: EImages.masterCard, name: 'Master Card'),
              ),
              const SizedBox(
                height: ESizes.spaceBtItems / 2,
              ),
              EPaymentTile(
                paymentMethod:
                    PaymentMethodModel(image: EImages.visa, name: 'Visa'),
              ),
              const SizedBox(
                height: ESizes.spaceBtItems / 2,
              ),
              EPaymentTile(
                paymentMethod: PaymentMethodModel(
                    image: EImages.paystack, name: 'Pay Stack'),
              ),
              const SizedBox(
                height: ESizes.spaceBtItems / 2,
              ),
              EPaymentTile(
                paymentMethod: PaymentMethodModel(
                    image: EImages.applePay, name: 'Apple Pay'),
              ),
              const SizedBox(
                height: ESizes.spaceBtItems / 2,
              ),
              EPaymentTile(
                paymentMethod: PaymentMethodModel(
                    image: EImages.googlePay, name: 'Google Pay'),
              ),
              const SizedBox(
                height: ESizes.spaceBtItems / 2,
              ),
              EPaymentTile(
                paymentMethod: PaymentMethodModel(
                    image: EImages.creditCard, name: 'Credit Card'),
              ),
              const SizedBox(
                height: ESizes.spaceBtItems / 2,
              ),
              EPaymentTile(
                paymentMethod:
                    PaymentMethodModel(image: EImages.paytm, name: 'Paytm'),
              ),
              const SizedBox(
                height: ESizes.spaceBtItems / 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
