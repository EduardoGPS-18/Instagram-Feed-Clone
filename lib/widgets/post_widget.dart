import 'package:feedinstagramclone/models/post_model.dart';
import 'package:feedinstagramclone/providers/posts.dart';
import 'package:feedinstagramclone/utils/format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//FIXME: Arrumar a apresentação do tempo (Há x tempo atrás!)!

class PostWidget extends StatefulWidget {
  final Post post;

  const PostWidget({Key key, this.post}) : super(key: key);

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  Future<bool> showConfirmDialog(BuildContext context, {Widget content}) async {
    var res = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        content: content,
        actions: [
          FlatButton(
            child: Text(
              "Confirmar",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
          FlatButton(
            child: Text(
              "Cancelar",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          )
        ],
      ),
    );
    return res;
  }

  Future<void> deletePost() async {
    var res = await this.showConfirmDialog(
      context,
      content: Text("Deseja apagar mesmo?"),
    );
    if (res) {
      Provider.of<Posts>(context, listen: false).deletePost(
        widget.post,
        FirebaseAuth.instance.currentUser.uid,
      );
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    var curUserCurtiu = this
        .widget
        .post
        .curtidas
        .where((element) {
          return element == FirebaseAuth.instance.currentUser.uid;
        })
        .toList()
        .isNotEmpty;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12),
      width: double.infinity,
      height: 550,
      // color: Colors.grey,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundImage: Image.network(widget.post.icon).image,
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 16),
                    child: Text(
                      widget.post.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                if (FirebaseAuth.instance.currentUser.uid == widget.post.userUID)
                  DropdownButton(
                    underline: Container(),
                    icon: Icon(Icons.more_vert),
                    items: [
                      DropdownMenuItem<String>(
                        child: Text("Excluir"),
                        value: "Excluir",
                      ),
                    ],
                    onChanged: (value) async {
                      if (value == "Excluir") {
                        deletePost();
                      }
                    },
                  ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              child: Image(
                image: Image.network(widget.post.imageSRC).image,
                fit: BoxFit.cover,
                repeat: ImageRepeat.noRepeat,
                filterQuality: FilterQuality.high,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    curUserCurtiu ? Icons.favorite : Icons.favorite_outline,
                    color: curUserCurtiu ? Colors.red : Colors.black,
                    size: 32,
                  ),
                  onPressed: () {
                    Provider.of<Posts>(context, listen: false).changeCurtiu(
                      this.widget.post,
                      FirebaseAuth.instance.currentUser.uid,
                    );
                  },
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: IconButton(
                    icon: Icon(
                      Icons.chat_bubble_outline,
                      size: 32,
                    ),
                    onPressed: () {},
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.send_rounded,
                    size: 32,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: RichText(
                        maxLines: 2,
                        text: TextSpan(
                          text: "${widget.post.name} ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: "${widget.post.legend}",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 8,
                    left: 10,
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Hora : ",
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        "${MyUtils.formatDateTimeHHMMSS(widget.post.date)} (Há ${MyUtils.getTime(widget.post.date)})",
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
