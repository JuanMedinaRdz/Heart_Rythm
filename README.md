# Hearth Rythm Dance Academy App

¡Bienvenido a la app de administración de alumnos de la Academia de Baile Hearth Rythm! Este proyecto en Flutter permite gestionar alumnos, filtrar por niveles, horarios, maestros, así como manejar el pago de mensualidades de forma visual e interactiva.

## Capturas de Pantalla

| Pantalla Principal | Detalle del Alumno | Mensualidades |
|--------------------|--------------------|---------------|
| ![Lista de Alumnos](assets/readme/alumnos_main.jpg) | ![Detalle del Alumno](assets/readme/alumnos_detail.jpg) | ![Mensualidades](assets/readme/alumnos_detail.jpg) |

*(Asegúrate de reemplazar las rutas de las imágenes según tu estructura.)*

## Características

- **Lista de Alumnos con filtros:** Filtra por nivel, horario, maestro y nombre.
- **Edición de Datos del Alumno:** Actualiza el nombre, teléfono, nivel, maestro y día asignado.
- **Gestión de Mensualidades:** Visualiza y marca los meses pagados con un diseño innovador (línea de tiempo, tarjetas mensuales, etc.).
- **Animaciones y Haptic Feedback:** Pequeñas animaciones, colores dinámicos y vibración al interactuar, mejorando la experiencia de usuario.
- **Diseño limpio y escalable:** Código organizado en distintas clases y carpetas, siguiendo buenas prácticas.

## Tecnologías Utilizadas

- **Flutter:** Framework de desarrollo UI para múltiples plataformas.
- **Firebase Firestore:** Almacén de datos en la nube, actualizaciones en tiempo real.
- **Lottie:** Animaciones JSON para las pantallas de éxito y transiciones.
- **Dart:** Lenguaje de programación orientado a objetos, simple y potente.


Futuras Mejoras
Implementar selección de año dinámico para las mensualidades.
Añadir más estadísticas y reportes descargables.
Integrar autenticación para diferentes roles (administrador, maestro, alumno).

## Estructura del Código

```bash
lib/
  src/
    core/
      constants/
        app_color.dart
        text_styles.dart
    data/
      models/
        student_model.dart
      repositories/
        student_repository.dart
    features/
      students/
        screens/
          salsa_bachata_screen.dart
          student_detail_screen.dart
          monthly_payment_screen.dart
        widgets/
          edit_student_form.dart
          success_animation_dialog.dart
          month_card.dart
          ...
    widgets/
      north/
        navbar_north_screen.dart
      ...





