function [ i_g ] = intensity( elevation_angle,azi_angle )
%INTENSITY This will calculate the intensity of sunlight on an arbitrary
%flat surface at my location, given the elevation angle and azimuthal angle
%of the sun

%This uses equations from pveducation.org, as cited in references

if elevation_angle>0 && elevation_angle<180
    if elevation_angle<90
        zen=90-elevation_angle;
        am=1/(cosd(zen)+.50572*((96.07995-zen).^-1.6364));
        i_g=1.1*1.353*(.7.^am.^.678);
    else 
        zen=elevation_angle-90;
        am=1/(cosd(zen)+.50572*((96.07995-zen).^-1.6364));
        i_g=1.1*1.353*(.7.^am.^.678);
    end
else
    i_g=0;
end

