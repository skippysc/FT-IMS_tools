function prosight = importProsight(baseFileName, numFiles)
    %Import fragment lists from ProSight
    for fnum = 1:numFiles
        extension = sprintf(" no%d prosight.xlsx", fnum);
        fileName = strcat(baseFileName, extension);
        %disp(strcat('Importing fragments from: ',fileName))
        [num,txt,raw] = xlsread(fileName);
        prosight(fnum).name = txt;
        prosight(fnum).mz = num(:,3);
        prosight(fnum).mass = num(:,4);
        fprintf('Imported %d fragments from %s\n', length(prosight(fnum).name), fileName)
    end
fprintf('Imported fragment lists from %d files\n', fnum)
end