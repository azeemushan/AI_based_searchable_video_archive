import 'package:flutter/material.dart';
import 'package:algolia/algolia.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Archive App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: VideoGridPage(),
    );
  }
}

class VideoGridPage extends StatefulWidget {
  @override
  _VideoGridPageState createState() => _VideoGridPageState();
}

class _VideoGridPageState extends State<VideoGridPage> {
  final Algolia algolia = Algolia.init(
    applicationId: 'YOUR_APP_ID',
    apiKey: 'YOUR_API_KEY',
  );

  List<AlgoliaObjectSnapshot> _videoResults = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadAllVideos();
  }

  void _loadAllVideos() async {
    AlgoliaQuerySnapshot querySnapshot = await algolia.instance
        .index('videos_archive')
        .query('')
        .getObjects();

    setState(() {
      _videoResults = querySnapshot.hits;
    });
  }

  void _searchVideos(String query) async {
    AlgoliaQuerySnapshot querySnapshot = await algolia.instance
        .index('videos_archive')
        .query(query)
        .getObjects();

    setState(() {
      _searchQuery = query;
      _videoResults = querySnapshot.hits;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Archive'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search Videos',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (query) {
                _searchVideos(query);
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: _videoResults.length,
              itemBuilder: (context, index) {
                final result = _videoResults[index].data;
                final title = result['title'];
                final thumbnailUrl = result['thumbnail'];

                return GestureDetector(
                  onTap: () {
                    // Handle video selection
                    // You can navigate to a video detail page here
                  },
                  child: Column(
                    children: <Widget>[
                      CachedNetworkImage(
                        imageUrl: thumbnailUrl,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
