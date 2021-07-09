import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlogScreen extends StatefulWidget {
  final user;
  BlogScreen({Key key, @required this.user}) : super(key: key);

  @override
  _BlogScreenState createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: getUserBlog(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error initializing Firebase');
            } else if (snapshot.connectionState == ConnectionState.done ||
                snapshot.hasData) {
              return blogsList(snapshot.data);
            }
            return CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.orange,
              ),
            );
          },
        ),
      ),
    );
  }

  blogsList(blogsData) {
    QuerySnapshot blogsSnapShot = blogsData;
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.75,
          child: ListView.builder(
            itemCount: blogsSnapShot.size,
            shrinkWrap: true,
            itemBuilder: (ctx, index) {
              var blogs = blogsSnapShot.docs;
              var blogData = blogs[index].data();
              var blogTitle = blogData['title'];
              var blogBody = blogData['body'];
              return InkWell(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (ctxSheet) {
                        return Column(
                          children: [
                            Text(
                              blogTitle,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              blogBody,
                              // maxLines: 3,
                              overflow: TextOverflow.fade,
                            ),
                          ],
                        );
                      });
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: Column(
                    children: [
                      Text(
                        blogTitle,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(blogBody,
                          maxLines: 3, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
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

  Future<QuerySnapshot> getUserBlog() async {
    var firestore = FirebaseFirestore.instance;
    var blogCollection = firestore.collection('blogs');
    var userId = widget.user['id'];
    return await blogCollection.where('userId', isEqualTo: userId).get();
  }
}
