import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:laundry_seller/components/custom_button.dart';
import 'package:laundry_seller/components/custom_search_field.dart';
import 'package:laundry_seller/config/app_color.dart';
import 'package:laundry_seller/config/app_text_style.dart';
import 'package:laundry_seller/config/theme.dart';
import 'package:laundry_seller/controllers/misc/misc_provider.dart';
import 'package:laundry_seller/controllers/order/order_controller.dart';
import 'package:laundry_seller/controllers/rider/rider_controller.dart';
import 'package:laundry_seller/generated/l10n.dart';
import 'package:laundry_seller/models/rider/rider.dart';
import 'package:laundry_seller/routes.dart';
import 'package:laundry_seller/utils/context_less_navigation.dart';
import 'package:laundry_seller/utils/global_function.dart';
import 'package:laundry_seller/views/profile/components/earning_history_shimmer_widget.dart';
import 'package:laundry_seller/views/rider/components/select_rider_card.dart';

class RiderSelectPageLayout extends ConsumerStatefulWidget {
  const RiderSelectPageLayout({super.key});

  @override
  ConsumerState<RiderSelectPageLayout> createState() =>
      _RiderSelectPageLayoutState();
}

class _RiderSelectPageLayoutState extends ConsumerState<RiderSelectPageLayout> {
  final TextEditingController riderSearchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (ref.read(riderController.notifier).riders == null) {
        ref.read(riderController.notifier).getRiders(
              page: 1,
              perPage: 20,
              search: null,
              pagination: false,
            );
      }
    });
    scrollController.addListener(() {
      scrollListener();
    });
    super.initState();
  }

  int page = 1;
  final int perPage = 20;
  bool scrollLoading = false;

  void scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent) {
      if (ref.watch(riderController.notifier).riders!.length <
              ref.watch(riderController.notifier).total!.toInt() &&
          !ref.watch(riderController)) {
        scrollLoading = true;
        page++;
        ref.read(riderController.notifier).getRiders(
              page: page,
              perPage: perPage,
              search: null,
              pagination: true,
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: ref.watch(riderController)
              ? SizedBox(
                  height: 50.h,
                  width: 50.w,
                  child: const Center(child: CircularProgressIndicator()),
                )
              : AbsorbPointer(
                  absorbing: ref.watch(selectedRider) == null ? true : false,
                  child: CustomButton(
                    buttonText: S.of(context).assignToRider,
                    buttonColor: ref.watch(selectedRider) != null
                        ? colors(context).primaryColor
                        : AppColor.violet100,
                    onPressed: () {
                      ref
                          .read(riderController.notifier)
                          .assignRider(
                            riderId: ref.read(selectedRider) ?? 0,
                            orderId: ref.read(orderIdProvider),
                          )
                          .then((response) {
                        if (response.isSuccess) {
                          ref.refresh(selectedRider);
                          GlobalFunction.showCustomSnackbar(
                            message: response.message,
                            isSuccess: response.isSuccess,
                          );
                          ref.refresh(orderDetailsController);
                          context.nav.pop(context);
                        }
                      });
                    },
                  ),
                ),
        ),
        body: Column(
          children: [
            buildHeader(context: context),
            Flexible(
              flex: 5,
              child: buildBody(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader({required BuildContext context}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h)
          .copyWith(top: 50.h),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select a Rider',
                style: AppTextStyle(context).subTitle,
              ),
              Consumer(builder: (context, ref, _) {
                return IconButton(
                  onPressed: () {
                    ref.read(selectedIndexProvider.notifier).state = 0;
                    context.nav
                        .pushNamedAndRemoveUntil(Routes.core, (route) => false);
                  },
                  icon: const Icon(Icons.close),
                );
              })
            ],
          ),
          Gap(10.h),
          CustomSearchField(
            name: 'searchRider',
            hintText: S.of(context).searchByName,
            textInputType: TextInputType.text,
            controller: riderSearchController,
            onChanged: (value) {
              if (value!.isEmpty) {
                FocusScope.of(context).unfocus();
                ref.read(riderController.notifier).getRiders(
                      page: 1,
                      perPage: 20,
                      search: null,
                      pagination: false,
                    );
              }
            },
            widget: IconButton(
              onPressed: () {
                if (riderSearchController.text.isNotEmpty) {
                  ref.read(riderController.notifier).getRiders(
                        page: 1,
                        perPage: 20,
                        search: riderSearchController.text,
                        pagination: false,
                      );
                }
              },
              icon: Icon(
                Icons.search,
                size: 30.sp,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildBody() {
    return ref.watch(riderController)
        ? const EarningHistoryShimmerWidget()
        : AnimationLimiter(
            child: RefreshIndicator(
              onRefresh: () async {
                riderSearchController.clear();
                ref.read(selectedRider.notifier).state = null;
                ref.read(riderController.notifier).getRiders(
                      page: 1,
                      perPage: 20,
                      search: null,
                      pagination: false,
                    );
              },
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                controller: scrollController,
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
                itemCount:
                    ref.watch(riderController.notifier).riders?.length ?? 0,
                itemBuilder: (context, index) {
                  final Rider rider =
                      ref.watch(riderController.notifier).riders![index];
                  return AnimationConfiguration.staggeredList(
                    duration: const Duration(milliseconds: 500),
                    position: index,
                    child: SlideAnimation(
                      verticalOffset: 50.0.w,
                      child: FadeInAnimation(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 6.h),
                          child: SelectRiderCard(
                            rider: rider,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
  }
}
