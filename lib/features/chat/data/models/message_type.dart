/// Message Type Enum
///
/// Represents the type of content in a message
enum MessageType {
  text, // Text message
  image, // Image message
}

extension MessageTypeExtension on MessageType {
  String get displayName {
    switch (this) {
      case MessageType.text:
        return 'Text';
      case MessageType.image:
        return 'Image';
    }
  }
}
