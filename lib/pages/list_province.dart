// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'package:gallery/l10n/gallery_localizations.dart';

// BEGIN listDemo

enum ListLineType {
  oneLine,
  twoLine,
}

class ListProvincePage extends StatelessWidget {
  const ListProvincePage({Key key, this.type = ListLineType.oneLine})
      : super(key: key);

  final ListLineType type;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(GalleryLocalizations.of(context).demoListsTitle),
      ),
      body: Scrollbar(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            for (int index = 1; index < 21; index++)
              ListTile(
                leading: ExcludeSemantics(
                  child: CircleAvatar(child: Text('$index')),
                ),
                title: Text(
                  GalleryLocalizations.of(context).demoBottomSheetItem(index),
                ),
                subtitle: type == ListLineType.twoLine
                    ? Text(GalleryLocalizations.of(context).demoListsSecondary)
                    : null,
              ),
          ],
        ),
      ),
    );
  }
}

// END
