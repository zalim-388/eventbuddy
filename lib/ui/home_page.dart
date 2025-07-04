import 'package:eventbuddy/provider/evantprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eventbuddy/utils/fontstyle.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'event_provider.dart';
// import 'event_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context);

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "",
            style: fontStyle.heading.copyWith(color: Color(0xFF6C63FF)),
          ),
          actions: [
            // IconButton(

            //   onPressed: () => provider.toggleSortBy(),
            //   tooltip: "Sort by ${provider.sortBy == 'Date' ? 'Name' : 'Date'}",
            // ),
            IconButton(icon: Icon(Icons.logout), onPressed: () {
          
            }),
          ],
          bottom: TabBar(
            isScrollable: true,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            indicator: BoxDecoration(
              color: Color(0xFF6C63FF),
              borderRadius: BorderRadius.circular(8),
            ),
            tabs:
                [
                  'All',
                  'Tech',
                  'Sports',
                  'Culture',
                  'Music',
                ].map((cat) => Tab(text: cat)).toList(),
            onTap: (index) {
              provider.setCategory(
                ['All', 'Tech', 'Sports', 'Culture', 'Music'][index],
              );
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search by title or location',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: provider.setSearchQuery,
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: ListView.builder(
                  itemCount: provider.filteredEvents.length,
                  itemBuilder: (context, index) {
                    final event = provider.filteredEvents[index];
                    return Card(
                      child: ListTile(
                        title: Text(
                          event.title,
                          style: fontStyle.heading.copyWith(fontSize: 16),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("📍 ${event.location}"),
                            Text(
                              "📅 ${event.date.toLocal().toString().split(' ')[0]}",
                            ),
                            Text("🏷️ ${event.category}"),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
