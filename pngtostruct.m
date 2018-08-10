function S = pngtostruct(png)
%PNGTOSTRUCT Converts a PNG file to a structure of binary fields.
%  data = PNGTOSTRUCT(png) opens a file using the Portable Network Graphics
%  file specification and returns a structure using the data chunk types as
%  field names containing their data. Duplicate chunks, such as IDAT
%  typically, have their data stored as cell arrays preserving the data
%  size of each chunk.
%  
%  For explaination of the PNG file format refer to the specification here:
%  https://www.w3.org/TR/PNG/
%
%  Copyright (C) 2018  Nick Macholl

   %% Open File
   pngfile = fopen(png, 'r');
   pnghead = fread(pngfile, 8);
   S = struct();
   
   %% Verify PNG Header
   if any(pnghead ~= [137; 80; 78; 71; 13; 10; 26; 10])
      [~, filename, ext] = fileparts(png);
      warning('File ''%s%s'' is not a PNG', filename, ext)
      fclose(pngfile);
      return
   end
   
   %% Iterate Chunks
   while true
      chunk.size = fread(pngfile, 1, '*uint32', 'b');
      chunk.type = fread(pngfile, 4, '*char', 'b')';
      chunk.data = fread(pngfile, chunk.size, '*uint8', 'b');
      chunk.crc = reshape(dec2hex(fread(pngfile, 4, 'uint8', 'b'))', [1 8]);
      if isfield(S, chunk.type)
         if ~iscell(S.(chunk.type))
            S.(chunk.type) = {S.(chunk.type)};
         end
         S.(chunk.type){end+1} = chunk.data';
      else
         S.(chunk.type) = chunk.data';
      end
      if strcmp(chunk.type, 'IEND')
         % EOF
         break;
      end
   end
   
   %% Close File
   fclose(pngfile);
   
end
