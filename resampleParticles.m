function [ resampledParticles, numP ] = resampleParticles( particles, w )
%[ resampledParticles, numP ] = resampleParticles( particles, w )

    numP = size(particles,1);
    
    resampledParticles = [];
    
    repNumParticles = round( w*numP );
    
    for currIdx = 1:numP
        if repNumParticles(currIdx) >= 1
            resampledParticles = [ resampledParticles; repmat( particles(currIdx, :), repNumParticles(currIdx), 1 ) ];
        end
    end
    
    numP = size(resampledParticles, 1);
end
