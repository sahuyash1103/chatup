enum MessageEnum {
  text('text'),
  image('image'),
  audio('audio'),
  video('video'),
  gif('gif'),
  file('file'),
  location('location'),
  contact('contact'),
  sticker('sticker');

  const MessageEnum(this.type);

  final String type;
}

extension ConvertMessage on String {
  MessageEnum toMessageEnum() {
    switch (this) {
      case 'audio':
        return MessageEnum.audio;
      case 'image':
        return MessageEnum.image;
      case 'text':
        return MessageEnum.text;
      case 'gif':
        return MessageEnum.gif;
      case 'video':
        return MessageEnum.video;
      case 'file':
        return MessageEnum.file;
      case 'location':
        return MessageEnum.location;
      case 'contact':
        return MessageEnum.contact;
      case 'sticker':
        return MessageEnum.sticker;
      default:
        return MessageEnum.text;
    }
  }
}
