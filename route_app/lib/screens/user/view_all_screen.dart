import 'package:accesible_route/bloc/places/places_bloc.dart';
import 'package:accesible_route/bloc/places/places_state.dart';
import 'package:accesible_route/generated/l10n.dart';
import 'package:accesible_route/models/place_model.dart';
import 'package:accesible_route/utils/darkmode_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'place_screen.dart';

class ViewAllScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = ThemeUtils.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).user_allview_screen_title),
        backgroundColor: isDarkMode
            ? Theme.of(context).scaffoldBackgroundColor
            : Colors.white,
      ),
      backgroundColor:
          isDarkMode ? Theme.of(context).scaffoldBackgroundColor : Colors.white,
      body: BlocBuilder<PlacesBloc, PlacesState>(
        builder: (context, state) {
          if (state is PlacesLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is PlacesFailure) {
            return Center(child: Text(state.error));
          } else if (state is PlacesSuccess) {
            List<Place> places = state.places;
            return GridView.builder(
              padding: EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.75,
              ),
              itemCount: places.length,
              itemBuilder: (context, index) {
                final place = places[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PlaceScreen(placeIndex: place.key),
                      ),
                    );
                  },
                  child: Card(
                    color: isDarkMode ? Colors.grey[800] : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    elevation: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AspectRatio(
                          aspectRatio: 1.5,
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(16.0),
                            ),
                            child: Image.network(
                              place.imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/template.png',
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            place.titleTr,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: isDarkMode ? Colors.white : Colors.black87,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            place.contentTr,
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  isDarkMode ? Colors.grey[400] : Colors.grey,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}
