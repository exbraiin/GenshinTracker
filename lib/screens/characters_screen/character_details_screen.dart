import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/utils.dart';
import 'package:tracker/common/widgets/file_image.dart';
import 'package:tracker/common/widgets/gs_app_bar.dart';
import 'package:tracker/common/widgets/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';

class CharacterDetailsScreen extends StatelessWidget {
  static const id = 'character_details_screen';

  CharacterDetailsScreen();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final info = args as InfoCharacter?;
    return ValueStreamBuilder<bool>(
      stream: GsDatabase.instance.loaded,
      builder: (context, snapshot) {
        if (!snapshot.data! || info == null) return SizedBox();
        final db = GsDatabase.instance.saveCharacters;
        final ascension = db.getCharAscension(info.id);
        return Scaffold(
          appBar: GsAppBar(
            label: info.name,
          ),
          body: ListView(
            padding: EdgeInsets.all(kSeparator4),
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 160,
                    child: CachedImageWidget(info.image),
                  ),
                  SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              info.name,
                              style: Theme.of(context).textTheme.bigTitle2,
                            ),
                            SizedBox(width: 8),
                            Image.asset(
                              info.element.assetPath,
                              width: 36,
                              height: 36,
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () => db.increaseAscension(info.id),
                          child: Text(
                            '${'✦' * ascension}${'✧' * (6 - ascension)}',
                            style: context.textTheme.bigTitle3,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class InfoCharacterDetails extends IdData {
  final String id;

  InfoCharacterDetails({
    required this.id,
  });
}

/*
import 'dart:convert';
import 'dart:io';
Future<InfoCharacterDetails> _getCharacterDetails(String id) async {
  final file = File('db/info/characters/$id.json');
  if (!await file.exists()) return InfoCharacterDetails(id: '');

  final data = jsonDecode(await file.readAsString());

  return InfoCharacterDetails(
    id: id,
  );
}
*/