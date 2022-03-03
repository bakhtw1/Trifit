import 'package:flutter/material.dart';
import 'package:trifit/components/addfeeditem.dart';
import 'package:trifit/components/feedItem.dart';
import '../assets/Styles.dart' as tfstyle;
import '../utilities/feedData.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);
  final String pageTitle = "Feed";

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  String text = "initial";
  late TextEditingController c;

  @override
  initState() {
    c = TextEditingController();
    super.initState();
  }

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
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddFeedItem()));
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
                    title: Text('Create Post'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(children: [
                          CircleAvatar(
                              backgroundImage: NetworkImage(
                                  "https://thumbs.dreamstime.com/b/portrait-young-african-american-business-woman-black-peop-people-51712509.jpg")),
                          SizedBox(
                            width: 7,
                          ),
                          Text('John Doe')
                        ]),
                        SizedBox(height: 15),
                        TextField(
                          keyboardType: TextInputType.multiline,
                          decoration:
                              InputDecoration(hintText: "Type something..."),
                          controller: c,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              _getImage();
                            },
                            child: Text('Add a photo'))
                      ],
                    ),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: Text('Cancel')),
                      TextButton(
                          onPressed: () => Navigator.pop(context, 'Post'),
                          child: Text('Post')),
                    ],
                  )));
        });
  }

  _getImage() async {
    File _image;
    PickedFile? imageFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
//if user doesn't take any image, just return.
    if (imageFile == null) return;
    setState(
      () {
//Rebuild UI with the selected image.
        _image = File(imageFile.path);
      },
    );
  }

  // Get from camera
  _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
    }
  }
}
