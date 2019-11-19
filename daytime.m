function [ final_vector ] = daytime(x,y)
%DAYTIME This function creates a matrix of day and time values given a
%start and finish date, with half-hour preset intervals.

number_of_days=y-x;
base_time=linspace(0,23.5,48);
time_vector=base_time;
for i=1:number_of_days
    time_vector=cat(2,time_vector,base_time);
end
day_vector=zeros(1,length(time_vector));
final_vector=cat(1,time_vector,day_vector);

for i=1:48
    for j=0:number_of_days
        final_vector(2,i+(j*48))=j+x;
    end
end
    


