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
verificare di avere un lettore di pdf e che sia impostato il suo avvio automatico quando si apre un pdf
### Note
-di norma dopo l'esecuzione di una funzione, nella tab del prompt compariranno una lunga serie di scritte usate da latex. Non è un problema fate come nulla fosse. Tanto le informazioni utili stanno in temp.pdf
-in caso nel prompt compaia una richiesta di input proveniente da Latex, stoppare la compilazione con il tasto rettangolare
-di norma le funzioni non richiederanno input nel prompt (se lo facessero, stoppate la compilazione). L'unica che lo farà, sarà Hamilton() in modalità asimmetrica