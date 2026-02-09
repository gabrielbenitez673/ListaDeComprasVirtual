import 'package:flutter/material.dart';
import 'package:shopping_list_app/models/product.dart';
import 'package:shopping_list_app/themes/theme.dart';

class ProductListForm extends StatefulWidget {
  final Product? productoAEditar; // Parametro opcional para editar
  const ProductListForm({super.key, this.productoAEditar});

  @override
  State<ProductListForm> createState() => _ProductListFormState();
}

class _ProductListFormState extends State<ProductListForm> {
  // Variables para la promoción de la segunda unidad
  bool _tienePromocionSegundaUnidad = false;
  final _promoController = TextEditingController();

  // Clave para el formulario
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controladores para los campos
  late TextEditingController _nombreController;
  late TextEditingController _cantidadController;
  late TextEditingController _precioController;

  @override
  void initState() {
    super.initState();
    //Cargamos si estamos editando un producto, de lo contrario dejamos los campos vacios
    _nombreController = TextEditingController(
      text: widget.productoAEditar?.title ?? '',
    );
    _cantidadController = TextEditingController(
      text: widget.productoAEditar?.quantity ?? '',
    );
    _precioController = TextEditingController(
      text: widget.productoAEditar != null
          ? widget.productoAEditar!.price.toStringAsFixed(2)
          : '',
    );
    //Si el producto tiene descuento, activa el switch y llena el campo
    if (widget.productoAEditar != null &&
        widget.productoAEditar!.descuentoSegundaUnidad > 0) {
      _tienePromocionSegundaUnidad = true;
      _promoController.text = widget.productoAEditar!.descuentoSegundaUnidad
          .toString();
    }
  }

  @override
  // Esta funcion se ejecuta cuando se destruye el widget
  //y sirve para liberar recursos ocupados por los controladores
  void dispose() {
    // Es buena práctica limpiar los controladores (para evitar fugas de memoria)
    _nombreController.dispose();
    _cantidadController.dispose();
    _precioController.dispose();
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //creamos una variable para verificar si el teclado esta visible
    return Scaffold(
      backgroundColor: AppTheme.primaryBlue,
      appBar: AppBar(
        title: Text(
          widget.productoAEditar != null
              ? "Editar Producto"
              : "Agregar Nuevo Producto",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppTheme.primaryMint,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
        ),
      ),
      // El Form envuelve al Scaffold o al body para gestionar las validaciones
      body: Center(
        child: Card(
          elevation: 10,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ), // Espacio para que el botón no tape el final
              child: Column(
                children: [
                  // Campo Nombre
                  TextFormField(
                    controller: _nombreController,
                    decoration: const InputDecoration(
                      hintText: "Nombre Del Producto",
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.label_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Ingrese un nombre';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  const Divider(height: 1),
                  // Campo Cantidad
                  TextFormField(
                    controller: _cantidadController,
                    decoration: const InputDecoration(
                      hintText: "Cantidad",
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.inventory_2_outlined),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null ||
                          int.tryParse(value) == null ||
                          int.parse(value) <= 0) {
                        return 'Ingrese una cantidad válida';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  const Divider(height: 1),
                  // Campo Precio
                  TextFormField(
                    controller: _precioController,
                    decoration: const InputDecoration(
                      hintText: "Precio",
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.savings_outlined),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (value) {
                      if (value == null ||
                          double.tryParse(value) == null ||
                          double.parse(value) <= 0) {
                        return 'Ingrese un precio válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  const Divider(height: 1),

                  //apartado de promocion en la segunda unidad
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        //Parte 1: interruptor de promocion
                        SwitchListTile(
                          title: const Text("Promocion En Segunda Unidad"),
                          subtitle: Text(
                            _tienePromocionSegundaUnidad
                                ? "Descuento activo en la 2da unidad"
                                : "Sin promociones especiales",
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.textLight,
                            ),
                          ),
                          value: _tienePromocionSegundaUnidad,
                          onChanged: (bool value) {
                            setState(() {
                              _tienePromocionSegundaUnidad = value;
                              //aqui en este if limpiamos si se apaga
                              if (!value) _promoController.clear();
                            });
                          },
                        ),
                        //Parte 2: El campo (Que solo aparece si el switch da true)
                        if (_tienePromocionSegundaUnidad)
                          //Creamos un Divider con una linea para separar
                          const Divider(height: 1, indent: 15, endIndent: 15),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextFormField(
                            controller: _promoController,
                            decoration: const InputDecoration(
                              labelText: "De Descuento en la 2da unidad",
                              hintText: "Ej: 50",
                              prefixIcon: Icon(Icons.percent, size: 18),
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (_tienePromocionSegundaUnidad &&
                                  (value == null || value.isEmpty)) {
                                return "Indique el porcentaje de descuento";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      // Boton para Guardar el Producto
      // Usamos bottomNavigationBar para que el botón esté siempre fijo abajo
      bottomNavigationBar: MediaQuery.of(context).viewInsets.bottom != 0.0
          ? const SizedBox.shrink() // Si el teclado está abierto, ocultamos el panel para liberar espacio visual
          : Container(
              margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: 20,
              ),
              decoration: BoxDecoration(
                color: AppTheme
                    .background, // Fondo blanco: unifica el estilo con el panel de totales de la pantalla principal
                // Bordes redondeados arriba para dar sensación de "panel deslizable"
                borderRadius: BorderRadius.circular(30),
              ),
              child: SafeArea(
                // SafeArea: Protege el botón en dispositivos sin marcos (como iPhone o nuevos Android)
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add_shopping_cart, size: 24),
                  label: Text(
                    widget.productoAEditar != null
                        ? "Editar Producto"
                        : "Agregar Producto",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  onPressed: () {
                    // 1. Primero validamos el formulario
                    if (_formKey.currentState!.validate()) {
                      // 2. Creamos UN SOLO objeto producto que servirá para ambos casos (Nuevo o Editar)
                      final productoAEnviar = Product(
                        // CLAVE: Si productoAEditar existe, usamos su ID original. Si no, creamos uno nuevo.
                        id:
                            widget.productoAEditar?.id ??
                            DateTime.now().toString(),
                        title: _nombreController.text,
                        quantity: _cantidadController.text,
                        price: double.tryParse(_precioController.text) ?? 0.0,
                        // Solo guardamos el descuento si el interruptor está activo
                        descuentoSegundaUnidad: _tienePromocionSegundaUnidad
                            ? (double.tryParse(_promoController.text) ?? 0.0)
                            : 0.0,
                      );

                      // 3. Devolvemos el producto (ya sea editado o nuevo)
                      Navigator.pop(context, productoAEnviar);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        AppTheme.primaryMint, //Color de fondo del boton
                    foregroundColor: AppTheme.white,
                    minimumSize: const Size(
                      double.infinity,
                      55,
                    ), // double.infinity hace que el botón ocupe todo el ancho del panel
                    elevation:
                        5, // Quitamos la sombra propia del botón para que se vea plano y moderno sobre el panel blanco
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
