import 'package:flutter/material.dart';

class PostDetail extends StatelessWidget {
  const PostDetail({super.key});

  /// SAMPLE DATA
  final String _category = 'CategoryX';
  final List<String> _tagsData = const ['Tag1', 'Tag2', 'Tag3'];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Post Detail')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// TITLE
              Text(
                'Post Title title title title title title title',
                style: textTheme.titleLarge?.copyWith(fontSize: 24),
              ),

              const SizedBox(height: 8),

              /// AUTHOR & DATE
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Author: Alex - Create date: 2024-01-01 12:00'),
                ],
              ),

              const SizedBox(height: 16),

              /// IMAGE
              SizedBox(
                width: double.infinity,
                child: Image.asset('images/sample.jpg', fit: BoxFit.contain),
              ),

              const SizedBox(height: 16),

              /// CONTENT
              const Text(
                'Lake Oeschinen lies at the foot of the Blüemlisalp in the Bernese '
                'Alps. Situated 1,578 meters above sea level, it is one of the '
                'larger Alpine Lakes. A gondola ride from Kandersteg, followed by a '
                'half-hour walk through pastures and pine forest, leads you to the '
                'lake, which warms to 20 degrees Celsius in the summer. Activities '
                'enjoyed here include rowing, and riding the summer toboggan run.'
                'Lake Oeschinen lies at the foot of the Blüemlisalp in the Bernese '
                'Alps. Situated 1,578 meters above sea level, it is one of the '
                'larger Alpine Lakes.',
                softWrap: true,
              ),

              const SizedBox(height: 32),

              /// CATEGORY
              Wrap(
                children: [
                  const Text(
                    'Category: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  _buildLink(
                    text: _category,
                    onPressed: () => _categoryPressed(_category, context),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              /// TAGS
              Wrap(children: _createTags(context)),
            ],
          ),
        ),
      ),
    );
  }

  /// TAG BUILDER
  List<Widget> _createTags(BuildContext context) {
    final List<Widget> tags = [
      const Text('Tags: ', style: TextStyle(fontWeight: FontWeight.bold)),
    ];

    for (int i = 0; i < _tagsData.length; i++) {
      tags.add(
        _buildLink(
          text: i == _tagsData.length - 1 ? _tagsData[i] : '${_tagsData[i]},',
          onPressed: () => _tagPressed(_tagsData[i], context),
        ),
      );

      if (i < _tagsData.length - 1) {
        tags.add(const SizedBox(width: 4));
      }
    }

    return tags;
  }

  /// LINK TEXT WIDGET
  Widget _buildLink({required String text, required VoidCallback onPressed}) {
    return RawMaterialButton(
      constraints: const BoxConstraints(),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.blueAccent,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  /// EVENTS
  void _categoryPressed(String category, BuildContext context) {
    Navigator.pop(context);
  }

  void _tagPressed(String tag, BuildContext context) {
    Navigator.pop(context);
  }
}
