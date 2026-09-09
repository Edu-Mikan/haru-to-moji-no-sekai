# Arquitectura

## Principios

La aplicación utiliza una arquitectura modular por funcionalidades.

Cada funcionalidad podrá contener las responsabilidades que realmente
necesite:

- `presentation`: pantallas, widgets y estado visual.
- `application`: coordinación de casos de uso.
- `domain`: reglas y modelos independientes de Flutter.
- `infrastructure`: almacenamiento y adaptadores técnicos locales.

No se crearán capas o interfaces sin una necesidad real.

## Regla de dependencias

Las dependencias deben apuntar hacia la lógica:

```text
Presentación
    ↓
Aplicación
    ↓
Dominio
    ↑
Infraestructura local
```
