import 'package:rick_and_morty_wiki/src/features/character_list/character_events.dart';

class CharacterDetailedEvent extends CharacterEvent {
  CharacterDetailedEvent({required String characterIndex});

  getIndex(characterIndex) {
    return characterIndex;
  }
}