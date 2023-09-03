//c0b642c80d46ff5a2e1321336f147ea7 Admin API
//7a4fe7debd83e72011d653b513076c84  API key from Environment Variables

import 'package:flutter/material.dart';
import 'package:algolia/algolia.dart';

class VideoSearchPage extends StatefulWidget {
  @override
  _VideoSearchPageState createState() => _VideoSearchPageState();
}

class _VideoSearchPageState extends State<VideoSearchPage> {
  final Algolia algolia = Algolia.init(
    applicationId: 'YOUR_ALGOLIA_APP_ID',
    apiKey: 'YOUR_ALGOLIA_API_KEY',
  );

  TextEditingController _searchController = TextEditingController();
  List<AlgoliaObjectSnapshot> _searchResults = [];

  void _performSearch(String query) async {
    AlgoliaQuerySnapshot querySnapshot = await algolia.instance
        .index('videos_archive') // Replace with your Algolia index name
        .query(query)
        .getObjects();

    setState(() {
      _searchResults = querySnapshot.hits;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Archive Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (query) {
                _performSearch(query);
              },
              decoration: InputDecoration(
                hintText: 'Search videos...',
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final result = _searchResults[index].data;
                return ListTile(
                  title: Text(result['title']),
                  subtitle: Text(result['description']),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
