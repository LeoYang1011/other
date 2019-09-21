function make_file(U,W,dt)

[row,column] =  size(U);

for index = 1:column
    time = (index - 1) * dt;
    mkdir(['boundaryData/inlet/',num2str(time)]);
    U_id = fopen(['boundaryData/inlet/',num2str(time),'\U'],'w');
    
    fprintf(U_id,'%s\n','/*--------------------------------*- C++ -*----------------------------------*\');
    fprintf(U_id,'%s\n','| =========                 |                                                 |');
    fprintf(U_id,'%s\n','| \\      /  F ield         | foam-extend: Open Source CFD                    |');
    fprintf(U_id,'%s\n','|  \\    /   O peration     | Version:     3.1                                |');
    fprintf(U_id,'%s\n','|   \\  /    A nd           | Web:         http://www.extend-project.de       |');
    fprintf(U_id,'%s\n','|    \\/     M anipulation  |                                                 |');
    fprintf(U_id,'%s\n','\*---------------------------------------------------------------------------*/');
    fprintf(U_id,'%s\n','FoamFile');
    fprintf(U_id,'%s\n','{');
    fprintf(U_id,'%s\n','    version     2.0;');
    fprintf(U_id,'%s\n','    format      ascii;');
    fprintf(U_id,'%s\n','    class       vectorAverageField;');
    fprintf(U_id,'%s\n','    object      values;');
    fprintf(U_id,'%s\n','}');
    fprintf(U_id,'%s\n','// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //');
    fprintf(U_id,'\n');
    fprintf(U_id,'%s\n','// Average');
    fprintf(U_id,'%s\n','(0 0 0)');
    fprintf(U_id,'\n');
    fprintf(U_id,'%s\n','// Data on points');
    fprintf(U_id,'%s\n',num2str(row*2));
    fprintf(U_id,'%s\n','(');
    fprintf(U_id,'\n');
    fprintf(U_id,'%s\n',' // min z');
    
    for inside_index = 1:row
        fprintf(U_id,'%s\n',['(',num2str(U(inside_index,index)),' ',num2str(W(inside_index,index)),' ','0)']);
    end
    
    fprintf(U_id,'\n');
    fprintf(U_id,'%s\n',' // max z');
    
    for inside_index = 1:row
        fprintf(U_id,'%s\n',['(',num2str(U(inside_index,index)),' ',num2str(W(inside_index,index)),' ','0)']);
    end
    
    fprintf(U_id,'%s\n',')');
    fprintf(U_id,'\n');
    fprintf(U_id,'%s\n','// ************************************************************************* //');
    
    fclose(U_id);
end

end

    