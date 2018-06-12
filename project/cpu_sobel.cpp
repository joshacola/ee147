#include <string>
#include "EasyBMP.h"
using namespace std;
int cpu_sobel(string filename){
    
    int mult_weights[3][3];
    int div_weights[3][3];
    for (int i = 0; i < 3; i++){
        for (int j = 0; j < 3; j++){
            div_weights[i][j] = 1;
            mult_weights[i][j] = 1;
        }
    }
    
    //     WEIGHTS
    mult_weights[0][0] = 1;
    mult_weights[1][0] = 2;
    mult_weights[2][0] = 1;
    
    mult_weights[0][1] = 0;
    mult_weights[1][1] = 0;
    mult_weights[2][1] = 0;
    
    mult_weights[0][2] = -1;
    mult_weights[1][2] = -2;
    mult_weights[2][2] = -1;
    //    END WEGIHTS
    
    BMP Background;
    Background.ReadFromFile(filename.c_str());
    int height = Background.TellHeight();
    int width = Background.TellWidth();
    int depth = Background.TellBitDepth();
    BMP Output;
    Output.SetSize( width , height );
    Output.SetBitDepth( 24 );
    for (int i = 1; i < width-1; i++){
        for (int j = 1; j < height-1; j++){
            RGBApixel temp = Background.GetPixel(i, j);
            RGBApixel temp2 = Background.GetPixel(i-1, j-1);
            int Blue = 0;
            int Green = 0;
            int Red = 0;
            Blue += (static_cast<int>(temp2.Blue)*mult_weights[0][0])/div_weights[0][0];;
            Green += (static_cast<int>(temp2.Green)*mult_weights[0][0])/div_weights[0][0];
            Red += (static_cast<int>(temp2.Red)*mult_weights[0][0])/div_weights[0][0];
            temp2 = Background.GetPixel(i, j-1);
            Blue += (static_cast<int>(temp2.Blue)*mult_weights[1][0])/div_weights[1][0];;
            Green += (static_cast<int>(temp2.Green)*mult_weights[1][0])/div_weights[1][0];
            Red += (static_cast<int>(temp2.Red)*mult_weights[1][0])/div_weights[1][0];
            temp2 = Background.GetPixel(i+1, j-1);
            Blue += (static_cast<int>(temp2.Blue)*mult_weights[2][0])/div_weights[2][0];;
            Green += (static_cast<int>(temp2.Green)*mult_weights[2][0])/div_weights[2][0];
            Red += (static_cast<int>(temp2.Red)*mult_weights[2][0])/div_weights[2][0];
            temp2 = Background.GetPixel(i-1, j);
            Blue += (static_cast<int>(temp2.Blue)*mult_weights[0][1])/div_weights[0][1];;
            Green += (static_cast<int>(temp2.Green)*mult_weights[0][1])/div_weights[0][1];
            Red += (static_cast<int>(temp2.Red)*mult_weights[0][1])/div_weights[0][1];
            temp2 = Background.GetPixel(i, j);
            Blue += (static_cast<int>(temp2.Blue)*mult_weights[1][1])/div_weights[1][1];;
            Green += (static_cast<int>(temp2.Green)*mult_weights[1][1])/div_weights[1][1];
            Red += (static_cast<int>(temp2.Red)*mult_weights[1][1])/div_weights[1][1];
            temp2 = Background.GetPixel(i+1, j);
            Blue += (static_cast<int>(temp2.Blue)*mult_weights[2][1])/div_weights[2][1];;
            Green += (static_cast<int>(temp2.Green)*mult_weights[2][1])/div_weights[2][1];
            Red += (static_cast<int>(temp2.Red)*mult_weights[2][1])/div_weights[2][1];
            temp2 = Background.GetPixel(i-1, j+1);
            Blue += (static_cast<int>(temp2.Blue)*mult_weights[0][2])/div_weights[0][2];;
            Green += (static_cast<int>(temp2.Green)*mult_weights[0][2])/div_weights[0][2];
            Red += (static_cast<int>(temp2.Red)*mult_weights[0][2])/div_weights[0][2];
            temp2 = Background.GetPixel(i, j+1);
            Blue += (static_cast<int>(temp2.Blue)*mult_weights[1][2])/div_weights[1][2];;
            Green += (static_cast<int>(temp2.Green)*mult_weights[1][2])/div_weights[1][2];
            Red += (static_cast<int>(temp2.Red)*mult_weights[1][2])/div_weights[1][2];
            temp2 = Background.GetPixel(i+1, j+1);
            Blue += (static_cast<int>(temp2.Blue)*mult_weights[2][2])/div_weights[2][2];;
            Green += (static_cast<int>(temp2.Green)*mult_weights[2][2])/div_weights[2][2];
            Red += (static_cast<int>(temp2.Red)*mult_weights[2][2])/div_weights[2][2];
            if (Blue < 0) Blue = 0;
            if (Green < 0) Green = 0;
            if (Red < 0) Red = 0;
            if (Blue > 255) Blue = 255;
            if (Green > 255) Green = 255;
            if (Red > 255) Red = 255;
            temp.Blue = static_cast<char>(Blue);
            temp.Green = static_cast<char>(Green);
            temp.Red = static_cast<char>(Red);
            Output.SetPixel(i, j, temp);
        }
    }
    cout << "writing bmp ... " << endl;
    string fileout = filename;
    fileout.pop_back();
    fileout.pop_back();
    fileout.pop_back();
    fileout.pop_back();
    string extra = "_cpu_sobel.bmp";
    fileout = fileout + extra;
    Output.WriteToFile(fileout.c_str());
    return 0;
}

