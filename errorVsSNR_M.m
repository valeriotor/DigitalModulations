function errorVsSNR_M(modulation, SNratios_dB, Ms, triesPerSim)
% Del parametro modulation per questa funzione importa esclusivamente il
% tipo, poiché sia energia che M sono dettati dai parametri SNratios_dB e
% Ms. Per non modificare modulation si effettua un backup dei suoi due
% campi, e lo si ripristina all'uscita dalla funzione.
backupEnergy = modulation.averageEnergy;
backupM = modulation.M;
figure
SNratios = 10.^(SNratios_dB/10);
errorRatios = zeros(length(Ms), length(SNratios_dB));
errorProbs = zeros(length(Ms), length(SNratios_dB));
for i = 1:length(SNratios)
    modulation.setBitEnergy(SNratios(i));
    for j = 1:length(Ms)
        modulation.setMKeepBitEnergy(Ms(j));
        [~, errorRatios(j, i)] = modulation.montecarloSim(1, triesPerSim);
        errorProbs(j,i) = modulation.errorProbability(1);
    end
end
height = max(max(errorRatios)) - min(min(errorRatios));
width = max(SNratios_dB) - min(SNratios_dB);
index = ceil(length(SNratios_dB)/2);
for i = 1:length(Ms)
    semilogy(SNratios_dB, errorRatios(i,:), '-ok', 'linewidth', 2);
    hold on
    semilogy(SNratios_dB, errorProbs(i,:), '--r', 'linewidth', 2);
    text(SNratios_dB(index)-width/25,errorRatios(i,index)+height/15,strcat('M = ', num2str(Ms(i))));
end
xlabel('$\frac{Eb}{N0} [dB]$', 'Interpreter', 'latex', 'fontsize', 20)
ylabel('Error probability', 'fontsize', 20)
modulation.setAverageEnergy(backupEnergy);
modulation.M = backupM;
hold off
end

