function ATDs = ftIMS(XICs, startFreq, endFreq, sweepTime)

% Set up parameters
sweepRate = (endFreq-startFreq)/(sweepTime*60);
[numSplines, numFrags] = size(XICs(1).avg);
ATDs.td = ((numSplines/(sweepTime*60))*(0:numSplines/2-1)/numSplines)'/sweepRate;
ATDs.ints = zeros(numSplines/2, numFrags);

% Perform FT 
for frag = 1:numFrags
    X = fft(XICs(1).avg(:,frag));
    Xsq = (abs(X(1:length(X)/2))).^2;
    ATDs.ints(:, frag) = Xsq;
end
end