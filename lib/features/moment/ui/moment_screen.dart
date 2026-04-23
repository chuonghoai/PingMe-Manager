// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:pingme_manager/features/moment/ui/moment_controller.dart';
import 'components/list_moments_component.dart';
import 'components/list_moments_reported_component.dart';

class MomentScreen extends StatefulWidget {
  const MomentScreen({Key? key}) : super(key: key);

  @override
  State<MomentScreen> createState() => _MomentScreenState();
}

class _MomentScreenState extends State<MomentScreen> {
  late final MomentController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MomentController();

    _controller.addListener(() {
      if (_controller.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_controller.errorMessage!),
            backgroundColor: Colors.redAccent,
          ),
        );
        _controller.clearError();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quản lý Moment'),
          backgroundColor: const Color(0xFFF5A623),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            tabs: [
              Tab(text: 'Khoảnh khắc'),
              Tab(text: 'Vi phạm'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListMomentsComponent(controller: _controller),

            ListMomentsReportedComponent(controller: _controller),
          ],
        ),
      ),
    );
  }
}
