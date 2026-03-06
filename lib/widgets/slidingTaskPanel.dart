import 'package:flutter/material.dart';

//Este widget es un panel deslizable que muestra las tareas pendientes de compra
class Slidingtaskpanel extends StatefulWidget {
  final List<String> purchases;
  final VoidCallback onClear;
  final Function(String) onAddPurchase;
  final bool isOpen; // Para controlar si el panel esta abierto o cerrado

  //Inicializamos el widget con la lista de compras, una funcion para limpiar la lista
  //y una funcion para agregar una compra
  const Slidingtaskpanel({
    super.key,
    required this.purchases,
    required this.onClear,
    required this.onAddPurchase,
    required this.isOpen,
  });

  @override
  State<Slidingtaskpanel> createState() => _SlidingtaskpanelState();
}

class _SlidingtaskpanelState extends State<Slidingtaskpanel> {
  // Controlador de texto para obtener lo que el usuario escribe en el campo de entrada
  final TextEditingController _taskController = TextEditingController();

  // Función interna para manejar la lógica de agregar un ítem
  void _addPurchase() {
    // Solo agregamos si el campo de texto no está vacío
    if (_taskController.text.isNotEmpty) {
      // Llamamos a la función onAddPurchase que nos pasaron desde el widget padre
      widget.onAddPurchase(_taskController.text);
      // Limpiamos el campo de texto después de agregar
      _taskController.clear();
    }
  }

  @override
  void dispose() {
    // Es importante liberar los recursos del controlador cuando el widget se destruye
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Utilizamos AnimatedSlide para lograr el efecto de deslizamiento vertical.
    // El offset controla la posición del widget en base a su propio tamaño.
    // Offset.zero significa que está en su posición original (abierto).
    // Offset(0, 1.5) significa que se desplaza hacia abajo un 150% de su propia altura 
    // asegurando que quede 100% oculto en cualquier dispositivo.
    return AnimatedSlide(
      offset: widget.isOpen ? Offset.zero : const Offset(0, 1.5),
      duration: const Duration(milliseconds: 300), // Duración de la animación (0.3 segundos)
      curve: Curves.easeInOut, // Curva de animación suave al inicio y al final
      child: Container(
        // El panel ocupará la mitad de la altura de la pantalla (50%)
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: const BoxDecoration(
          color: Colors.white,
          // Bordes redondeados solo en la parte superior para dar aspecto de panel tipo "bottom sheet"
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
          // Sombra para dar un efecto de elevación y separarlo del contenido del fondo
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              spreadRadius: 2.0,
            ),
          ],
        ),
        child: Column(
          children: [
            // Handle (manija): Un pequeño indicador visual en la parte superior central
            // que sugiere al usuario que este panel podría ser arrastrable (aunque aquí está controlado por botón)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12.0),
              width: 50.0,
              height: 5.0,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            
            // Cabecera del panel: Título y botón para limpiar toda la lista
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Lista de Compras',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    // Llamamos a la función onClear proporcionada por el widget padre
                    onPressed: widget.onClear,
                    child: const Text('Limpiar', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ),
            
            // Línea divisoria entre la cabecera y el cuerpo de la lista
            const Divider(),
            
            // Área de la lista real de compras. Expanded ocupa todo el espacio restante disponible.
            Expanded(
              // Si la lista está vacía, mostramos un mensaje amistoso
              child: widget.purchases.isEmpty
                  ? const Center(child: Text('No hay compras pendientes'))
                  // Si hay elementos, usamos ListView.builder para crear la lista de forma eficiente en memoria
                  : ListView.builder(
                      itemCount: widget.purchases.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          // Icono de carrito decorativo a la izquierda
                          leading: const Icon(Icons.shopping_cart_outlined, color: Colors.blueGrey),
                          // Texto con el nombre de la compra
                          title: Text(widget.purchases[index]),
                        );
                      },
                    ),
            ),
            
            // Área inferior para agregar nuevas compras (Campo de texto + Botón)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Utilizamos un Expanded para que el TextField ocupe el mayor ancho posible
                  Expanded(
                    child: TextField(
                      controller: _taskController,
                      decoration: InputDecoration(
                        hintText: 'Agregar nueva compra...',
                        // Borde redondeado sutil
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                      // Permite agregar presionando la tecla "Enter" o "Check" en el teclado del móvil
                      onSubmitted: (_) => _addPurchase(),
                    ),
                  ),
                  const SizedBox(width: 8.0), // Espacio entre text field y botón
                  // Botón flotante miniatura para agregar visualmente la tarea
                  FloatingActionButton(
                    mini: true,
                    onPressed: _addPurchase,
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
