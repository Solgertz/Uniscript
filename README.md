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
-per avviare gli script si utilizzi la classe matlabwizard. Ad esempio matlabwizard.simplesso(...).
-si consiglia di utilizzare un massiccio uso del comando TAB nella prompt di matlab per l'autocompletamento del testo e di salvare tra i preferiti dei comandi ricorrenti (premendo la freccia verso l'alto all'interno della prompt si accede a una dashboard con tutti i comandi precedentemente dati e andando col cursore alla sinistra del comando lo si potrà aggiungere ai comandi preferiti in alto)
-di norma dopo l'esecuzione di una funzione, nella tab del prompt compariranno una lunga serie di scritte usate da latex. Non è un problema fate come nulla fosse. Tanto i risultati stanno in temp.pdf (e dovrebbero essere aperti automaticamente con il lettore di pdf predefinito)
-in caso nel prompt compaia una richiesta di input proveniente da Latex, stoppare la compilazione con il tasto rettangolare del debugger
-di norma le funzioni non richiederanno input nel prompt (se lo facessero, stoppate la compilazione). L'unica che lo farà, sarà Hamilton() in modalità asimmetrica
-alcune funzioni, come quello sulla rete capacitata, mostrano i risultati su delle tab plot di Matlab usate apposta per i grafici
-tutti gli script non menzionati in questa lista sono di difficile utilizzo per via degli input richiesti (sono funzioni di utility delle funzioni generali)
-solo e unicamente gli script di Frankwolfe e LKKT sono stati realizzati a partire da algoritmi resi disponibili in (https://github.com/Guray00/IngegneriaInformatica/blob/master/SECONDO%20ANNO/II%20SEMESTRE/Ricerca%20operativa/RicOp.m). Si ringrazia quindi il creatore. 
Tali script sono stati modificati per migliorarne le performance e adattarli alla forma della classe.
### Lista script completamente funzionanti
-Assegnamento() : permette di risolvere il problema di assegnamento (anche il caso di persone che si rifiutano di fare determinati lavori)
-Standardizza() : prende in ingresso un sistema e lo converte come richiesto dall'utente (primale standard, duale standard, duale)
-TSP() : risolve il problema del TSPS e vi applica il BranchAndBound agli archi specificati
-Zaino() :  permette di risolvere il problema dello zaino (intero e binario insieme), 
-TestOttimalit() : permette di valutare l'ammissibilità di una base
-Simplesso() : applica l'algoritmo del simplesso a un problema di PL
-valutazioniPLIeGomory() : permette di risolvere tramite valutazioni un problema di PLI e inoltre calcola i tagli di Gomory
-ReteCapacitata(): permette di risolvere il problema delle reti capacitate (ammissibilità, un passo del simplesso, Dijsktra, Faulk-Falkerson)
-Frank_Wolfe(): permette di applicare l'algoritmo di frank wolfe sia per sistemi sia per punti
-GradienteProiettato(): permette di applicare l'algoritmo del gradiente proiettato 
-LKKTsys(): permette di avere le soluzioni del sistema LKKT

