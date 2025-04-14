import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_card.dart';

class NewsItem {
  final String title;
  final String source;
  final DateTime date;
  final String? imageUrl;
  final bool isPremium;

  NewsItem({
    required this.title,
    required this.source,
    required this.date,
    this.imageUrl,
    this.isPremium = false,
  });
}

class NewsCard extends StatelessWidget {
  final NewsItem newsItem;
  final VoidCallback onTap;

  const NewsCard({super.key, required this.newsItem, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNewsImage(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        newsItem.source,
                        style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        _getTimeAgo(),
                        style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (newsItem.isPremium) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'PRO',
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  newsItem.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsImage() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        image:
            newsItem.imageUrl != null
                ? DecorationImage(
                  image: AssetImage(newsItem.imageUrl!),
                  fit: BoxFit.cover,
                )
                : null,
      ),
      child:
          newsItem.imageUrl == null
              ? const Icon(
                Icons.newspaper,
                color: AppTheme.primaryColor,
                size: 24,
              )
              : null,
    );
  }

  String _getTimeAgo() {
    final difference = DateTime.now().difference(newsItem.date);
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  static List<NewsItem> getDemoNews() {
    return [
      NewsItem(
        title:
            'Lifechain announces new partnership with major financial institution',
        source: 'Crypto News',
        date: DateTime.now().subtract(const Duration(hours: 2)),
        isPremium: true,
      ),
      NewsItem(
        title: 'Market analysis: LCN token shows strong growth potential',
        source: 'Market Watch',
        date: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      NewsItem(
        title: 'New DeFi features coming to Lifechain ecosystem next month',
        source: 'DeFi Pulse',
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
      NewsItem(
        title: 'Crypto regulations: How new policies might affect Lifechain',
        source: 'Crypto Insights',
        date: DateTime.now().subtract(const Duration(days: 2)),
        isPremium: true,
      ),
    ];
  }
}
