%demand_resource_evaluation.m

%This script compares demand and resource profiles for optimizing
%panel orientations and sizing for both panels and storage

%First check to see that the data has been imported; if not, import it.
if ismember({'data'},who)==0
    excel_parser()
else
end
%The weather reductions and conversion factors of panel and inverter are
%known
weather_factor=.3997;
conversion_factor=.2204*.97;
reductions=weather_factor*conversion_factor;
%Alter the resource to include weather, conversion, and make it kWh
ghi_theoretical_south=spot_simulator(1,365,39,180)*reductions;
ghi_theoretical_west=spot_simulator(1,365,39,270)*reductions;
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

%Below, a test to get some basic magnitudes for demand and how many panels
%will be needed
%south_magnitude=sum(ghi_theoretical_south);
%west_magnitude=sum(ghi_theoretical_west);
%demand_magnitude=sum(data);




%% DIFFERENCE METHOD
%Set boundaries for how many cells you want to check
lower_south=0;
upper_south=360;
lower_west=0;
upper_west=120;
%Establish a blank slate to record similarity values
comp_matrix=zeros((upper_south-lower_south),(upper_west-lower_west));

for i=lower_south:upper_south
    for j=lower_west:upper_west
        x_dimension=i-(lower_south-1);
        y_dimension=j-(lower_west-1);
        %Create an array of comparison data
        a=abs((data-((i*ext_theor_south*500)+(j*ext_theor_west*500))))./data;
        %Eliminate night-time
        a(a==0) = [];
        a(a==Inf)=[];
        a(a==-Inf)=[];
        a=1-a;
        %Determine the average value of the data
        comp_matrix(x_dimension,y_dimension)=mean(a);
    end
    i
end
beep
figure

%Examine this data in the form of a 3d contour map
contour3(comp_matrix,300)


%% Determining energy storage

%First, find the point of max similarity; the base ratio
[row col]=find(comp_matrix==max(max(comp_matrix)));

%Remember that resolution was in terms of 500 m^2 of panels, for decreased
%computation time. Future trials could include increased resolution
ideal_resource=row*500*ext_theor_south+col*500*ext_theor_west;
%Consider excess generation
storage_array=ideal_resource-data;
balance=sum(storage_array)
%Delete points of non-excess generation
storage_array(storage_array<0)=[0];
%Assume it to be delivered daily
storage_potential=sum(storage_array)/(4*365);
%Result in kWh
storage_gen_ratio=(row*500+col*500)/(storage_potential/10)
%how many panels are needed to justify one 10 kWh battery
figure
set(gca,'fontsize',18)
hold on
xlabel('15 minute intervals through 2015')
ylabel('Kilowatts (kW)')
title('Resource, Demand, and Potential Storage in Middlebury, 2015')
set(gca, 'XTick', []);
plot(ideal_resource,'y')
plot(data,'r')
plot(storage_array,'m')
legend('Suggested Resource','Middlebury Demand','Excess Capacity')
hold off

 %% MEAN METHOD - NO STORAGE
 %The original method for comparison, eventually succeeded by the
 %difference method
 
% lower_south=0;
% upper_south=300;
% lower_west=0;
% upper_west=180;
% comp_matrix=zeros((upper_south-lower_south),(upper_west-lower_west));
% 
%  
% for i=lower_south:upper_south
%     for j=lower_west:upper_west
%         x_dimension=i-(lower_south-1);
%         y_dimension=j-(lower_west-1);
%         %Create an array of comparison data
%         a=(((i*ext_theor_south*500)+(j*ext_theor_west*500))./data);
%         %Eliminate night-time
%         a(a==0) = [];
%         %In trying to fit, overcompensation is negatively biased
%         a(a>1)=1;
%         %Determine the average value of the data
%         comp_matrix(x_dimension,y_dimension)=mean(a);
%     end
%     i
% end
% beep
% figure
% contour3(comp_matrix,200)

%% DIFFERENCE METHOD W/ ITERATED DATA PROFILING
% Another approach to comparing, ultimately not used


%Set boundaries for how many cells you want to check
% lower_south=0;
% upper_south=100;
% lower_west=0;
% upper_west=50;
% comp_matrix=zeros((upper_south-lower_south),(upper_west-lower_west));

% %I'm trying to see how the recommendation changes as we zoom in closer and
% %closer on peak demand
% resolution=10;
% x_spots=numel(1,resolution);
% y_spots=numel(1,resolution);
% 
% %lower=min(data);
% %upper=max(data);
% %reduction_values=linspace(lower,upper,resolution);
% 
% lower=.2
% upper=.02
% division_values=linspace(lower,upper,resolution);
% 
% %data_set=data-((k-1)*data/resolution);
% for k=1:resolution
%     %This should iterate the data set down to slow zoom in on peak
%     data_set=data*division_values(k);
%     for i=lower_south:upper_south
%         for j=lower_west:upper_west
%             x_dimension=i-(lower_south-1);
%             y_dimension=j-(lower_west-1);
%             %Create an array of comparison data
%             a=abs((data_set-((i*ext_theor_south*500)+(j*ext_theor_west*500))))./data_set;
%             %Eliminate night-time
%             a(a==0) = [];
%             a(a==Inf)=[];
%             a(a==-Inf)=[];
%             a(a<0)=[];
%             a=1-a;
%             %Determine the average value of the data
%             comp_matrix(x_dimension,y_dimension)=mean(a);
%         end
%     end
% [row col]=find(comp_matrix==max(max(comp_matrix)))
% x_spots(k)=row;
% y_spots(k)=col;
% disp(k)
% end
% beep
% figure
% scatter(y_spots,x_spots)

 
%%
%Displaying the data in visual form

solar_resource=500*28*ext_theor_south+500*27*ext_theor_west;
grid_demand=data-6225;
hold on
plot(solar_resource)
plot(grid_demand)
xlabel('15-minute intervals over one year')
ylabel('kW')
title('Demand vs. Resource for Middlebury (reduced)')
hold off

