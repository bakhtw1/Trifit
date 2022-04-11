import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../controllers/UserController.dart';

class FriendList extends StatefulWidget {
  const FriendList({
    Key? key,
    required this.title,
    required this.isFollowingScreen,
    required this.followingList,
    required this.followersList,
  }) : super(key: key);

  final String title;
  final bool isFollowingScreen;
  final List followingList;
  final List followersList;

  @override
  State<FriendList> createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  var userController = UserController();
  @override
  bool getIsFollowing(id) {
    if (widget.followingList.contains(id)) {
      return true;
    }
    return false;
  }

  Widget getContent(friends) {
    if (widget.isFollowingScreen && widget.followingList.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: const Center(
          child: Text("You are not following anyone."),
        ),
      );
    }

    if (!widget.isFollowingScreen && widget.followersList.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: const Center(
          child: Text("You have no followers"),
        ),
      );
    }

    return ListView.builder(
      itemCount: friends.length,
      itemBuilder: (context, index) => Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(8),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(
              friends[index]["imageURL"],
            ),
          ),
          title: Text(friends[index]["name"]),
          trailing: getTrailing(friends[index]),
        ),
      ),
    );
  }

  Widget getTrailing(item) {
    if (!widget.isFollowingScreen) {
      bool isFollowing = getIsFollowing(item["uid"]);
      if (isFollowing) {
        return ElevatedButton(
          onPressed: () {},
          child: const Text("Following"),
        );
      } else {
        return Container(
          width: 100,
          child: OutlinedButton(
            onPressed: () async {
              setState(() {
                widget.followingList.add(item["uid"]);
              });
              await userController.updateFollowing(widget.followersList);
            },
            child: const Text('Follow'),
          ),
        );
      }
    }
    return ElevatedButton(
      onPressed: () async {
        setState(() {
          widget.followingList.remove(item["uid"]);
        });
        await userController.updateFollowing(widget.followingList);
      },
      child: const Text("Following"),
    );
  }

  Widget build(BuildContext context) {
    if (widget.isFollowingScreen && widget.followingList.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: const Center(
          child: Text("You are not following anyone."),
        ),
      );
    } else if (!widget.isFollowingScreen && widget.followersList.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: const Center(
          child: Text("You have no followers"),
        ),
      );
    } else {
      return StreamBuilder<QuerySnapshot>(
        stream: widget.isFollowingScreen
            ? userController.getFollowing(widget.followingList)
            : userController.getFollowers(widget.followersList),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          var friends = snapshot.data!.docs;
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: SafeArea(child: getContent(friends)),
          );
        },
      );
    }
  }
}
