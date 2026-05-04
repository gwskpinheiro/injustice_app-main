import 'character_entity.dart';

class CharacterMapper {
  static Map<String, dynamic> toMap(Character character) {
    return {
      'id': character.id,
      'name': character.name,
      'characterClass': character.characterClass.name,
      'rarity': character.rarity.name,
      'level': character.level,
      'threat': character.threat,
      'attack': character.attack,
      'health': character.health,
      'stars': character.stars,
      'alignment': character.alignment.name,
      'createdAt': character.createdAt.toIso8601String(),
      'updatedAt': character.updatedAt.toIso8601String(),
    };
  }

  static Character fromMap(Map<String, dynamic> map) {
    return Character(
      id: map['id'] as String,
      name: map['name'] as String,
      characterClass: CharacterClass.values.byName(
        (map['characterClass'] as String?) ?? CharacterClass.poderoso.name,
      ),
      rarity: CharacterRarity.values.byName(
        (map['rarity'] as String?) ?? CharacterRarity.prata.name,
      ),
      level: (map['level'] as int?) ?? 1,
      threat: (map['threat'] as int?) ?? 0,
      attack: (map['attack'] as int?) ?? 0,
      health: (map['health'] as int?) ?? 0,
      stars: (map['stars'] as int?) ?? 1,
      alignment: CharacterAlignment.values.byName(
        (map['alignment'] as String?) ?? CharacterAlignment.heroi.name,
      ),
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(map['updatedAt'] as String? ?? '') ?? DateTime.now(),
    );
  }
}
