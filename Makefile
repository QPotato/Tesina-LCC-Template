#
#                              Dale que ya estás
#
#                    . .:.:.:.:. .:\     /:. .:.:.:.:. ,
#                .-._  `..:.:. . .:.:`- -':.:. . .:.:.,'  _.-.
#               .:.:.`-._`-._..-''_...---..._``-.._.-'_.-'.:.:.
#            .:.:. . .:_.`' _..-''._________,``-.._ `.._:. . .:.:.
#         .:.:. . . ,-'_.-''      ||_-(O)-_||      ``-._`-. . . .:.:.
#        .:. . . .,'_.'           '---------'           `._`.. . . .:.
#      :.:. . . ,','               _________               `.`. . . .:.:
#     `.:.:. .,','            _.-''_________``-._            `._.     _.'
#   -._  `._./ /            ,'_.-'' ,       ``-._`.          ,' '`:..'  _.-
#  .:.:`-.._' /           ,','                   `.`.       /'  '  \\.-':.:.
#  :.:. . ./ /          ,','               ,       `.`.    / '  '  '\\. .:.:
# :.:. . ./ /          / /    ,                      \ \  :  '  '  ' \\. .:.:
# .:. . ./ /          / /            ,          ,     \ \ :  '  '  ' '::. .:.
# :. . .: :    o     / /        __________             \ ;'  '  '  ' ':: . .:
# .:. . | |   /_\   : :     ,  ()_________)         ,   : '  '  '  ' ' :: .:.
# :. . .| |  ((<))  | |,        \ ~~~~~~~~ \            |\'__',-._.' ' ||. .:
# .:.:. | |   `-'   | |---....__ \ ~~ LCC ~ \           | ,---\/--/  ' ||:.:.
# ------| |         : :    ,.     \~~~~~~~~~_\ ,        |''  '  '  ' ' ||----
# _...--. |  ,       \ \          ()__________)     ,  /: '  '  '  ' ' ;;..._
# :.:. .| | -O-       \ \    ,.           ,.   `._    / /:'  '  '  ' ':: .:.:
# .:. . | |_(`__       \ \                        `. / / :'  '  '  ' ';;. .:.
# :. . .<' (_)  `>      `.`.          ,.    ,.     ,','   \  '  '  ' ;;. . .:
# .:. . |):-.--'(         `.`-._  ,.           _,-','      \ '  '  '//| . .:.
# :. . .;)()(__)(___________`-._`-.._______..-'_.-'_________\'  '  //_:. . .:
# .:.:,' \/\/--\/--------------------------------------------`._',;'`. `.:.:.
# :.,' ,' ,'  ,'  /   /   /   ,-------------------.   \   \   \  `. `.`. `..:
# ,' ,'  '   /   /   /   /   //                   \\   \   \   \   \  ` `.SSt
#
############
# Makefile #
############
#
# Los bucles while son porque biber quiere que corras pdflatex -> biber -> pdflatex
# para agarrar bien las referencias.
#
# Por el mismo motivo necesitamos hacer clean antes de buildear.


####################################################
# Instrucciones para eliminar el lint o formatter  #
####################################################

# Para eliminar el lint o el formatter, vas a necesitar modificar el comando de build:
# Para Tesis, en el comando pdflatex eliminar format y lint. Es decir, pasar de:
# pdflatex: clean format lint
# a
# pdflatex: clean
#
# Análogo para carta y slides.

# Nombre de tus archivos de Tesis - Slides - Carta, modificar aca si es necesario.
MAINTEX = Tesis
SLIDES = slides
CARTA = carta

RM = rm -f
LATEX = latex
MKLATEX = latexmk -shell-escape
BIB = biber
EXT = *.bak* *.nav *.snm *.ptb *.blg *.log *.lof *.lot *.bit *.idx *.glo *.bbl *.ilg *.toc *.out *.ind *~ *.ml* *.mt* *.th* *.bmt *.xyc *.bcf *.run.xml *.dot *.ptc
LINT = chktex
FORMAT = latexindent -w -s -m -l=.localSettings.yaml
SPELLCHECK = aspell -c -d es -t

