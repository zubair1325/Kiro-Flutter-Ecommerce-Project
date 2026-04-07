import 'package:ecommerce/presentation/ui/screens/menu/login_state.dart';
import 'package:ecommerce/presentation/ui/utility/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';

class TermsConditions extends StatelessWidget {
  const TermsConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(onPressed: ()=>Get.offAll(LoginState()), icon: Icon(Icons.arrow_back_ios),),
        title: const Text("B2B Terms & Conditions",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 25),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _TermsSection(
              title: "1. AGREEMENT",
              content:
                  "This agreement is between the seller ('Seller') and the business entity ('Buyer') registered on this platform. Use of this platform constitutes a legally binding contract. This platform is not intended for individual consumer use.",
            ),

            _TermsSection(
              title: "2. ELIGIBILITY & REGISTRATION",
              content:
                  "Buyer represents that they are a validly existing business entity and that the person creating the account has the legal authority to bind said entity. Seller reserves the right to request business registration documents, tax IDs (VAT/GST), and credit references before fulfilling any orders.",
            ),

            _TermsSection(
              title: "3. PRICING & TAXATION",
              content:
                  "Unless explicitly stated otherwise, all prices are quoted NET of Value Added Tax (VAT), Goods and Services Tax (GST), and any other applicable duties or levies. Buyer is responsible for all taxes arising from the purchase. Prices are subject to change without notice due to market fluctuations or supply chain costs.",
            ),

            _TermsSection(
              title: "4. PAYMENT & CREDIT TERMS",
              content:
                  "Standard payment is required at the time of order via corporate credit card or bank transfer. Buyers with an approved credit line must adhere to 'Net-30' terms (payment due 30 days from invoice date). Late payments shall accrue interest at a rate of 1.5% per month or the maximum rate permitted by law.",
            ),

            _TermsSection(
              title: "5. SHIPPING & RISK OF LOSS",
              content:
                  "Delivery is typically Ex-Works (EXW) or FOB Shipping Point. This means the Risk of Loss and legal title transfer to the Buyer as soon as the goods are handed over to the carrier. Seller is not liable for delays caused by customs, port congestion, or force majeure events.",
            ),

            _TermsSection(
              title: "6. INSPECTION & DEFECTS",
              content:
                  "Buyer must inspect all goods within three (3) business days of delivery. Claims for shortages or visible defects must be submitted in writing within this period. Failure to notify the Seller within this window constitutes an irrevocable acceptance of the goods.",
            ),

            _TermsSection(
              title: "7. CANCELLATIONS & RETURNS",
              content:
                  "B2B orders are generally non-cancellable once processing begins. Returns are only accepted for manufacturing defects. A 20% restocking fee may apply to any authorized returns of non-defective stock items. Custom-manufactured or 'Special Order' items are strictly non-returnable.",
            ),

            _TermsSection(
              title: "8. LIMITATION OF LIABILITY",
              content:
                  "In no event shall the Seller be liable for any indirect, incidental, or consequential damages, including loss of profits or business interruption. Seller's maximum liability for any claim shall not exceed the total purchase price of the specific order in question.",
            ),

            _TermsSection(
              title: "9. GOVERNING LAW",
              content:
                  "This agreement shall be governed by and construed in accordance with the laws of your jurisdiction. Any disputes shall be resolved exclusively in the courts of your location.",
            ),

            SizedBox(height: 40),

            Center(
              child: Text(
                "By proceeding, you acknowledge you have read and agree to these terms on behalf of your business entity.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _TermsSection extends StatelessWidget {
  final String title;
  final String content;

  const _TermsSection({
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}