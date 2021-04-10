import 'package:interview_app/domain/entities/suggestion.dart';

class SuggestionModel extends Suggestion {
  SuggestionModel({required String description, required String city})
      : super(
          city: city,
          description: description,
        );

  factory SuggestionModel.fromJson(Map<String, dynamic> jsonData) {
    return SuggestionModel(
      description: jsonData['description'],
      city: jsonData['structured_formatting']['main_text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': this.city,
      'description': this.description,
    };
  }
}
