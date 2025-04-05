import 'package:flutter/material.dart';
import 'package:prideconnect/screen/postScreen.dart';
import 'package:prideconnect/screen/profilePage.dart';
import '../utils/contstants.dart';

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final List<bool> _isLiked = [false, false]; // Tracks whether each post is liked
  final List<int> _likes = [248, 156]; // Initial likes for each post

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Explore" , style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold),),
        backgroundColor: Constants.PrideAPPCOLOUR, // Set background color to transparent
        elevation: 0, // Remove the shadow
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back,color: Colors.white,)),
        // leading:
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Image.asset('assets/images/loading.png', fit: BoxFit.contain ,),
        // ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: InkWell(
              onTap: (){Navigator.push(context, MaterialPageRoute(builder: (_)=>ProfilePage()));},
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/images/loading.png', fit: BoxFit.contain ,),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Constants.PrideAPPCOLOUR, // Set scaffold background color to white
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildPostInput(),
            Divider(thickness: 1, color: Colors.grey[300] ,indent: 35,endIndent: 35,),
      _buildPostCard(
      index: 0,
      profileImage: 'assets/images/d.png',
      name: 'Jamie Rivera',
      role: 'LGBTQ+ Rights Advocate & Tech Mentor',
      content:
      'Just launched a new mentorship program connecting LGBTQ+ individuals with industry leaders. If youre looking for career guidance, sign up today! 🌈✨',
      codeImage: 'assets/images/c.png',
      ),
      _buildPostCard(
        index: 1,
        profileImage: 'assets/images/d.png',
        name: 'Taylor Brooks',
        role: 'Community Manager at PrideTech',
        content:
        'Excited to announce an upcoming workshop on AI-driven career development for LGBTQ+ professionals! Join us to explore opportunities and grow together. 🚀🌍',
      ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostInput() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage('assets/images/d.png'), // Replace with your profile image path
              ),
              const SizedBox(width: 15),
              SizedBox(
                width: 330, // Adjust width (80% of screen width)
                height: 50,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Share your thoughts...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.image,color: Colors.white,),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.code ,color: Colors.white,),
                    onPressed: () {},
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_)=>SelectMedia()));
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Post'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard({
    required int index,
    required String profileImage,
    required String name,
    required String role,
    required String content,
    String? codeImage,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(profileImage), // Replace with the path to the profile image
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        role,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(content),
              if (codeImage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Image.asset(
                    codeImage,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          _isLiked[index] ? Icons.favorite : Icons.favorite_border,
                          color: _isLiked[index] ? Colors.red : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isLiked[index] = !_isLiked[index];
                            if (_isLiked[index]) {
                              _likes[index]++;
                            } else {
                              _likes[index]--;
                            }
                          });
                        },
                      ),
                      const SizedBox(width: 4),
                      Text('${_likes[index]}'),
                      const SizedBox(width: 16),
                      const Icon(Icons.comment),
                      const SizedBox(width: 4),
                      const Text('42'), // Replace this with dynamic comment count
                    ],
                  ),
                  const Icon(Icons.bookmark_border),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
