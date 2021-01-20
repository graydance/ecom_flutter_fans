import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:fans/models/models.dart';
import 'package:fans/screen/components/default_button.dart';
import 'package:fans/store/actions.dart';

class InterestListScreen extends StatefulWidget {
  final void Function() onInit;
  InterestListScreen({this.onInit});

  @override
  _InterestListScreenState createState() => _InterestListScreenState();
}

class _InterestListScreenState extends State<InterestListScreen> {
  List<String> selectedList;

  @override
  void initState() {
    selectedList = [];
    if (widget.onInit != null) widget.onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      onDidChange: (viewModel) {
        if (viewModel.isLoading) {
          EasyLoading.show();
        } else {
          EasyLoading.dismiss();
        }
      },
      builder: (ctx, model) => Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/auth_background.png'),
                fit: BoxFit.cover),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Text(
                    'Tell us about yourself',
                    style: TextStyle(
                        fontSize: 20,
                        color: Color(0xffEA8121),
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white54,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: model.isLoading && model.items.isEmpty
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Column(
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Text(
                                    'Choose at Least 3 Categories',
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: Color(0xffEA9124),
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Expanded(
                                  child: GridView.count(
                                    shrinkWrap: true,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 20,
                                    crossAxisCount: 3,
                                    children: _buildList(model),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: DefaultButton(
                      text: 'Procced To Homepage',
                      press: () {
                        if (selectedList.length < 3) {
                          return;
                        }
                        model.onFinish(selectedList);
                      },
                    ),
                  ),
                  Text(model.error)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildList(_ViewModel model) {
    var items = model.items.map((item) {
      return InterestItem(
          viewModel: item,
          isSelected: (value) {
            setState(() {
              if (value) {
                selectedList.add(item.id);
              } else {
                selectedList.remove(item.id);
              }
            });
          });
    });
    return items.toList();
  }
}

class InterestItem extends StatefulWidget {
  final Interest viewModel;
  final ValueChanged<bool> isSelected;

  InterestItem({Key key, this.viewModel, this.isSelected}) : super(key: key);

  @override
  _InterestItemState createState() => _InterestItemState(viewModel);
}

class _InterestItemState extends State<InterestItem> {
  final Interest viewModel;

  _InterestItemState(this.viewModel);
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
          widget.isSelected(isSelected);
        });
        print('$viewModel isSelected $isSelected');
      },
      child: Center(
        child: Column(
          children: [
            SizedBox(
              width: 60,
              child: Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(60 / 2),
                        child: Container(
                          decoration: BoxDecoration(color: Colors.white54),
                          child: Image(
                            image: NetworkImage(viewModel.interestPortrait),
                            height: 60,
                            width: 60,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                    child: Container(
                      alignment: Alignment.topRight,
                      child: isSelected
                          ? Image.asset('assets/images/interest_selected.png')
                          : Image.asset(
                              'assets/images/interest_unselected.png'),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              viewModel.interestName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Color(0xffEA9124),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ViewModel {
  final bool isLoading;
  final String error;
  final List<Interest> items;
  final Function(List<String>) onFinish;

  _ViewModel(
      {this.isLoading = false,
      this.error = '',
      this.items = const [],
      this.onFinish});

  static _ViewModel fromStore(Store<AppState> store) {
    _onFinish(List<String> selectedIds) {
      store.dispatch(UploadInterestsAction(selectedIds));
    }

    return _ViewModel(
      isLoading: store.state.interests.isLoading,
      error: store.state.interests.error,
      items: store.state.interests.interests,
      onFinish: _onFinish,
    );
  }
}
