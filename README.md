# proyectomuebleria

App de Flutter para la mueblería.

## Requisitos

| Herramienta | Versión                              |
|-------------|--------------------------------------|
| Flutter     | **3.47.9** (canal stable)            |
| Dart        | 3.13.7 (incluido con Flutter 3.47.9) |

La versión de Flutter del proyecto está fijada en el archivo [`.fvmrc`](.fvmrc).
**Todo el equipo debe usar la misma versión.** Si no, `pubspec.lock` cambia en
cada commit y aparecen errores que solo le pasan a una persona.

Para ver qué versión tienes:

```sh
flutter --version
```

Si dice `Flutter 3.47.9`, puedes saltar a [Primeros pasos](#primeros-pasos).
Si no, instala FVM con los pasos de abajo.

## Usar la misma versión con FVM

[FVM](https://fvm.app) (Flutter Version Management) permite tener varias
versiones de Flutter instaladas y usar una distinta en cada proyecto, sin
cambiar la que tienes instalada globalmente.

### 1. Instalar FVM

```sh
# macOS / Linux (Homebrew)
brew tap leoafarias/fvm
brew install fvm

# Windows (Chocolatey)
choco install fvm

# Cualquier sistema con Dart instalado
dart pub global activate fvm
```

Para comprobar que quedó instalado: `fvm --version`.

### 2. Instalar la versión del proyecto

Desde la raíz del proyecto:

```sh
fvm install   # lee .fvmrc y descarga Flutter 3.47.9
```

### 3. Usar siempre `fvm flutter`

Escribe `fvm flutter` en lugar de `flutter`:

```sh
fvm flutter pub get
fvm flutter run
fvm flutter analyze
fvm flutter test
```

### 4. Configurar el IDE

FVM crea un enlace al SDK en `.fvm/flutter_sdk`.

- **VS Code:** agrega esto en `.vscode/settings.json`:
  ```json
  { "dart.flutterSdkPath": ".fvm/flutter_sdk" }
  ```
- **Android Studio / IntelliJ:** *Settings → Languages & Frameworks → Flutter →
  Flutter SDK path* → elige la ruta absoluta de `.fvm/flutter_sdk` dentro del
  proyecto.

Reinicia el IDE después de cambiar la ruta.

## Primeros pasos

```sh
git clone <url-del-repo>
cd proyectomuebleria
fvm install            # solo si usas FVM
fvm flutter pub get
fvm flutter run
```

(Si tu `flutter` global ya es 3.47.9, puedes quitar el `fvm` de adelante.)

## Estructura del proyecto

El código nuevo se organiza **por funcionalidad (feature)**:

```
lib/
├── common/              # Código compartido entre features
│   └── widgets/
├── features/
│   ├── inicio/
│   │   ├── pagina_inicio.dart
│   │   └── widgets/     # Widgets que solo usa esta feature
│   └── login/
│       ├── constants/
│       ├── login_page.dart
│       └── widgets/
├── tema.dart            # Colores y estilos de texto
└── main.dart
```

- Cada pantalla nueva va en `lib/features/<nombre>/`.
- Si un widget lo usan varias features, va en `lib/common/widgets/`.
- Colores y tipografía se toman de `tema.dart`. No pongas colores escritos a
  mano en los widgets.

## Buenas prácticas de código

- **Nombres descriptivos.** Una variable o función debe decir qué es o qué hace
  sin tener que leer su implementación.
- **Los callbacks empiezan con `al…`** e indican cuándo se llaman. La función que
  se les pasa lleva el verbo de lo que hace:
  ```dart
  TecladoPin(alTocar: tocar, alBorrar: borrar)
  ```
- **Saber cuando los callbacks reciben datos.** Escribe
  `void Function(String digito)` y nombra el parámetro, así queda claro qué
  llega.
- **Documenta con `///`** los widgets, clases o parametros públicos de los widgets. Ese texto
  aparece en el autocompletado del IDE.
- **Widgets pequeños.** Separa en clases (`_MiWidget`) en vez de métodos que
  devuelven widgets, y usa `const` siempre que se pueda.
- **Widgets privados** (`_NombreWidget`) cuando solo se usan dentro de un
  archivo.

## Antes de hacer commit

```sh
fvm flutter analyze    # no debe mostrar problemas
fvm dart format .      # formatea el código
```

## Recursos

- [Documentación de Flutter](https://docs.flutter.dev/)
- [Effective Dart](https://dart.dev/effective-dart)
- [Documentación de FVM](https://fvm.app/documentation)
