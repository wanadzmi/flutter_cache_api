import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

var url =
    "https://newsapi.org/v2/everything?q=tesla&from=2023-03-11&sortBy=publishedAt&apiKey=e08d799ed43c436197badb8afc6e90c5";

abstract class ApiService {
  Future<dynamic> getAllNews();
}

class ApiServiceLists implements ApiService {
  static final ApiServiceLists _instance = ApiServiceLists.internal();
  ApiServiceLists.internal();
  factory ApiServiceLists() => _instance;

  @override
  Future<dynamic> getAllNews() async {
    dynamic result;
    dynamic fileName = "news.json";
    dynamic fileDirectory = await getTemporaryDirectory();
    File file = File("${fileDirectory.path}/$fileName");

    // Fetch data for the first time.
    if (!file.existsSync()) {
      await http.get(Uri.parse(url)).then((res) {
        // Write data into cache.
        file.writeAsStringSync(res.body, flush: true, mode: FileMode.write);
        log("Write Data for first time.");
        result = file.readAsStringSync();
      });
    } else {
      // Fetch data from cache.
      await http.get(Uri.parse(url)).then((res) {
        dynamic readData = file.readAsStringSync();

        // If api data not same as cache, overwite the data.
        if (res.body != readData) {
          file.writeAsStringSync(res.body, flush: true, mode: FileMode.write);
          log("Data not same. Data replaced.");
          result = readData;
        } else {
          log("Data same.");
          result = readData;
        }
      });
    }

    log('$result');
    return result;
  }
}

    // NewsModel? newsModelfromApi;
    //  newsModelfromApi = NewsModel.fromJson(jsonDecode(res.body));


// 1 - Fetch data from internet
// 2 - Store in Cache
// 3 - Read from cache
// 4 - If data from internet not equal to cache, fetch again


    // for (var i = 0; i < newsModelfromApi!.articles!.length; i++) {
        //   file.writeAsString(newsModelfromApi!.articles![i].title!);

        //   readData = fileData.readAsString();
        //   print(readData);
        // }

