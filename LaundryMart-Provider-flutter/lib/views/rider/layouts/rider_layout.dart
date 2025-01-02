import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:laundry_seller/components/custom_search_field.dart';
import 'package:laundry_seller/config/app_color.dart';
import 'package:laundry_seller/config/app_text_style.dart';
import 'package:laundry_seller/controllers/rider/rider_controller.dart';
import 'package:laundry_seller/generated/l10n.dart';
import 'package:laundry_seller/models/rider/rider.dart';
import 'package:laundry_seller/routes.dart';
import 'package:laundry_seller/utils/context_less_navigation.dart';
import 'package:laundry_seller/views/profile/components/earning_history_shimmer_widget.dart';
import 'package:laundry_seller/views/rider/components/rider_card.dart';

class RiderLayout extends ConsumerStatefulWidget {
  const RiderLayout({super.key});

  @override
  ConsumerState<RiderLayout> createState() => _RiderLayoutState();
}

class _RiderLayoutState extends ConsumerState<RiderLayout> {
  final TextEditingController riderSearchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      riderSearchController.addListener(() {});

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
    bool isDark =
        Theme.of(context).scaffoldBackgroundColor == AppColor.blackColor;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: isDark ? AppColor.blackColor : AppColor.offWhiteColor,
        body: Column(
          children: [
            buildHeader(context: context),
            Flexible(flex: 5, child: buildBody()),
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
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(14),
          bottomRight: Radius.circular(14),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).riders,
            style: AppTextStyle(context).subTitle,
          ),
          Gap(10.h),
          SizedBox(
            child: Row(
              children: [
                Flexible(
                  flex: 5,
                  child: CustomSearchField(
                    name: 'searchRider',
                    hintText: S.of(context).searchByName,
                    textInputType: TextInputType.text,
                    controller: riderSearchController,
                    onChanged: (value) {
                      ref.read(riderController.notifier).getRiders(
                            page: 1,
                            perPage: 20,
                            search: value,
                            pagination: false,
                          );
                    },
                    widget: const SizedBox(),
                    // IconButton(
                    //   onPressed: () {
                    //     if (riderSearchController.text.isNotEmpty) {
                    //       ref.read(riderController.notifier).getRiders(
                    //             page: 1,
                    //             perPage: 20,
                    //             search: riderSearchController.text,
                    //             pagination: false,
                    //           );
                    //     }
                    //   },
                    //   icon: Icon(
                    //     Icons.search,
                    //     size: 30.sp,
                    //   ),
                    // ),
                  ),
                ),
                Gap(5.w),
                ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<CircleBorder>(
                      const CircleBorder(),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(AppColor.violetColor),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.all(10.0),
                    ),
                  ),
                  onPressed: () {
                    context.nav.pushNamed(Routes.createRider);
                  },
                  child: const Center(
                    child: Icon(
                      Icons.add,
                      color: AppColor.whiteColor,
                    ),
                  ),
                )
              ],
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
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
                controller: scrollController,
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
                          child: RiderCard(
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
