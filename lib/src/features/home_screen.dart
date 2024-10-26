import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hearth_rythm/src/widgets/blobs.dart';
import 'package:hearth_rythm/src/widgets/gradient_button.dart';
import 'package:hearth_rythm/src/core/constants/text_styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Blobs decorativos
          const Positioned(
              // Blob izquierdo superior
              top: -80,
              left: -120,
              child: BlobDecoration()),
          const Positioned(
              // Blop Derecho inferior
              bottom: -120,
              right: -120,
              child: BlobDecoration()),
          const Positioned(
              // Blob derecho superior
              top: 80,
              right: -140,
              child: BlobDecoration()),
          // Contenido Principal
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Titulo
                  const Text('¡Hola Bienvenido!',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.mainTitle),
                      const SizedBox(height: 20,),
                  const Text('Elige tu sucursal',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.subtitle),

                  const SizedBox(
                    height: 40,
                  ),

                  // Primer boton
                  GradientButton(
                      text: 'Sucursal Norte',
                      onPressed: () {
                        // Navegación con go router o context.go
                       GoRouter.of(context).push('/north_screen');
                      }),

                  const SizedBox(
                    height: 40,
                  ),
                  // Segundo Boton
                  GradientButton(
                      text: 'Sucursal Norte',
                      onPressed: () {
                        // Navegación con go router o context.go
                      }),

                  const SizedBox(
                    height: 40,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'lib/src/core/assets/images/girl_one.png',
                        width: 150,
                        height: 150,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Image.asset(
                        'lib/src/core/assets/images/girl_two.png',
                        width: 150,
                        height: 150,
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
