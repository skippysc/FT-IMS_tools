function isoMasses = makeIsoMass(fragMz, fragMass, numPks, isoThresh)
    z = round(fragMass ./ fragMz)
    for frag = 1:length(fragMass)
        isoBoo = mass2dist(fragMass(frag),numPks) > isoThresh;
        pkNum = 1;
        for iso = 1:numPks
            if isoBoo(iso) > 0
                isoMasses(frag).mass(pkNum) = fragMz(frag) + ((iso-1)*(1/z(frag)));
                pkNum = pkNum+1;
            end
        end
    end   
isoMasses;
end
