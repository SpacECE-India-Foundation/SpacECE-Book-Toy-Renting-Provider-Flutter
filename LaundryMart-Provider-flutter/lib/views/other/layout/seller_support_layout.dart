import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laundry_seller/config/theme.dart';
import 'package:laundry_seller/controllers/other/seller_support_controller.dart';

class SellerSupportLayout extends StatelessWidget {
  const SellerSupportLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seller Support'),
      ),
      body: Consumer(builder: (context, ref, child) {
        final asyncValue = ref.watch(sellerSupportControllerProvider);
        return asyncValue.when(data: (data) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                Html(
                  style: {
                    '*': Style(
                        fontSize: FontSize(14.sp),
                        color: colors(context).bodyTextColor)
                  },
                  data: data.setting.content,
                ),
              ],
            ),
          );
        }, error: (error, stackTrace) {
          return Text('Error: $error');
        }, loading: () {
          return const Center(child: CircularProgressIndicator());
        });
      }),
    );
  }
}
