import 'package:flutter/material.dart';
import 'package:trifit/components/feedItem.dart';
import '../assets/Styles.dart' as tfstyle;
import '../utilities/feedData.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);
  final String pageTitle = "Feed";
  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: posts.length,
          itemBuilder: (BuildContext context, int index) {
            Map post = posts[index];
            return FeedItem(
              dp: post['dp'],
              name: post['name'],
              desc: post['desc'],
              img: post['img'],
            );
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: tfstyle.trifitColor[700],
        onPressed: () {
          showAddFeedDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void showAddFeedDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: ((context, setState) => AlertDialog(
                    title: Text('Add Post'),
                    content: Text('Post Content'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: Text('Cancel')),
                      TextButton(
                          onPressed: () => Navigator.pop(context, 'Add'),
                          child: Text('Add')),
                    ],
                  )));
        });
  }
}
