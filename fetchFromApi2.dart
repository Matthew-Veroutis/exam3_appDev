import 'package:http/http.dart' as http;
import 'dart:convert';
void main() {
  _getDataFromApi() async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data); // or process data
        final ListData = data as List;
        print("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n");
        for(int i = 0;i < ListData.length; i++) {
          var MapData = ListData[i] as Map<String, dynamic>;
          print("\n\n${MapData}");
        }
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  _getDataFromApi();
}