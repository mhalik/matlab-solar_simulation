%Yearly Resource - Scaling Exercse
%yearly weather cap factor 0.3997
harvested_energy=(spot_simulator(1,365,37,180));
conversion=.2204*.97
total=sum(harvested_energy)*.3997*conversion/1000; %MWh per year
yearly_need=5841.5;
extent=yearly_need/total
plot(harvested_energy)