function XICs = makeXICs(spectra, isoMasses, numReps, numPks, ppmTol)
    tol = ppmTol*1E-6;
    numFrags = length(isoMasses);
    for rep = 1:numReps                     % Loop through all replicates
        fprintf('Processing file # %d\n', rep)
        [scans,time] = mzxml2peaks(spectra(rep), 'Levels', 2);
        figure, hold on
        plot(scans{1}(:,1),scans{1}(:,2));
        XICs(rep).time = time;
        numScans = length(scans);
        XICs(rep).XICmat = zeros(numScans, numFrags); % Matrix to store XICs
        pkMat = zeros(numFrags, numPks);
        locMat = zeros(numFrags, numPks);
        %ints = zeros(1,numPks);             % Intensities of each isotope peak
        tic
        for scn = 1:numScans                % Loop through all scans in mzXML 
            fprintf('processing scan # %d of %d in file # %d\n', scn, numScans, rep) 
            for frag = 1:numFrags
                for iso = 1:length(isoMasses(frag).mass)
%                     iso
%                     disp(length(isoMasses(frag).mass))
                    mzRange = find(scans{scn}(:,1) > (isoMasses(frag).mass(iso)-(isoMasses(frag).mass(iso)*tol)) & scans{scn}(:,1) < (isoMasses(frag).mass(iso)+(isoMasses(frag).mass(iso)*tol)));
                    if length(mzRange) < 3  % mzXML files omit m/z ranges without peaks, so if mzRange contains < 3 data points the target peak is not present in this scan
                        %disp('range empty')
                        locMat(frag,iso) = isoMasses(frag).mass(iso);
                        pkMat(frag,iso) = 0; % set intensity value for peak to 0
                        %ints(iso) = 0;      % set intensity value for peak to 0
                    else
                        startmz = min(mzRange)-1; % Index of last m/z value in scan outsied of m/z range
                        [pks, locs] = findpeaks(scans{scn}(min(mzRange):max(mzRange),2)); %find peak in m/z range
                    
                        if length(locs) > 1     % If more than 1 peak found in range
                            [~, ind] = min(abs(scans{scn}(locs+startmz)-isoMasses(frag).mass(iso))); % Find peak closes to observed m/z of target peak
                            locs = locs(ind);   % m/z index of selected peak
                            pks = pks(ind);     % Intesity value of selected peak
                        end
                        if isempty(locs) == 0   % If a peak was found in range
                            locMat(frag,iso) = scans{scn}(locs+startmz); % save m/z index of peak in locMat
                            pkMat(frag,iso) = pks;
                            %ints(iso) = pks;    % save intensity of peak in pkMat
                        else
                            locMat(frag,iso) = scans{scn}(mzRange(ceil(end/2))); % save m/z index as middle of range
                        end
                    end
                end
                if scn == 1
                    plot(locMat(frag,:),pkMat(frag,:),'o') % Plot all peaks for scan 1
                end
                XICs(rep).XICmat(scn,frag) = sum(pkMat(frag,:));       %sum(ints);
            end
        end
        runTime = toc;
        fprintf('Processed %d scans in %d minutes and %d seconds\n\n', numScans, floor(runTime/60), mod(runTime,60))
    end
end