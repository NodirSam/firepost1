import 'package:firepost1/pages/detail_page.dart';
import 'package:firepost1/services/rtdb_service.dart';
import 'package:flutter/material.dart';

import '../model/post_model.dart';
import '../services/auth_service.dart';
import '../services/prefs_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const String id="home_page";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var isLoading = false;

  List<Post> items = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiGetPosts();
  }

  Future _openDetail() async{
    Map results = await Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context){
          return const DetailPage();
        }
    ));
    if(results != null && results.containsKey("data")){
      print(results['data']);
      _apiGetPosts();
    }
  }

  _apiGetPosts() async {
    setState(() {
      isLoading = true;
    });
    var id = await Prefs.loadUserId();
    RTDBService.getPosts(id!).then((posts) => {
      _respPosts(posts),
    });
  }

  _respPosts(List<Post> posts){
    setState(() {
      isLoading = false;
      items = posts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Post"),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.white,),
            onPressed: (){
              AuthService.signOutUser(context);
            },
          )
        ],
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: items.length,
            itemBuilder: (ctx, i){
              return itemOfList(items[i]);
            },
          ),
          isLoading?
          Center(
            child: CircularProgressIndicator(),
          ): SizedBox.shrink(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>_openDetail(),
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget itemOfList(Post post){
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            height: 70,
            width: 70,
            child: post.img_url != null ?
                Image.network(post.img_url, fit: BoxFit.cover,):
                Image.asset("assets/images/images1.png"),
          ),
          SizedBox(width: 20,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(post.title, style: TextStyle(color: Colors.black, fontSize: 20),),
              SizedBox(height: 10,),
              Text(post.content, style: TextStyle(color: Colors.blue, fontSize: 15),),
            ],
          ),
        ],
      )
    );
  }
}
