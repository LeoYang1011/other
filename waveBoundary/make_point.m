function make_point(zCoordinate)

pointId = fopen('boundaryData/inlet/points','w');

fprintf(pointId,'%s\n','/*--------------------------------*- C++ -*----------------------------------*\');
fprintf(pointId,'%s\n','| =========                 |                                                 |');
fprintf(pointId,'%s\n','| \\      /  F ield         | foam-extend: Open Source CFD                    |');
fprintf(pointId,'%s\n','|  \\    /   O peration     | Version:     3.1                                |');
fprintf(pointId,'%s\n','|   \\  /    A nd           | Web:         http://www.extend-project.de       |');
fprintf(pointId,'%s\n','|    \\/     M anipulation  |                                                 |');
fprintf(pointId,'%s\n','\*---------------------------------------------------------------------------*/');
fprintf(pointId,'%s\n','FoamFile');
fprintf(pointId,'%s\n','{');
fprintf(pointId,'%s\n','    version     2.0;');
fprintf(pointId,'%s\n','    format      ascii;');
fprintf(pointId,'%s\n','    class       vectorField;');
fprintf(pointId,'%s\n','    object      points;');
fprintf(pointId,'%s\n','}');
fprintf(pointId,'%s\n','// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //');
fprintf(pointId,'\n');
fprintf(pointId,'%s\n','(');
fprintf(pointId,'%s\n',' // min z');

for index = 1:length(zCoordinate)/2
    %fprintf(pointId,'%s\n',[' (',num2str(zCoordinate(index,1)),' ',num2str(zCoordinate(index,2)),' ',num2str(zCoordinate(index,3)),')']);
    fprintf(pointId,'%s\n',[' (',num2str(0),' ',num2str(zCoordinate(index,2)),' ',num2str(zCoordinate(index,3)),')']);
end

fprintf(pointId,'\n');
fprintf(pointId,'%s\n',' // max z');

for index = length(zCoordinate)/2+1 : length(zCoordinate)
    %fprintf(pointId,'%s\n',[' (',num2str(zCoordinate(index,1)),' ',num2str(zCoordinate(index,2)),' ',num2str(zCoordinate(index,3)),')']);
    fprintf(pointId,'%s\n',[' (',num2str(0),' ',num2str(zCoordinate(index,2)),' ',num2str(zCoordinate(index,3)),')']);
end

fprintf(pointId,'\n');
fprintf(pointId,'%s\n',')');
fprintf(pointId,'\n');
fprintf(pointId,'%s\n','// ************************************************************************* //');

fclose(pointId);
end
