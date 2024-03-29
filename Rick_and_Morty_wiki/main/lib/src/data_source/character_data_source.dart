import '../common/errors.dart';
import 'dto/character_detailed_dto.dart';

import 'dto/page_dto.dart';

abstract class CharacterDataSource {
  Future<Both<PageDto>> getPageAsync(int pageNumber);

  Future<Both<CharacterDetailedDto>> getCharacterDetailedAsync(int id);
}
