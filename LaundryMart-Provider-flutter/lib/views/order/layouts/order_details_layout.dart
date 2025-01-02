import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:laundry_seller/components/confirmation_dialog.dart';
import 'package:laundry_seller/components/custom_button.dart';
import 'package:laundry_seller/config/app_color.dart';
import 'package:laundry_seller/config/app_text_style.dart';
import 'package:laundry_seller/config/theme.dart';
import 'package:laundry_seller/controllers/authentication/authentication_controller.dart';
import 'package:laundry_seller/controllers/order/order_controller.dart';
import 'package:laundry_seller/gen/assets.gen.dart';
import 'package:laundry_seller/generated/l10n.dart';
import 'package:laundry_seller/models/order/order.dart';
import 'package:laundry_seller/models/order/order_details.dart';
import 'package:laundry_seller/routes.dart';
import 'package:laundry_seller/utils/context_less_navigation.dart';
import 'package:laundry_seller/utils/global_function.dart';
import 'package:laundry_seller/views/order/components/order_status_card.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class OrderDetailsLayout extends ConsumerStatefulWidget {
  final Order order;
  const OrderDetailsLayout({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  ConsumerState<OrderDetailsLayout> createState() => _OrderDetailsLayoutState();
}

class _OrderDetailsLayoutState extends ConsumerState<OrderDetailsLayout> {
  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).scaffoldBackgroundColor == AppColor.blackColor;
    return Scaffold(
      backgroundColor: isDark ? AppColor.blackColor : AppColor.offWhiteColor,
      appBar: AppBar(
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(S.of(context).orderDetails),
        toolbarHeight: 70.h,
        actions: [
          ref.watch(orderDetailsController).maybeWhen(
            orElse: () {
              return const Text('No Data available');
            },
            data: (details) {
              return Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 22.h).copyWith(right: 20.w),
                child: OrderStatusCard(
                  orderStatus: details.orderStatus,
                ),
              );
            },
            loading: () {
              return const SizedBox();
            },
          )
        ],
      ),
      bottomNavigationBar:
          ref.watch(orderDetailsController).maybeWhen(data: (details) {
        return _buildBottomWidget(context, details);
      }, loading: () {
        return const SizedBox();
      }, orElse: () {
        return const Text('No Data available');
      }),
      body: Consumer(builder: (context, ref, child) {
        final asyncValue = ref.watch(orderDetailsController);

        return asyncValue.when(data: (orderDetails) {
          return SingleChildScrollView(
            child: AnimationLimiter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 500),
                  childAnimationBuilder: (widget) => SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(child: widget)),
                  children: [
                    Gap(2.h),
                    _buildHeaderWidget(
                        context: context, orderDetails: orderDetails),
                    _buildShippingInfoCard(
                        context: context, orderDetails: orderDetails),
                    _buildCustomerInfoCardWdget(
                        context: context, orderDetails: orderDetails),
                    _buildItemCardWidget(
                        context: context, orderDetails: orderDetails),
                    orderDetails.rider != null
                        ? _buildRiderCardWidget(
                            context: context, orderDetails: orderDetails)
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          );
        }, error: (error, stackTrace) {
          return Text('Error: $error');
        }, loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
      }),
    );
  }

  Widget _buildBottomWidget(BuildContext context, OrderDetails orderDetails) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _getBottomDesign(context: context, orderDetails: orderDetails),
    );
  }

  Widget _getBottomDesign(
      {required BuildContext context, required OrderDetails orderDetails}) {
    if (orderDetails.orderStatus == 'Pending') {
      return Consumer(builder: (context, ref, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 1,
              child: Material(
                color: AppColor.red100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                child: InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => ConfirmationDialog(
                              isLoading: ref.watch(orderStatusController),
                              text: S.of(context).orderCancelDes,
                              cancelTapAction: () {
                                context.nav.pop(context);
                              },
                              applyTapAction: () {
                                ref
                                    .read(orderStatusController.notifier)
                                    .updateOrderStatus(
                                      status: 'Cancelled',
                                      orderId: orderDetails.id,
                                    )
                                    .then((response) {
                                  if (response.isSuccess) {
                                    GlobalFunction.showCustomSnackbar(
                                      message: response.message,
                                      isSuccess: response.isSuccess,
                                    );
                                    ref.refresh(orderDetailsController);
                                    ref
                                        .read(orderStatusController.notifier)
                                        .getStatusWiseOrderCount();
                                    ref
                                        .read(orderController.notifier)
                                        .getOrders(
                                          status: 'Pending',
                                          page: 1,
                                          perPage: 10,
                                          pagination: false,
                                        );
                                    context.nav.pop();
                                  }
                                });
                              },
                              image: Assets.image.alert.image(width: 90.w),
                            ));
                  },
                  borderRadius: BorderRadius.circular(100),
                  child: SizedBox(
                    height: 50.h,
                    width: 50.w,
                    child: const Center(
                      child: Icon(
                        Icons.close,
                        color: AppColor.redColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 5,
              child: ref.watch(orderStatusController)
                  ? const CircularProgressIndicator()
                  : CustomButton(
                      buttonText: S.of(context).accepAndAssignRider,
                      onPressed: () {
                        ref
                            .read(orderStatusController.notifier)
                            .updateOrderStatus(
                                status: 'Confirm', orderId: orderDetails.id)
                            .then((response) {
                          if (response.isSuccess) {
                            ref
                                .read(orderStatusController.notifier)
                                .getStatusWiseOrderCount();
                            ref.read(orderController.notifier).getOrders(
                                  status: 'Pending',
                                  page: 1,
                                  perPage: 20,
                                  pagination: false,
                                );
                            GlobalFunction.showCustomSnackbar(
                              message: response.message,
                              isSuccess: response.isSuccess,
                            );
                            context.nav.pushNamed(Routes.riderSelectPageView);
                          }
                        });
                      },
                    ),
            ),
          ],
        );
      });
    } else if (orderDetails.orderStatus == 'Confirm' &&
        orderDetails.rider == null) {
      return CustomButton(
        buttonText: 'Assign for Pickup',
        onPressed: () {
          context.nav.pushNamed(Routes.riderSelectPageView);
        },
      );
    } else if (orderDetails.orderStatus == 'Processing') {
      return CustomButton(
        buttonText: orderDetails.rider == null
            ? S.of(context).assignForDelivery
            : 'Change Rider',
        onPressed: () {
          context.nav.pushNamed(Routes.riderSelectPageView);
        },
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildHeaderWidget(
      {required BuildContext context, required OrderDetails orderDetails}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      color: AppColor.whiteColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    orderDetails.orderCode,
                    style: AppTextStyle(context).bodyText.copyWith(
                        color: AppColor.blackColor,
                        fontWeight: FontWeight.w500),
                  ),
                  Gap(5.w),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: AppColor.blackColor.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      orderDetails.paymentType,
                      style: AppTextStyle(context)
                          .bodyTextSmall
                          .copyWith(color: AppColor.offWhiteColor),
                    ),
                  )
                ],
              ),
              Gap(5.h),
              Text(
                getFormattedDate(orderedAt: orderDetails.orderedAt),
                style: AppTextStyle(context).bodyTextSmall.copyWith(
                    fontSize: 12.sp,
                    color: AppColor.blackColor.withOpacity(0.8),
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
          isLoading
              ? const CircularProgressIndicator()
              : GestureDetector(
                  onTap: () {
                    if (Platform.isIOS) {
                      _startDownloadIos(widget.order.invoicePath ?? '');
                    }
                    _startDownload(url: widget.order.invoicePath ?? '');
                  },
                  child: SvgPicture.asset(Assets.svg.print),
                ),
        ],
      ),
    );
  }

  Widget _buildShippingInfoCard(
      {required BuildContext context, required OrderDetails orderDetails}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      margin: EdgeInsets.symmetric(horizontal: 20.w).copyWith(top: 16.h),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${S.of(context).shippingInfo}:',
            style: AppTextStyle(context).bodyTextSmall.copyWith(
                color: AppColor.blackColor, fontWeight: FontWeight.w700),
          ),
          Gap(8.h),
          Text(
            '${S.of(context).address}:',
            style: AppTextStyle(context).bodyTextSmall.copyWith(
                  color: AppColor.blackColor.withOpacity(0.5),
                ),
          ),
          Gap(8.h),
          Text(
            orderDetails.userAddress,
            style: AppTextStyle(context).bodyTextSmall.copyWith(
                color: AppColor.blackColor, fontWeight: FontWeight.w500),
          ),
          Gap(8.h),
          _buildInfoDateCardWidget(
            context: context,
            orderDetails: orderDetails,
          )
        ],
      ),
    );
  }

  Container _buildInfoDateCardWidget(
      {required BuildContext context, required OrderDetails orderDetails}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColor.offWhiteColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${S.of(context).pickUpDate}:',
                  style: AppTextStyle(context).bodyTextSmall.copyWith(
                      color: AppColor.blackColor.withOpacity(0.6),
                      fontWeight: FontWeight.w500),
                ),
                Gap(5.h),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_month,
                      size: 20.sp,
                    ),
                    Gap(5.w),
                    Text(
                      DateFormat("d MMM, y", "en_US").format(
                        DateFormat("d MMMM, y", "en_US")
                            .parse(orderDetails.pickDate),
                      ),
                      style: AppTextStyle(context).bodyTextSmall.copyWith(
                          color: AppColor.blackColor,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                )
              ],
            ),
          ),
          Column(
            children: List.generate(
              5,
              (index) => Container(
                margin: const EdgeInsets.only(top: 5),
                height: 3,
                width: 1,
                color: AppColor.blackColor.withOpacity(0.2),
              ),
            ),
          ),
          Gap(10.w),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${S.of(context).deliveryDate}:',
                  style: AppTextStyle(context).bodyTextSmall.copyWith(
                      color: AppColor.blackColor.withOpacity(0.6),
                      fontWeight: FontWeight.w500),
                ),
                Gap(5.h),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_month,
                      size: 20.sp,
                    ),
                    Gap(5.w),
                    Text(
                      DateFormat("d MMM, y", "en_US").format(
                        DateFormat("d MMMM, y", "en_US")
                            .parse(orderDetails.deliveryDate),
                      ),
                      style: AppTextStyle(context).bodyTextSmall.copyWith(
                          color: AppColor.blackColor,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerInfoCardWdget(
      {required BuildContext context, required OrderDetails orderDetails}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h)
          .copyWith(bottom: 10.h),
      margin: EdgeInsets.symmetric(horizontal: 20.w).copyWith(top: 10.h),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${S.of(context).customerInfo}:',
            style: AppTextStyle(context).bodyTextSmall.copyWith(
                color: AppColor.blackColor, fontWeight: FontWeight.w700),
          ),
          Gap(5.h),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              radius: 24.sp,
              backgroundImage:
                  CachedNetworkImageProvider(widget.order.userProfile),
            ),
            title: Text(
              orderDetails.userName,
              style: AppTextStyle(context).bodyText.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColor.blackColor,
                  ),
            ),
            subtitle: Padding(
              padding: EdgeInsets.only(top: 5.h),
              child: Text(
                orderDetails.userMobile,
                style: AppTextStyle(context).bodyText.copyWith(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColor.blackColor.withOpacity(0.7),
                    ),
              ),
            ),
            trailing: Material(
              color: AppColor.violetColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: () {
                  UrlLauncher.launchUrl(
                    Uri.parse("tel://${orderDetails.userMobile}"),
                  );
                },
                child: Container(
                  height: 45.h,
                  width: 45.w,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: const Center(
                    child: Icon(
                      Icons.call,
                      color: AppColor.whiteColor,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildItemCardWidget(
      {required BuildContext context, required OrderDetails orderDetails}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h)
          .copyWith(bottom: 10.h),
      margin: EdgeInsets.symmetric(horizontal: 20.w).copyWith(top: 10.h),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${GlobalFunction.numberLocalization(orderDetails.products.length)} ${S.of(context).items}',
                style: AppTextStyle(context).bodyTextSmall.copyWith(
                    color: AppColor.blackColor, fontWeight: FontWeight.w700),
              ),
              Consumer(builder: (context, ref, _) {
                return Text(
                  ref.read(authController.notifier).settings.currency +
                      GlobalFunction.numberLocalization(
                          orderDetails.payableAmount.toString()),
                  style: AppTextStyle(context).bodyTextSmall.copyWith(
                      color: AppColor.blackColor, fontWeight: FontWeight.w700),
                );
              })
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: orderDetails.products.length,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.symmetric(vertical: 5.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    orderDetails.products[index].serviceName,
                    style: AppTextStyle(context).bodyTextSmall.copyWith(
                        color: AppColor.blackColor.withOpacity(0.5),
                        fontSize: 12.sp),
                  ),
                  Gap(2.h),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        orderDetails.products[index].items.length,
                        (index2) => Padding(
                          padding: EdgeInsets.only(left: 10.w),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 2,
                                backgroundColor: AppColor.blackColor,
                              ),
                              Gap(5.w),
                              Text(
                                "${GlobalFunction.numberLocalization(orderDetails.products[index].items[index2].quantity)} x ${orderDetails.products[index].items[index2].name}",
                                style: AppTextStyle(context)
                                    .bodyTextSmall
                                    .copyWith(
                                        color: AppColor.blackColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13.sp),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRiderCardWidget(
      {required BuildContext context, required OrderDetails orderDetails}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: AppColor.whiteColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Assigned',
            style: AppTextStyle(context).bodyTextSmall.copyWith(
                color: AppColor.blackColor, fontWeight: FontWeight.w700),
          ),
          Gap(8.h),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.r),
                  color: AppColor.offWhiteColor,
                  border:
                      Border.all(color: AppColor.blackColor.withOpacity(0.1))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20.r,
                          backgroundImage: CachedNetworkImageProvider(
                            orderDetails.rider!.profilePhoto,
                          ),
                        ),
                        Gap(10.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              orderDetails.rider!.name,
                              style: AppTextStyle(context)
                                  .bodyTextSmall
                                  .copyWith(
                                      color: AppColor.blackColor,
                                      fontWeight: FontWeight.w500),
                            ),
                            Text(
                              orderDetails.rider!.mobile,
                              style: AppTextStyle(context)
                                  .bodyTextSmall
                                  .copyWith(
                                      fontSize: 10.sp,
                                      color: colors(context).primaryColor,
                                      fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      UrlLauncher.launchUrl(
                        Uri.parse("tel://${orderDetails.rider!.mobile}"),
                      );
                    },
                    child: const Icon(Icons.call),
                  )
                ],
              )

              // ListTile(
              //   dense: true,
              //   contentPadding:
              //       EdgeInsets.symmetric(horizontal: 10.w, vertical: 0),
              //   tileColor: AppColor.redColor,
              //   leading: CircleAvatar(
              //     radius: 20.r,
              //   ),
              //   title: Padding(
              //     padding: const EdgeInsets.only(top: 0),
              //     child: Text(
              //       'Mahbub Alam',
              //       style: AppTextStyle(context).bodyTextSmall.copyWith(
              //           color: AppColor.blackColor,
              //           fontWeight: FontWeight.w700),
              //     ),
              //   ),
              //   subtitle: Text(
              //     '10 Nov, 2023',
              //     style: AppTextStyle(context).bodyTextSmall.copyWith(
              //         fontSize: 10.sp,
              //         color: colors(context).primaryColor,
              //         fontWeight: FontWeight.w700),
              //   ),
              // ),
              )
        ],
      ),
    );
  }

  String getFormattedDate({required String orderedAt}) {
    try {
      DateTime originalDate = DateFormat("yyyy-MM-dd HH:mm").parse(orderedAt);
      String formattedDate =
          DateFormat("d MMM, y - hh:mm a").format(originalDate);
      return formattedDate;
    } catch (e) {
      return widget.order.orderedAt;

      // Handle the error, or print more information to diagnose the issue
    }
  }

  bool isLoading = false;
  Future<void> _startDownload({required String url}) async {
    try {
      setState(() {
        isLoading = true;
      });
      final appDocDirectory = await getApplicationDocumentsDirectory();
      final taskId = await FlutterDownloader.enqueue(
        url: url,
        savedDir: appDocDirectory.path,
        showNotification: true,
        openFileFromNotification: true,
        saveInPublicStorage: true,
      );
      GlobalFunction.showCustomSnackbar(
        isSuccess: true,
        message: S.of(context).invoiceDownloaded,
      );
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _startDownloadIos(String url) async {
    setState(() {
      isLoading = true;
    });

    try {
      Dio dio = Dio();
      Response<List<int>> response = await dio.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );

      final appDocDirectory = await getApplicationDocumentsDirectory();
      final filePath =
          "${appDocDirectory.path}/${DateTime.now()}invoice_file.pdf";
      await File(filePath).writeAsBytes(response.data!);
      setState(() {
        isLoading = false;
      });
      _openFile(filePath: filePath);
    } catch (error) {
      debugPrint("Download error: $error");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _openFile({required String filePath}) async {
    try {
      final result = await OpenFile.open(filePath);

      if (result.type == ResultType.done) {
        debugPrint("File opened with success!");
      } else {
        debugPrint("Error opening file: ${result.message}");
      }
    } catch (e) {
      debugPrint("Error opening file: $e");
    }
  }
}
