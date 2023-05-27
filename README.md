# Uniscript
Script e programmi creati durante il percorso Universitario


## RICERCA OPERATIVA
### Requisiti LATEX  
(permette di stampare correttamente su un pdf)
- Si raccomanda l'installazione di Tex-live, si può trovare al link : https://www.tug.org/texlive/. Ma va bene anche un qualsiasi installazione di latex, purchè recente. Avviso però che il comando <sub>!pdflatex temp.tex </sub> nel file *stampalatex()* potrebbe non funzionare (non ho testato su altre installazioni)
- In caso doveste installare Tex-live, l'installazione potrebbe durare un paio d'ore (purtroppo), nonostante il programmma in se pesi poco. Quindi armatevi di pazienza
- cambiare il path dell'interpreter di Latex su Mathlab con il comando : <sub> setenv('PATH', ['C:\texlive\2021\bin\win32;' getenv('PATH')]);</sub>
Tale path deve ovviamente puntare alla cartella che contiene i file *pdftlatex.exe* o *latex.exe*, quindi può variare a seconda del sistema operativo o dell'installazione latex (per me era ad esempio *C:\texlive\2023\bin\windows*)
### Requisiti PDF  
-verificare di avere un lettore di pdf e che sia impostato il suo avvio automatico quando si apre un pdf
-il mio consio è quello di usare Firefox e Chrome come lettore, poichè permette lo stacking dei pdf. Ogni volta che avviate uno script, i risultati vengono scritti sempre sullo stesso file temp.pdf, causando il non updating del file se era stato lasciato aperto. In quel caso basterà chiudere la copia che era stata lasciata aperta prima di avviare lo script e riaprire il file manualmente (lo troverete nella stessa directory dove stanno gli script). Nel caso invece che funzioni lo stacking dei files, a ogni avvio di script verrà aperta una nuova pagina sul lettore di pdf, contenente la nuova copia aggiornata
### Requisiti di PATH
-si consiglia di inserire gli script all'interno della cartella standard di Matlab (C:\Users\NOMEUTENTE\Documents\MATLAB) senza creare separare i file in cartelle diverse
### Note
-di norma dopo l'esecuzione di una funzione, nella tab del prompt compariranno una lunga serie di scritte usate da latex. Non è un problema fate come nulla fosse. Tanto i risultati stanno in temp.pdf
-in caso nel prompt compaia una richiesta di input proveniente da Latex, stoppare la compilazione con il tasto rettangolare del debugger
-di norma le funzioni non richiederanno input nel prompt (se lo facessero, stoppate la compilazione). L'unica che lo farà, sarà Hamilton() in modalità asimmetrica
### Lista script completamente funzionanti
-assegnamento() : permette di risolvere il problema di assegnamento (anche il caso di persone che si rifiutano di fare determinati lavori)
-convOdual() : prende in ingresso un sistema e lo converte come richiesto dall'utente (primale standard, duale standard, duale)
-Hemilton() : risolve il problema del TSPS. Se volete provare anche il relativo Brench And Bound togliere il commento dalla riga 296
-zaino() :  permette di risolvere il problema dello zaino
-indagasoluzione() : permette di valutare l'ammissibilità di una base
-simplesso() : applica l'algoritmo del simplesso se possibile
-valPLI() : permette di risolvere tramite valutazioni un problema di PLI e inoltre calcola i tagli di Gomory
### Lista script non testati a sufficienza
- BranchEBound() : permette di fare il branch&bound di un qualsiasi problema
-costoridotto() : permette di calcolare il costo ridotto di un arco
