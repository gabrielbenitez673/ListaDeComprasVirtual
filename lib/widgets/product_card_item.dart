import 'package:flutter/material.dart';
import 'package:shopping_list_app/themes/theme.dart';
import 'package:shopping_list_app/models/product.dart';

/*
Este modulo contiene el producto creado y mostrado en la pantalla principal.
con todos sus atributos.
*/
class ProductCardItem extends StatelessWidget {
  final Product product; //Recibe el objeto completo para mostrar los datos
  final VoidCallback
  onEdit; //Accion para cuando tocan el boton azul (en desarrollo)
  final VoidCallback onDelete; //Accion para cuando tocan el boton rojo
  const ProductCardItem({
    super.key,
    required this.product,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        title: Text(
          product.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          //logica del texto: Si tiene promo, muestra el porcentaje; sino solo cantidad y precio
          "Cant: ${product.quantity} - Precio: \$${product.price.toStringAsFixed(2)}"
          "${product.descuentoSegundaUnidad > 0 ? " (Promo 2da: ${product.descuentoSegundaUnidad.toStringAsFixed(0)}%)" : ""}",
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              //Ejecuta la funcion pasada por parametro (en este caso editar)
              onPressed: onEdit,
              icon: const Icon(
                Icons.edit_outlined,
                color: AppTheme.primaryMint,
              ),
            ),
            IconButton(
              //Ejecuta la funcion pasada por parametro (en este caso eliminar)
              onPressed: onDelete,
              icon: Icon(Icons.delete_outline, color: AppTheme.accentCoral),
            ),
          ],
        ),
      ),
    );
  }
}
