import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagramhomework/controllers/profile_controller.dart';
import 'package:instagramhomework/services/pref_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  static const String id = "/profile_page";

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  void initState() {
    super.initState();
    Get.find<Profile_Controller>().apiLoadUser();
    Get.find<Profile_Controller>().apiLoadPost();
  }

  @override
  Widget build(BuildContext context) {
    Get.find<Profile_Controller>().height = MediaQuery.of(context).size.height;
    Get.find<Profile_Controller>().width = MediaQuery.of(context).size.width;
    return GetBuilder<Profile_Controller>(
      init: Profile_Controller(),
      builder: (profileController) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Row(
              children: [
                Text(
                  profileController.isLoading ? ""
                  : profileController.user.fullName,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.black,
                ),
              ],
            ),
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.add_box_outlined,
                    color: Colors.black,
                    size: 30,
                  )),
              IconButton(
                  onPressed: () {
                    Prefs.remove(StorageKeys.UID);
                    Navigator.pushReplacementNamed(context, 'signin_page');
                  },
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.black,
                    size: 30,
                  )),
            ],
          ),
          body: profileController.isLoading || profileController.isReloading ? const Center(child: CircularProgressIndicator(strokeWidth: 2),)
              : SingleChildScrollView(
            primary: true,
            child: SizedBox(
              height: profileController.height - 130,
              child: NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return [
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // #info
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.15,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [

                                  // searchimage
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        if(!profileController.imgLoading) {
                                          profileController.showPicker(context);
                                        }
                                      },
                                      onLongPress: () {
                                        profileController.imgDelete("1");
                                      },
                                      child: Stack(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(4),
                                            child: CircleAvatar(
                                              radius: double.infinity,
                                              backgroundColor: Colors.redAccent,
                                              child: Padding(
                                                padding: EdgeInsets.all(1),
                                                child: CircleAvatar(
                                                    radius: double.infinity,
                                                    foregroundImage: AssetImage("assets/images/user.png"),
                                                ),
                                              ),
                                            ),
                                          ),
                                          if(profileController.imgLoading)
                                          const Padding(
                                            padding: EdgeInsets.all(5),
                                            child: CircleAvatar(
                                              radius: double.infinity,
                                              backgroundColor: Colors.white,
                                              child: CircleAvatar(
                                                backgroundColor: Colors.white,
                                                child: Padding(
                                                  padding: EdgeInsets.all(8),
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 1,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          if(profileController.user.imageUrl != null && !profileController.imgLoading)
                                            Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: CircleAvatar(
                                              radius: double.infinity,
                                              backgroundColor: Colors.white,
                                              backgroundImage: NetworkImage(profileController.user.imageUrl!),
                                            )
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  userInfos(
                                    info: profileController.countPosts.toString(),
                                    context: "\nPosts",
                                  ),
                                  userInfos(
                                    info: profileController.user.followersCount.toString(),
                                    context: "\nFollowers",
                                  ),
                                  userInfos(
                                    info: profileController.user.followingCount.toString(),
                                    context: "\nFollowing",
                                  ),
                                ],
                              ),
                            ),

                            // #fullName
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                              child: Text(
                                profileController.user.fullName,
                                style: const TextStyle(
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
                                    margin: const EdgeInsets.only(
                                        top: 10, bottom: 10, left: 5, right: 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Text(
                                      "Edit Profile",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Icon(Icons.person_add),
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
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 1,
                          mainAxisSpacing: 1,
                        ),
                        primary: true,
                        itemCount: profileController.posts.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            child: Container(
                              height: 0,
                              width: 0,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                image: DecorationImage(
                                    image: NetworkImage(profileController.posts[index].postImage,),
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
        );
      },
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
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
              TextSpan(
                  text: context,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  // CircleAvatar userImageWidget(BuildContext context,image) {
  //   if(image == null) {
  //     return const CircleAvatar(
  //       radius: double.infinity,
  //       backgroundColor: Colors.white,
  //       backgroundImage: AssetImage("assets/images/user.png"),
  //     );
  //   }
  //   return CircleAvatar(
  //     radius: double.infinity,
  //     backgroundColor: Colors.white,
  //     backgroundImage: NetworkImage(image,),
  //   );
  // }

  // for categories
  Widget categories() {
    return const DefaultTabController(
      length: 2,
      child: TabBar(
        indicatorColor: Colors.black,
        indicatorWeight: 2,
        automaticIndicatorColorAdjustment: true,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.grey,
        tabs: [
          const Tab(
            icon: Icon(Icons.grid_on),
            // text: 'Address',
          ),
          const Tab(
            icon: Icon(Icons.person_pin_outlined),
            // text: 'Location',
          ),
        ],
      ),
    );
  }
}
