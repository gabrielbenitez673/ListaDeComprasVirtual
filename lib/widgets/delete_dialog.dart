import 'package:flutter/material.dart';

class DeleteDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  const DeleteDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Eliminar Producto?"),
      content: const Text("Esta accion quitara el producto de tu lista actual"),
      actions: [
        //Boton para cerrar sin hacer nada
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
        //Boton para confirmar
        TextButton(
          onPressed: () {
            onConfirm(); //Primero ejecutamos la logica de borrar
            Navigator.pop(context); //Cerramos el cuadro de dialogo
          },
          child: const Text("Eliminar"),
        ),
      ],
    );
  }
}
