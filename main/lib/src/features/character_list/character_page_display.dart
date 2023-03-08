import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../common/error_messages.dart';
import '../../dependencies_config.dart';
import 'character_block.dart';
import 'character_detailed_page_display.dart';
import 'character_events.dart';
import 'character_state.dart';
import '../../entities/character.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CharacterPage extends StatelessWidget {
  late ScrollController _scrollController;

  CharacterBloc? _bloc;

  CharacterPage() {
    _scrollController = ScrollController()
      ..addListener(() {
        //двойная точка - это конструкция
        var extentPosition = _scrollController.position.extentAfter;

        if (extentPosition < 700) {
          _bloc?.add(LoadMoreEvent());
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CharacterBloc>(
      create: (_) => container<CharacterBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.rick_and_morty_wiki),
        ),
        body: BlocBuilder<CharacterBloc, CharacterState>(
          builder: _buildBody,
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, CharacterState state) {
    _bloc = context.read<CharacterBloc>();

    if (state is InitCharacterState) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state is NetworkError) {
      NoConnect noConnect = NoConnect();
      String message = noConnect.getNoConnectMessage();
      return const Center(
        child: Card(
          child: Text('no internet'),
        ),
      );
    } else if (state is CharacterListState) {
      return Column(
        children: <Widget>[
          Expanded(
            child: _buildCharacterList(context, state.character),
            flex: 3,
          ),
          if (state is CharacterNextPageLoading)
            const Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildImage() {
    return Image.asset('assets/images/header_image.png');
  }

  Widget _buildCharacterList(BuildContext context, List<Character> character) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(left: 10, right: 10),
      itemBuilder: (_, index) {
        if (index == 0) {
          return Column(children: [
            Image.asset('assets/images/header_image.png'),
          ]);
        }
        return Card(
          child: ListTile(
            contentPadding:
                EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
            leading: Image.network(character[index - 1].imageUrl),
            title: Text(
                character[index - 1].id.toString() +
                    '. ' +
                    character[index - 1].name,
                style: TextStyle(color: Colors.blueGrey)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      CharacterDetailedPage(character[index - 1].id),
                ),
              );
            },
          ),
        );
      },
      itemCount: character.length,
    );
  }
}
