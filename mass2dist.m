function isotopes = mass2dist(mass, nPks)

    if ~exist('nPks','var')
        nPks = 50;
    end
        
    % Averageine info
    mAvg = 111.1254;
    %Averageine formula in order C H N O S
    avgArray = [4.9384; 7.7583; 1.3577; 1.4773; 0.0417]; 

    elNums = round(mass / mAvg * avgArray); 

    % Set up for FT
    numC = elNums(1);
    numH = elNums(2);
    numN = elNums(3);
    numO = elNums(4);
    numS = elNums(5);

    [c,h,n,o,s] = deal(zeros(1, 512));

    c(1:4) = [1, 0.011, 0, 0];
    h(1:4) = [1, 0.00015, 0, 0];
    n(1:4) = [1, 0.0037, 0, 0];
    o(1:4) = [1, 0.0004, 0.002, 0];
    s(1:4) = [1, 0.0079, 0.044, 0];

    cft = fft(c);
    hft = fft(h);
    nft = fft(n);
    oft = fft(o);
    sft = fft(s);

    allft = cft.^numC .* hft.^numH .* nft.^numN .* oft.^numO .* sft.^numS;

    allift = ifft(allft);
    allift = allift / max(allift);
    isotopes = allift(1:nPks);

%     figure
%     stem(isotopes)
end