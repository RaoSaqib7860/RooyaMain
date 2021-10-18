import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:rooya_app/utils/AppFonts.dart';

class HomePageGridView extends StatefulWidget {
  final double? width;
  final double? height;

  const HomePageGridView({Key? key, this.width, this.height}) : super(key: key);

  @override
  _HomePageGridViewState createState() => _HomePageGridViewState();
}

class _HomePageGridViewState extends State<HomePageGridView> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.asset(
                    'assets/images/one.jpeg',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 3,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircularProfileAvatar(
                '',
                child: Image.asset(
                  'assets/images/model.jpeg',
                  fit: BoxFit.cover,
                ),
                elevation: 2,
                radius: 10,
              ),
              SizedBox(
                width: widget.width! * 0.010,
              ),
              Text(
                'Dubai United Arab,emirates',
                style: TextStyle(fontSize: 10, fontFamily: AppFonts.segoeui),
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
          SizedBox(
            height: 3,
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: widget.width! * 0.065),
                child: Text(
                  '4322 views',
                  style: TextStyle(
                      fontSize: 8,
                      fontFamily: AppFonts.segoeui,
                      fontWeight: FontWeight.w400),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '27 Feb, 2021',
                style: TextStyle(
                    fontSize: 8,
                    fontFamily: AppFonts.segoeui,
                    fontWeight: FontWeight.w400),
                overflow: TextOverflow.ellipsis,
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          )
        ],
      ),
    );
  }
}
