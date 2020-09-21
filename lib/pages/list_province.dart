import 'package:flutter/material.dart';

import 'package:gallery/models/province.dart';
import 'package:gallery/services/province.dart';

class ListProvincePage extends StatelessWidget {
  const ListProvincePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedId = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Lựa chọn tỉnh thành'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: FutureBuilder<List>(
          future: ProvinceService.getProvinces(),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (buildContext, position) {
                      final item = snapshot.data[position] as Province;
                      return GestureDetector(
                          //You need to make my child interactive
                          onTap: () => Navigator.pop<Province>(context, item),
                          child: Card(
                            child: ListTile(
                              leading: ExcludeSemantics(
                                child: CircleAvatar(
                                    child: Text('${position + 1}')),
                              ),
                              title: Text(item.provinceName),
                              trailing: Icon(
                                item.id == selectedId
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color:
                                    item.id == selectedId ? Colors.red : null,
                              ),
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
