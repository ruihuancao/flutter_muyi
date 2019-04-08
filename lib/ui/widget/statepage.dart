import 'package:flutter/material.dart';

enum PageState { loading, error, empty, content }

class StatePage extends StatefulWidget {
  final Widget loading;
  final Widget error;
  final Widget empty;
  final Widget content;
  final StateController stateController;
  final PageState pageState;
  StatePage(
      {Key key,
      @required this.content,
      StateController controller,
      Widget loading,
      Widget error,
      Widget empty,
      PageState pageState})
      : assert(content != null),
        this.stateController = controller ?? StateController(),
        this.loading = loading ?? DefaultLoadWidget(),
        this.error = error ?? DefaultErrorWidget(),
        this.empty = empty ?? DefaultEmptyWidget(),
        this.pageState = pageState ?? PageState.loading,
        super(key: key);

  @override
  _StatePageState createState() => _StatePageState();
}

class _StatePageState extends State<StatePage> {
  PageState pageState;
  ValueNotifier<PageState> lisenter = ValueNotifier(PageState.loading);

  @override
  void initState() {
    pageState = PageState.loading;
    widget.stateController.pageListenter = lisenter;
    lisenter.addListener(_pageLisenter);
    super.initState();
  }

  void _pageLisenter() {
    if (lisenter.value == PageState.loading) {
      setState(() {
        pageState = PageState.loading;
      });
    } else if (lisenter.value == PageState.error) {
      setState(() {
        pageState = PageState.error;
      });
    } else if (lisenter.value == PageState.empty) {
      setState(() {
        pageState = PageState.empty;
      });
    } else if (lisenter.value == PageState.content) {
      setState(() {
        pageState = PageState.content;
      });
    }
  }

  @override
  void dispose() {
    lisenter.removeListener(_pageLisenter);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (pageState == PageState.loading) {
      return widget.loading;
    } else if (pageState == PageState.empty) {
      return widget.empty;
    } else if (pageState == PageState.error) {
      return widget.error;
    } else if (pageState == PageState.content) {
      return widget.content;
    }
  }
}

class StateController {
  PageState pageState = PageState.loading;

  ValueNotifier<PageState> pageListenter;

  void showError() {
    pageListenter.value = PageState.error;
  }

  void showLoading() {
    pageListenter.value = PageState.loading;
  }

  void showConetent() {
    pageListenter.value = PageState.content;
  }
}

class DefaultErrorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("error"),
      ),
    );
  }
}

class DefaultLoadWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class DefaultEmptyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("empty"),
      ),
    );
  }
}
