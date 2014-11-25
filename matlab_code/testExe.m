function testExe(mode, dataRate, chippingRates, chipLengths, numberOfSenders, jammingMode, freqs, powers, randomNumbers, repetitions)
%% setup
samplesPerSecond = 1024;
medium = Medium;

%create power array with frequency and power
%only the FHSS, narrow-band test uses more than one frequency
if strcmp(mode,'fhss') && strcmp(jammingMode, 'narrowband')
    jammingParaLength = length(frequs);
else
    jammingParaLength = length(powers);
end    

%% test
%repeat for averaging
subTestIter = 1;
testIter = 1;
for i = 1:repetitions 
   for chippingRate = chippingRates
      for chipLength = chipLengths
        for jammingPara = 1:jammingParaLength
            %setup entities
            pnGenerator = PNGenerator(chipLength);
            %the receiver and the FIRST sender get the same chip sequence
            sequence = pnGenerator.step();

            receiver = Receiver(medium, sequence, mode, samplesPerSecond, dataRate,chippingRate);
            jammer = Jammer(medium, samplesPerSecond, jammingMode);


            %create senders
            for senderNumber = numberOfSenders
                senders(senderNumber) = Sender(medium, sequence, mode, samplesPerSecond, dataRate,chippingRate);
                sequence = pnGenerator.step();
            end

            %save data to compare with received data
            sentData(:,testIter) = randomNumbers(:,subTestIter);

            %let all senders send  
            for sender = senders
                sender.send(randomNumbers(:,subTestIter));
                subTestIter = subTestIter+1;
            end

            %jam on differend frequencies
            if strcmp(mode,'fhss') && strcmp(jammingMode, 'narrowband')
                jammer.jam(freqs(jammingPara), powers);
            else
                jammer.jam(freqs, powers(jammingPara));
            end    
             
            receivedData(:,testIter) = receiver.receive();
            medium.clear();
        end
      end    
   end
end
%% output
i=0;
