function y=speech_project()
threshold=0.5;
[y, fs] = audioread('s5.wav');
sample_per_frame=floor(fs/100);
sample_count=floor(fs/5);
sample=[];

for i=1:1:sample_count
    sample=[sample y(i)];
end
mean_value=mean(sample); %mean
standard_deviation=std(sample); %standard deviation
for i=1:1:length(y)
    if(abs(y(i)-mean_value)/standard_deviation>threshold) %mahalanobis distance greater than threshold
        voiced(i)=1;
    else
        voiced(i)=0;
    end
end
useful_samples=length(y)-mod(length(y),sample_per_frame);
frame_count=useful_samples/sample_per_frame;
for i=1:1:frame_count
    count_voiced=0;
    count_unvoiced=0;
    for j=i*sample_per_frame-sample_per_frame+1:1:i*sample_per_frame
        if(voiced(j)==1)
            count_voiced=count_voiced+1;
        else
            count_unvoiced=count_unvoiced+1;
        end
    end
    %frame voiced or not
    if(count_voiced>count_unvoiced)
        voiced_unvoiced(i)=1;
    else
        voiced_unvoiced(i)=0;
    end
end
new_y=[];
for i=1:1:frame_count
    if(voiced_unvoiced(i)==1)
        for j=i*sample_per_frame-sample_per_frame+1:1:i*sample_per_frame
            new_y=[new_y y(j)];
        end
    end
end
subplot(2,1,1);plot(y);title('Silence/Unvoiced Signal Removal');xlabel('time');ylabel('original speech signal');
subplot(2,1,2);plot(new_y);xlabel('time');ylabel('new speech signal');
sound(y);
sound(new_y);


