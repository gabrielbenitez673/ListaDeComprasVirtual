import 'package:flutter/material.dart';
import 'package:shopping_list_app/constants/app_strings.dart';

class DeleteDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  const DeleteDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(AppStrings.mensajeConfirmacionEliminacion),
      content: const Text(AppStrings.advertenciaEliminacion),
      actions: [
        //Boton para cerrar sin hacer nada
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(AppStrings.botonCancelar),
        ),
        //Boton para confirmar
        TextButton(
          onPressed: () {
            onConfirm(); //Primero ejecutamos la logica de borrar
            Navigator.pop(context); //Cerramos el cuadro de dialogo
          },
          child: const Text(AppStrings.botonEliminar),
        ),
      ],
    );
  }
}
