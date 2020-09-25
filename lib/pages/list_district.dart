import 'package:flutter/material.dart';

import 'package:gallery/models/district.dart';
import 'package:gallery/services/district.dart';

class ListDistrictPage extends StatelessWidget {
  const ListDistrictPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedId = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Lựa chọn quận huyện'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: FutureBuilder<List>(
          future: DistrictService.getDistricts(),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (buildContext, position) {
                      final item = snapshot.data[position] as District;
                      return GestureDetector(
                          //You need to make my child interactive
                          onTap: () => Navigator.pop<District>(context, item),
                          child: Card(
                            child: ListTile(
                              leading: ExcludeSemantics(
                                child: CircleAvatar(
                                    child: Text('${position + 1}')),
                              ),
                              title: Text(item.districtName),
                              trailing: Icon(
                                item.id == selectedId
                                    ? Icons.radio_button_checked
                                    : null,
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
