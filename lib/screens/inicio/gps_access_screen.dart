import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rowing_app/blocs/blocs.dart';

class GpsAccessScreen extends StatelessWidget {
  const GpsAccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<GpsBloc, GpsState>(
          builder: (context, state) {
            return (!state.isGpsEnabled)
                ? const _EnableGpsMessage()
                : const _AccessButton();
          },
        ),
      ),
    );
  }
}

//--------------- _AccessButton ---------------
class _AccessButton extends StatelessWidget {
  const _AccessButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Debe habilitar el Permiso de GPS'),
        MaterialButton(
          color: Colors.black,
          shape: const StadiumBorder(),
          elevation: 0,
          splashColor: Colors.transparent,
          onPressed: () {
            final gpsBloc = BlocProvider.of<GpsBloc>(context);
            gpsBloc.askGpsAccess();
          },
          child: const Text(
            'Solicitar Permiso',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

//--------------- _EnableGpsMessage ---------------
class _EnableGpsMessage extends StatelessWidget {
  const _EnableGpsMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Debe habilitar la Ubicación',
      style: TextStyle(
        color: Colors.black,
        fontSize: 25,
        fontWeight: FontWeight.w300,
      ),
    );
  }
}
