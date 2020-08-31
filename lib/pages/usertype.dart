import 'package:flutter/material.dart';
import 'package:gallery/data/demos.dart';
import 'package:gallery/services/user.dart';

import 'category_list_item.dart';

class UserTypePage extends StatelessWidget {
  const UserTypePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('PHÂN LOẠI NGƯỜI DÙNG'),
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CategoryListItem(
                key: const PageStorageKey<GalleryDemoCategory>(
                  GalleryDemoCategory.mentee,
                ),
                category: GalleryDemoCategory.mentee,
                imageString: 'assets/icons/material/material.png',
                demos: List<GalleryDemo>(0),
                initiallyExpanded: false,
                onTap: () {
                  UserService.setBoxItemValue('usertype', 'mentee').then(
                      (value) => Navigator.of(context).pushNamed('/signup'));
                },
              ),
              CategoryListItem(
                key: const PageStorageKey<GalleryDemoCategory>(
                  GalleryDemoCategory.mentor,
                ),
                category: GalleryDemoCategory.mentor,
                imageString: 'assets/icons/reference/reference.png',
                demos: List<GalleryDemo>(0),
                initiallyExpanded: false,
                onTap: () {
                  UserService.setBoxItemValue('usertype', 'mentor').then(
                      (value) => Navigator.of(context).pushNamed('/signup'));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
