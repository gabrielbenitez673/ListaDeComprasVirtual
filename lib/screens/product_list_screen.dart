import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_list_app/constants/app_strings.dart';
import 'package:shopping_list_app/models/product.dart';
import 'package:shopping_list_app/screens/product_list_form.dart';
import 'package:shopping_list_app/themes/theme.dart';
//creamos nuevos imports de los widgets modularizados
import 'package:shopping_list_app/widgets/delete_dialog.dart';
import 'package:shopping_list_app/widgets/cart_summary.dart';
import 'package:shopping_list_app/widgets/product_card_item.dart';
//Importaremos los paquetes nencesarios para crear las funciones de guardado de datos
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  //Aca creamos las funciones para guardar y cargar los datos usando SharedPreferences

  //Funcion de guardado de datos
  Future<void> _guardarDatos() async {
    final prefs = await SharedPreferences.getInstance();

    //Convertimos la lista de objetos Product a una lista de mapas
    //Luego convertimos esa lista de mapas a una cadena JSON
    final String encodedData = json.encode(
      productList.map((product) => product.toMap()).toList(),
    );
    await prefs.setString("my_shopping_list", encodedData);
    await prefs.setDouble("global_discount", _descuentoPorcentaje);
  }

  //Funcion de carga de datos
  Future<void> _cargarDatos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedData = prefs.getString("my_shopping_list");
    if (savedData != null) {
      //Si hay datos, hacemos el camino inverso:
      //Texto -> Lista de mapas --> Lista de objetos Product
      final List<dynamic> decodedData = json.decode(savedData);

      setState(() {
        productList = decodedData.map((item) => Product.fromMap(item)).toList();
      });
    }
    final double? savedDiscount = prefs.getDouble("global_discount");
    if (savedDiscount != null) {
      setState(() {
        _descuentoPorcentaje = savedDiscount;
      });
    }
  }

  //creamos una variable para almacenar el descuento
  double _descuentoPorcentaje = 0.0;
  //funcion para calcular el subtotal de la compra
  double _calcularSubTotalCompra() {
    double subtotal =
        0.0; //La variable para almacenar el total la inicializamos en 0

    //creamos un ciclo for para recorrer la lista de productos uno por uno
    for (var producto in productList) {
      //convertimos la cantidad y el precio a double y los multiplicamos
      double cant = double.tryParse(producto.quantity) ?? 0.0;

      //declaramos unas variables, para manejar el precio con descuento en la segunda unidad
      double precioUnitario = producto.price;
      double desc2da = producto.descuentoSegundaUnidad;

      //verificamos si el producto tiene descuento en la segunda unidad y la cantidad es mayor o igual a 2
      if (desc2da > 0 && cant >= 2) {
        //calculamos cuantos pares hay
        int pares = cant ~/ 2;

        //calculamos las unidades sueltas (si compra 3, sobra 1)
        double unidadesSueltas = cant % 2;

        // El precio de la SEGUNDA unidad con su descuento aplicado
        double precioSegundaUnidad = precioUnitario * (1 - desc2da / 100);

        // El par es: (1ra unidad normal) + (2da unidad con descuento)
        double totalPorPar = precioUnitario + precioSegundaUnidad;

        //calculamos el subtotal para los pares y las unidades sueltas
        subtotal += (pares * totalPorPar) + (unidadesSueltas * precioUnitario);
      } else {
        //multiplicamos el precio por la cantidad y lo sumamos al total
        subtotal += cant * precioUnitario;
      }
    }
    //devolvemos el total calculado
    return subtotal;
  }

  //funcion para calcular el total de la compra con descuento
  double _calcularTotalCompra() {
    double subtotal = _calcularSubTotalCompra();
    double descuento = subtotal * (_descuentoPorcentaje / 100);
    return subtotal - descuento;
  }

  //funcion para eliminar un producto de la lista
  void _eliminarProducto(int posicion) {
    setState(() {
      productList.removeAt(posicion);
      _guardarDatos(); //Guardamos los datos despues de eliminar
    });
    //mostrar un snackbar para confirmar la eliminacion
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(AppStrings.mensajeProductoEliminado),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _cargarDatos(); //Cargamos los datos al iniciar la pantalla
  }

  List<Product> productList = [];

  //pantalla principal de la app
  @override
  Widget build(BuildContext context) {
    //variables para separar los productos pendientes de los que ya estan en el changuito,
    //esto nos servira para mostrar secciones diferentes en la lista
    final pendientes = productList
        .where((product) => product.isPending)
        .toList();
    final enChanguito = productList
        .where((product) => !product.isPending)
        .toList();

    //aqui construimos la interfaz de la pantalla principal
    return Scaffold(
      backgroundColor: AppTheme.primaryBlue,
      appBar: AppBar(
        title: Text(
          AppStrings.tituloPrincipal,
          style: GoogleFonts.montserrat(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppTheme.primaryMint,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
        ),
      ),
      //aqui consultamos si la lista esta vacia y mostramos un mensaje
      body: productList.isEmpty
          ? Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  AppStrings.mensajeListaVacia,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    color: AppTheme.textDark,
                  ),
                ),
              ),
            )
          //aqui construimos la lista de productos
          : ListView.builder(
              itemCount: productList.length,
              itemBuilder: (context, index) {
                final product = productList[index];

                //Conectamos el widget ProductCardItem
                return ProductCardItem(
                  product: product,
                  onEdit: () => _abrirFormularioEdicion(product, index),
                  onDelete: () => _confirmarEliminacion(index),
                );
              },
            ),

      //Aqui ira el total de la compra que se este realizando
      bottomNavigationBar: CartSummary(
        subtotal: _calcularSubTotalCompra(),
        total: _calcularTotalCompra(),
        onDiscountChanged: (value) {
          setState(() {
            _descuentoPorcentaje = double.tryParse(value) ?? 0.0;
            _guardarDatos(); //Guardamos los datos despues de cambiar el descuento
          });
        },
        onAddProduct: _abrirFormularioNuevo, //Funcion para abrir el formulario
      ),
    );
  }

  //Navegamos a la pantalla del formulario para editar un producto, le pasamos el producto a editar y su indice en la lista
  void _abrirFormularioEdicion(Product product, int index) async {
    final Product? productoEditado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductListForm(productoAEditar: product),
      ),
    );
    if (productoEditado != null) {
      setState(() {
        productList[index] = productoEditado;
        _guardarDatos(); //Guardamos los datos despues de editar
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.mensajeProductoEditado),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  //Funcion para mostrar un dialogo de confirmacion antes de eliminar un producto
  void _confirmarEliminacion(int index) {
    showDialog(
      context: context,
      builder: (context) =>
          DeleteDialog(onConfirm: () => _eliminarProducto(index)),
    );
  }

  //Funcion para abrir el formulario de agregar nuevo producto
  void _abrirFormularioNuevo() async {
    final Product? nuevoProducto = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProductListForm()),
    );
    if (nuevoProducto != null) {
      setState(() {
        productList.add(nuevoProducto);
        _guardarDatos(); //Guardamos los datos despues de agregar
      });
    }
  }
}
