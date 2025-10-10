import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class ActivityHeader extends StatelessWidget {
  const ActivityHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      height: 130,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        // color: Color(0xFF649B71),
        image: DecorationImage(
          image: AssetImage("assets/images/activity_banner.jpeg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Row(
        children:[
          Flexible(
            flex: 50,
            child: CustomText(
              "Satukan Langkah, Wujudkan Kebersihan !",
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 80)
        ],
      ),
    );
  }
}
