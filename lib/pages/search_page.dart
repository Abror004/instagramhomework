import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:instagramhomework/controllers/search_controller.dart';
import 'package:instagramhomework/views/textfield_widget.dart';

class SearchPage extends StatefulWidget {
  static const String id = "/Search_Page";

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Search_Controller search_controller = Search_Controller();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    search_controller.loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    search_controller.height.value = MediaQuery.of(context).size.height;
    search_controller.width.value = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        primary: true,
        child: Obx(
          () => Container(
            height: search_controller.height.value,
            width: search_controller.width.value,
            child: Column(
              children: [
                Container(
                  height: 40,
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                  child: textField(hintText: "search", controller: search_controller.controller.value,function: search_controller.loadUsers),
                ),
                SizedBox(
                  height: 50,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: search_controller.types.value.length,
                      itemBuilder: (context,index) {
                        return MaterialButton(
                          color: index == search_controller.selectType.value ? Colors.green : Colors.grey,
                          shape: StadiumBorder(),
                          onPressed: () {
                            search_controller.selectTypeEdit(index);
                          },
                          child: Text(search_controller.types.value[index],style: TextStyle(color: Colors.white),),
                        );
                      },
                    ),
                  ),
                ),
                if(search_controller.isLoading.value)
                  Expanded(child: Center(child: CircularProgressIndicator(),)),
                if(!search_controller.isLoading.value)
                  search(selectType: search_controller.selectType.value,context: context),
                Container(height: 70,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget userImageWidget(imageUrl) {
    if(imageUrl != null) {
      return CircleAvatar(
        radius: 25,
        backgroundColor: Colors.white,
        backgroundImage: NetworkImage(imageUrl),
      );
    } else {
      return CircleAvatar(
        radius: 25,
        backgroundColor: Colors.white,
        backgroundImage: AssetImage("assets/images/user.png"),
      );
    }
  }

  Widget search({required int selectType,required BuildContext context}) {
    if(selectType == 0) {
      return Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: search_controller.users.value.length,
          itemBuilder: (context,index) {
            return ListTile(
              leading: userImageWidget(search_controller.users.value[index].imageUrl),
              title: Text(search_controller.users.value[index].fullName,style: TextStyle(color: Colors.black),),
              trailing: Container(
                height: 40,
                width: 90,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: MaterialButton(
                  padding: EdgeInsets.all(0),
                  onPressed: () {
                    setState(() {});
                    search_controller.users.value[index].followed = !(search_controller.users.value[index].followed);
                    search_controller.likedFunction(index: index);
                  },
                  child: Text(search_controller.users.value[index].followed ? "followed" : "follow",style: TextStyle(color: Colors.white),),
                ),
              ),
            );
          },
        ),
      );
    } else {
      return Expanded(
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverQuiltedGridDelegate(
            crossAxisCount: 3,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            repeatPattern: QuiltedGridRepeatPattern.same,
            pattern: [
              QuiltedGridTile(1, 1),
              QuiltedGridTile(2, 2),
              QuiltedGridTile(1, 1),
              QuiltedGridTile(1, 1),
              QuiltedGridTile(1, 1),
              QuiltedGridTile(1, 1),
              QuiltedGridTile(1, 1),
              QuiltedGridTile(1, 1),
              QuiltedGridTile(1, 1),

              QuiltedGridTile(2, 2),
              QuiltedGridTile(1, 1),
              QuiltedGridTile(1, 1),
              QuiltedGridTile(1, 1),
              QuiltedGridTile(1, 1),
              QuiltedGridTile(1, 1),
              QuiltedGridTile(1, 1),
              QuiltedGridTile(1, 1),
              QuiltedGridTile(1, 1),
            ],
          ),
          itemCount: 100,
          itemBuilder: (context, index) {
            return Container(
              height: 10,
              width: 10,
              color: Colors.green,
            );
          },
        ),
      );
    }
  }
}
