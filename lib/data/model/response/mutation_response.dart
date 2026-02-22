import 'package:json_annotation/json_annotation.dart';

part 'mutation_response.g.dart';

@JsonSerializable()
class MutationResponse {
  final bool error;
  final String message;

  MutationResponse({required this.error, required this.message});

  factory MutationResponse.fromJson(Map<String, dynamic> json) =>
      _$MutationResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MutationResponseToJson(this);
}
