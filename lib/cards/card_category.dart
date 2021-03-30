import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CardCaseCategory extends StatelessWidget {
  final title, icon, image, color, isVerified, hasStatistic, value;

  CardCaseCategory(
      {this.title,
      this.icon,
      this.image,
      this.color,
      this.isVerified,
      this.hasStatistic = false,
      this.value});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            !hasStatistic ? BorderRadius.circular(5) : BorderRadius.circular(0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                width: 15,
              ),
              FaIcon(
                icon,
                color: color,
              ),
              SizedBox(
                width: 30,
              ),
              Text(
                "${title}",
                style: TextStyle(
                    color: color, fontSize: 15, fontWeight: FontWeight.bold),
              ),
              !hasStatistic
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Chip(
                          backgroundColor: Color(0xfff5f5f5),
                          label: Text(
                            "$value",
                            style: TextStyle(
                                color: color,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
            ],
          ),
          Container(
            height: 80,
            width: 80,
            margin: EdgeInsets.only(right: 5),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("$image"), fit: BoxFit.scaleDown),
            ),
          ),
        ],
      ),
    );
  }
}
