import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../domain/models/character_entity.dart';
import '../../../../../domain/models/extensions/character_ui.dart';
import '../../../../controllers/characters_view_model.dart';
import '../../../../widgets/numeric_spinner.dart';
import '../../../../widgets/star_rating.dart';

/// Bottom sheet para editar um personagem existente
class CharacterEditDialog extends StatefulWidget {
  final Character character;
  final CharactersViewModel viewModel;

  const CharacterEditDialog({
    super.key,
    required this.character,
    required this.viewModel,
  });

  @override
  State<CharacterEditDialog> createState() => _CharacterEditDialogState();
}

class _CharacterEditDialogState extends State<CharacterEditDialog> {
  late final TextEditingController _nameController;

  late CharacterClass _selectedClass;
  late CharacterRarity _selectedRarity;
  late CharacterAlignment _selectedAlignment;
  late int _level;
  late int _attack;
  late int _health;
  late int _threat;
  late int _stars;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final c = widget.character;
    _nameController = TextEditingController(text: c.name);
    _selectedClass = c.characterClass;
    _selectedRarity = c.rarity;
    _selectedAlignment = c.alignment;
    _level = c.level;
    _attack = c.attack;
    _health = c.health;
    _threat = c.threat;
    _stars = c.stars;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('O nome não pode ser vazio.')),
      );
      return;
    }

    setState(() => _isSaving = true);

    final updated = widget.character.copyWith(
      name: name,
      characterClass: _selectedClass,
      rarity: _selectedRarity,
      alignment: _selectedAlignment,
      level: _level,
      attack: _attack,
      health: _health,
      threat: _threat,
      stars: _stars,
      updatedAt: DateTime.now(),
    );

    await widget.viewModel.commands.updateCharacter(updated);

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${updated.name} atualizado com sucesso!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: AppSpacing.paddingMd,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Editar Personagem',
                    style: context.textStyles.titleLarge?.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Nome
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                isDense: true,
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: AppSpacing.lg),

            // Classe
            _SectionLabel(label: 'Classe'),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: CharacterClass.values.map((cls) {
                final selected = _selectedClass == cls;
                return ChoiceChip(
                  avatar: Icon(cls.icon, size: 16, color: cls.color),
                  label: Text(cls.displayName),
                  selected: selected,
                  onSelected: (_) => setState(() => _selectedClass = cls),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Raridade
            _SectionLabel(label: 'Raridade'),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: CharacterRarity.values.map((rarity) {
                final selected = _selectedRarity == rarity;
                return ChoiceChip(
                  label: Text(
                    rarity.displayName,
                    style: TextStyle(color: rarity.color),
                  ),
                  selected: selected,
                  onSelected: (_) => setState(() => _selectedRarity = rarity),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Alinhamento
            _SectionLabel(label: 'Alinhamento'),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: CharacterAlignment.values.map((alignment) {
                final selected = _selectedAlignment == alignment;
                return ChoiceChip(
                  label: Text(alignment.displayName),
                  selected: selected,
                  onSelected: (_) =>
                      setState(() => _selectedAlignment = alignment),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Estrelas
            _SectionLabel(label: 'Estrelas'),
            const SizedBox(height: AppSpacing.sm),
            StarRating(
              stars: _stars,
              size: 28,
              interactive: true,
              onStarsChanged: (v) => setState(() => _stars = v.clamp(1, 14)),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Atributos numéricos
            _SectionLabel(label: 'Atributos'),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.lg,
              runSpacing: AppSpacing.lg,
              children: [
                NumericSpinner(
                  label: 'Level',
                  value: _level,
                  minValue: 1,
                  maxValue: 80,
                  onChanged: (v) => setState(() => _level = v),
                ),
                NumericSpinner(
                  label: 'Ataque',
                  value: _attack,
                  minValue: 0,
                  maxValue: 9999999,
                  step: 1000,
                  onChanged: (v) => setState(() => _attack = v),
                ),
                NumericSpinner(
                  label: 'Vida',
                  value: _health,
                  minValue: 0,
                  maxValue: 9999999,
                  step: 1000,
                  onChanged: (v) => setState(() => _health = v),
                ),
                NumericSpinner(
                  label: 'Ameaça',
                  value: _threat,
                  minValue: 0,
                  maxValue: 9999999,
                  step: 100,
                  onChanged: (v) => setState(() => _threat = v),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            // Botão salvar
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isSaving ? null : _save,
                icon: _isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save),
                label: Text(_isSaving ? 'Salvando...' : 'Salvar alterações'),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: context.textStyles.labelLarge?.withColor(
        Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
