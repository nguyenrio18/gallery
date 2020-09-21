import 'package:flutter/material.dart';

import 'package:gallery/models/province.dart';
import 'package:gallery/services/province.dart';

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
    var emptyList = <String>[];
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Tỉnh thành'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: FutureBuilder<List>(
          future: ProvinceService.getProvinces(),
          initialData: emptyList,
          builder: (context, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (buildContext, position) {
                      final item = snapshot.data[position] as Province;
                      return GestureDetector(
                          //You need to make my child interactive
                          onTap: () =>
                              Navigator.pop(context, item.provinceName),
                          child: Card(
                            child: ListTile(
                              leading: ExcludeSemantics(
                                child: CircleAvatar(
                                    child: Text('${position + 1}')),
                              ),
                              title: Text(item.provinceName),
                            ),
                          ));
                    },
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  );
          },
        ),
      ),
    );
  }
}
