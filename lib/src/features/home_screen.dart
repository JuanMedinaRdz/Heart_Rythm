import 'package:flutter/material.dart';
import 'package:hearth_rythm/src/widgets/blobs.dart';
import 'package:hearth_rythm/src/widgets/gradient_button.dart';

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
          Positioned(
            top: -100,
            left: -50,
            child: BlobDecoration()
            ),
          Positioned(
            bottom: -150,
            right: 100,
            child: BlobDecoration()
            ),
          Positioned(
            top: 200,
            right: -120,
            child: BlobDecoration()
            ),
                      Positioned(
            top: 200,
            right: -150,
            child: BlobDecoration()
            ),
            // Contenido Principal
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Titulo 
                    Text(
                      '¡Hola Bienvenido! Elige tu sucursal',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ), 
                    const SizedBox(height: 40,),

                    // Primer boton 
                    GradientButton(
                      text: 'Sucursal Norte', 
                      onPressed: (){
                        // Navegación con go router o context.go
                      }
                      ),

                      const SizedBox(height: 40,),
                      // Segundo Boton 
                                          GradientButton(
                      text: 'Sucursal Norte', 
                      onPressed: (){
                        // Navegación con go router o context.go
                      }
                      ),

                      const SizedBox(height: 40,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('lib/src/core/assets/images/girl_one.png',
                          width: 150,
                          height: 150,
                          ),
                          const SizedBox(width: 20,),
                          Image.asset('lib/src/core/assets/images/girl_two.png',
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