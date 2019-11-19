function [ intensity_vector ] = spot_simulator(day_one,day_two,module_elev,module_azi)
%SPOT_SIMULATOR This function generates an intensity vector given a set of
%conditions
%   The function unifies three other functions: 'daytime',
%   'elevation_angle', and 'intensity' to determine first a base vector of
%   dates and hours (split into half-hour incrememnts), then generates a
%   set of azimuthal and elevation angles for the sun. Those are fed
%   through the 'intensity' calculation, with conditions to detect whether
%   the module is shading itself
timing_vector=daytime(day_one,day_two);
timing=length(timing_vector);
intensity_vector=zeros(1,timing);
azi_angles=zeros(1,timing);
elev_angles=zeros(1,timing);
base_vector=zeros(1,timing);
for i=1:timing
    angles=elevation_angle(timing_vector(1,i),timing_vector(2,i));
    % This generates the angles (elevation and azimuthal) based on the
    % timing vector
    elev_angles(i)=angles(1);
    azi_angles(i)=angles(2);
    intensity_value=intensity(angles(1),angles(2));
    if (module_azi-azi_angles(i)-90)<0 && (module_azi-azi_angles(i)-90)>-180 || module_elev==0
        intensity_vector(i)=intensity_value*(sind(elev_angles(i))*cosd(module_elev)+(cosd(elev_angles(i))*sind(module_elev)*cosd(module_azi-azi_angles(i))));
        %This calculates intensity on an arbitrarily tilted and oriented
        %surface.
    else
        intensity_vector(i)=intensity_value*(.1/1.1);
        %In the case of the module shading itself, only diffuse radiation
        %is taken into account, assumed to be 10% of total (needs
        %re-working for accuracy)
    end
    base_vector(i)=timing_vector(2,i);
end
%I leave in the option to plot angles and intensity in order to check for
%bugs

% subplot(3,1,1);
% plot(elev_angles);
%  
% subplot(3,1,2);
% plot(azi_angles);
%  
% subplot(3,1,3);
% plot(intensity_vector);

%plot(intensity_vector)

end

