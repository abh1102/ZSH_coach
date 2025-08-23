import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/widgets/back_arrow.dart';


PreferredSize backArrowAppBar(){
  return PreferredSize(preferredSize: Size(deviceWidth, 55.h), child:AppBar(elevation: 0,
      centerTitle: false,
      title: const BackArrow(),
      automaticallyImplyLeading: false,
    ) );
}
