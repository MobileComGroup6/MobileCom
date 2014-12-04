function testExe(mode, dataRate, chippingRates, chipLengths, numberOfSenders, gaussSNR, freqs, powers, bandwidths, randomNumbers, repetitions, testName)
%% setup
samplesPerSecond = 4096;
medium = Medium();

%create power array with frequency and power
%only the FHSS, narrow-band test uses more than one frequency
if length(freqs) > 1 && length(powers) == 1 && length(bandwidths) == 1 && length(numberOfSenders) == 1 && length(gaussSNR) == 1
    jammingMode = 'frequency';
    jammingParaLength = length(freqs);
elseif length(freqs) == 1 && length(powers) > 1 && length(bandwidths) == 1 && length(numberOfSenders) == 1 && length(gaussSNR) == 1
    jammingMode = 'power';
    jammingParaLength = length(powers);
elseif length(freqs) == 1 && length(powers) == 1 && length(bandwidths) > 1 && length(numberOfSenders) == 1 && length(gaussSNR) == 1
    jammingMode = 'bandwidth';
    jammingParaLength = length(bandwidths);
elseif length(freqs) == 1 && length(powers) == 1 && length(bandwidths) == 1 && length(numberOfSenders) > 1 && length(gaussSNR) == 1
    jammingMode = 'numberOfSenders';
    jammingParaLength = length(numberOfSenders);
elseif length(freqs) == 1 && length(powers) == 1 && length(bandwidths) == 1 && length(numberOfSenders) == 1 && length(gaussSNR) > 1
    jammingMode = 'gaussSNR';
    jammingParaLength = length(gaussSNR);
else
    error('invalid jamming argument length');
end    

%% test
% deactivate verbose output to prevent figure spam
ProjectSettings.verbose(false);
%counter to access the right column of the randomNumbers
msgsSent = 0;
%counter that is increased each time a test configuration with all
%repetitions has ran
configRan = 0;

for chippingRate = chippingRates
	for chipLength = chipLengths
        for jammingPara = 1:jammingParaLength
            testRepetition = 0;
                for i = 1:repetitions 
                    %setup entities
                    pnGenerator = PNGenerator(chipLength);
                    %the receiver and the FIRST sender get the same chip sequence
                    sequence = pnGenerator.step();
                    
                    %medium.clear() has probably a bug, so creating a new medium
                    %each time instead
                    medium = Medium();
                    receiver = Receiver(medium, sequence, mode, samplesPerSecond, dataRate,chippingRate);
                    jammer = Jammer(medium, samplesPerSecond);

                    if strcmp(jammingMode,'frequency')
                        freq = freqs(1:jammingPara);
                        power = powers;
                        bandwidth = bandwidths;
                        numberOfSender = numberOfSenders;
                        snr = gaussSNR;
                    elseif strcmp(jammingMode,'power')
                        freq = freqs;
                        power = powers(jammingPara);
                        bandwidth = bandwidths;
                        numberOfSender = numberOfSenders;
                        snr = gaussSNR;
                    elseif strcmp(jammingMode,'bandwidth')
                        freq = freqs;
                        power = powers;
                        bandwidth = bandwidths(jammingPara);
                        numberOfSender = numberOfSenders;
                        snr = gaussSNR;
                    elseif strcmp(jammingMode,'numberOfSenders')
                        freq = freqs;
                        power = powers;
                        bandwidth = bandwidths;
                        numberOfSender = numberOfSenders(jammingPara);
                        snr = gaussSNR;
                    elseif strcmp(jammingMode,'gaussSNR')
                        freq = freqs;
                        power = powers;
                        bandwidth = bandwidths;
                        numberOfSender = numberOfSenders;
                        snr = gaussSNR(jammingPara);
                    end
                    
                    %TODO: USE snr WHEN SENDIN!
                    %create senders
                    for senderNumber = 1:numberOfSender
											senders(senderNumber) = Sender(medium, sequence, mode, samplesPerSecond, dataRate,chippingRate);
											senders(senderNumber).setGaussianSNR(gaussSNR(jammingPara));
											sequence = pnGenerator.step();
                    end

                    %save data to compare with received data
                    sentData(:,testRepetition+1) = randomNumbers(:,msgsSent+1);
                    msgsSentIntermediate = msgsSent;
                    %let all senders send  
                    for sender = senders
                        sender.send(randomNumbers(:,msgsSent+1));
                        msgsSent = msgsSent+1;
                    end
                    %Each iteration adds another user to the transmission,
                    %but the users should send the same data in each
                    %iteration. That's why i reset the counter.
                    msgsSent = msgsSentIntermediate;
                    
                    %jam on different frequencies or with different power
                    for f = freq
                        jammer.jam(f, bandwidth, power);
                    end

                    receivedData(:,testRepetition+1) = receiver.receive();
                    medium.clear();
                    testRepetition = testRepetition+1;
                end
                %get the bit error rate fore each sample and average them
                bitErrors = sum(receivedData ~= sentData,1);

                meanBitError = mean(bitErrors);
                relativeMeanBitError = meanBitError / size(randomNumbers,1);
        
                % test result contains: chippingRate,chipLength,freqs, powers, bit errors
                testResults(:,configRan+1) = [ chippingRate, chipLength, jammingPara, power, bandwidth, numberOfSender, snr, meanBitError, relativeMeanBitError];
                receivedData = zeros(size(receivedData));
                configRan = configRan+1;
            end
            
       
	end
end
%% output
% testResults
% reactivate verbose output
ProjectSettings.verbose(true);
h = figure;
count = 1;
colors = {'b-*','r-*','g-*','k-*';'b--o','r--o','g--o','k--o'};

for i = 1:length(chippingRates)
    for j = 1:length(chipLengths)
        start = 1+(count-1)*jammingParaLength;
        ende = start+jammingParaLength-1;
        %either there are multiple users or multiple power levels
        if strcmp(jammingMode,'frequency')
            X = testResults(3,start:ende)-1;
            x = 'Number of jammed channels';
        elseif strcmp(jammingMode,'power')
        	X = testResults(4,start:ende);
            x = 'Amplification factor of noise';
        elseif strcmp(jammingMode,'bandwidth')
            X = testResults(5,start:ende);
            x = 'Noise bandwidth (Hz)';
        elseif strcmp(jammingMode,'numberOfSenders')
            X = testResults(6,start:ende);
            x = 'Number of senders';
        elseif strcmp(jammingMode,'gaussSNR')
            X = testResults(7,start:ende);
            x = 'SNR of gaussian noise';            
        end
        Y = 100*testResults(9,start:ende);
        color = colors{j+length(chipLengths)*(i-1)}
        plot(X,Y,color);
        xlabel(x);
        ylabel('Bit error rate (%)');
        hold on
       
        legendEntries{count} = ['Chipping rate:', num2str(chippingRates(i)), ', Chip Length:', num2str(chipLengths(j))];
         
        count = count+1;
    end
end
legend(legendEntries,'Location','southeast');
hold off

if ProjectSettings.saveResultPlots
    filename = ['output/plot_mode_',mode, '-test_',testName,'-rep_',num2str(repetitions) ,'-dataRate_',num2str(dataRate),'-dataLength_', num2str(size(randomNumbers,1)),'_'];
    c = fix(clock);
    for i = 1:length(clock)
        filename = [filename, '-', num2str(c(i))];
    end
    filename = [filename, '.png'];
    print(h, '-dpng', filename);
end

