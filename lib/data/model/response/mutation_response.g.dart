// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mutation_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MutationResponse _$MutationResponseFromJson(Map<String, dynamic> json) =>
    MutationResponse(
      error: json['error'] as bool,
      message: json['message'] as String,
    );

Map<String, dynamic> _$MutationResponseToJson(MutationResponse instance) =>
    <String, dynamic>{'error': instance.error, 'message': instance.message};
