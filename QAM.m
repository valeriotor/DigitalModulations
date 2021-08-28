classdef QAM < BidimensionalDigitalModulation
    
    methods
        function obj = QAM(M, averageEnergy)
            obj.M = M;
            obj.averageEnergy = averageEnergy;
        end
        
        function signals = signalCoords(obj)
            [width, height, widthEnergy, heightEnergy] = obj.getSizes();
            widthPAM = 1-width:2:width-1;
            heightPAM = 1-height:2:height-1;
            [X,Y] = meshgrid(widthPAM, heightPAM);
            signals = [X(:)*sqrt(widthEnergy) Y(:)*sqrt(heightEnergy)];
        end
        
        function [errorProbability, isUpperBound] = errorProbability(obj, N0)
            % La probabilità di errore viene calcolata partendo dalle
            % funzioni già definite in PAM, poiché la QAM è divisibile in 2
            % PAM, in altezza e larghezza.
            [width, height, widthEnergy, heightEnergy] = obj.getSizes();
            averageWidthEnergy = widthEnergy * (width^2-1) / 3;
            averageHeightEnergy = heightEnergy * (height^2-1) / 3;
            if width == 1
                widthError = 0;
            else
                widthError = PAM(width, averageWidthEnergy).errorProbability(N0);
            end
            heightError = PAM(height, averageHeightEnergy).errorProbability(N0);
            isUpperBound = 0;
            errorProbability = 1 - (1-widthError)*(1-heightError);
        end
        
        function [width, height, widthEnergy, heightEnergy] = getSizes(obj)
            % width e height sono il numero (in unità) di segnali in
            % larghezza e altezza.
            % widthEnergy e heightEnergy non sono le energie medie dei PAM
            % corrispondenti, bensì le "Eg", ossia le energie di base tale
            % che Sm = Am*sqrt(Eg)
            divs = divisors(obj.M);
            root = sqrt(obj.M);
            roots = ones(1, length(divs)) * root;
            [~,closestToRootIndex] = min(abs(divs-roots));
            width = divs(closestToRootIndex);
            height = obj.M / width;
            if width == 1
                widthEnergy = 0;
                heightEnergy = obj.averageEnergy*3/(height^2-1);
            else
                widthEnergy = obj.averageEnergy*3/2/(width^2-1);
                heightEnergy = obj.averageEnergy*3/2/(height^2-1);
            end
        end
    end
end

