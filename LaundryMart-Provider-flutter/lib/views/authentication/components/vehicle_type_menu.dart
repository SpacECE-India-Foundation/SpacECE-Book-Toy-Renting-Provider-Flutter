import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laundry_seller/config/app_text_style.dart';
import 'package:laundry_seller/config/theme.dart';
import 'package:laundry_seller/controllers/misc/misc_provider.dart';
import 'package:laundry_seller/utils/context_less_navigation.dart';

class ShowVehicleTypeMenu extends ConsumerWidget {
  ShowVehicleTypeMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(vertical: 0.h),
          itemBuilder: (context, index) => ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 10.w, vertical: 0.0),
            minVerticalPadding: 0.0,
            onTap: () {
              context.nav.pop();
              ref.read(selectedVehicle.notifier).state = vehicleTypes[index];
              ref.read(vehcleTypeProvider).text = vehicleTypes[index];
            },
            title: Text(
              vehicleTypes[index],
              style: AppTextStyle(context).subTitle,
            ),
            trailing: Radio(
              value: vehicleTypes[index],
              groupValue: ref.watch(selectedVehicle.notifier).state,
              onChanged: (String? vehicle) {
                ref.read(selectedVehicle.notifier).state = vehicle ?? '';
              },
            ),
          ),
          separatorBuilder: ((context, index) => Divider(
                thickness: 1.0,
                color: colors(context).bodyTextColor!.withOpacity(0.5),
              )),
          itemCount: vehicleTypes.length,
        ),
      ],
    );
  }

  final List<String> vehicleTypes = [
    'Minivan',
    'Lorry',
    'Estate car',
    'Crossover',
    'Hatchback'
  ];
}
