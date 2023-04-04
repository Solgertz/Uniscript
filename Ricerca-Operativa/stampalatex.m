function [] = stampalatex(stringa)
%crea un documento pdf in latex e lo apre in autonomia
%richiamando più volte con lo stesso script, si sovrascrive il file
%tutte le librerie necessarie sono già definite


%INPUT:
%-stringa: è il contenuto da scriverci

%permette di chiudere in automatico il pdf non aggiornato se già aperto sul
%desktop
editor = matlab.desktop.editor.getActive;
if ~isempty(editor) && strcmp(editor.Filename, 'temp.pdf')
    close('temp.pdf');
end


dfile ="temp.tex";
if exist(dfile, 'file')  
    delete(dfile); 
end

diary(dfile);
disp("\documentclass[]{article}"+...
      "\usepackage{multirow}"+...
"\usepackage{amsmath}"+...
"\usepackage{amssymb}"+...
"\usepackage{hyperref}"+...
"\usepackage{blindtext}"+...
"\usepackage{graphicx}"+...
"\usepackage[table,dvipsnames]{xcolor}"+...
"\usepackage{float}"+...
      "\begin{document} "+ stringa +...
        " \end{document}");

diary off
    % creo pdf
!pdflatex temp.tex




%ELIMINO FILE INUTILI UTILI SOLO PER LA COMPILAZIONE
        %elimino .tex
if exist(dfile, 'file')  
    delete(dfile); 
end

    %elimino .log
if exist("temp.log", 'file')  
    delete("temp.log"); 
end

    %elimino .aux
if exist("temp.aux", 'file')  
    delete("temp.aux"); 
end

    %elimino .out
if exist("temp.out", 'file')  
    delete("temp.out"); 
end

%apre in automatico il file
if exist("temp.pdf",'file')
    open("temp.pdf"); 
end


end