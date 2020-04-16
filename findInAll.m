function inAll = findInAll(fragments, numReps)

%output = cell(1);
inAll.name = cell(1);
cellCount = 1;
for frag = 1:length(fragments.prosight(1).name)
    for rep = 2:numReps
        if ~any(contains(fragments.prosight(rep).name, fragments.prosight(1).name{frag})) == 0
            %if ~any(strcmp(output, fragments.prosight(1).name{frag}))
            if ~any(strcmp(inAll.name, fragments.prosight(1).name{frag}))
                %output{cellCount} = fragments.prosight(1).name{frag};
                inAll.name{cellCount} = fragments.prosight(1).name{frag};
                inAll.mz(cellCount) = fragments.prosight(1).mz(frag);
                inAll.mass(cellCount) = fragments.prosight(1).mass(frag);
                cellCount = cellCount + 1;
            end
        end
    end
end
inAll;