classdef PPM < DigitalModulation
    
    methods
        function obj = PPM(M, averageEnergy)
            obj.M = M;
            obj.averageEnergy = averageEnergy;
        end
        
        function dim = dimensionality(obj)
           dim = obj.M; 
        end
        
        function signals = signalCoords(obj)
           signals = sqrt(obj.averageEnergy)*eye(obj.M);
        end
        
        function [errorProbability, isUpperBound] = errorProbability(obj, N0)
            isUpperBound = 1;
            errorProbability = (obj.M-1) * (1-normcdf(sqrt(obj.averageEnergy/N0)));
        end    
        
    end
end

