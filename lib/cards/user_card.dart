import 'package:firebase_cco2/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

class UserCard extends StatefulWidget {
  final name, email, phone, altPhone, role, address;
  UserCard(
      {this.name,
      this.address,
      this.email,
      this.phone,
      this.altPhone,
      this.role});
  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  TextStyle style = TextStyle(color: Colors.black);
  @override
  Widget build(BuildContext context) {
    String phoneNumber = widget.phone;
    if (widget.altPhone != "") phoneNumber += " | " + widget.altPhone;
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 350,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 15),
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: secondColor,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Center(
              child: Icon(
                Icons.person_pin,
                size: 90,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 40),
          Text(
            "${widget.name}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "${widget.address}",
            style: style,
          ),
          SizedBox(height: 10),
          Text(
            "${widget.email}",
            style: style,
          ),
          SizedBox(height: 10),
          Text(
            "$phoneNumber",
            style: style,
          ),
          SizedBox(height: 40),
          TextButton.icon(
            icon: Icon(Icons.stars, color: Colors.grey),
            onPressed: null,
            style: TextButton.styleFrom(backgroundColor: secondColor),
            label: Text(
              "CCO ${widget.role.toUpperCase()}",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
          ),
          SizedBox(
            height: 5,
          )
        ],
      ),
    );
  }
}
