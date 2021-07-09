import 'package:blogs_app/viewBlogs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewBlogScreen extends StatefulWidget {
  final user;
  NewBlogScreen({Key key, @required this.user}) : super(key: key);

  @override
  _NewBlogScreenState createState() => _NewBlogScreenState();
}

class _NewBlogScreenState extends State<NewBlogScreen> {
  var _titleController = TextEditingController();
  var _bodyController = TextEditingController();

  var blogTitle = "";
  var blogBody = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Add Blog Title",
                  border: OutlineInputBorder(),
                ),
                controller: _titleController,
                // autofillHints: ["email"],
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  blogTitle = value.trim();
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Add Blog Body",
                  border: OutlineInputBorder(),
                ),
                controller: _bodyController,
                // autofillHints: ["password"],
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                onChanged: (value) {
                  blogBody = value.trim();
                },
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () async {
                  var blog = await createNewBlog();
                  if (blog != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      customSnackBar(
                        content: 'Blog Created Succesfully',
                      ),
                    );
                    setState(() {
                      _bodyController.text = "";
                      _titleController.text = "";
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      customSnackBar(
                        content: 'Error in creating Blog. Try again.',
                      ),
                    );
                  }
                },
                child: Text("Create Blog"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (cont) => BlogScreen(user: widget.user),
                    ),
                  );
                },
                child: Text("View Blogs"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static SnackBar customSnackBar({@required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  Future<DocumentReference> createNewBlog() async {
    var firestore = FirebaseFirestore.instance;
    var blogCollection = firestore.collection('blogs');
    return await blogCollection.add(
        {"title": blogTitle, "body": blogBody, "userId": widget.user['id']});
  }
}
