classdef PAM < DigitalModulation
    
    methods (Static)
        function dim = dimensionality()
           dim = 1; 
        end           
    end
    
    methods
        function obj = PAM(M, averageEnergy)
            obj.M = M;
            obj.averageEnergy = averageEnergy;
        end
        
        function signals = signalCoords(obj)
            signals = 1-obj.M : 2 : obj.M-1;
            eg = obj.averageEnergy*3/(obj.M^2-1);
            signals = (signals*sqrt(eg))';
        end
        
        function [errorProbability, isUpperBound] = errorProbability(obj, N0)
            isUpperBound = 0;
            arg = sqrt(6*obj.averageEnergy/(obj.M^2-1)/N0);
            errorProbability = 2*(obj.M-1)/obj.M * (1- normcdf(arg));
        end
        
        function drawMontecarloSim(obj, N0, tries)
            signals = obj.signalCoords();
            receivedSignals = obj.montecarloSim(N0, tries);
            size = sqrt(obj.averageEnergy);
            for i = 1:obj.M
                plot(signals(i), 0, 'o', 'markersize', 10, 'markerface', 'r');
                axis([-2*size, 2*size, -1, 1]);
                hold on
            end
            axis square
            for i = 1:tries
                plot(receivedSignals(i), 0, 'o', 'markersize', 6, 'markerface', 'b');
            end
            hold off
        end
    end
end

