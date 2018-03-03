float[][] matrix5conv = { { 3,   1, -1,  1,  3},
			  { 1,  -2, -2, -2,  1},
			  { -1, -2, -3, -2, -1},
			  { 1,  -2, -2, -2,  1},
			  { 3,   1, -1,  1,  3}}; 


float[][] matrix3erode = { {  1,  1,  1 },
			   {  1,  1,  1 },
			   {  1,  1,  1 } }; 

int max = 70;
color erosion(int x, int y, float[][] matrix, int matrixsize, PImage img){
    float rtotal = 0.0;
    float gtotal = 0.0;
    float btotal = 0.0;

    int off = x + img.width*y;

    int rinit = (int) max;
    int ginit = (int) max;
    int binit = (int) max;
    // int rinit = (int) red(img.pixels[off]);
    // int ginit = (int) green(img.pixels[off]);
    // int binit = (int) blue(img.pixels[off]);

    int matSum = 0;
    for(int i = 0; i < matrixsize; i++){
	for(int j = 0; j < matrixsize; j++){
	    matSum += matrix[i][j];
	}
    }

    int vSumr = 0, vSumg = 0, vSumb = 0;
    int offset = matrixsize / 2;
    for (int i = 0; i < matrixsize; i++){
	for (int j= 0; j < matrixsize; j++){
	    // What pixel are we testing
	    int xloc = x+i-offset;
	    int yloc = y+j-offset;
	    int loc = xloc + img.width*yloc;
	    // Make sure we haven't walked off our image, we could do better here
	    loc = constrain(loc,0,img.pixels.length-1);

	    // Calculate erosion
	    if(matrix[i][j] == 1 && red(img.pixels[loc]) >= rinit){
		vSumr++;
	    }

	    if(matrix[i][j] == 1 && green(img.pixels[loc]) >= ginit){
		vSumg++;
	    }

	    if(matrix[i][j] == 1 && blue(img.pixels[loc]) >= binit){
		vSumb++;
	    }
	}
    }
    // Make sure RGB is within range
    rtotal = vSumr == matSum ? rinit : 0;
    gtotal = vSumg == matSum ? ginit : 0;
    btotal = vSumb == matSum ? binit : 0;

    // Return the resulting color
    return color(rtotal, gtotal, btotal);
}



color convolution(int x, int y, float[][] matrix, int matrixsize, PImage img){
    float rtotal = 0.0;
    float gtotal = 0.0;
    float btotal = 0.0;
    int offset = matrixsize / 2;
    for (int i = 0; i < matrixsize; i++){
	for (int j= 0; j < matrixsize; j++){
	    // What pixel are we testing
	    int xloc = x+i-offset;
	    int yloc = y+j-offset;
	    int loc = xloc + img.width*yloc;
	    // Make sure we haven't walked off our image, we could do better here
	    loc = constrain(loc,0,img.pixels.length-1);
	    // Calculate the convolution
	    rtotal += (red(img.pixels[loc]) * matrix[i][j]);
	    gtotal += (green(img.pixels[loc]) * matrix[i][j]);
	    btotal += (blue(img.pixels[loc]) * matrix[i][j]);
	}
    }
    // Make sure RGB is within range
    rtotal = constrain(rtotal / 4f, 0, 255);
    gtotal = constrain(gtotal / 4f, 0, 255);
    btotal = constrain(btotal / 4f, 0, 255);
    // Return the resulting color
    return color(rtotal, gtotal, btotal);
}

