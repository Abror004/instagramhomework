import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagramhomework/controllers/profile_controller.dart';
import 'package:instagramhomework/services/pref_service.dart';

class ProfilePage extends StatefulWidget {
  static const String id = "/profile_page";

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final profile_controller = Get.put(Profile_Controller());

  @override
  void initState() {
    super.initState();
    profile_controller.apiLoadUser();
    profile_controller.apiLoadPost();
  }

  @override
  Widget build(BuildContext context) {
    profile_controller.height.value = MediaQuery.of(context).size.height;
    profile_controller.width.value = MediaQuery.of(context).size.width;
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            children: [
              Text(
                profile_controller.user.value.fullName,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Icon(
                Icons.keyboard_arrow_down,
                color: Colors.black,
              ),
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.add_box_outlined,
                  color: Colors.black,
                  size: 30,
                )),
            IconButton(
                onPressed: () {
                  Prefs.remove(StorageKeys.UID);
                  Navigator.pushReplacementNamed(context, 'signin_page');
                },
                icon: Icon(
                  Icons.menu,
                  color: Colors.black,
                  size: 30,
                )),
          ],
        ),
        body: profile_controller.isLoading.value ? Center(child: CircularProgressIndicator(),)
            : SingleChildScrollView(
          primary: true,
          child: Container(
            height: profile_controller.height.value - 130,
            child: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // #info
                          Container(
                            height: MediaQuery.of(context).size.height * 0.15,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [

                                // searchimage
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      if(!profile_controller.imgLoading.value) {
                                        profile_controller.showPicker(context);
                                      }
                                    },
                                    onLongPress: () {
                                      profile_controller.imgDelete();
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: profile_controller.imgLoading.value ? CircleAvatar(backgroundColor: Colors.white, child: CircularProgressIndicator(),) : userImageWidget(context),
                                    ),
                                  ),
                                ),

                                userInfos(
                                  info: profile_controller.posts.value.length.toString(),
                                  context: "\nPosts",
                                ),
                                userInfos(
                                  info: profile_controller.user.value.followersCount.toString(),
                                  context: "\nFollowers",
                                ),
                                userInfos(
                                  info: profile_controller.user.value.followingCount.toString(),
                                  context: "\nFollowing",
                                ),
                              ],
                            ),
                          ),

                          // #fullName
                          Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                            child: Text(
                              profile_controller.user.value.fullName != null ? profile_controller.user.value.fullName : "",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),

                          // #button
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 35,
                                  margin: EdgeInsets.only(
                                      top: 10, bottom: 10, left: 5, right: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Edit Profile",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 10),
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Icon(Icons.person_add),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ]),
                  ),
                ];
              },
              body: Column(
                children: [
                  // #catalog
                  categories(),
                  // #history
                  Expanded(
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 1,
                        mainAxisSpacing: 1,
                      ),
                      primary: true,
                      itemCount: profile_controller.posts.value.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          child: Container(
                            height: 0,
                            width: 0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              image: DecorationImage(
                                  image: NetworkImage(profile_controller.posts.value[index].postImage,),
                                  fit: BoxFit.cover
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // : Center(child: Text("miweqfifeqwfijew",style: TextStyle(color: Colors.black),),),
      ),
    );
  }

  Widget userInfos({required String info, required String context}) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                  text: info,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
              TextSpan(
                  text: context,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget userImageWidget(BuildContext context) {
    if(profile_controller.user.value.imageUrl == null) {
      return CircleAvatar(
        radius: double.infinity,
        backgroundColor: Colors.white,
        backgroundImage: AssetImage("assets/images/user.png"),
      );
    }
    return CircleAvatar(
      radius: double.infinity,
      backgroundColor: Colors.white,
      backgroundImage: NetworkImage(profile_controller.user.value.imageUrl!,),
    );
  }

  // for categories
  Widget categories() {
    return Container(
      child: DefaultTabController(
        length: 2,
        child: TabBar(
          indicatorColor: Colors.black,
          indicatorWeight: 2,
          automaticIndicatorColorAdjustment: true,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          tabs: [
            Tab(
              icon: const Icon(Icons.grid_on),
              // text: 'Address',
            ),
            Tab(
              icon: const Icon(Icons.person_pin_outlined),
              // text: 'Location',
            ),
          ],
        ),
      ),
    );
  }
}
