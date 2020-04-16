function averages = splineAverageXICs(XICs, times, numReps, numSplines)

[~, numFrags] = size(XICs(1).XICmat);
averages = zeros(numSplines, numFrags);

for rep = 1:numReps
    [numScans, numFrags] = size(XICs(rep).XICmat);
    splineTimes = (times:times(numScans)/numSplines:times(numScans));
    XICs(rep).splines = zeros(numSplines,numFrags);
    for frag = 1:numFrags
        XICs(rep).splines(:,frag) = spline(XICs(rep).time,XICs(rep).XICmat(:,frag),splineTimes);
    end
end

for frag = 1:numFrags
    for rep = 1:numReps
        averages(:,frag) = averages(:,frag) + XICs(rep).splines(:,frag);
    end
    averages(:,frag) = averages(:,frag)./numReps;
end
end