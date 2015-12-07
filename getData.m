
function [ Xv, Yv ] = getData( dataSrcName )
% function: [ Xv, Yv ] = getData( dataSrcName )
% 
%getData() retrieves data for a given source name.
%
%Inputs:
%
%data source names list: { 'ozone', 'wind', 'image', 'rain', 'sp500', 'juraCu' }
%
%Outputs:
%
%Xv: is a vector of coordinates for locations with size n*p where n is the
%number of locations and p is the number of dimensions
%
%Yv: is a vector of data observations   with size n*1.
%
%

switch dataSrcName
    case 'image'
        [ Xv, Yv ] = getImageData( );
    case 'rain'
        [ Xv, Yv ] = getRainData( );
    case 'wind'
        [ Xv, Yv ] = getWindData( );
    case 'indoorTemp'
        [ Xv, Yv ] = getIndoorTempData( );
    case 'ozone'
        [ Xv, Yv ] = getOzoneData( );
    case 'sp500'
        [ Xv, Yv ] = getSP500Data();
    case 'juraCu'
        [ Xv, Yv ] = getJuraCuData();
    case 'juraCo'
        [ Xv, Yv ] = getJuraCoData();
    case 'juraCd'
        [ Xv, Yv ] = getJuraCdData();
    case 'juraCr'
        [ Xv, Yv ] = getJuraCrData();
    case 'juraLanduse'
        [ Xv, Yv ] = getJuraLanduseData();
    case 'juraRock'
        [ Xv, Yv ] = getJuraRockData();
    case 'juraNi'
        [ Xv, Yv ] = getJuraNiData();
    case 'juraPb'
        [ Xv, Yv ] = getJuraPbData();
    case 'juraZn'
        [ Xv, Yv ] = getJuraZnData();
    otherwise,
        error('unknown data source name');
end

end


%get S&P 500 Price Index data. 
%
%Outputs: 
%
%Xv is a vector of input coordinates of data with size n*3 wherein n represents number of price index data points and the three columns are for year, month, date of month respectively.  
%
%Yv is a vector of stock price index data points with size n*1
%corresponding to the date coordinates vector Xv.
%
%Data Details: 
%The SP500 data was retrieved from web with link below:
%http://research.stlouisfed.org/fred2/series/SP500/downloaddata. This
%website provides the stock price index data starting from its inception till date. 
%
function [ Xv, Yv ] = getSP500Data()

load sp500;

Xv = sp500.X( 1:100:end, :);
Yv = sp500.Y( 1:100:end, :);

end

%
%get cupper data from the jura dataset.
%
%Outputs: 
%
%Xv is a vector of 2-D input coordinates of data with size n*2.
%
%Yv is a vector of cupper mineral concentration data points with size n*1
%corresponding to the date coordinates vector Xv.
%
%Data Details: 
%The Jura dataset contains concentration samples for many minerals
%including Cupper. The complete dataset is published at web with link
%below:
%https://sites.google.com/site/goovaertspierre/pierregoovaertswebsite/download/jura-data
%

function [ Xv, Yv ] = getJuraCuData()

load juraData;

Xv = juraData.X;
Yv = juraData.Cu;

end

function [ Xv, Yv ] = getJuraLanduseData()

load juraData;

Xv = juraData.X;
Yv = juraData.Landuse;

end

function [ Xv, Yv ] = getJuraRockData()

load juraData;

Xv = juraData.X;
Yv = juraData.Rock;

end

function [ Xv, Yv ] = getJuraCdData()

load juraData;

Xv = juraData.X;
Yv = juraData.Cd;

end

function [ Xv, Yv ] = getJuraCoData()

load juraData;

Xv = juraData.X;
Yv = juraData.Co;

end

function [ Xv, Yv ] = getJuraCrData()

load juraData;

Xv = juraData.X;
Yv = juraData.Cr;

end

function [ Xv, Yv ] = getJuraNiData()

load juraData;

Xv = juraData.X;
Yv = juraData.Ni;

end

function [ Xv, Yv ] = getJuraPbData()

load juraData;

Xv = juraData.X;
Yv = juraData.Pb;

end

function [ Xv, Yv ] = getJuraZnData()

load juraData;

Xv = juraData.X;
Yv = juraData.Zn;

end

%Get image data
%
%outputs: 
%Xv is a vector with size n*3 representing spatio-temporal input
%locations with first two columns of vector for spatial coordinates and the
%third one for indices of equally distant time instances.
%
%Yv represents sunlight intensity measure as per recorded brightness in
%images captured across time. 
%
%
function [ Xv, Yv ] = getImageData()

load imageData;

T = 1:size( imageData.data, 1 );

[ Xv, Yv ] = extndTmprlDmnsnFrSpcTmData( imageData.coords, T, imageData.data(T, :) );

end

%Get rain data
function [ Xv, Yv ] = getRainData()

load rainData;

T = 1:50:size( rainData.trainData.sensordata, 1);

[ Xv, Yv ] = extndTmprlDmnsnFrSpcTmData( rainData.coords, T, rainData.trainData.sensordata(T, :) );

end

%Get wind data
function [ Xv, Yv ] = getWindData( )

load irish_wind_data;

T = 1:10:360; %data for year 1961

[ Xv, Yv ] = extndTmprlDmnsnFrSpcTmData( irish_wind_data.coords, T, irish_wind_data.data(T, :) ) ;

end

%Get ozone data
function [ Xv, Yv ] = getOzoneData( )

load ozone_data;

T = 1:size( ozone_data.data, 1 );

[ Xv, Yv ] = extndTmprlDmnsnFrSpcTmData( ozone_data.coords, T, ozone_data.data(T, :) );

end


%Get Indoor temperature data (from Intel Lab. in UC Berkeley)
function [ Xv, Yv ] = getIndoorTempData( )

load berkeley_data;

T = 1:100:size( berkeley_data.data, 1 );

[ Xv, Yv ] = extndTmprlDmnsnFrSpcTmData( berkeley_data.coords, T, berkeley_data.data(T, :) );

end

%Extend temporal dimensions of spatial coordinates X with T and also format data Y accordingly 
function [Xe, Ye] = extndTmprlDmnsnFrSpcTmData( X, T, Y )

x = size( X, 1 );
t = length(T);
Xe = repmat( X, t, 1 );
Ye = [];

for i=1:t;
    Xe( (x*(i-1)+1):x*i, 3 ) = T(i);
    Ye = [ Ye Y(i, :) ];
end

Ye = Ye';

end