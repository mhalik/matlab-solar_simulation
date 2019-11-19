%Demand vs. Resource
%Sample calculation of resources and demand, using "spot_simulator"

midd_resource_1=(spot_simulator(213,213,37,180))
midd_resource_2=(.3*(spot_simulator(213,213,37,180))+.7*(spot_simulator(213,213,37,270)))
midd_resource_3=(spot_simulator(213,213,37,270))
midd_demand=zeros(1,numel(midd_resource_1))

for i=1:numel(DA_DEMD)
    midd_demand(2*(i-1)+1)=DA_DEMD(i);
    midd_demand(2*(i-1)+2)=DA_DEMD(i);
end

x=linspace(1,numel(midd_resource_1),numel(midd_resource_1))
midd_demand=.1*midd_demand*.0136
figure
plot(x,midd_resource_1,x,midd_demand,x,midd_resource_2,'g',x,midd_resource_3)
title('Demand vs. Resource Scenarios (1/8/2015)')
ylabel('MW')
xlabel('Time (15 minute separations)')
legend('100% south', 'Demand', '30% South, 70% West', '100% West')
%%

for i=1:numel(VarName17)
    midd_demand(2*(i-1)+1)=DA_DEMD3(i);
    midd_demand(2*(i-1)+2)=DA_DEMD3(i);
end
resolution=20
residual_values=zeros(numel(midd_demand),resolution)
midd_demand=.1*.0136*midd_demand
for i=1:resolution
    demand_values=((i/20)*spot_simulator(213,213,37,180))+((1-(i/20))*spot_simulator(213,213,37,180));
    b=sum(demand_values)
    c=sum(midd_demand)
    residual=(midd_demand)-(((i/20)*spot_simulator(213,213,37,180))+((1-(i/20))*spot_simulator(213,213,37,270)));
    residual_values(:,i)=residual
end



figure
x=linspace(1,numel(midd_demand),numel(midd_demand))
for i=1:resolution
    color=[1,0,0]+[(-i/20),0,(i/20)]
    hold on
    plot(x,residual_values(:,i),'Color',color)
end
plot(midd_demand)
title('Demand vs. Resdiual (01/08/2015)')
ylabel('MW')
xlabel('Time (15 minute separations)')
hold off

%%
weather_factor=.3997;
conversion_factor=.2204*.97;
reductions=weather_factor*conversion_factor;
%Alter the resource to include weather, conversion, and make it kWh
ghi_theoretical_south=spot_simulator(1,365,37,180)*reductions;
ghi_theoretical_west=spot_simulator(1,365,37,270)*reductions;
theoretical_extent=numel(ghi_theoretical_south);
%Now, extend the resolution of the theoretical data to fit demand
ext_theor_south=zeros((2*theoretical_extent),1);
ext_theor_west=zeros((2*theoretical_extent),1);
for i=1:(2*theoretical_extent)
    if mod(i,2)==0
        ext_theor_south(i)=ghi_theoretical_south((i/2));
        ext_theor_west(i)=ghi_theoretical_west((i/2));
    else
        ext_theor_south(i)=ghi_theoretical_south((i+1)/2);
        ext_theor_west(i)=ghi_theoretical_west((i+1)/2);
    end
end
resource_values_1=(65*200*ext_theor_south)+(25*200*ext_theor_west);
demand=data;
hold on
plot(resource_values_1)
plot(data)