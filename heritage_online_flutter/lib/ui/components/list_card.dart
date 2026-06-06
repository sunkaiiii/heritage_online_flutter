import 'package:flutter/material.dart';

import 'content_card.dart';

/// 列表卡片组件
/// prominent 为纵向图文，否则横向图文
/// 用于文章、名录、传承人列表复用
class ListCard extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget image;
  final Widget text;
  final bool prominent;

  const ListCard({
    super.key,
    this.onTap,
    required this.image,
    required this.text,
    this.prominent = false,
  });

  @override
  Widget build(BuildContext context) {
    return ContentCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: prominent ? _buildVertical() : _buildHorizontal(),
    );
  }

  Widget _buildVertical() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        image,
        const SizedBox(height: 10),
        text,
      ],
    );
  }

  Widget _buildHorizontal() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        image,
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [text],
          ),
        ),
      ],
    );
  }
}
