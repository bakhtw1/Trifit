import 'package:flutter/material.dart';

class AddFeedItem extends StatefulWidget {
  const AddFeedItem({Key? key}) : super(key: key);

  @override
  State<AddFeedItem> createState() => _AddFeedItemState();
}

class _AddFeedItemState extends State<AddFeedItem> {
  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Post')),
      body: Padding(
        padding: EdgeInsets.all(25),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://thumbs.dreamstime.com/b/portrait-young-african-american-business-woman-black-peop-people-51712509.jpg")),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'John Doe',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              style: TextStyle(decoration: TextDecoration.none),
              decoration: InputDecoration(
                hintText: 'What would you like to share?',
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
              ),
              controller: myController,
            ),
          ],
        ),
      ),
    );
  }
}
