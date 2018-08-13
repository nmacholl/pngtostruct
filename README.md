# PNGTOSTRUCT.m
This function converts a [Portable Network Graphics (PNG)](https://www.w3.org/TR/PNG/) file to a MATLAB structure of binary fields.
Applications of this function include image processing in MATLAB and payload extraction from PNG files.

## Example 0
Using the article image from the [Wikipedia entry for PNG files](https://en.wikipedia.org/wiki/Portable_Network_Graphics), we can observe the contents.

![From Wikipedia](https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/PNG_transparency_demonstration_1.png/280px-PNG_transparency_demonstration_1.png)

    png = pngtostruct('280px-PNG_transparency_demonstration_1.png')

    png = 
        struct with fields:
            IHDR: [0 0 1 24 0 0 0 210 8 6 0 0 0]
            gAMA: [0 0 177 143]
            cHRM: [0 0 122 38 0 0 128 132 0 0 250 0 0 0 128 232 0 0 117 48 0 0 234 96 0 0 58 152 0 0 23 112]
            bKGD: [0 255 0 255 0 255]
            tIME: [7 226 7 11 0 48 47]
            IDAT: {[1×32768 uint8]  [1×6513 uint8]}
            tEXt: {[100 97 116 101 58 99 114 101 97 116 101 0 50 48 49 56 45 48 55 45 49 49 84 48 48 58 52 56 58 52 55 43 48 48 58 48 48]  [1×37 uint8]}
            IEND: []

Note that chunks of the same type are stored as cell arrays preserving the data in each chunk.

## Example 1
We can examine the contents of the **tEXt** field very easily. There were two **tEXt** chunks in this file so we can access each chunk using cell array indexing.

    char(png.tEXt{1})

        ans =
            'date:create 2018-07-11T00:48:47+00:00'

    char(png.tEXt{2})

        ans =
            'date:modify 2018-07-11T00:48:47+00:00'

## Example 2
The **IHDR** field often contains useful information. Here is how we can read the width and height from this chunk.

    width = typecast(png.IHDR(4:-1:1), 'uint32')

    width =
        uint32
        280

    height = typecast(png.IHDR(8:-1:5), 'uint32')

    height =
        uint32
        210

Our image is 280px by 210px.
