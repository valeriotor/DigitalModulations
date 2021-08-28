classdef PSK < BidimensionalDigitalModulation
    
    methods
        function obj = PSK(M, averageEnergy)
            obj.M = M;
            obj.averageEnergy = averageEnergy;
        end
        
        function signals = signalCoords(obj)
            M = obj.M;
            m = (0:M-1)';
            signals = sqrt(obj.averageEnergy)*[cos(2*pi*m/M), sin(2*pi*m/M)];
        end
        
        function [errorProbability, isUpperBound] = errorProbability(obj, N0)
            isUpperBound = 1;
            arg = sqrt(2*obj.averageEnergy*(sin(pi/obj.M))^2/N0);
            errorProbability = 2*(1-normcdf(arg));
        end    
    end
end

