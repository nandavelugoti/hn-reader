import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() async {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hacker News Client',
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
				brightness: Brightness.dark,	
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
	int _maxItem = -1;
	List<Widget> _items = [];
		
	void _fetch() async {
		final respMaxItem = await http.get(Uri.parse('https://hacker-news.firebaseio.com/v0/maxitem.json'));
		_maxItem = int.parse(respMaxItem.body);
		
		final respTop500 = await http.get(Uri.parse('https://hacker-news.firebaseio.com/v0/topstories.json'));
		List<dynamic> top500 = jsonDecode(respTop500.body) as List<dynamic>; 
		
		List<Widget> newItems = [];
		
		for(int id in top500.sublist(0, 20)) {
			//int id = int.parse(storyId);
			var respItem = await http.get(Uri.parse('https://hacker-news.firebaseio.com/v0/item/$id.json'));
			Map<String, dynamic> item = jsonDecode(respItem.body) as Map<String, dynamic>; 
			String text = item['title'];
			newItems.add(Text('$id: $text'));
		}
	
		print('done');
		print(newItems);
		
		setState(() {
			_items = newItems;
		});
	}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
					children: _items,
				),
      ), 
			floatingActionButton: FloatingActionButton(
				onPressed: _fetch,
				tooltip: 'Fetch',
				child: const Icon(Icons.refresh),
			),
    );
  }
}
