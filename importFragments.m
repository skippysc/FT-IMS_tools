function fragStruct = importFragments(baseFileName, numFiles)
    %Import fragment lists from ProSight
    for fnum = 1:numFiles
        extension = sprintf(" no%d fragments.xlsx", fnum);
        fileName = strcat(baseFileName, extension);
        [num,txt,raw] = xlsread(fileName);
        fragStruct(fnum).name = txt;
        fragStruct(fnum).mz = num(:,3);
        fragStruct(fnum).mass = num(:,4);
    end
end