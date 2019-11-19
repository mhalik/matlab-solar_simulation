%excel_parser.m
%This script simply extracts the demand data from the excel file provided
%by GMP. Further parsing is established by "demand_resource_evaluation.m"
clear d
clear data

folder='C:\Users\smart_000\Documents\MATLAB\excel_data\year_of_data_midd\midd_year.xlsx';
data=xlsread(folder,'L3:L35042');

%L3:L35042
