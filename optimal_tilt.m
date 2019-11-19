solar_sum=zeros(1,90)
for i=1:89
    solar_sum(i)=sum(sum(spot_simulator(1,365,i,180)));
end
value=find(solar_sum==max(solar_sum))
    
    