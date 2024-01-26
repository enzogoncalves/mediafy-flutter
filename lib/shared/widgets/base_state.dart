import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediafy/cubit/cubit_states.dart';
import 'package:mediafy/cubit/cubits.dart';
import 'package:mediafy/modules/handle_errors/no_internet_screen.dart';
import 'package:mediafy/modules/handle_errors/server_error_screen.dart';

class BaseState extends StatefulWidget {
  const BaseState({super.key, required this.body, required this.refresh});

  final Widget body;
  final Function() refresh;

  @override
  State<BaseState> createState() => _BaseStateState();
}

class _BaseStateState extends State<BaseState> {
  final AppCubit _bloc = AppCubit();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
        bloc: _bloc,
        listener: (context, state) {
          if (state is InternetErrorState) {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(snack);
          }
        },
        builder: (_, state) {
          if (state is InternetErrorState) {
            return NoInternetScreen(widget.refresh);
          } else if (state is ServerErrorState) {
            return ServerErrorScreen(
              tmdbError: state.tmdbError,
              parentFunction: widget.refresh,
            );
          } else {
            return widget.body;
          }
        });
  }
}

const snack = SnackBar(
  content: Text("Make sure your device is connected to the Internet"),
  showCloseIcon: true,
  duration: Duration(milliseconds: 10000),
);

dialogBuilder(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => SimpleDialog(title: const Text("You have no Internet"), children: [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        style: TextButton.styleFrom(foregroundColor: Colors.purple),
        child: const Text('Ok'),
      ),
    ]),
  );
}
