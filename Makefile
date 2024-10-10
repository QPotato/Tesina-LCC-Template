# Makefile
#
# Los bucles while son porque biber quiere que corras pdflatex -> biber -> pdflatex
# para agarrar bien las referencias.
#
# Por el mismo motivo necesitamos hacer clean antes de buildear.

# Nombre de tus archivos de Tesis - Slides - Carta
MAINTEX = Tesis
SLIDES = slides
CARTA = carta

RM = rm -f
LATEX = latex
PDFLATEX = pdflatex
BIB = biber
EXT = *.bak0 *.nav *.snm *.ptb *.blg *.log *.lof *.lot *.bit *.idx *.glo *.bbl *.ilg *.toc *.out *.ind *~ *.ml* *.mt* *.th* *.bmt *.xyc *.bcf *.run.xml *.dot *.ptc
LINT = chktex
FORMAT = latexindent -w -s -m -l=./.localSettings.yaml

default: pdflatex

carta: clean lint-carta
	$(PDFLATEX) $(CARTA).tex

slides: clean lint-slides
	$(PDFLATEX) $(SLIDES).tex
	@latex_count=100 ; \
	while egrep -s 'Rerun (LaTeX|to get)' $(SLIDES).log && [ $$latex_count -gt 0 ] ;\
	    do \
	      echo "Rerunning latex...." ;\
	      $(PDFLATEX) $(SLIDES).tex ;\
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

pdflatex: clean lint
	$(PDFLATEX) $(MAINTEX).tex
	$(BIB) $(MAINTEX)
	@latex_count=100 ; \
	while egrep -s 'rerun (LaTeX|to get cross-references right)' $(MAINTEX).log && [ $$latex_count -gt 0 ] ;\
		do \
			echo "Rerunning latex...." ;\
			$(PDFLATEX) $(MAINTEX).tex ;\
			sleep 0.5;\
				latex_count=`expr $$latex_count - 1` ;\
			done

lint: 
	$(LINT) $(MAINTEX)

lint-carta:
	$(LINT) $(CARTA)

lint-slides:
	$(LINT) $(SLIDES)

lint-all: lint lint-carta lint-slides

format: clean-format-backup
	for filename in ./**/*.tex; \
	do \
		$(FORMAT) "${filename}"; \
	done

format-slides: clean-format-backup
	for filename in ./Capitulos/*.tex
	do
		$(FORMAT) "${filename}"
	done

	$(FORMAT) Capitulos/*.tex

clean-format-backup:
	rm -f Capitulos/*.bak0;
	rm -f Slides/*.bak0

clean: clean-format
	$(RM) $(EXT)

clean-all: clean
	$(RM) *.dvi
	$(RM) *.ps
	$(RM) *.pdf

tar: clean
	alias NOMBRE="basename `pwd`";\
	tar -cvjf `NOMBRE`.tar.bz2\
					--exclude "*.bz2"\
					--exclude "*.dvi"\
		--exclude "*.tar.bz2"\
					../`NOMBRE`/ ;\
	unalias NOMBRE

help:
	@echo "    make dvi"
	@echo "    make all           -- dvi ps pdf slides carta"
	@echo "    make ps"
	@echo "    make pdflatex      -- default"
	@echo "    make clean"
	@echo "    make clean-all"
	@echo "    make tar"
	@echo "    make slides"
	@echo "    make lint"
	@echo "    make format"
