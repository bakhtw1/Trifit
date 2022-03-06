import 'package:flutter/material.dart';

class FriendList extends StatefulWidget {
  const FriendList({Key? key, required this.title, required this.friends})
      : super(key: key);

  final String title;
  final List friends;

  @override
  State<FriendList> createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: widget.friends.length,
          itemBuilder: (context, index) => Container(
            alignment: Alignment.center,
            // padding: const EdgeInsets.only(left: 8, right: 8, bottom: 50),
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(
                  widget.friends[index]["imageUrl"],
                ),
              ),
              title: Text(widget.friends[index]["name"]),
              trailing: widget.friends[index]["isFollowing"]
                  ? ElevatedButton(
                      onPressed: () {},
                      child: const Text('Following'),
                    )
                  : Container(
                      width: 100,
                      child: OutlinedButton(
                        onPressed: () {},
                        child: const Text('Follow'),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
