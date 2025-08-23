bool containsEmoji(String text) {
  // Regular expression to detect common emojis
  RegExp emojiRegex = RegExp(
    r'[\u{1F600}-\u{1F64F}]|[\u{1F300}-\u{1F5FF}]|[\u{1F680}-\u{1F6FF}]|[\u{1F900}-\u{1F9FF}]|[\u{2600}-\u{26FF}]|[\u{2700}-\u{27BF}]',
    unicode: true,
  );

  return emojiRegex.hasMatch(text);
}
