import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_riverpod/provider/pokemon_data_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../model/pokemon.dart';

class PokemonListTile extends ConsumerWidget {
  final String pokemonUrl;

  late FavoritePokemonProvider _favoritePokemonProvider;
  late List<String> _favoritePokemon;

  PokemonListTile({
    super.key,
    required this.pokemonUrl,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _favoritePokemonProvider = ref.watch(favoritePokemonProvider.notifier);
    _favoritePokemon = ref.watch(favoritePokemonProvider);

    final pokemon = ref.watch(pokemonDataProvider(pokemonUrl));
    return pokemon.when(data: (data) {
      return _tile(context, false, data);
    }, error: (error, stackTrace) {
      return Text('error $error');
    }, loading: () {
      return _tile(context, true, null);
    });
  }

  Widget _tile(
    BuildContext context,
    bool isLoading,
    Pokemon? pokemon,
  ) {
    return Skeletonizer(
      containersColor: Colors.black,
      enabled: isLoading,
      child: ListTile(
        leading: pokemon != null
            ? CircleAvatar(
                backgroundImage: NetworkImage(pokemon.sprites!.frontDefault!),
              )
            : const CircleAvatar(
                child: Icon(Icons.warning),
              ),
        title: Text(pokemon != null
            ? pokemon.name!.toUpperCase()
            : 'currently loading'),
        subtitle: Text('has ${pokemon?.moves?.length ?? 0} moves'),
        trailing: IconButton(
            onPressed: () {
              if (_favoritePokemon.contains(pokemonUrl)) {
                _favoritePokemonProvider.removeFavoritePokemon(pokemonUrl);
              } else {
                _favoritePokemonProvider.addFavoritePokemon(pokemonUrl);
              }
            },
            icon: Icon(
              _favoritePokemon.contains(pokemonUrl)
                  ? Icons.favorite
                  : Icons.favorite_border_outlined,
              color: Colors.red,
            )),
      ),
    );
  }
}
