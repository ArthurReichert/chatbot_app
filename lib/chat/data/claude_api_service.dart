import 'dart:convert';

import 'package:http/http.dart' as http;  
  
  /*

  Service class to handle all Claude API stuff...

  */

class ClaudeApiService {

  //API Constants
  static const String _baseUrl = "https://api.anthropic.com/v1/messages";
  static const String _apiVersion = '2023-06-01';
  static const String _model = 'claude-3-opus';
  static const int _maxTokens = 1024;

  // Store the API key securely
  final String _apiKey;

  // Required API key
  ClaudeApiService({required String apiKey}) : _apiKey = apiKey;

  /*

  Send a message to Claude API & return the response

  */

  Future<String> sendMessage(String content) async {
    try{
      // Create a client that accepts all certificates (apenas para desenvolvimento)
      final client = http.Client();
      // Make POST request to Claude API
      final response = await client.post(
        Uri.parse(_baseUrl),
        headers: _getHeaders(),
        body: _getRequestBody(content),
      );

      // Check if request was successful
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body); // parse json response
        return data['content'][0]['text']; // extract claude's response text
      }

      // Handle unsucessful response
      else {
        throw Exception('Failed to get response from Claude: ${response.statusCode}');
      }
    } catch (e) {
      // handle any errors during api call
      throw Exception('API Error $e');
    }
  }

  // create required headers for Claude API
  Map<String, String> _getHeaders() => {
    'Content-Type': 'application/json',
    'anthropic-api-key': _apiKey,
    'anthropic-version': _apiVersion,
  };

  //format request body  according to Claude API specs
  String _getRequestBody(String content) => jsonEncode(
    {
      'model': _model,
      'messages': [
        // format message in Claude1s required structure
        { 'role': 'user', 'content': content }
      ],
      'max_tokens': _maxTokens
    }
  );

}