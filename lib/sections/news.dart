import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/sections/components/news_detail.dart';
import '../providers/news_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsComponent extends StatefulWidget {
  const NewsComponent({super.key});

  @override
  State<NewsComponent> createState() => _NewsComponentState();
}

class _NewsComponentState extends State<NewsComponent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSelectedCategoryAndFetchNews();
    });
  }

  Future<void> _loadSelectedCategoryAndFetchNews() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedCategory = prefs.getString('selectedCategory') ?? 'General';
    print(selectedCategory);
    context.read<NewsProvider>().fetchNews(selectedCategory);
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'Latest News',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          newsProvider.newsData == null
              ? const Center(child: CircularProgressIndicator())
              : newsProvider.newsData!.isEmpty
                  ? const Center(
                      child: Text('No news available',
                          style:
                              TextStyle(fontSize: 16, color: Colors.black54)),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: newsProvider.newsData!.length,
                        itemBuilder: (context, index) {
                          final article = newsProvider.newsData![index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(12.0),
                              title: Text(
                                article.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                article.description ?? 'No description',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NewsDetailScreen(
                                      description: article.description ??
                                          'No description',
                                      title: article.title,
                                      url: article.url,
                                    ),
                                  ),
                                );
                              },
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
