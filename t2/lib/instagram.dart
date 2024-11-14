import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'viannnnnnnnnn...',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Icon(Icons.add_box_outlined, color: Colors.black),
          SizedBox(width: 15),
          Icon(Icons.menu, color: Colors.black),
          SizedBox(width: 15),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Profile Picture
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: CachedNetworkImageProvider(
                      'https://picsum.photos/id/99/99',
                    ),
                  ),
                  // Spacer for Profile Stats
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildProfileStat("Posts", "14"),
                            _buildProfileStat("Followers", "666"),
                            _buildProfileStat("Following", "511"),
                          ],
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Username and Bio
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'vian.',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Ini merupakan contoh tugas yang dimana kita disuruh untuk meng-clone tampilan instagram, dan ini merupakan best clone dari instagram saya',
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Link goes here',
                    style: TextStyle(color: Colors.blue),
                  ),
                  SizedBox(height: 15,)
                ],
              ),
            ),
            // Edit Profile Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18), // Padding of 20 on left and right
              child: SizedBox(
                width: double.infinity, // Makes the button stretch horizontally within the padding
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5), // Rounded corners with radius 5
                    ),
                  ),
                  child: Text(
                    "Edit Profile",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            // Story Highlights
            _buildStoryHighlights(),
            Divider(),
            // View Option
            _buildViewOptions(),
            // Photo Grid
            _buildPhotoGrid(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              radius: 12,
              backgroundImage: CachedNetworkImageProvider('https://picsum.photos/id/99/99'),
            ),
            label: '',
          ),
        ],
      ),
    );
  }

  Widget _buildProfileStat(String label, String count) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(label),
      ],
    );
  }

  Widget _buildStoryHighlights() {
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5, // Number of stories
        itemBuilder: (context, index) {
          return _buildStoryCircle("Story ${index + 1}", index);
        },
      ),
    );
  }

  Widget _buildStoryCircle(String label, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: CachedNetworkImageProvider(
              'https://picsum.photos/id/${index + 990}/100', // Unique image URL for each story
            ),
          ),
          SizedBox(height: 4),
          Text(label),
        ],
      ),
    );

  }

  Widget _buildViewOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(Icons.grid_on, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.portrait, color: Colors.grey),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoGrid() {

    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 9, // Number of photos
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemBuilder: (context, index) {
        return CachedNetworkImage(
          imageUrl: 'https://picsum.photos/id/${index + 123}/100',
          fit: BoxFit.cover,
        );
      },
    );
  }
}