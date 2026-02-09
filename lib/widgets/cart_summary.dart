import 'package:flutter/material.dart';
import 'package:shopping_list_app/themes/theme.dart';

/*
En este archivo esta el modulo del subtotal y total de la compra con su
descuento con billetera virtual
*/
class CartSummary extends StatelessWidget {
  final double subtotal;
  final double total;

  //Callback: es una funcion que se ejecuta en la pantalla principal al cambiar
  //el texto
  final Function(String) onDiscountChanged;
  //Callback: para disparar la navegacion al formulario
  final VoidCallback onAddProduct;

  const CartSummary({
    super.key,
    required this.subtotal,
    required this.total,
    required this.onAddProduct,
    required this.onDiscountChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        //Estilizacion del panel inferior (sombra y bordes redondeados)
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.background,
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.percent, size: 20, color: Colors.blueGrey),
                const SizedBox(width: 8),
                const Text("Descuento Billetera Virtual"),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "0",
                        border: OutlineInputBorder(),
                      ),
                      //Importante, Al cambiar el texto, notificamos a la pantalla principal de esto.
                      onChanged: onDiscountChanged,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            // Usamos un widget interno para no repetir el codigo de las filas de precio
            _PriceRow(label: "Subtotal:", value: subtotal, isTotal: false),
            _PriceRow(label: "Total:", value: total, isTotal: true),
            const SizedBox(height: 10),

            //El boton principal para agregar productos
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: onAddProduct,
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text(
                  "Nuevo Producto",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryMint,
                  foregroundColor: AppTheme.white,
                  iconSize: 24,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//widget auxiliar para las filas de subtotal y total, es privado
class _PriceRow extends StatelessWidget {
  final String label;
  final double value;
  final bool isTotal; //Cambia el tamaño y el peso de la fuente si es el total

  const _PriceRow({
    required this.label,
    required this.value,
    required this.isTotal,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? null : AppTheme.textLight,
          ),
        ),
        Text(
          "\$${value.toStringAsFixed(2)}",
          style: TextStyle(
            fontSize: isTotal ? 22 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? null : AppTheme.textLight,
          ),
        ),
      ],
    );
  }
}
