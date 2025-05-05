import 'package:flutter/material.dart';
import 'package:prak3/network/base_network.dart';

class DetailScreen extends StatefulWidget {
  final int id;
  final String endpoint;
  DetailScreen({super.key, required this.id, required this.endpoint});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _detailData;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchDetailData();
  }

  Future<void> _fetchDetailData() async {
    try {
      final data = await BaseNetwork.getDetailData(widget.endpoint, widget.id);
      setState(() {
        _detailData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detail")),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _errorMessage != null
              ? Center(child: Text("Error ${_errorMessage}"))
              : _detailData != null
              ? SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${_detailData!['name']}",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Image.network(
                      _detailData!['images'][0] ??
                          'https://placehold.co/600x400',
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 20),
                    Text("Titles: ${_detailData!['personal']['titles']}"),
                    SizedBox(height: 16),
                    Text("Family: ${_detailData!['family']}"),
                    SizedBox(height: 16),
                    Text("Debut: ${_detailData!['debut']}"),
                    SizedBox(height: 16),
                    Text(
                      "Kekkei Genkai: ${_detailData!['personal']["kekkaiGenkai"] ?? 'Empty'}",
                    ),
                  ],
                ),
              )
              : Center(child: Text("No Data")),
    );
  }
}
