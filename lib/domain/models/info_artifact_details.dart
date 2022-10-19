import 'package:tracker/domain/gs_domain.dart';

class InfoArtifactDetails implements IdData {
  final String id;

  InfoArtifactDetails({
    required this.id,
  });

  factory InfoArtifactDetails.fromMap(String id, Map<String, dynamic> map) {
    return InfoArtifactDetails(
      id: id,
    );
  }
}
