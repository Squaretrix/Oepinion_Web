import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oepinion_web/features/dashboard/survey_item.dart';
import 'package:oepinion_web/features/dashboard/survey_provider.dart';

class DashboardPage_Copy extends ConsumerWidget {
  const DashboardPage_Copy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surveys = ref.watch(surveyProvider);

    return Scaffold(
      body: Scrollbar(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              actions: [
                GestureDetector(
                  onTap: () {
                    createSurvey(context, "", "", "");
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: const [
                        Icon(Icons.add),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Neue Umfrage'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SliverPadding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 16,
                top: 32,
              ),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Alle Umfragen',
                  style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            surveys.when<Widget>(
              loading: () {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
              error: (error, _) {
                print(error);
                return const SliverToBoxAdapter();
              },
              data: (data) {
                final surveys = data.docs;

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: SurveyItem(
                            data: surveys[index],
                          ),
                        );
                      },
                      childCount: data.docs.length,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
