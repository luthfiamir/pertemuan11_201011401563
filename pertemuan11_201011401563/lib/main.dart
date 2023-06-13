import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Programing - Pertemuan 11',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'sans serif',
      ),
      home: PhotoScreen(),
    );
  }
}

class PhotoScreen extends StatefulWidget {
  @override
  _PhotoScreenState createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  List<dynamic> _photos = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchPhotos();
  }

  Future<void> _fetchPhotos() async {
    setState(() {
      _isLoading = true;
    });

    final apiKey = '37247732-03b3ab86d3e73c616eff191f2';
    final searchQuery = 'lovebird';
    final language = 'en';
    final imageType = 'photo';

    final url = Uri.parse(
        'https://pixabay.com/api/?key=$apiKey&q=$searchQuery&lang=$language&image_type=$imageType');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final photos = data['hits'];

      setState(() {
        _photos = photos;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      print('Failed to fetch photos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Luthfi Amir Ramadhan - 201011401563',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 0.9,
              ),
              itemCount: _photos.length,
              itemBuilder: (context, index) {
                final photo = _photos[index];
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 116, 89, 247),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          child: Image.network(
                            photo['webformatURL'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          photo['tags'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 200, 46, 190),
                          ),
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
