timing_vector=daytime(120,120);
timing=length(timing_vector);
intensity_vector=zeros(1,timing);
azi_angles=zeros(1,timing);
elev_angles=zeros(1,timing);
base_vector=zeros(1,timing);
for i=1:timing
    angles=elevation_angle(timing_vector(1,i),timing_vector(2,i));
    elev_angles(i)=angles(1);
    azi_angles(i)=angles(2);
    intensity_vector(i)=intensity(angles(1),angles(2));
    base_vector(i)=timing_vector(2,i);
end
 
 figure
 
 subplot(3,1,1)
 plot(elev_angles,'c')
 title('Elevation Angles- April 30')
 ylabel('Degrees')
 set(gca, 'XTick', []);
 
 subplot(3,1,2)
 plot(azi_angles,'m')
 title('Azimuthal Angles- April 30')
 set(gca, 'XTick', []);
 ylabel('Degrees')
 
 subplot(3,1,3)
 plot(intensity_vector,'r')
 title('Intensity Values- April 30')
 set(gca, 'XTick', []);
 ylabel('kW/m^2')

