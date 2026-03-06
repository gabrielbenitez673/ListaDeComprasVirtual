class AppStrings {
  //Aqui centralizamos todos los textos de la aplicacion para facilitar su mantenimiento y futuras traducciones
  //Pantalla principal
  static const String tituloPrincipal = "Mi Changuito Virtual";
  static const String mensajeListaVacia =
      "Ups.. No hay productos agregados. ¡Agrega productos para empezar a llenar tu changuito!";
  static const String mensajeConfirmacionEliminacion =
      "¿Estás seguro de que deseas eliminar este producto?";
  static const String advertenciaEliminacion =
      "Esta acción no se puede deshacer y el producto se eliminará permanentemente.";
  static const String mensajeProductoEliminado =
      "Producto eliminado con exito!";
  static const String mensajeProductoEditado =
      "Producto editado exitosamente!.";
  //Botones
  static const String botonAgregarProducto = "Agregar Producto";
  static const String botonFinalizarCompra = "Finalizar Compra";
  static const String botonCancelar = "Cancelar";
  static const String botonEliminar = "Eliminar";
  static const String botonCerrar = "Cerrar";

  //CartSummary
  static const String etiquetaDescuento = "Descuento Billetera Virtual";
  static const String subtotalLabel = "Subtotal";
  static const String totalLabel = "Total";
  static const String seccionEnDesarrollo = "¡Sección en desarrollo!";
  static const String seccionEnDesarrolloMensaje =
      "Estamos trabajando en esta sección para ofrecerte una mejor experiencia. ¡Pronto estará disponible!";

  //Seccion de formulario
  static const String tituloFormularioAgregar = "Agregar Nuevo Producto";
  static const String tituloFormularioEditar = "Editar Producto";
  static const String etiquetaNombre = "Nombre del producto, Ej: Leche";
  static const String etiquetaPrecio = "Precio por unidad";
  static const String etiquetaCantidad = "Cantidad de unidades";
  static const String promocionSegundaUnidad = "Promocion en la segunda unidad";
  static const String etiquetaDescuentoSegundaUnidad =
      "Descuento en la segunda unidad (%)";
  static const String tienePromo = "Descuento activo en la 2da unidad";
  static const String noTienePromo = "Sin promociones especiales";
  static const String labelDescuentoSegundaUnidad = "De descuento";
  static const String hintDescuentoSegundaUnidad = "Ej: 50 para 50% menos";
  //Mensajes de validacion del formulario
  static const String mensajeErrorNombre =
      "Por favor ingresa un nombre para el producto";
  static const String mensajeErrorPrecio =
      "Por favor ingresa un precio válido para el producto";
  static const String mensajeErrorCantidad =
      "Por favor ingresa una cantidad válida para el producto";
  static const String mensajeErrorDescuentoSegundaUnidad =
      "Por favor ingresa un descuento válido entre 0 y 100";

  //Sidebar textos
  static const String tituloSidebar = "Historial de Compras Anteriores";
  static const String mensajeSidebarVacio =
      "No hay compras anteriores para mostrar. ¡Realiza tu primera compra para llenar el historial!";
}
