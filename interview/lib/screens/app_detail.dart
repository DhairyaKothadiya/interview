import 'package:flutter/material.dart';

class AppDetail extends StatefulWidget {
  final String artistName;
  final String name;
  final String description;
  final String logo;
  const AppDetail({Key? key, required this.artistName, required this.name, required this.description, required this.logo}) : super(key: key);

  @override
  State<AppDetail> createState() => _AppDetailState();
}

class _AppDetailState extends State<AppDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading:  IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: const Icon(Icons.arrow_back_ios, color: Colors.blue)),
        title:const Text("Back", style: TextStyle(color: Colors.blue, fontSize: 22)),
        bottom: PreferredSize(
          preferredSize: const Size(double.infinity, 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:  [
              Padding(
                padding: const EdgeInsets.only(left: 17),
                child: Text(widget.artistName, style: const TextStyle(color: Colors.black, fontSize: 34, fontWeight: FontWeight.bold)),
              ),
              const Divider(thickness: 1),
            ],
          ),
          // autofocus: true,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 110,
                    width: 110,
                    decoration:  BoxDecoration(
                        image: DecorationImage(image: NetworkImage(widget.logo),fit: BoxFit.cover),
                        color: Colors.blue, borderRadius: const BorderRadius.all(Radius.circular(20))),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text(widget.artistName, style: const TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Container(alignment: Alignment.center, decoration: const BoxDecoration(color: Colors.yellow, shape: BoxShape.circle), child: const Icon(Icons.star, color: Colors.white,size: 20,)),
                            const SizedBox(width: 10),
                            const Text("4.5", style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 20),
                            Container(alignment: Alignment.center, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle), child: const Icon(Icons.person, color: Colors.white,size: 20,)),
                            const SizedBox(width: 10),
                            const Text("12 +", style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 7),
                        Container(
                          height: 40,
                          width: 120,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: const Text("Download", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 320,
                child: ListView.builder(
                  itemCount: 3,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(
                      height: 320,
                      width: 200,
                      alignment: Alignment.center,
                      decoration:  BoxDecoration(
                          color: Colors.blue,
                        image: DecorationImage(image: NetworkImage(widget.logo),fit: BoxFit.cover),
                      ),
                    ),
                  );
                },),
              ),
              const SizedBox(height: 20),
              const Text("Description", style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
               Text(widget.description, style: const TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
