import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:interview/models/fees_model.dart';
import 'package:interview/screens/app_detail.dart';

class AppList extends StatefulWidget {
  const AppList({Key? key}) : super(key: key);

  @override
  State<AppList> createState() => _AppListState();
}

class _AppListState extends State<AppList> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  FeedModel feedModel = FeedModel();
  List<Results> filterResult = [];
  TextEditingController searchController = TextEditingController();

  Future<void> feedApiCall() async {
    var response = await http.get(Uri.parse("https://rss.applemarketingtools.com/api/v2/us/apps/top-free/50/apps.json"), headers: {'q': '{http}'});
    if (response.statusCode == 200) {
      print(response.body);
      feedModel = FeedModel.fromJson(jsonDecode(response.body));
      setState(() {});
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  void filter() {
    List<Results>? results = [];
    results.addAll(feedModel.feed!.results!);
    if (searchController.text.isNotEmpty) {
      results.retainWhere((contact) {
        String searchItem = searchController.text.toLowerCase();
        String searchName = contact.artistName!.toLowerCase();
        return searchName.contains(searchItem);
      });
      filterResult = results;
      setState(() {});
    }
    if (searchController.text.isEmpty) {
      filterResult = feedModel.feed!.results!;

      setState(() {});
    }
  }

  @override
  void initState() {
    feedApiCall();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text("Apps", style: TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold)),
        bottom: PreferredSize(
          preferredSize: const Size(double.infinity, 60),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    filter();
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.black12,
                    prefixIcon: const Icon(Icons.search, color: Colors.black26),
                    suffixIcon: const Icon(Icons.mic, color: Colors.black26),
                    hintText: 'Search',
                    hintStyle: const TextStyle(color: Colors.black26, fontSize: 17),
                    contentPadding: const EdgeInsets.all(10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.white)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.white)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.white)),
                  ),
                ),
              ),
              const Divider(thickness: 1),
            ],
          ),
          // autofocus: true,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            DefaultTabController(
              length: 2,
              child: Container(
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: TabBar(
                  controller: _tabController,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.black,
                  // indicatorWeight: 1,
                  // indicatorColor: AppColor.primaryColor,
                  indicator: BoxDecoration(color: Colors.white, borderRadius: const BorderRadius.all(Radius.circular(15)), border: Border.all(color: Colors.black12, width: 2)),
                  tabs: const [
                    Tab(child: Text("Top Free", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold))),
                    Tab(child: Text("App", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold))),
                  ],
                ),
              ),
            ),
            Expanded(
                child: TabBarView(controller: _tabController, children: <Widget>[
              feedModel.feed == null
                  ? const Center(child: CircularProgressIndicator())
                  : filterResult.isEmpty
                      ? SingleChildScrollView(
                          child: Column(
                            children: [
                              ListView.builder(
                                itemCount: feedModel.feed!.results!.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => AppDetail(
                                                  artistName: feedModel.feed!.results![index].artistName.toString(),
                                                  name: feedModel.feed!.results![index].name.toString(),
                                                  description: feedModel.feed!.results![index].url.toString(),
                                                  logo: feedModel.feed!.results![index].artworkUrl100.toString()),
                                            ));
                                      },
                                      child: SizedBox(
                                        height: 78,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Stack(
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(top: 8, left: 9),
                                                  height: 60,
                                                  width: 60,
                                                  decoration: BoxDecoration(
                                                      color: Colors.black12,
                                                      image: DecorationImage(image: NetworkImage(feedModel.feed!.results![index].artworkUrl100.toString()), fit: BoxFit.cover),
                                                      borderRadius: const BorderRadius.all(Radius.circular(10))),
                                                ),
                                                Container(
                                                  height: 25,
                                                  width: 25,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue,
                                                    shape: BoxShape.circle,
                                                    border: Border.all(color: Colors.white, width: 1),
                                                  ),
                                                  child: Text("${index + 1}", style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                                ),
                                              ],
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(right: 10.0, top: 10.0, left: 10.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Wrap(
                                                      children: [
                                                        Text(feedModel.feed!.results![index].artistName.toString(),
                                                            style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold))
                                                      ],
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Text(feedModel.feed!.results![index].name.toString(), style: const TextStyle(color: Colors.black38, fontSize: 16)),
                                                    const SizedBox(height: 2),
                                                    Text(feedModel.feed!.results![index].url.toString(),
                                                        maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.blue, fontSize: 12))
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const Align(
                                              alignment: Alignment.centerRight,
                                              child: Icon(Icons.navigate_next, color: Colors.black26),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 30,
                              )
                            ],
                          ),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              ListView.builder(
                                itemCount: filterResult.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => AppDetail(
                                                  artistName: filterResult[index].artistName.toString(),
                                                  name: filterResult[index].name.toString(),
                                                  description: filterResult[index].url.toString(),
                                                  logo: filterResult[index].artworkUrl100.toString()),
                                            ));
                                      },
                                      child: SizedBox(
                                        height: 78,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Stack(
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(top: 8, left: 9),
                                                  height: 60,
                                                  width: 60,
                                                  decoration: BoxDecoration(
                                                      color: Colors.black12,
                                                      image: DecorationImage(image: NetworkImage(filterResult[index].artworkUrl100.toString()), fit: BoxFit.cover),
                                                      borderRadius: const BorderRadius.all(Radius.circular(10))),
                                                ),
                                                Container(
                                                  height: 25,
                                                  width: 25,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue,
                                                    shape: BoxShape.circle,
                                                    border: Border.all(color: Colors.white, width: 1),
                                                  ),
                                                  child: Text("${index + 1}", style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                                ),
                                              ],
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(right: 10.0, top: 10.0, left: 10.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Wrap(
                                                      children: [
                                                        Text(filterResult[index].artistName.toString(), style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold))
                                                      ],
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Text(filterResult[index].name.toString(), style: const TextStyle(color: Colors.black38, fontSize: 16)),
                                                    const SizedBox(height: 2),
                                                    Text(filterResult[index].url.toString(), maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.blue, fontSize: 12))
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const Align(
                                              alignment: Alignment.centerRight,
                                              child: Icon(Icons.navigate_next, color: Colors.black26),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 30,
                              )
                            ],
                          ),
                        ),
              feedModel.feed == null
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          ListView.builder(
                            itemCount: feedModel.feed!.results!.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AppDetail(
                                              artistName: feedModel.feed!.results![index].artistName.toString(),
                                              name: feedModel.feed!.results![index].name.toString(),
                                              description: feedModel.feed!.results![index].url.toString(),
                                              logo: feedModel.feed!.results![index].artworkUrl100.toString()),
                                        ));
                                  },
                                  child: SizedBox(
                                    height: 78,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Stack(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(top: 8, left: 9),
                                              height: 60,
                                              width: 60,
                                              decoration: BoxDecoration(
                                                  color: Colors.black12,
                                                  image: DecorationImage(image: NetworkImage(feedModel.feed!.results![index].artworkUrl100.toString()), fit: BoxFit.cover),
                                                  borderRadius: const BorderRadius.all(Radius.circular(10))),
                                            ),
                                            Container(
                                              height: 25,
                                              width: 25,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: Colors.blue,
                                                shape: BoxShape.circle,
                                                border: Border.all(color: Colors.white, width: 1),
                                              ),
                                              child: Text("${index + 1}", style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                            ),
                                          ],
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(right: 10.0, top: 10.0, left: 10.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Wrap(
                                                  children: [
                                                    Text(feedModel.feed!.results![index].artistName.toString(), style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold))
                                                  ],
                                                ),
                                                const SizedBox(height: 2),
                                                Text(feedModel.feed!.results![index].name.toString(), style: const TextStyle(color: Colors.black38, fontSize: 16)),
                                                const SizedBox(height: 2),
                                                Text(feedModel.feed!.results![index].url.toString(),
                                                    maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.blue, fontSize: 12))
                                              ],
                                            ),
                                          ),
                                        ),
                                        const Align(
                                          alignment: Alignment.centerRight,
                                          child: Icon(Icons.navigate_next, color: Colors.black26),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          )
                        ],
                      ),
                    ),
            ]))
          ],
        ),
      ),
    );
  }
}
