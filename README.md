# Uniscript
Script e programmi creati durante il percorso Universitario


RICERCA OPERATIVA
-Requisiti LATEX  -> permette di stampare correttamente su un pdf
            -Si raccomanda l'installazione di Tex-live, si può trovare al link : https://www.tug.org/texlive/. Ma va bene anche un qualsiasi installazione di latex, purchè recente. Avviso però che il comando !pdflatex temp.tex nel file stampalatex() potrebbe non funzionare (non ho testato su altre installazioni)
            -In caso doveste installare Tex-live, l'installazione potrebbe durare un paio d'ore (purtroppo), nonostante il programmma in se pesi poco. Quindi armatevi di pazienza
            -cambiare il path dell'interpreter di Latex su Mathlab con il comando : 
                setenv('PATH', ['C:\texlive\2021\bin\win32;' getenv('PATH')]);
             tale path deve ovviamente puntare alla cartella che contiene i file pdftlatex.exe o latex.exe, quindi può variare a seconda del sistema operativo o dell'installazione latex (per me era ad esempio C:\texlive\2023\bin\windows)
-Requisiti 