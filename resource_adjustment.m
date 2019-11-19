% Resource adjustment

ideal_values=spot_simulator(1,365,39,180)*1000;
observed_values=rot90(csvread('sample_year_2013_midd_csv.csv',0,1));
observed_values=observed_values(10:end);
observed_values=cat(2,observed_values,zeros(1,9));
array_length=length(ideal_values)
% figure
% hold on
% plot(ideal_values)
% plot(observed_values)
% hold off
reconciled_values=zeros(1,array_length);
for i=1:array_length
    if observed_values(i)>=ideal_values(i)
        reconciled_values(i)=ideal_values(i);
    else
        relative_value=ideal_values(i)/observed_values(i);
        if relative_value>=2
            reconciled_values(i)=observed_values(i);
        else
            reconciled_values(i)=ideal_values(i);
        end
    end
end

figure
hold on
plot(reconciled_values)
hold off

reconciled_values=reconciled_values';
second_col=[.5:.5:8760]';
reconciled_values=cat(2,second_col,reconciled_values);
csvwrite('2013_midd_weather_adjusted_resource.csv',reconciled_values)
