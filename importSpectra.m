function mzStruct = importSpectra(baseFileName, numReps)
    for fnum = 1:numReps 
        mzFile = strcat(baseFileName, sprintf(" no%d.mzXML", fnum));
        disp(strcat("Importing file: ", mzFile))
        mzStruct(fnum) = mzxmlread(convertStringsToChars(mzFile));
        %[mzStruct.scans, mzStruct.time] = mzxml2peaks(mzStruct, 'Levels', 2);
    end  
    fprintf('Imported %d mzXML files\n', numReps)
end
       