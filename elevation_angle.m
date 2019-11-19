function [ angles ] = elevation_angle( time,day )
%ELEVATION_ANGLE: This function calculates the elevation and azimuthal angles of the sun at a
%pre-specified location for an input day of the year and time of day
%(military format)

%   Detailed explanation goes here
latitude=44;
longitude=73+(8/60);
gtm_difference=5;
LSTM=15*gtm_difference;
B=(360/365)*(day-81);
eot=9.87*sind(2*B)-7.53*cosd(B)-1.5*sind(B);
TC=4*(longitude-LSTM)+eot;
LST=time+(TC/60);
HRA=15*(LST-12);
dec_angle=asind(sind(23.45)*sind((360/365)*(day-81)));
elev_angle=asind(sind(dec_angle)*sind(latitude)+cosd(dec_angle)*cosd(latitude)*cosd(HRA));
zen_angle=90-elev_angle;
if HRA<0
    azi_angle=acosd((sind(dec_angle)*cosd(latitude)-cosd(dec_angle)*sind(latitude)*(cosd(HRA)))/(cosd(elev_angle)));
else
    azi_angle=360-acosd((sind(dec_angle)*cosd(latitude)-cosd(dec_angle)*sind(latitude)*(cosd(HRA)))/(cosd(elev_angle)));
end
%azi angle is measured in degrees clockwise from north
angles=[elev_angle, azi_angle];
end

