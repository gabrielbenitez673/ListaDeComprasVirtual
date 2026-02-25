//aqui ira la clase product
class Product {
  final String id;
  final String title;
  final String quantity;
  final double price;
  final double
  descuentoSegundaUnidad; // descuento para la segunda unidad ej, 0 es sin descuento, 50 es 50% de descuento
  bool
  isPending; // para verificar si el producto esta en la lista de pendientes

  Product({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
    this.descuentoSegundaUnidad = 0.0,
    this.isPending =
        true, // por defecto el producto se considera pendiente hasta que se confirme su compra
  });

  // vamos a convertir un objeto Product a un mapa (serializacion) para facilitar su almacenamiento si es necesario
  //Esto transforma el objeto en un mapa de clave-valor
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'quantity': quantity,
      'price': price,
      'descuentoSegundaUnidad': descuentoSegundaUnidad,
      'isPending': isPending, // Guardamos el estado de pendiente en el mapa
    };
  }

  //Ahora a la inversa, convertir un mapa a un objeto Product (deserializacion)
  //Este es un constructor especial (factory) que recibe el mapa y reconstruye el objeto
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map["id"],
      title: map["title"],
      quantity: map["quantity"],
      price: (map["price"] as num).toDouble(), //Nos aseguramos que sea double
      descuentoSegundaUnidad: (map["descuentoSegundaUnidad"] as num)
          .toDouble(), //Nos aseguramos que sea double
    );
  }
}
