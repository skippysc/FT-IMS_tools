%% User inputs
baseFileName = '112119 2st Ub 8+ OT120k IIT400_5-5k 15m PD1p2mJ';
numReps = 3;        % number of replicate data sets
ppmTol = 15;        % mass tollerance for each isotope peak in ppm
numPks = 15;        % maximum number of isotope peaks to search for
isoThresh = 0.05;   % intensity threshold for isotope peaks normalized to most abundant peak
numSplines = 1024;  % number of points for cubic spline
startFreq = 5;
endFreq = 5000;
sweepTime = 15;
preMass = 8560.6240;
preCharge = 8;

%% Import fragment lists for all replicates and mzXMLfiles 
data.mz = importSpectra(baseFileName, numReps);
fragments.prosight = importProsight(baseFileName, numReps);

%% Identify fragments in all replicates
if numReps > 1
    fragments.inAll = findInAll(fragments, numReps);
    fprintf('%d fragments were identified in all %d replicates\n', length(fragments.inAll.name), numReps)
else
    fragments.inAll = fragments.prosight
end
%% Generate mass lists for precursor and fragment isotope peaks
disp('Generating isotope mass lists...')
preMz = (preMass + preCharge*1.0078)/preCharge;
preIsos = makeIsoMass(preMz, preMass, 1, isoThresh);
fragments.isoMasses = makeIsoMass(fragments.inAll.mz, fragments.inAll.mass, numPks, isoThresh);
disp('Done')

%% Generate XICs
tic
XICs.pre = makeXICs(data.mz, preIsos, numReps, numPks, ppmTol)
%XICs = makeXICs(data.mz, fragments.inAll.name, fragments.isoMasses, numReps, numPks, ppmTol);
XICs = makeXICs(data.mz, fragments.isoMasses, numReps, numPks, ppmTol);
runTime = toc
fprintf('Processed %d files in %d minutes and %d seconds\n', numReps, floor(runTime/60), mod(runTime,60))

%% Average XICs
if numReps > 1
    disp('Averaging XICs...')
    XICs(1).preAvg = splineAverageXICs(XICs, numReps, numSplines);
    XICs(1).avg = splineAverageXICs(XICs, numReps, numSplines);
    disp('Done')
else
     XICs(1).avg = XICs.XICmat;
end
  

%% Transform XICs and

ATDs = ftIMS(XICs, startFreq, endFreq, sweepTime);

%% Plot ATDs
figure
plot(ATDs.td,ATDs.ints)