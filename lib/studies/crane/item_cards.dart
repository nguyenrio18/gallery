// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:gallery/layout/adaptive.dart';
import 'package:gallery/layout/highlight_focus.dart';
import 'package:gallery/layout/image_placeholder.dart';
import 'package:gallery/studies/crane/model/destination.dart';
import 'package:gallery/models/mentor.dart';
import 'package:gallery/l10n/gallery_localizations.dart';

// Width and height for thumbnail images.
const mobileThumbnailSize = 60.0;

class DestinationCard extends StatelessWidget {
  const DestinationCard({@required this.destination})
      : assert(destination != null);
  final Mentor destination;

  String getSubtitle() {
    var duration = DateTime.now().difference(destination.startDate);
    return '${(duration.inDays / 360)} · ${destination.rate}';
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = isDisplayDesktop(context);
    final textTheme = Theme.of(context).textTheme;

    final Destination imageDestination = FlyDestination(
      id: 0,
      destination: GalleryLocalizations.of(context).craneFly0,
      stops: 1,
      duration: const Duration(hours: 6, minutes: 15),
      assetSemanticLabel:
          GalleryLocalizations.of(context).craneFly0SemanticLabel,
      imageAspectRatio: 400 / 400,
    );

    Widget card = isDesktop
        ? Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Semantics(
              container: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    child: _DestinationImage(destination: imageDestination),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                    child: Text(
                      destination.fullName,
                      style: textTheme.subtitle1,
                    ),
                  ),
                  Text(
                    getSubtitle(),
                    semanticsLabel: getSubtitle() + ' ***',
                    style: textTheme.subtitle2,
                  ),
                ],
              ),
            ),
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                contentPadding: const EdgeInsetsDirectional.only(end: 8),
                leading: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  child: SizedBox(
                    width: mobileThumbnailSize,
                    height: mobileThumbnailSize,
                    child: _DestinationImage(destination: imageDestination),
                  ),
                ),
                title: Text(destination.fullName, style: textTheme.subtitle1),
                subtitle: Text(
                  getSubtitle(),
                  semanticsLabel: getSubtitle() + ' ***',
                  style: textTheme.subtitle2,
                ),
              ),
              const Divider(thickness: 1),
            ],
          );

    return HighlightFocus(
      debugLabel: 'DestinationCard: ${destination.fullName}',
      highlightColor: Colors.red.withOpacity(0.5),
      onPressed: () {},
      child: card,
    );
  }
}

class _DestinationImage extends StatelessWidget {
  const _DestinationImage({@required this.destination})
      : assert(destination != null);
  final Destination destination;

  @override
  Widget build(BuildContext context) {
    final isDesktop = isDisplayDesktop(context);

    return Semantics(
      child: ExcludeSemantics(
        child: FadeInImagePlaceholder(
          image: AssetImage(
            destination.assetName,
            package: 'flutter_gallery_assets',
          ),
          fit: BoxFit.cover,
          width: isDesktop ? null : mobileThumbnailSize,
          height: isDesktop ? null : mobileThumbnailSize,
          placeholder: LayoutBuilder(builder: (context, constraints) {
            return Container(
              color: Colors.black.withOpacity(0.1),
              width: constraints.maxWidth,
              height: constraints.maxWidth / destination.imageAspectRatio,
            );
          }),
        ),
      ),
      label: destination.assetSemanticLabel,
    );
  }
}
