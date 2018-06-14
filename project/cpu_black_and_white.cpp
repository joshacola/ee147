using namespace std;
int cpu_b_and_w(string filename){
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
            int Blue = static_cast<int>(temp.Blue);
            int Green = static_cast<int>(temp.Green);
            int Red = static_cast<int>(temp.Red);
            Blue+=Red+Green;
            Blue /= 3;
            if (Blue < 0) Blue = 0;
            if (Blue > 255) Blue = 255;
            temp.Blue = static_cast<char>(Blue);
            temp.Green = static_cast<char>(Blue);
            temp.Red = static_cast<char>(Blue);
            Output.SetPixel(i, j, temp);
        }
    }
    cout << "writing bmp ... " << endl;
    string fileout = filename;
    fileout.pop_back();
    fileout.pop_back();
    fileout.pop_back();
    fileout.pop_back();
    string extra = "_cpu_black_and_white.bmp";
    fileout = fileout + extra;
    Output.WriteToFile(fileout.c_str());
    return 0;
}
