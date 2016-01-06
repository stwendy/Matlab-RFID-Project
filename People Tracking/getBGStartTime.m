function bgStartTime=getBGStartTime(bgImages)
     filename=bgImages(1).name;
     filenameWithExtension = strsplit(filename,'.');
     filenameWithoutExtension=strsplit(filenameWithExtension{1},'_');
     
     bgStartTime=str2double(filenameWithoutExtension{2})*3600+ ...
                        str2double(filenameWithoutExtension{3})*60+ ...
                        str2double(filenameWithoutExtension{4});
return