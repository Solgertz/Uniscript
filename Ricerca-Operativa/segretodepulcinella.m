function segretodepulcinella()
clear;clc;
dfile ="music.txt";
if exist(dfile, 'file')  
 fileID = fopen(dfile,'r');
 t=1;
 tline = fgetl(fileID);
 count=37;
 while (ischar(tline) && count>0)
     disp(tline);
     tline = fgetl(fileID);
     count=count-1;
 end
 pause(t);
 clc;
 count=37;
 while (ischar(tline) && count>0)
     disp(tline);
     tline = fgetl(fileID);
     count=count-1;
 end
 pause(t);
 clc;
 count=37;
 while (ischar(tline) && count>0)
     disp(tline);
     tline = fgetl(fileID);
     count=count-1;
 end
 pause(t);
 clc;
  count=37;
 while (ischar(tline) && count>0)
     disp(tline);
     tline = fgetl(fileID);
     count=count-1;
 end
 pause(t);
 clc;
 count=37;
 while (ischar(tline) && count>0)
     disp(tline);
     tline = fgetl(fileID);
     count=count-1;
 end
 fclose(fileID);
end

end