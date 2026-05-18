import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/transaction.dart';
import '../bloc/transaction_bloc.dart';
import '../bloc/transaction_event.dart';

class TransactionCardItem extends StatelessWidget {
  final TransactionEntity item;

  const TransactionCardItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          // 1. Settlement toggle checkbox 
          IconButton(
            onPressed: () {
              context.read<TransactionBloc>().add(ToggleTransactionStatusEvent(item.id));
            },
            icon: Icon(
              item.isPaid ? Icons.check_circle : Icons.radio_button_unchecked,
              color: item.isPaid ? const Color(0xFF16A34A) : const Color(0xFF94A3B8),
              size: 24,
            ),
          ),
          const SizedBox(width: 8),
          
          // 2. Transaction Details Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.personName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E293B),
                    decoration: item.isPaid ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.description, 
                  style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
                ),
                const SizedBox(height: 8),
                
                // Status Badges (Uses flexible padding to clean up text truncation)
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    _buildBadge(
                      text: item.isYouOwe ? "You Owe" : "They Owe",
                      bgColor: item.isYouOwe ? const Color(0xFFFEE2E2) : const Color(0xFFDCFCE7),
                      textColor: item.isYouOwe ? const Color(0xFF991B1B) : const Color(0xFF166534),
                    ),
                    _buildBadge(
                      text: item.isPaid ? "Paid" : "Pending",
                      bgColor: const Color(0xFFF1F5F9),
                      textColor: const Color(0xFF475569),
                    ),
                  ],
                )
              ],
            ),
          ),
          
          // 3. Amount & Management Actions Row
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${item.isYouOwe ? '-' : '+'}${item.amount.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: item.isYouOwe ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: Color(0xFF3B82F6), size: 20),
                    onPressed: () {
                      // TODO: Hook edit sheet transaction context form
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Color(0xFFEF4444), size: 20),
                    onPressed: () {
                      context.read<TransactionBloc>().add(DeleteTransactionEvent(item.id));
                    },
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  // Inner Badge Helper
  Widget _buildBadge({required String text, required Color bgColor, required Color textColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(color: textColor, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}