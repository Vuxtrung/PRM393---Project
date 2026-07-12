import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/notification_service.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<dynamic> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    try {
      final notifs = await NotificationService.getNotifications();
      if (mounted) {
        setState(() {
          _notifications = notifs;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _markAsRead(String id, int index) async {
    if (_notifications[index]['isRead'] == true) return;
    
    setState(() {
      _notifications[index]['isRead'] = true;
    });
    try {
      await NotificationService.markAsRead(id);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo'),
        backgroundColor: FinzyTheme.surfaceContainerLowest,
        elevation: 0,
        foregroundColor: FinzyTheme.onSurface,
      ),
      backgroundColor: FinzyTheme.background,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
              ? const Center(child: Text('Không có thông báo nào'))
              : ListView.separated(
                  padding: const EdgeInsets.all(FinzyTheme.spacingMd),
                  itemCount: _notifications.length,
                  separatorBuilder: (context, index) => const SizedBox(height: FinzyTheme.spacingSm),
                  itemBuilder: (context, index) {
                    final notif = _notifications[index];
                    final isRead = notif['isRead'] == true;
                    final date = DateTime.parse(notif['createdAt']).toLocal();
                    final dateStr = '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} ${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

                    return GestureDetector(
                      onTap: () => _markAsRead(notif['_id'], index),
                      child: Container(
                        padding: const EdgeInsets.all(FinzyTheme.spacingMd),
                        decoration: BoxDecoration(
                          color: isRead ? FinzyTheme.surfaceContainerLowest : FinzyTheme.primaryContainer,
                          borderRadius: BorderRadius.circular(FinzyTheme.radiusMd),
                          border: Border.all(
                            color: isRead ? FinzyTheme.surfaceContainerHigh : FinzyTheme.primary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isRead ? FinzyTheme.surfaceContainerHigh : FinzyTheme.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.notifications,
                                size: 20,
                                color: isRead ? FinzyTheme.onSurfaceVariant : FinzyTheme.onPrimary,
                              ),
                            ),
                            const SizedBox(width: FinzyTheme.spacingMd),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    notif['title'],
                                    style: FinzyTheme.bodyLg.copyWith(
                                      fontWeight: isRead ? FontWeight.w500 : FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    notif['body'],
                                    style: FinzyTheme.bodyMd.copyWith(
                                      color: FinzyTheme.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: FinzyTheme.spacingSm),
                                  Text(
                                    dateStr,
                                    style: FinzyTheme.labelMd.copyWith(
                                      color: FinzyTheme.outline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
