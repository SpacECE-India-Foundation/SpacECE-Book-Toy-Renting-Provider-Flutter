import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:laundry_seller/config/app_color.dart';
import 'package:laundry_seller/config/app_text_style.dart';
import 'package:laundry_seller/controllers/misc/misc_provider.dart';
import 'package:laundry_seller/controllers/order/order_controller.dart';
import 'package:laundry_seller/generated/l10n.dart';
import 'package:laundry_seller/models/dashboard/dashboard_model.dart'
    as pending_order;
import 'package:laundry_seller/utils/global_function.dart';
import 'package:laundry_seller/views/dashboard/components/pending_order_card.dart';
import 'package:laundry_seller/views/order/components/order_card.dart';
import 'package:laundry_seller/views/order/components/order_tab_card.dart';
import 'package:laundry_seller/views/order/components/order_tab_card_shimmer_widget.dart';
import 'package:laundry_seller/views/profile/components/earning_history_shimmer_widget.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class OrderLayout extends ConsumerStatefulWidget {
  const OrderLayout({super.key});

  @override
  ConsumerState<OrderLayout> createState() => _OrderLayoutState();
}

class _OrderLayoutState extends ConsumerState<OrderLayout> {
  final ItemScrollController itemScrollController = ItemScrollController();

  final ScrollOffsetController scrollOffsetController =
      ScrollOffsetController();
  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      page = 1;
      ref.read(activeOrderTab.notifier).state = 0;
      ref.read(selectedOrderStatus.notifier).state = 'Pending';
      ref.read(orderStatusController.notifier).getStatusWiseOrderCount();
      await ref.read(orderController.notifier).getOrders(
            status: ref.read(selectedOrderStatus),
            page: page,
            perPage: perPage,
            pagination: false,
          );
      scrollController.addListener(() {
        scrollListener();
      });
    });

    super.initState();
  }

  int page = 1;
  final int perPage = 20;
  bool scrollLoading = false;

  void scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent) {
      if (ref.watch(orderController.notifier).orderModel.orders.length <
              ref.watch(orderController.notifier).orderModel.total &&
          ref.watch(orderController) == false) {
        scrollLoading = true;
        page++;
        ref.read(orderController.notifier).getOrders(
              pagination: true,
              page: page,
              perPage: perPage,
              status: ref.read(selectedOrderStatus),
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor == AppColor.blackColor
              ? AppColor.blackColor
              : AppColor.offWhiteColor,
      body: Column(
        children: [
          buildHeader(context: context, ref: ref),
          Flexible(
            flex: 5,
            child: ref.watch(orderController) && !scrollLoading
                ? const EarningHistoryShimmerWidget()
                : buildBody(ref: ref),
          )
        ],
      ),
    );
  }

  Widget buildHeader({required BuildContext context, required WidgetRef ref}) {
    return Container(
      padding: EdgeInsets.only(top: 50.h, bottom: 20.h),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16.r),
          bottomRight: Radius.circular(16.r),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                S.of(context).orders,
                style: AppTextStyle(context).subTitle,
              ),
              subtitle: Padding(
                padding: EdgeInsets.only(top: 3.h),
                child: Text(
                  'Today-${DateFormat('dd MMM,yyyy').format(DateTime.now().toLocal())}',
                  style: AppTextStyle(context)
                      .bodyTextSmall
                      .copyWith(fontWeight: FontWeight.w500, fontSize: 13.sp),
                ),
              ),
              trailing: SizedBox(
                width: 90.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: const CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColor.offWhiteColor,
                        child: Icon(Icons.search),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: const CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColor.offWhiteColor,
                        child: Icon(Icons.calendar_month),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Gap(10.h),
          Container(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height / 12),
            child: ScrollablePositionedList.builder(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 20.w),
              initialScrollIndex: ref.watch(activeOrderTab),
              itemScrollController: itemScrollController,
              itemCount: ref.watch(orderController)
                  ? 6
                  : ref
                      .watch(orderStatusController.notifier)
                      .statusWiseOrder
                      .length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return AbsorbPointer(
                  absorbing: ref.watch(orderController),
                  child: InkWell(
                    onTap: () {
                      page = 1;
                      if (ref.read(activeOrderTab) != index) {
                        ref.read(activeOrderTab.notifier).state = index;
                        ref.read(selectedOrderStatus.notifier).state = ref
                            .watch(orderStatusController.notifier)
                            .statusWiseOrder[index]
                            .status;
                        if (itemScrollController.isAttached) {
                          itemScrollController.scrollTo(
                            index: ref.watch(activeOrderTab),
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOutCubic,
                          );
                        }
                        ref.read(orderController.notifier).getOrders(
                              status: ref
                                  .watch(orderStatusController.notifier)
                                  .statusWiseOrder[index]
                                  .status,
                              page: 1,
                              perPage: perPage,
                              pagination: false,
                            );
                      }
                    },
                    child: ref.watch(orderStatusController)
                        ? const OrderTabCardShimmerWidget()
                        : OrderTabCard(
                            isActiveTab: ref.watch(activeOrderTab) == index,
                            orderCount: ref
                                .watch(orderStatusController.notifier)
                                .statusWiseOrder[index]
                                .count,
                            orderStatus:
                                GlobalFunction.getOrderStatusLocalizationText(
                              context: context,
                              status: ref
                                  .watch(orderStatusController.notifier)
                                  .statusWiseOrder[index]
                                  .status,
                            ),
                          ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget buildBody({required WidgetRef ref}) {
    return ref.watch(orderController.notifier).orderModel.orders.isNotEmpty
        ? AnimationLimiter(
            child: RefreshIndicator(
              onRefresh: () async {
                page = 1;
                ref.read(activeOrderTab.notifier).state = 0;
                ref.read(selectedOrderStatus.notifier).state = 'Pending';
                ref
                    .read(orderStatusController.notifier)
                    .getStatusWiseOrderCount();
                await ref.read(orderController.notifier).getOrders(
                      status: ref.read(selectedOrderStatus),
                      page: page,
                      perPage: perPage,
                      pagination: false,
                    );
                if (itemScrollController.isAttached) {
                  itemScrollController.scrollTo(
                    index: 0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOutCubic,
                  );
                }
              },
              child: ListView.builder(
                controller: scrollController,
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
                itemCount: ref
                    .watch(orderController.notifier)
                    .orderModel
                    .orders
                    .length,
                itemBuilder: (context, index) {
                  if (ref.watch(activeOrderTab) == 0) {
                    final pendingOrder = pending_order.Order.fromMap(
                      ref
                          .watch(orderController.notifier)
                          .orderModel
                          .orders[index]
                          .toMap(),
                    );

                    return AnimationConfiguration.staggeredList(
                      duration: const Duration(milliseconds: 500),
                      position: index,
                      child: SlideAnimation(
                        verticalOffset: 50.0.w,
                        child: FadeInAnimation(
                          child: PendingOrderCard(
                            order: pendingOrder,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return AnimationConfiguration.staggeredList(
                      duration: const Duration(milliseconds: 500),
                      position: index,
                      child: SlideAnimation(
                        verticalOffset: 50.0.w,
                        child: FadeInAnimation(
                          child: OrderCard(
                            order: ref
                                .watch(orderController.notifier)
                                .orderModel
                                .orders[index],
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          )
        : Center(
            child: Text(
              S.of(context).orderNotFound,
              style: AppTextStyle(context)
                  .bodyText
                  .copyWith(fontWeight: FontWeight.w400),
            ),
          );
  }
}
