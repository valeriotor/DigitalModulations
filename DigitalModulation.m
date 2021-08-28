classdef (Abstract) DigitalModulation < handle
    
    properties
        M
        averageEnergy
    end
    
    methods (Abstract)
        signals = signalCoords(obj)
        dim = dimensionality(obj)
        [errorProbability, isUpperBound] = errorProbability(obj, N0)
    end
    
    methods
        function setMKeepAverageEnergy(obj, M)
           obj.M = M; 
        end
        
        function setMKeepBitEnergy(obj, M)
            bitEnergy = obj.averageEnergy/log2(obj.M);
            obj.M = M; 
            obj.setBitEnergy(bitEnergy);
        end
        
        function setBitEnergy(obj, bitEnergy)
            % Va chiamata ***DOPO*** aver reimpostato il valore di M se non
            % si usa setMKeepBitEnergy()
            obj.averageEnergy = bitEnergy * log2(obj.M);
        end
        
        function setAverageEnergy(obj, averageEnergy)
            obj.averageEnergy = averageEnergy;
        end
        
        function displayProperties(obj)
            fprintf( 'M: %d\nAverageEnergy: %f\nDimensionality: %d\n', obj.M, obj.averageEnergy, obj.dimensionality())
        end
        
        function [receivedSignals, errorRatio] = montecarloSim(obj, N0, tries)
            signals = obj.signalCoords();
            receivedSignals = zeros(tries, obj.dimensionality());
            correctSignals = 0;
            for i = 1:tries
                sentSignalIndex = unidrnd(obj.M);
                n = normrnd(0, sqrt(N0/2), 1, obj.dimensionality());
                receivedSignals(i,:) = signals(sentSignalIndex,:) + n;
                distances = zeros(1,obj.M);
                for j = 1:obj.M
                    distances(j) = norm(receivedSignals(i,:) - signals(j,:));
                end
                [~, chosenSignalIndex] = min(distances);
                correctSignals = correctSignals + (sentSignalIndex == chosenSignalIndex);
            end
            errorRatio = (tries-correctSignals) / tries;
        end        
    end
    
end
