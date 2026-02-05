# 📸 Flutter Camera & Multimedia App

L'aplicació permet la captura de fotos, gestió de galeria i reproducció d'àudio.

## 🛠️ Configuració del Sistema i Resolució de Problemes
Durant el desenvolupament s'han superat diversos obstacles tècnics crítics:
- **Compatibilitat Java 21:** S'ha ajustat el `build.gradle` per utilitzar Java 17 com a target i Gradle 8.5/AGP 8.2.1 per evitar conflictes amb les versions més noves de l'SDK d'Android.
- **Mode Desenvolupador:** S'ha activat el mode desenvolupador a Windows per permetre la creació de *symlinks* necessaris per a les llibreries de Flutter.
- **Dispositius Xiaomi:** S'han habilitat els permisos de "Instal·lació via USB" i "Ajustos de seguretat" per permetre el desplegament en un terminal POCO/Xiaomi.

---

### Exercici 1: Gestió de la Càmera
- **API Utilitzada:** `camera`.
- **Funcionalitats:**
  - Preview en temps real.
  - Commutació entre càmera frontal i trasera.
  - Control de Flash (On/Off/Torch).
  - Captura d'imatge amb **AlertDialog** informatiu de la ruta temporal.
  - Disseny basat en un `Stack` per superposar el menú de controls sobre la imatge.

### Exercici 2: Persistència i Galeria (Clau: Z80)
- **Objectiu:** Passar de memòria volàtil (`cache`) a permanent.
- **Implementació:**
  - Ús de `path_provider` per gestionar directoris permanents.
  - Integració de la llibreria `gal` per a l'exportació directa al carret del dispositiu.
  - Configuració de permisos d'escriptura a l'`AndroidManifest.xml`.

### Exercici 3: Reproductor Multimèdia
- **API Utilitzada:** `audioplayers`.
- **Funcionalitats:**
  - Reproducció des de `assets`.
  - Controls de Play, Pause i Stop.
  - Barra de progrés (Slider) amb funcionalitat de `seek` (posicionament).
  - Control de velocitat de reproducció (x1 / x2).
  - Botons de salt temporal (+10s / -10s).

---

## 🔑 Paraules Clau de la Pràctica
Les paraules clau identificades en el material per al lliurament són:
1. **Z80** (Persistència/Hardware)
2. **Multimèdia** (Objectiu de l'app)
3. **Chat GPT** (Eina de suport i anàlisi de codi)

---

## 📦 Dependències Principals
```yaml
dependencies:
  camera: ^0.10.6
  audioplayers: ^5.2.1
  gal: ^2.1.0
  path_provider: ^2.1.2
