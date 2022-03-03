import 'package:flutter/material.dart';

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
  String imagecheck = " ";
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.all(15),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage("${widget.dp}"),
                  ),
                  SizedBox(width: 7),
                  Text(widget.name)
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(widget.desc),
              Container(
                // child: (widget.img != null) ? Image.network(widget.img) : null,
                child: widget.img.isEmpty ? null : Image.network(widget.img),
              )
            ],
          ),
        ),
      ),
    );
  }
}
