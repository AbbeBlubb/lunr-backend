          Scream Tracker 3.20 File Formats And Mixing Info 
          ================================================ 
 
This document finally containts the OFFICIAL information on s3m format 
and much more. There might be some errors here, so if something seems 
weird, don't just blindly believe it. Think first if it could be just 
a typo or something. 
 
----------------------------------------------------------------------------- 
What is the S3M file format? 
What is the samplefile format? 
What is the adlib instrument format? 
 
 
        The first table describes the S3M header. All other blocks are 
        pointer to by pointers, so in theory they could be anywhere in 
        the file. However, the practical standard order is: 
        - header 
        - instruments in order 
        - patterns in order 
        - samples in order 
 
        Next the instrument header is described. It is stored to S3M 
        for each instrument and also saved to the start of all samples 
        saved from ST3. Same header is also used by Advance Digiplayer. 
 
        The third part is the description of the packed pattern format. 
 
 
                                S3M Module header 
          0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F 
        ����������������������������������������������������������������� 
  0000: 3 Song name, max 28 chars (end with NUL (0))                    3 
        ~A���������������������������������������������������������������' 
  0010: 3                                               31Ah3Typ3 x 3 x 3 
        ~A���������������������������������������������������������������' 
  0020: 3OrdNum 3InsNum 3PatNum 3 Flags 3 Cwt/v 3 Ffi   3'S'3'C'3'R'3'M'3 
        ~A���������������������������������������������������������������' 
  0030: 3g.v3i.s3i.t3m.v3u.c3d.p3 x 3 x 3 x 3 x 3 x 3 x 3 x 3 x 3Special3 
        ~A���������������������������������������������������������������' 
  0040: 3Channel settings for 32 channels, 255=unused,+128=disabled     3 
        ~A���������������������������������������������������������������' 
  0050: 3                                                               3 
        ~A���������������������������������������������������������������' 
  0060: 3Orders; length=OrdNum (should be even)                         3 
        ~A���������������������������������������������������������������' 
  xxx1: 3Parapointers to instruments; length=InsNum*2                   3 
        ~A���������������������������������������������������������������' 
  xxx2: 3Parapointers to patterns; length=PatNum*2                      3 
        ~A���������������������������������������������������������������' 
  xxx3: 3Channel default pan positions                                  3 
        ~A���������������������������������������������������������������' 
        xxx1=70h+orders 
        xxx2=70h+orders+instruments*2 
        xxx3=70h+orders+instruments*2+patterns*2 
 
        Parapointers to file offset Y is (Y-Offset of file header)/16. 
        You could think of parapointers as segments relative to the 
        start of the S3M file. 
 
        Type    = File type: 16=ST3 module 
        Ordnum  = Number of orders in file (should be even!) 
	Insnum	= Number of instruments in file 
	Patnum	= Number of patterns in file 
        Cwt/v   = Created with tracker / version: &0xfff=version, >>12=tracker 
                        ST3.00:0x1300 (NOTE: volumeslides on EVERY frame) 
                        ST3.01:0x1301 
                        ST3.03:0x1303 
                        ST3.20:0x1320 
        Ffi     = File format information 
                        1=[VERY OLD] signed samples 
                        2=unsigned samples 
        Flags   =  [ These are old flags for Ffv1. Not supported in ST3.01 
                   |  +1:st2vibrato 
                   |  +2:st2tempo 
                   |  +4:amigaslides 
                   | +32:enable filter/sfx with sb 
                   ] 
                    +8: 0vol optimizations 
                          Automatically turn off looping notes whose volume 
                          is zero for >2 note rows. 
                   +16: amiga limits 
                          Disallow any notes that go beond the amiga hardware 
                          limits (like amiga does). This means that sliding 
                          up stops at B#5 etc. Also affects some minor amiga 
                          compatibility issues. 
                   +64: st3.00 volumeslides 
                          Normally volumeslide is NOT performed on first 
                          frame of each row (this is according to amiga 
                          playing). If this is set, volumeslide is performed 
                          ALSO on the first row. This is set by default 
                          if the Cwt/v files is 0x1300 
                  +128: special custom data in file (see below) 
        Special = pointer to special custom data (not used by ST3.01) 
        ExtHead = pointer to extended header data area (generally after) 
                  the main header) 
	g.v	= global volume (see next section) 
	m.v	= master volume (see next section) 7 lower bits 
                  bit 8: stereo(1) / mono(0) 
	i.s	= initial speed (command A) 
	i.t    	= initial tempo (command T) 
        u.c     = ultra click removal. ST3 uses u.c gus channels to 
                  guarantee, that u.c/2 channels run without any clicks. 
                  If more channels are used, some clicks might appear. 
                  The number displayed in ST3 order page is u.c/2 
        d.p     = 252 when default channel pan positions are present 
                  in the end of the header (xxx3). If !=252 ST3 doesn't 
                  try to load channel pan settings. 
 
        Channel settings (byte per channel): 
          bit 8: channel enabled 
        bit 0-7: channel type 
                 0..7   : Left Sample Channel 1-8 
                 8..15  : Right Sample Channel 1-8 
                 16..31 : Adlib channels (9 melody + 5 drums) 
 
        Channel pan settings (byte per channel): 
        bit 6-7: reserved 
          bit 5: 1=default pan position specified, 0=use defaults: 
                 for mono 7, for stereo 3 or C. 
        bit 0-3: default pan position 
 
 
        Global volume directly divides the volume numbers used. So 
        if the module has a note with volume 48 and master volume 
        is 32, the note will be played with volume 24. This affects 
        both Gravis & SoundBlasters. 
 
        Master volume only affects the SoundBlaster. It controls 
        the amount of sample multiplication (see mixing section 
        of this doc). The bigger the value the bigger the output 
        volume (and thus quality) will be. However if the value 
        is too big, the mixer may have to clip the output to 
        fit the 8 bit output stream. The default value works 
        pretty well. Note that in stereo, the mastermul is 
        internally multiplied by 11/8 inside the player since 
        there is generally more room in the output stream. 
 
        Order list lists the order in which to play the patterns. 255=-- 
        is the end of tune mark and 254=++ is just a marker that is 
        skipped. 
 
 
 
                        Digiplayer/ST3 samplefileformat 
          0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F 
        ����������������������������������������������������������������� 
  0000: 3[T]3 Dos filename (12345678.ABC)                   3    MemSeg 3 
        ~A���������������������������������������������������������������' 
  0010: 3Length 3HI:leng3LoopBeg3HI:LBeg3LoopEnd3HI:Lend3Vol3 x 3[P]3[F]3 
        ~A���������������������������������������������������������������' 
  0020: 3C2Spd  3HI:C2sp3 x 3 x 3 x 3 x 3Int:Gp 3Int:5123Int:lastused   3 
        ~A���������������������������������������������������������������' 
  0030: 3 Sample name, 28 characters max... (incl. NUL)                 3 
        ~A���������������������������������������������������������������' 
  0040: 3 ...sample name...                             3'S'3'C'3'R'3'S'3 
        ~A���������������������������������������������������������������' 
  xxxx:	sampledata 
 
        Length / LoopBegin / LoopEnd are all 32 bit parameters although 
        ST3 only support file sizes up to 64,000 bytes. Files bigger 
        than that are clipped to 64,000 bytes when loaded to ST3. NOTE 
        that LoopEnd points to one byte AFTER the end of the sample, 
        so LoopEnd=100 means that byte 99.9999 (fixed) is the last one 
        played. 
        C2Spd  = Herz for middle C. ST3 only uses lower 16 bits. 
        Vol    = Default volume 0..64 
        Memseg = Pointer to sampledata 
                 Inside a sample or S3M, MemSeg tells the parapointer to 
                 the actual sampledata. In files all 24 bits are used. 
                 In memory the value points to the actual sample segment 
                 or Fxxx if sample is in EMS under handle xxx. In memory 
                 the first memseg byte is overwritten with 0 to create 
                 the dos filename terminator nul. 
        Int:Gp = Internal: Address of sample in gravis memory /32 
                 (only used while module in memory) 
        Int:512= Internal: flags for soundblaster loop expansion 
                 (only used while module in memory) 
        Int:las= Internal: last used position (only works with sb) 
                 (only used while module in memory) 
        [T]ype   1=Sample, 2=adlib melody, 3+=adlib drum (see below for 
                 adlib structure) 
	[F]lags, +1=loop on 
		 +2=stereo (after Length bytes for LEFT channel, 
		 	  another Length bytes for RIGHT channel) 
                 +4=16-bit sample (intel LO-HI byteorder) 
                 (+2/+4 not supported by ST3.01) 
        [P]ack   0=unpacked, 1=DP30ADPCM packing (not used by ST3.01) 
 
 
 
                              adlib instrument format 
          0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F 
        ����������������������������������������������������������������� 
  0000: 3[T]3 Dos filename (12345678.123)                   300h300h300h3 
        ~A���������������������������������������������������������������' 
  0010: 3D003D013D023D033D043D053D063D073D083D093D0A3D0B3Vol3Dsk3 x 3 x 3 
        ~A���������������������������������������������������������������' 
  0020: 3C2Spd  3HI:C2sp3 x 3 x 3 x 3 x 3 x 3 x 3 x 3 x 3 x 3 x 3 x 3 x 3 
        ~A���������������������������������������������������������������' 
  0030: 3 Sample name, 28 characters max... (incl. NUL)                 3 
        ~A���������������������������������������������������������������' 
  0040: 3 ...sample name...                             3'S'3'C'3'R'3'I'3 
        ~A���������������������������������������������������������������' 
 
        [T]ype  = 2:amel 3:abd 4:asnare 5:atom 6:acym 7:ahihat 
        C2Spd   = 'Herz' for middle C. ST3 only uses lower 16 bits. 
                  Actually this is a modifier since there is no 
                  clear frequency for adlib instruments. It scales 
                  the note freq sent to adlib. 
        D00..D0B contains the adlib instrument specs packed like this: 
        modulator:                                              carrier: 
        D00=[freq.muliplier]+[?scale env.]*16+[?sustain]*32+    =D01 
                [?pitch vib]*64+[?vol.vib]*128 
	D02=[63-volume]+[levelscale&1]*128+[l.s.&2]*64		=D03 
	D04=[attack]*16+[decay]					=D05 
	D06=[15-sustain]*16+[release]				=D07 
	D08=[wave select]					=D09 
	D0A=[modulation feedback]*2+[?additive synthesis] 
	D0B=unused 
 
 
 
                          packed pattern format 
          0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F 
        ����������������������������������������������������������������� 
  0000: 3Length 3 packed data, see below... 
        ~A���������������������������������������������������������������' 
 
        Length = length of packed pattern 
 
        Unpacked pattern is always 32 channels by 64 rows. Below 
        is the unpacked format st uses for reference: 
          Unpacked Internal memoryformat for patterns (not used in files): 
          NOTE: each channel takes 320 bytes, rows for each channel are 
                sequential, so one unpacked pattern takes 10K. 
          byte 0 - Note; hi=oct, lo=note, 255=empty note, 
                   254=key off (used with adlib, with samples stops smp) 
          byte 1 - Instrument      ;0=.. 
          byte 2 - Volume          ;255=.. 
          byte 3 - Special command ;255=.. 
          byte 4 - Command info    ; 
 
        Packed data consits of following entries: 
        BYTE:what  0=end of row 
                   &31=channel 
                   &32=follows;  BYTE:note, BYTE:instrument 
                   &64=follows;  BYTE:volume 
                   &128=follows; BYTE:command, BYTE:info 
 
        So to unpack, first read one byte. If it's zero, this row is 
        done (64 rows in entire pattern). If nonzero, the channel 
        this entry belongs to is in BYTE AND 31. Then if bit 32 
        is set, read NOTE and INSTRUMENT (2 bytes). Then if bit 
        64 is set read VOLUME (1 byte). Then if bit 128 is set 
        read COMMAND and INFO (2 bytes). 
 
        For information on commands / how st3 plays them, see the 
        manual. 
	 
 
