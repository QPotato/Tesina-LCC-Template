# Template Tesina LCC

Este repositorio es una template con el formato basico de LaTeX para una tesina de LCC. 
Esta basada en las tesinas de Martín, Fefo, Fede y Seba. Es una versión en español y con varios ejemplos de cosas que podrían servir.
Parece grande el repo, pero es bastante simple de usar (para lo que es LaTeX), con instalar y correr `make` funciona.

## Cómo recibirme

[Acá está todo](https://dcc.fceia.unr.edu.ar/es/lcc/tesinas-grado), pero step by step:

1. Conseguir director/a y tema.

2. Presentar un plan de tesina:

No la cuelgues, apenas tengas algo de idea es necesario que te aprueben.

Adjunto un documento (EjemploPropuestaTesina.pdf) para que vean qué onda.

3. Hacer el trabajo de la tesina (easy)

4. Escribirla.

No la cuelgues con escribir, toma tieeeempo. 
El repo es para ayudar con eso.

## Instrucciones de Instalación del Latex

- Forkea el repo.

### El camino del bien:
- Instalate [TeX Live](http://tug.org/texlive/) y [biber](http://biblatex-biber.sourceforge.net/) si aun no lo tenés.
- Edita con tu editor favorito. El repo incluye configs para Visual Studio Code (se aceptan PRs con configs/macros para otros editores).

#### Opcionales:

- Instalar [Chktex](https://ctan.org/pkg/chktex?lang=en) para correr el lint
- Instalar [Latex Indent](https://github.com/cmhughes/latexindent.pl) para correr el autoformatter
- Instalar Pre-commit - `sudo apt-get install pre-commit` para tener el pre-commit

### El camino del mal: 
- `sudo apt-get install texlive-full` y ya tenés todo (es pesado, pero Seba recomienda el camino del mal para no sufrir)

#### Opcional:
- `sudo apt-get install pre-commit` - Pre-commit.

## Instrucciones de uso

- `make pre-commit`: Prepara pre-commit (solo la primera vez)
- `make`: **Básicamente corrés esto y anda solo**. Buildea TODO la tesis (arma el .pdf, .dvi, .ps). Es medio quilombo el make porque tiene que correr varias veces para que biber agarre bien las referencias.

### Otros:
- `make clean`: Limpia la carpeta
- `make carta` / `make slides`: Crean el .pdf de la carta / slides.
- `make lint` / `make lint-carta` / `make lint-slides`: Corre el lint en la Tesina / Carta / Slides.
- `make format` / `make format-carta` / `make format-slides`: Formatea tus archivos.
- `make spell-check`: Chequea errores ortográficos (el diccionario es solo español, se puede cambiar).

## Organización de archivos

### Archivos

- **Tesis.tex** : este es el archivo central de la tesina, el cual importa las configuraciones (settings.mem.tex), la caratula (titulo.tex), el resumen (resumen.tex), los agradecimientos (gracias.tex) y luego importara los diferentes capítulos.

- **settings.mem.tex** : aquí se encuentran todos los paquetes y configuraciones necesarias, para dejar lo más limpio posible a Tesis.tex

- **titulo.tex** : La caratula.

- **resumen.tex** y **gracias.tex** : Resumen y agradecimientos.

- **slides.tex** : Archivo central de las slides para la defensa de la tesina. 

- **carta.tex** : Carta para presentar la tesis y solicitar la defensa

- **citas.bib** : Citas bibliografica con detalles y label para referenciarlas en al tesina

- **xpdfwithnotes** : Un script de Martin para hacer la presentacion de las slides usando xpdf que permite abrir sesiones remotas y navegar desde la terminal.

### Carpetas

- **Capitulos/** : archivos separados para cada capitulo

- **Imgs/** : Imagenes

- **Slides/** : archivos referentes a las Slides

- **Tablas** : tablas, obviamente.

## Modificar Lint - Formatter - Pre-commit: 

### Lint 

Para lint este repositorio usa `Chktex`.
Para modificar las reglas, referirse a `.chktexrc`.
Es opcional, excepto que agregues el precommit (para forzarlo para los commits).
El lint encuentra errores de Latex que capaz se van a ver raros, no es tan estricto.
Se puede ignorar al agregar un comentario `% chktex 38` ignora la regla 38 en esa linea.

### Formatter

Como Formatter, este repo usa `latexindent`. 
Para modificar las reglas de formateo, ver `.localSettings.yaml`
Para cancelar el formatter, modificar el Makefile (instrucciones adentro).

### Pre-commit hooks

El pre-commit hook corre el Formatter y el Lint. 
Es equivalente a lo que corre en el Lint en Github-actions. 
Para evitar los pre-commit hooks, remover `.pre-commit-config.yaml`

## Contribuciones

- Fede Badaloni, que hizo el original del que hago el fork.
- [@ZimmSebas](https://github.com/ZimmSebas)
- Vos, próximamente ;)
