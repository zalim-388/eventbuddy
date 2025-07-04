import 'package:eventbuddy/utils/fontstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> categories = ['All', 'Tech', 'Sports', 'Culture', 'Music'];

  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
        title: Text(
          "name",
          style: fontStyle.heading.copyWith(color: Color(0xFF6C63FF)),
        ),
        actions: [IconButton(icon: Icon(Icons.logout), onPressed: () {})],
      ),
      body: Column(
        children: [
          TabBar(
            dividerColor: Colors.transparent,
            labelColor: Colors.white,
            labelStyle: fontStyle.heading.copyWith(fontSize: 14),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
            unselectedLabelStyle: fontStyle.heading.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            indicator: BoxDecoration(
              color: Color(0xFF6C63FF),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            indicatorPadding: EdgeInsets.zero,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Tab(text: "Tech"),
              Tab(text: "Sports"),
              Tab(text: "Culture"),
              Tab(text: "Music"),
            ],
          ),
          SizedBox(height: 10.h),
          SizedBox(
            height: 700.h,
            child: TabBarView(
              children: [
                Column(
                  children: [
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search by title or location',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          // searchQuery = value.toLowerCase();
                        });
                      },
                    ),







                    
                  ],
                ),






              ],
            ),
          ),
        ],
      ),
    );
  }
}