----------------------------------------------------------------------------- 
What is the Stmik300old format? 
What is the STIMPORT file format? 
What is the SIMPLEXFILE format? 
 
        The old stmik 300 (never published because it has no 
        usable interface) want's that the samples in the module 
        are pre-extended for soundblaster. This means that 
        samples have an extra 512 bytes of loop after their 
        loopend (or silence if no loop). The save option for 
        old stmik does this extension. Otherwise the fileformat 
        is the same as for a normal S3M. 
 
        STIMPORT file format is supposed to be an easy way of 
        imputting weird data to st3. That is, it should be 
        easy to convert something to STIMPORT format. The format 
        goes like this: 
 
          0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F 
        ����������������������������������������������������������������� 
  0000: 3'S'3'T'3'I'3'M'3'P'3'O'3'R'3'T'3i.s3 x 3 x 3 x 3 x 3 x 3 x 3 x 3 
        ~A���������������������������������������������������������������' 
  0010: 3Notedata... 
        ~A���������������������������������������������������������������' 
  xxxx: 3Instruments... 
        ~A���������������������������������������������������������������' 
 
        There are no patterns or orders, just a continuos note stream 
        of following structures: 
          0    1    2    3    4    5 
        ������������������������������� 
        3Chan3Note3Inst3Volu3Cmnd3Info3 
        ������������������������������� 
        Chan is the channel number for the note +128. Value 0 stands 
        for next row. Value 255 stands for end of note stream. 
        Note/Inst/Cmnd/Info are like in the unpacked memory pattern 
        (see previous section) 
 
        After the notedata there can be instruments (optional) 
        Every instrument consits of the following block: 
          0    1    2    3    4 
        ����������������������������������������������������...��������... 
        3Inst3Flag3LoopBeg  3LoopEnd  3Length   3 Sampledata... 3 Name (opt) 
        ����������������������������������������������������...��������... 
        Inst = number of instrument to load (0=end of instruments) 
        Flag = +1=loop enabled +128=name after sampledata (null terminated) 
        LoopBeg/LoopEnd/Length = guess 
        Sampledata = raw sampledata for Length bytes. 
 
 
        SIMPLEXFORMAT is designed for easy export of notedata. 
        The contents of a S3Y file is: 
 
        32 first instruments, 128 bytes each. 
          The 80 first bytes correspond to the ST3 Samplefile header 
          (described in this file). The rest correspond to nothing. 
        Raw notedata for the entire song - 9 channels stored. 
          Every row consists of 9 notes, each consisting of 5 bytes: 
          ��������������������� 
          3not3ins3vol3cmd3inf3 
          ~A�������������������� 
          byte 0 - Note; hi=oct, lo=note, 255=empty note, 
                   254=key off (used with adlib, with samples stops smp) 
          byte 1 - Instrument      ;0=.. 
          byte 2 - Volume          ;255=.. 
          byte 3 - Special command ;255=.. 
          byte 4 - Command info    ; 
 
 
