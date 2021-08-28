classdef (Abstract) BidimensionalDigitalModulation < DigitalModulation
    % Una classe di utilità per raggruppare i metodi comuni alle due
    % digital modulation bidimensionali viste a lezione, in particolare la 
    % possibilità di rappresentarle facilmente su un grafico 2D.
    
    methods
        function drawMontecarloSim(obj, N0, tries)
            signals = obj.signalCoords();
            receivedSignals = obj.montecarloSim(N0, tries);
            size = sqrt(obj.averageEnergy);
            for i = 1:obj.M
                plot(signals(i,1), signals(i,2), 'o', 'markersize', 10, 'markerface', 'r');
                axis([-2*size, 2*size, -2*size, 2*size]);
                hold on
            end
            axis square
            for i = 1:tries
                plot(receivedSignals(i,1), receivedSignals(i,2), 'o', 'markersize', 6, 'markerface', 'b');
            end
            hold off
        end
        
    end
    
    methods (Static)
        function dim = dimensionality()
           dim = 2; 
        end
    end
end

