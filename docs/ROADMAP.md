## Hito 1. Definición del producto y base técnica

**Estado:** Completado

### Objetivo

Establecer una base pequeña, robusta y escalable para `haru-to-moji-no-sekai`, evitando incorporar prematuramente Flame, Tiled, audio, KanjiVG o el modelo de validación.

Este hito debe dejar preparado el proyecto Flutter para desarrollar progresivamente:

- la pantalla Home;
- el catálogo de kana;
- el mapa jugable;
- la animación de escritura;
- la práctica guiada;
- la validación visual local;
- el progreso almacenado en el dispositivo.

### Alcance del MVP

El primer MVP estará centrado exclusivamente en las cinco vocales hiragana:

- あ
- い
- う
- え
- お

La aplicación funcionará de forma local y sin conexión.

No utilizará inicialmente:

- backend;
- Render;
- MongoDB;
- cuentas de usuario;
- sincronización remota;
- recopilación de muestras;
- entrenamiento dentro de la aplicación;
- validación basada en el orden o la dirección de los trazos.

La validación se realizará sobre la imagen final dibujada por el usuario mediante un clasificador visual pequeño preparado externamente con datos ETL.

### Flujo principal previsto

El primer recorrido vertical completo será:

1. Mostrar una pantalla Home de presentación.
2. Entrar en el mapa jugable.
3. Desplazar a はる hasta el nodo de あ.
4. Reproducir la animación de escritura de あ.
5. Mostrar あ en gris como guía.
6. Permitir que el niño escriba sobre el lienzo.
7. Generar y normalizar la imagen final.
8. Validar localmente el dibujo contra el carácter esperado.
9. Si es correcto:
   - mostrar una felicitación;
   - registrar el progreso;
   - volver al mapa;
   - permitir avanzar.
10. Si es incorrecto:
    - permitir repetir;
    - permitir salir y volver al mapa.

La reproducción automática de la animación y la aparición de la guía gris serán configurables por ejercicio o nivel.

La pantalla de práctica tendrá dos ayudas configurables:

- reproducir la animación;
- mostrar el carácter en gris.

Ambos botones estarán visibles por defecto, pero podrán ocultarse fácilmente en niveles posteriores.

### Decisiones técnicas

- Flutter como framework principal.
- Android y Web como primeras plataformas configuradas.
- Funcionamiento offline.
- Arquitectura modular por funcionalidades.
- JDK 21 LTS para la compilación Android.
- Android SDK 37.
- Flutter estable.
- Git y GitHub para control de versiones.
- VS Code como editor principal.
- Android Studio como herramienta auxiliar para:
  - Android SDK;
  - emuladores;
  - configuración nativa;
  - diagnóstico de Gradle.
- KanjiVG como fuente local para los datos vectoriales del orden de escritura.
- ETL como fuente principal para preparar el futuro clasificador visual.
- TFLite/LiteRT como opción prevista para integrar el modelo local.
- Flame y Tiled reservados para el mapa cuando el hito correspondiente los necesite.
- Persistencia local para el progreso.
- Audios locales optimizados para las pronunciaciones kana.

### Arquitectura inicial

La aplicación utilizará una arquitectura modular ligera y orientada por funcionalidades.

```text
lib/
├── main.dart
├── app/
│   ├── app.dart
│   ├── assets/
│   └── theme/
└── features/
    ├── home/
    ├── kana_catalog/
    ├── world_map/
    ├── stroke_animation/
    ├── writing_practice/
    ├── writing_validation/
    └── progress/

## Hito 2. Pantalla inicial

- [x] Incorporar la imagen diseñada.
- [ ] Optimizar el formato y tamaño.
- [x] Adaptar la composición a teléfono y navegador.
- [ ] Preparar la futura carga de recursos.
- [ ] Añadir navegación al siguiente destino.
- [x] Definir el catálogo canónico de las cinco vocales.

## Hito 3. Introducción de lectura

- [x] Definir el catálogo canónico de las cinco vocales.
- [x] Mostrar las cinco vocales hiragana.
- [ ] Reproducir su pronunciación local.
- [x] Utilizar botones grandes y accesibles.
- [ ] Preparar los audios grabados por la madre.
- [x] Integrar temporalmente la actividad después de Home.
- [ ] Integrar la actividad como primera parada del mapa.
```

## Flujo canónico del MVP

```text
Home
→ mapa
→ parada pedagógica
→ pantalla de lectura o práctica
```