----------------------------------------------------------------------------- 
What is C2SPD? 
How to calculate the note frequencies like ST3? 
How does ST3 mix depending on master volume? 
 
 
        Finetuning (C2SPD) is actually the frequency in herz for 
        the note C4. Why is it C2SPD? Well, originally in ST2 
        the middle note was C2 and the name stuck. Later in ST3 
        the middle note was raised to C4 for more octaves... So 
        actually C2SPD should be called C4SPD... 
 
 
        Table for note frequencies used by ST3: 
 
	  note:  C    C#   D    D#   E    F    F#   G    G#   A    A#   B 
	period: 1712,1616,1524,1440,1356,1280,1208,1140,1076,1016,0960,0907 
	 
	middle octave is 4. 
	 
			 8363 * 16 * ( period(NOTE) >> octave(NOTE) ) 
	note_st3period = -------------------------------------------- 
	 		 middle_c_finetunevalue(INSTRUMENT) 
			  
	note_amigaperiod = note_st3period / 4 
			  
	note_herz=14317056 / note_st3period 
 
        Note that ST3 uses period values that are 4 times larger than the 
        amiga to allow for extra fine slides (which are 4 times finer 
        than normal fine slides). 
 
 
        How ST3 mixes: 
 
        1) volumetable is created in the following way: 
 
        > volumetable[volume][sampledata]=volume*(sampledata-128)/64; 
 
        NOTE: sampledata in memory is unsigned in ST3, so the -128 in the 
              formula converts it so that the volumetable output is signed. 
 
        2) postprocessing table is created with this pseudocode: 
 
        > z=mastervol&127; 
        > if(z<0x10) z=0x10; 
        > c=2048*16/z; 
        > a=(2048-c)/2; 
        > b=a+c; 
        >                     { 0                , if x < a 
        > posttable[x+1024] = { (x-a)*256/(b-a)  , if a <= x < b 
        >                     { 255              , if x > b 
 
        3) mixing the samples 
 
        output=1024 
        for i=0 to number of channels 
                output+=volumetable[volume*globalvolume/64][sampledata]; 
        next 
        realoutput=posttable[output] 
 
 
        This is how the mixing is done in theory. In practice it's a bit 
        different for speed reasons, but the result is the same. 
 
 
----------------------------------------------------------------------------- 
That's it. If there are any more questions, that's too bad :-) If you have 
problems with the S3M format, try to contact somone who already supports 
it (there is quite a lot of support for the S3M already, so that shouldn't 
be too hard...) Good luck for reading / writing Scream Tracker files. 
 
