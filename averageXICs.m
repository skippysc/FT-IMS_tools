function averages = averageXICs(XICs, numReps)
[numScans, numFrags] = size(XICs(1).XICmat);
averages = zeros(numScans, numFrags);
for frag = 1:numFrags
    for rep = 1:numReps
        averages(:,frag) = averages(:,frag) + XICs(rep).XICmat(:,frag);
    end
    averages(:,frag) = averages(:,frag)./numReps;
end
end