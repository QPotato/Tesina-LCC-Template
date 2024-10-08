# Makefile
#
# Los bucles while son porque biber quiere que corras pdflatex -> biber -> pdflatex
# para agarrar bien las referencias.
#
# Por el mismo motivo necesitamos hacer clean antes de buildear.

MAINTEX = Tesis
SLIDES = slides
CARTA = carta
RM = rm -f
LATEX = latex
PDFLATEX = pdflatex
BIB = biber
EXT = *.nav *.snm *.ptb *.blg *.log *.aux *.lof *.lot *.bit *.idx *.glo *.bbl *.ilg *.toc *.out *.ind *~ *.ml* *.mt* *.th* *.bmt *.xyc *.bcf *.run.xml *.dot *.ptc
LINT = chktex

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
	$(LINT) Tesis.tex

lint-carta:
	$(LINT) carta.tex

lint-slides:
	$(LINT) slides.tex

lint-all: lint lint-carta lint-slides

clean:
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
