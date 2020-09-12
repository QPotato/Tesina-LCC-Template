# Template Tesina LCC

Este repositorio es una template con el formato basico de LaTeX para una tesina de LCC. Esta basada en la tesina de Martín, pero pasada a español.

## Instrucciones

- Forkea el repo.
- Instalate [TeX Live](http://tug.org/texlive/) y [biber](http://biblatex-biber.sourceforge.net/) si aun no lo tenés.
- Edita con tu editor favorito.
- Buildea la tesis con `make` (arma la tesis con pdf, dvi, ps). Es medio quilombo el make porque tiene que correr varias veces para que biber agarre bien las referencias.
- Podes limpiar la carpeta con `make clean`

## Archivos

- Tesis.tex : este es el archivo central de la tesina, el cual importa las configuraciones (settings.mem.tex), la caratula (titulo.tex), el resumen (resumen.tex), los agradecimientos (gracias.tex),
y luego importara los diferentes capítulos.

- settings.mem.tex : aquí se encuentran todos los paquetes y configuraciones necesarias, para dejar lo más limpio posible a Tesis.tex

- titulo.tex : la caratula...

- resumen.tex y gracias.tex : resumen y agradecimientos.

- slides.tex: las slides para la defensa de la tesina

- citas.bib: citas bibliografica con detalles y label para referenciarlas en al tesina

- carta.tex: carta para presentar la tesis y solicitar la defensa

- xpdfwithnotes: un script de Martin para hacer la presentacion de las slides usando xpdf que permite abrir sesiones remotas y navegar desde la terminal.

- Capitulos/: archivos separados para cada capitulo

- Imgs/: imagenes

- Tablas: tablas, obviamente.

## Contribuciones

Soy horrible con LaTeX. Se aceptan PRs para mejorar esta template.
