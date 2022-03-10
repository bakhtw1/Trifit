import 'package:flutter/material.dart';

import '../assets/Styles.dart' as tfstyle;

class FeedItem extends StatefulWidget {
  final String dp;
  final String name;
  final String desc;
  final String img;

  const FeedItem({
    Key? key,
    required this.dp,
    required this.name,
    required this.desc,
    required this.img,
  }) : super(key: key);

  @override
  State<FeedItem> createState() => _FeedItemState();
}

class _FeedItemState extends State<FeedItem> {
  bool onClick = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage("${widget.dp}"),
                          ),
                          SizedBox(width: 7),
                          Text(
                            widget.name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          onClick = !onClick;
                        });
                      },
                      child: Icon(Icons.thumb_up,
                          color:
                              onClick ? tfstyle.trifitColor[700] : Colors.grey))
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(widget.desc),
              SizedBox(
                height: 10,
              ),
              Container(
                height: widget.img.isEmpty ? 0 : 300,
                width: widget.img.isEmpty ? 0 : 300,
                child: widget.img.isEmpty
                    ? null
                    : Image.network(
                        widget.img,
                        fit: BoxFit.cover,
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

//ImagePicker instance.

}
