import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_list_app/constants/app_strings.dart';
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
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 16),
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
                Text(
                  AppStrings.etiquetaDescuento,
                  style: GoogleFonts.montserrat(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintStyle: GoogleFonts.montserrat(
                          fontSize: 13,
                          color: AppTheme.textLight,
                        ),
                        hintText: "1 al 100",
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(8),
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
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 1),
                    child: SizedBox(
                      height: 55,
                      child: ElevatedButton.icon(
                        onPressed: onAddProduct,
                        icon: const Icon(Icons.add_shopping_cart),
                        label: Text(
                          AppStrings.botonAgregarProducto,
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
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
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: SizedBox(
                      height: 55,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text(
                                  AppStrings.seccionEnDesarrollo,
                                ),
                                content: const Text(
                                  AppStrings.seccionEnDesarrolloMensaje,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text(AppStrings.botonCerrar),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.payment),
                        label: Text(
                          AppStrings.botonFinalizarCompra,
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentCoral,
                          foregroundColor: AppTheme.white,
                          iconSize: 24,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
          style: GoogleFonts.montserrat(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? null : AppTheme.textLight,
          ),
        ),
        Text(
          "\$${value.toStringAsFixed(2)}",
          style: GoogleFonts.montserrat(
            fontSize: isTotal ? 22 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? null : AppTheme.textLight,
          ),
        ),
      ],
    );
  }
}
