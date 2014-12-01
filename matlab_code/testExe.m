function testExe(mode, dataRate, chippingRates, chipLengths, numberOfSenders, freqs, bandwidths, snrs, randomNumbers, repetitions)
%% setup
samplesPerSecond = 10000;
medium = Medium;

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
        for snr = snrs
            for bandwidth = bandwidths
                testRepetition = 0;
                for totalSenders = 1: numberOfSenders
                    for i = 1:repetitions 
                        %setup entities
                        pnGenerator = PNGenerator(chipLength);
                        %the receiver and the FIRST sender get the same chip sequence
                        sequence = pnGenerator.step();

                        receiver = Receiver(medium, sequence, mode, samplesPerSecond, dataRate,chippingRate);
                        jammer = Jammer(medium, samplesPerSecond);


                        %create senders
                        for senderNumber = 1:totalSenders
                            senders(senderNumber) = Sender(medium, sequence, mode, samplesPerSecond, dataRate,chippingRate);
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

                        %jam on different frequencies 
                        for f = freqs
                            jammer.jam(f, bandwidth, snr);
                        end

                        receivedData(:,testRepetition+1) = receiver.receive();
                        medium.clear();
                        testRepetition = testRepetition+1;
                    end
                    %get the bit error rate fore each sample and average them
                    bitErrors = sum(receivedData ~= sentData,1);

                    meanBitError = mean(bitErrors);

                    % test result contains: chippingRate,chipLength,freqs, powers, bit errors
                    testResults(:,configRan+1) = [ chippingRate, chipLength, bandwidth, snr, totalSenders, meanBitError];

                    configRan = configRan+1;
                end
            end
            
        end
       
	end
end
%% output
% testResults
% reactivate verbose output
ProjectSettings.verbose(true);
figure;
count = 1;
for i = 1:length(chippingRates)
    for j = 1:length(chipLengths)
        start = 1+(count-1)*length(snrs)*length(bandwidths)*numberOfSenders;
        ende = start+length(snrs)*length(bandwidths)*numberOfSenders-1;
        %either there are multiple users or multiple power levels
        X = testResults(4,start:ende).*testResults(5,start:ende).*testResults(3,start:ende);
        Y = testResults(6,start:ende);
        scatter(X,Y);
        hold on
       
        legendEntries{count} = ['Chipping rate:', num2str(chippingRates(i)), ', Chip Length:', num2str(chipLengths(j)), ' , number of senders:', num2str(numberOfSenders)];
         
        count = count+1;
    end
end    
legend(legendEntries);
hold off

