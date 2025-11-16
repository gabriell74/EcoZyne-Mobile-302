import 'dart:ui';
import 'package:ecozyne_mobile/core/utils/user_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ecozyne_mobile/data/models/answer.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';

class ReplyItem extends StatefulWidget {
  final Answer answer;
  final VoidCallback? onEdit;
  final Function(int answerId)? onDelete;

  const ReplyItem({
    super.key,
    required this.answer,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<ReplyItem> createState() => _ReplyItemState();
}

class _ReplyItemState extends State<ReplyItem> {
  Offset tapPosition = Offset.zero;
  final GlobalKey _cardKey = GlobalKey();

  void _storePosition(LongPressStartDetails details) {
    tapPosition = details.globalPosition;
  }

  void _showPopupMenu(BuildContext context) {
    final isOwner = UserHelper.currentUserId(context) == widget.answer.userId;

    HapticFeedback.heavyImpact();

    final RenderBox? renderBox = _cardKey.currentContext?.findRenderObject() as RenderBox?;
    final cardPosition = renderBox?.localToGlobal(Offset.zero);
    final cardSize = renderBox?.size;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "",
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (dialogContext, __, ___) {
        return GestureDetector(
          onTap: () => Navigator.pop(dialogContext),
          child: Stack(
            children: [
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.4),
                  ),
                ),
              ),

              if (cardPosition != null && cardSize != null)
                Positioned(
                  left: cardPosition.dx,
                  top: cardPosition.dy,
                  width: cardSize.width,
                  height: cardSize.height,
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.4),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: const CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.black, width: 2),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    widget.answer.username,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(height: 2),
                                  CustomText(
                                    widget.answer.answer,
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              Positioned(
                left: tapPosition.dx - 120,
                top: tapPosition.dy + 10,
                child: GestureDetector(
                  onTap: () {},
                  child: Material(
                    color: Colors.white,
                    elevation: 8,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isOwner)
                            InkWell(
                              onTap: () {
                                Navigator.pop(dialogContext);
                                widget.onEdit?.call();
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                child: Row(
                                  children: const [
                                    Icon(Icons.edit, size: 20),
                                    SizedBox(width: 12),
                                    Text("Edit", style: TextStyle(fontSize: 14)),
                                  ],
                                ),
                              ),
                            ),

                          if (isOwner)
                            Divider(height: 1, color: Colors.grey.shade300),

                          if (isOwner)
                            InkWell(
                              onTap: () {
                                Navigator.pop(dialogContext);
                                widget.onDelete?.call(widget.answer.id);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                child: Row(
                                  children: const [
                                    Icon(Icons.delete, size: 20, color: Colors.red),
                                    SizedBox(width: 12),
                                    Text("Hapus", style: TextStyle(fontSize: 14, color: Colors.red)),
                                  ],
                                ),
                              ),
                            ),

                          if (isOwner)
                            Divider(height: 1, color: Colors.grey.shade300),

                          InkWell(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: widget.answer.answer));
                              Navigator.pop(dialogContext);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Row(
                                children: const [
                                  Icon(Icons.copy, size: 20),
                                  SizedBox(width: 12),
                                  Text("Salin", style: TextStyle(fontSize: 14)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: _storePosition,
      onLongPress: () => _showPopupMenu(context),
      child: _buildReplyCard(context),
    );
  }

  Widget _buildReplyCard(BuildContext context) {
    return Container(
      key: _cardKey,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(radius: 20, backgroundColor: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    widget.answer.username,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                  const SizedBox(height: 2),
                  CustomText(widget.answer.answer, fontSize: 14),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}