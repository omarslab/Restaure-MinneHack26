import 'package:flutter/material.dart';
import '../models/models.dart';

class ReviewDialog extends StatefulWidget {
  const ReviewDialog({
    super.key,
    required this.restaurant,
    required this.onSubmit,
  });

  final Restaurant restaurant;
  final void Function(int rating, String comment) onSubmit;

  @override
  State<ReviewDialog> createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<ReviewDialog> {
  int _rating = 0;
  int _hovered = 0;
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Review ${widget.restaurant.name}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              const Text('Your Rating', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Row(
                children: List.generate(5, (index) {
                  final star = index + 1;
                  final filled = star <= (_hovered == 0 ? _rating : _hovered);
                  return MouseRegion(
                    onEnter: (_) => setState(() => _hovered = star),
                    onExit: (_) => setState(() => _hovered = 0),
                    child: IconButton(
                      onPressed: () => setState(() => _rating = star),
                      icon: Icon(
                        Icons.star,
                        size: 32,
                        color: filled ? const Color(0xFFF59E0B) : const Color(0xFFD1D5DB),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 8),
              const Text('Your Review', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: _controller,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Share your experience...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Earn 50 points for leaving a review!',
                  style: TextStyle(color: Color(0xFF92400E)),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _rating == 0
                      ? null
                      : () {
                          widget.onSubmit(_rating, _controller.text.trim());
                          Navigator.of(context).pop();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD97706),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Submit Review'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