.PHONY: latex clean carta slides lint-all format-all format lint spell-check

default: latex

pre-commit: 
	pre-commit install

carta: clean format-carta
	$(MKLATEX) $(CARTA).tex

slides: clean format-slides
	$(MKLATEX) $(SLIDES).tex
	@latex_count=100 ; \
	while egrep -s 'Rerun (LaTeX|to get)' $(SLIDES).log && [ $$latex_count -gt 0 ] ;\
	    do \
	      echo "Rerunning latex...." ;\
	      $(MKLATEX) $(SLIDES).tex ;\
		  sleep 0.5;\
	      latex_count=`expr $$latex_count - 1` ;\
	    done

all: dvi ps lint-all pdflatex slides carta

dvi: clean
	$(LATEX) $(MAINTEX).tex
	$(BIB) $(MAINTEX)
	@latex_count=5 ; \
	while egrep -s 'rerun (LaTeX|to get cross-references right)' $(MAINTEX).log && [ $$latex_count -gt 0 ] ;\
	    do \
	      echo "Rerunning latex...." ;\
	      $(LATEX) $(MAINTEX).tex ;\
	      latex_count=`expr $$latex_count - 1` ;\
	    done

ps: dvi
	dvips -f $(MAINTEX).dvi > $(MAINTEX).ps

latex: clean format
	$(MKLATEX) $(MAINTEX).tex
	$(BIB) $(MAINTEX)
	@latex_count=100 ; \
	while egrep -s 'rerun (LaTeX|to get cross-references right)' $(MAINTEX).log && [ $$latex_count -gt 0 ] ;\
	    do \
	      echo "Rerunning latex...." ;\
	      $(MKLATEX) $(MAINTEX).tex ;\
		  sleep 0.5;\
	      latex_count=`expr $$latex_count - 1` ;\
	    done


biber:
	$(BIB) $(MAINTEX)

lint: 
	$(LINT) $(MAINTEX)

lint-carta:
	$(LINT) $(CARTA)

lint-slides:
	$(LINT) $(SLIDES)

lint-all: lint lint-carta lint-slides

format: clean-format-backup
	for filename in ./Capitulos/*.tex;\
	do \
		$(FORMAT) "$${filename}";\
	done;
	$(FORMAT) $(MAINTEX)

format-slides: clean-format-backup
	for filename in ./Slides/*.tex;\
	do \
		$(FORMAT) "$${filename}";\
	done;
	$(FORMAT) $(SLIDES)

format-carta: clean-format-backup
	$(FORMAT) $(CARTA)

format-all: format format-carta format-slides

clean-format-backup:
	rm -f Capitulos/*.bak*;
	rm -f Slides/*.bak*

clean: clean-format-backup
	$(RM) $(EXT)

clean-all: clean
	$(RM) *.dvi
	$(RM) *.ps
	$(RM) *.pdf

spell-check:
	 $(SPELLCHECK) $(MAINTEX).tex 
	for filename in ./Capitulos/*.tex;\
	do \
		$(SPELLCHECK) "$${filename}";\
	done;

tar: clean
	alias NOMBRE="basename `pwd`";\
	tar -cvjf `NOMBRE`.tar.bz2\
					--exclude "*.bz2"\
					--exclude "*.dvi"\
		--exclude "*.tar.bz2"\
					../`NOMBRE`/ ;\
	unalias NOMBRE

help:
	@echo "    Read the README, list of commands:"
	@echo "    make dvi"
	@echo "    make all           -- dvi ps latex slides carta"
	@echo "    make ps"
	@echo "    make latex         -- default"
	@echo "    make clean"
	@echo "    make clean-all"
	@echo "    make tar"
	@echo "    make slides        -- Prepara las slides"
	@echo "    make lint          -- Lint sobre Tesina" 
	@echo "    make format        -- Format sobre Tesina"
	@echo "    make lint-carta    -- Lint sobre Carta"	
	@echo "    make lint-slides   -- Lint sobre Slides"
	@echo "    make format-carta  -- Format sobre Carta"	
	@echo "    make format-slides -- Format sobre Slides"
			
