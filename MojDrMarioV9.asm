// MENJA BOJE!!!!!!!!!!!! // UNISTAVA 4 PICKA
// # # # # # # # # # #
// # . . . . . . . . #
// # . . . . . . . . #
// # . . . . . . . . #
// # . . . . . . . . #
// # . . . . . . . . #
// # . . . . . . . . #
// # . . . . . . . . #
// # . . . . . . . . #
// # # # # # # # # # #
  //
//     0 1 2 3 4 5 6 7
//   # # # # # # # # # #

// 0 # . . . . . . . . #
// 1 # . . . . . . . . #
// 2 # . . . . . . . . #
// 3 # . . . . . . . . #
// 4 # . . . . . . . . #
// 5 # . . . . . . . . #
// 6 # . . . . . . . . #
// 7 # . . . . . . . . #
//   # # # # # # # # # #
//
// ###########################
// #  0  1  2  3  4  5  6  7 #
// #  8  9 10 11 12 13 14 15 #
// # 16 17 18 19 20 21 22 23 #
// # 24 25 26 27 28 29 30 31 #
// # 32 33 34 35 36 37 38 39 #
// # 40 41 42 43 44 45 46 47 #
// # 48 49 50 51 52 53 54 55 #
// # 56 57 58 59 60 61 62 63 #
// ###########################
// 
//
 
 
.data

//pozicija odakle pustamo tableticu
3
0

// pointer na pocetak pozicija unapred ispisanih pilula
8										
	
0 		// frame count
75 	// frame per heartbeat / addresa boja
	
0x100 //matrixq	
0x140 //frame		
0x200 // pb_dec		

// pozicije gde se nalaze virusi
3,0 // location
0, 0, 0, 0, 0, 0, 0, 0 // hitmap
0, 1, 0, 0, 0, 0, 0, 0 // hitmap
0, 1, 0, 0, 0, 0, 0, 1 // hitmap
0, 1, 0, 1, 0, 0, 0, 1 // hitmap
0, 1, 0, 1, 0, 0, 0, 1 // hitmap
1, 1, 0, 1, 0, 0, 0, 1 // hitmap
1, 1, 0, 1, 0, 0, 0, 1 // hitmap
1, 1, 0, 1, 0, 0, 1, 1 // hitmap
-1 // hitmap_end	

//bojemap
2 // pilula
	//virusi
0, 0, 0, 0, 0, 0, 0, 0 // hitmap
0, 1, 0, 0, 0, 0, 0, 0 // hitmap
0, 1, 0, 0, 0, 0, 0, 4 // hitmap
0, 1, 0, 2, 0, 0, 0, 4 // hitmap
0, 1, 0, 2, 0, 0, 0, 4 // hitmap
4, 4, 0, 4, 0, 0, 0, 4 // hitmap
1, 1, 0, 1, 0, 0, 0, 4 // hitmap
2, 2, 0, 2, 0, 0, 1, 1 // hitmap				

/*

Spisak registara:
     R0 - tmp 
     R1 - x / frame
     R2 - y
     R3 - boja
     R4 - tabletica / adrese
     R5 - pb_dec / matrix
     R6 - position + 
     R7 - control

*/
.text

begin:

	
//ovo bi trebalo da moze da se zakomentarise
	sub R7, R7, R7 // R7 = 0


// frame_sync
frame_sync_rising_edge:
	
	sub R0, R0, R0 // R0 = 0
	inc R0, R0     // R0 = 1
	shl R0, R0     // R0 = 2
	shl R0, R0     // R0 = 4
	inc R0, R0     // R0 = 5
	inc R0, R0     // R0 = 6
	ld R1, R0      // R1 -> p_frame_sync
	
frame_sync_wait_0:
	ld R0, R1                   // R0 <- p_frame_sync
	jmpnz frame_sync_wait_0
frame_sync_wait_1:
	ld R0, R1                   // R0 <- p_frame_sync 
	jmpz frame_sync_wait_1



//pocetni setap za crtanje
draw_mario_begin:
	
	sub R0, R0, R0              	// addr = 0
	inc R0,R0							// addr = 1
	inc R0,R0							// addr = 2
	ld R4, R0                   // R4 -> p_data
	
	inc R0,R0							// addr = 3
	inc R0,R0							// addr = 4
	inc R0,R0							// addr = 5
	ld R5, R0                   // R5 <- p_rgb_matrix
	
//odredjivanje boje
	sub R0,R0,R0					// addr = 0
	inc R0,R0						// addr = 1
	inc R0,R0						// addr = 2
	inc R0,R0						// addr = 3
	inc R0,R0						// addr = 4
	
	ld R0, R0						// R0 = pocetna adresa boje, odnosno boja pilule
	ld R3, R0						// boja jednako boja pilule
	
	


crtam_pilulu:
	
// crtam pilulu
	ld R1, R4                   // R1 <- player x coord
	inc R4, R4                  // p_data++
	ld R2, R4                   // R2 <- player y coord


	shl R2, R2                  // y << 1
	shl R2, R2                  // y << 1
	shl R2, R2                  // y << 1
	add R2, R1, R2              // y += x
	add R2, R5, R2              // y += p_rgb_matrix
	
// crtamo pilulu
	st R3, R2                   // p_rgb_matrix[x][y] = red color
	
	
	
	
// drtam viruse
	
	inc R4,R4							// HITMAP[0]
	

	
	sub R0, R0, R0              // R0 = 0 / counter

	sub R6,R6,R6	//0
	inc R6,R6		//1
	shl R6,R6		//2
	shl R6,R6		//4
	shl R6,R6		//8
	shl R6,R6		//16
	shl R6,R6		//32
	shl R6,R6		//64
	inc R6,R6		//65
	inc R6,R6		//R6 = 66 = razlika izmedju tablice boje i hitmape
	
draw_virus_loop:

		
		

	
	ld R1, R4                   // R1 = hitmap[i]	
	jmps draw_end               // hitmap[i] == -1
	jmpz draw_virus_next       // hitmap[i] == 0
	
// hitmap[i] == 1
// bojamap[i] == boja
	
// loadujemo u R3 boju iz bojamap
	sub R3,R3,R3
	add R3, R4, R6					// R3 ima vrednosr bojamap[i]= hitmap[i] + 66
	ld R3, R3
	
// crtamo virus
	add R2, R5, R0 // R2 = p_rgb_matrix + counter
	st R3, R2      // color -> R2

	
draw_virus_next:
	inc R4, R4 // p_data++
	inc R0, R0 // R0++ / counter++
	jmp draw_virus_loop	
	
	
draw_end:	

	
//setap za pomeraj	
move:
	
	sub R0, R0, R0   // R0 = 0
	inc R0, R0       // R0 = 1
	shl R0, R0       // R0 = 2
	shl R0, R0       // R0 = 4
	inc R0, R0       // R0 = 5
	inc R0, R0       // R0 = 6
	inc R0, R0       // R0 = 7
	ld R5, R0        // R5 = pb dec
	
	ld R3, R5        // R3 = ctrl / -1/+1
	
	mov R0, R3       // R3 == 0 -> R7 = 0 //nije bilo pomeranja 	
	jmpz move_reset
	jmp move2
	
//nije bilo pomeranja 	
move_reset:
	sub R7, R7, R7 // R7 = 0
	jmp move_failed
	
//da li je vec bilo pomeraja unutar ovog hartbita
move2:

	mov R0, R7 // R7 == 0 -> move3
	jmpz move3
	jmp move_failed	
	
	
move3:

	inc R7, R7 // R7 = 1
	
	sub R0, R0, R0  // R0 = 0
	inc R0, R0		// R0 = 1
	inc R0, R0		// R0 = 2
	ld R4, R0       // R4 = p_data / x
	
	ld R1, R4       // R1 = x
	inc R4, R4      // p_data++
	ld R2, R4       // R2 = y
	inc R4, R4      // p_data -> hitmap[0]
	
// x >= 0
	sub R0, R0, R0  // R0 = 0
	inc R0, R0       // R0 = 1
	shl R0, R0       // R0 = 2
	shl R0, R0       // R0 = 4
	inc R0, R0       // R0 = 5
	inc R0, R0       // R0 = 6
	inc R0, R0       // R0 = 7
	ld R5, R0        // R5 = pb dec
	ld R3, R5        // R3 = ctrl / -1 if left, +1 if right
	
//OVIM SAM MOZDA NESTO SJEBAO
	sub R6,R6,R6
	add R6, R1, R3   // R6 = x+ctrl
	jmps move_failed // if R6 == -1 -> jmp move_failed
	
	
// x <= 7
	sub R0, R0, R0 // R0 = 0
	inc R0, R0     // R0 = 1
	shl R0, R0     // R0 = 2
	shl R0, R0     // R0 = 4
	shl R0, R0     // R0 = 8
	sub R0, R0, R6
	jmpz move_failed // if R6 == 8 -> jmp move_failed 
	
	//??????????????????????
// check for walls				// pita da li ce udariti u vec postojecu pilulu
// R2 = (y << 3) + x + R4
	shl R2, R2                  // y << 1
	shl R2, R2                  // y << 1
	shl R2, R2                  // y << 1
	add R2, R6, R2              // y += (x+ctrl)
	add R2, R4, R2              // y += p_data			//??????????????????????
	ld R0, R2
	jmpz move_control	
	jmp move_failed
	
// upisivanje pomeraja	
move_control:

	sub R0, R0, R0  // R0 = 0
	inc R0, R0		// R0 = 1
	inc R0, R0		// R0 = 2
	ld R4, R0       // R4 = p_data / x
	
// upisivanje pomeraja		
	st R6, R4       // x = R6
	
	
move_failed:
	
// drzanje pilule na istom nivou za duzinu hartbita 
sleep:
	
	sub R0, R0, R0              // R0 = 0
	inc R0, R0                  // R0 = 1
	inc R0, R0                  // R0 = 2
	inc R0, R0                  // R0 = 3
	ld R1, R0                   // R1 = frame_cnt
	inc R0, R0                  // R0 = 4
	ld R2, R0                   // R2 = frames_per_heartbeat
	
	dec R0, R0                  // R0 = 3
	
	inc R1, R1                  // R1++;
	
	sub R2, R2, R1              // frame_cnt == frames_per_heartbeat => jump
	jmpz count_frames_heatbeat  // 
	st R1, R0                   // frame_cnt = R1
	jmp frame_sync_rising_edge
	
// reset hartbita
count_frames_heatbeat:
	sub R1, R1, R1  // R1 = 0
	st R1, R0       // frame_cnt = 0	
	//R7
	
fall_begin:

// fall setup
	sub R0, R0, R0  // R0 = 0
	inc R0, R0		// R0 = 1
	inc R0, R0		// R0 = 2
	ld R4, R0       // R4 = p_data / x	
	
	ld R1, R4       // R1 = x
	inc R4, R4      // p_data++
	ld R2, R4       // R2 = y
	inc R4, R4      // p_data -> hitmap[0]
	
// R1 = x ; R2 = y ; R4 = hitmap[0]
	
//#==[ dal ima nesto ispod

	inc R2, R2                   // y++
	shl R2, R2                   // y << 1
	shl R2, R2                   // y << 1
	shl R2, R2                   // y << 1
	add R2, R1, R2               // y += x
	add R2, R4, R2               // y += R4
	ld R0, R2                    //
	jmpz falling_check_beneath   // if hitmap[y+1] == 1 -> jmp falling_hit
	jmp falling_hit
	
//#==[ FALLING -> CHECK UNDER END

//#==[ Dal smo skroz dole
// check if player hit the bottom / y == 7
falling_check_beneath:	
	
	sub R0, R0, R0  // R0 = 0
	inc R0, R0		// R0 = 1
	inc R0, R0		// R0 = 2
	ld R4, R0       // R4 = p_data / x	
	
	inc R4, R4                  // p_data++ / y cord
	ld R1, R4                   // R1 <- player y coord
	
// izmeniti ove proste stvari
	sub R0, R0, R0              // R0 = 0
	inc R0, R0                  // R0 = 1
	inc R0, R0                  // R0 = 2
	shl R0, R0                  // R0 = 4
	shl R0, R0                  // R0 = 8
	dec R0, R0                  // R0 = 7
	sub R2, R0, R1
	jmpz falling_hit
	
	
//#==[ FALLING -> CHECK BOTTOM END

//#==[ FALLING -> CHECK END
// all checks passed, you can fall now
	jmp falling
	
//#==[ FALLING END


///////// OVDE TREBA SVE NASE IMPLEMENTIRATI. KADA HITUJE PROVERITI OKOLO DA LI IMA ISTIH BOJA ////////////

// load x & y and put in hitmap[x][y] = 1
//#==[ FALLING -> HIT
falling_hit:	
	
	sub R0, R0, R0  // R0 = 0
	inc R0, R0		// R0 = 1
	inc R0, R0		// R0 = 2
	ld R4, R0       // R4 = p_data / x	
	
	ld R1, R4       // R1 = x
	inc R4, R4      // p_data++
	ld R2, R4       // R2 = y
	inc R4, R4      // p_data -> hitmap[0]
	
// R2 = (y << 3) + x + R4 / R2 -> hitmap[i]
	
	shl R2, R2                  // y << 1
	shl R2, R2                  // y << 1
	shl R2, R2                  // y << 1
	add R2, R1, R2              // y += x
	add R2, R4, R2              // y += R4
	sub R0, R0, R0              // R0 = 0
	inc R0, R0                  // R0 = 1
	
// ovde u hitmap gore upisujemo keca
	st R0, R2                   // hitmap[i] = 1 // ovde u hitmap gore upisujemo keca
	
	///////////////////////////////////////////////////////////////////////////////////////////// sada i u bojamap treba upisati odgovarajucu boju
	
	//odredjivanje boje
	sub R0,R0,R0					// addr = 0
	inc R0,R0						// addr = 1
	inc R0,R0						// addr = 2
	inc R0,R0						// addr = 3
	inc R0,R0						// addr = 4
	
	ld R0, R0						// R0 = pocetna adresa boje, odnosno boja pilule - 75
	
	ld R3, R0						// r3 jednako boja pilule
	
	sub R6,R6,R6	//0
	inc R6,R6		//1
	shl R6,R6		//2
	shl R6,R6		//4
	shl R6,R6		//8
	shl R6,R6		//16
	shl R6,R6		//32
	shl R6,R6		//64
	inc R6,R6		//65
	inc R6,R6		//R6 = 66 = razlika izmedju tablice boje i hitmape
	
	add R2, R2, R6
	st R3, R2						// bojamap[i] =   boja pilule
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
// obezbedjujemo da se iscrtava svaki put pilula druge boje
	sub R0,R0,R0					// R0 0
	inc R0,R0						// R0 = 1
	inc R0,R0						// R0 = 2
	inc R0,R0						// R0 = 3
	inc R0,R0						// R0 = 4
	
	sub R0, R0, R3
	jmpz boja_crvena
	jmp sledeca_boja

	
boja_crvena:
	sub R3,R3,R3
	inc R3,R3
	
//store u memoriju
	sub R0,R0,R0					// R0 0
	inc R0,R0						// R0 = 1
	inc R0,R0						// R0 = 2
	inc R0,R0						// R0 = 3
	inc R0,R0						// R0 = 4
	ld R0, R0						// r0 75
	st R3, R0
	
	jmp dal_je_ista_boja
	
sledeca_boja:
		shl R3,R3
	
//store u memoriju
	
	sub R0,R0,R0					// R0 0
	inc R0,R0						// R0 = 1
	inc R0,R0						// R0 = 2
	inc R0,R0						// R0 = 3
	inc R0,R0						// R0 = 4
	ld R0, R0						// r0 75
	st R3, R0
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	
	
	
	
	
//unistavanje
// ###########################################################################################################################

dal_je_ista_boja:	
	sub R6,R6,R6	//0
	inc R6,R6		//1
	shl R6,R6		//2
	shl R6,R6		//4
	shl R6,R6		//8
	shl R6,R6		//16
	shl R6,R6		//32
	shl R6,R6		//64
	inc R6,R6		//65
	inc R6,R6		//R6 = 66 = razlika izmedju tablice boje i hitmape
	
	
////////////////////////////////////////////////////////////////////////////////////// u R3 stavljamo boju od pilule
	sub R0, R0, R0  // R0 = 0
	inc R0, R0		// R0 = 1
	inc R0, R0		// R0 = 2
	ld R4, R0       // R4 = p_data / x	
	
	ld R1, R4       // R1 = x
	inc R4, R4      // p_data++
	ld R2, R4       // R2 = y
	inc R4, R4      // p_data -> hitmap[0]
	
// R2 = (y << 3) + x + R4 / R2 -> hitmap[i]
	
	shl R2, R2                  // y << 1
	shl R2, R2                  // y << 1
	shl R2, R2                  // y << 1
	add R2, R1, R2              // y += x
	add R2, R4, R2              // y += R4
	
	add R2, R6, R2

// u R3 stavljamo boju od pilule
	ld R3, R2 
	
// counter koji broji koliko istih ima  R5 = 1 sada jer je ova koja pada prva
	sub R5, R5, R5
	inc R5, R5
	
provera_boje_loop:
////////////////////////////////////////////////////////////////////////////////////////// u R2 stavljamo boju od ispod  R4 ////////////////// loop za brojanje koliko ima istih ispod
	sub R0, R0, R0  // R0 = 0
	inc R0, R0		// R0 = 1
	inc R0, R0		// R0 = 2
	ld R4, R0       // R4 = p_data / x		
	ld R1, R4       // R1 = x
	inc R4, R4      // p_data++
	ld R2, R4       // R2 = y
	
//moramo opet da loudujemo u R4
	//inc R4, R4      // p_data -> hitmap[0]
	
	

// koristimo R4 i R5  da odradimo povecavanje y za koliko treba
// R4 je i ----- i = 0
	sub R4, R4, R4
	


loop_y_plus:
// R5 je N - brojac ide do n
		
	sub R0, R5, R4
	jmpz dobavljamo_boju_dalje
	
	
	inc R2,R2							//y + 1
	
	inc R4,R4							//i + 1
	
	jmp loop_y_plus
	
dobavljamo_boju_dalje:
	
	// ponovo dobavljamo hitmap[0] u R4 jer smo prethodno koristili R4
	sub R0, R0, R0  // R0 = 0
	inc R0, R0		// R0 = 1
	inc R0, R0		// R0 = 2
	ld R4, R0       // R4 = p_data / x		
	inc R4, R4      // p_data++	
	inc R4, R4      // p_data -> hitmap[0]
	
	shl R2, R2                  // y << 1
	shl R2, R2                  // y << 1
	shl R2, R2                  // y << 1
	add R2, R1, R2              // y += x
	add R2, R4, R2              // y += R4
	
	add R2, R6, R2
	ld R2, R2
	
	///////////////////////////////////////////////////////////////////////////////////////////////uporedjujemo boje
	sub R0, R3, R2
	jmpz provera_boje_loop_2
	
	jmp unisti
	
provera_boje_loop_2:
	inc R5, R5
	
	jmp provera_boje_loop
	
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!	
unisti:

	sub R0, R0, R0
	inc R0, R0
	inc R0, R0
	inc R0, R0			// R0 = 3
	
	
	sub R0, R0, R5
	jmpns unisti_kraj
	
// koristicemo R3, R5, R4 da upisemo nule na odgovarajuca mesta	
	
	sub R3, R3, R3
	//inc R3, R3
	
	//dec R5, R5

//????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????


brisanje_loop:
/////////////////////////////////////////////////////////////////////R6///////////////////// u R2 stavljamo boju od ispod  R4 ////////////////// loop za brojanje koliko ima istih ispod

// Provera da li smo sve obrisali

	sub R0, R5, R3	
	jmpz unisti_kraj

	sub R0, R0, R0  // R0 = 0
	inc R0, R0		// R0 = 1
	inc R0, R0		// R0 = 2
	ld R4, R0       // R4 = p_data / x		
	ld R1, R4       // R1 = x
	inc R4, R4      // p_data++
	ld R2, R4       // R2 = y
	
//moramo opet da loudujemo u R4
	//inc R4, R4      // p_data -> hitmap[0]
	
	

// koristimo R4 i R5  da odradimo povecavanje y za koliko treba
// R4 je i ----- i = 0
	sub R4, R4, R4
	


loop_y_plus_brisanje:
// R5 je N - brojac ide do n
		
	sub R0, R3, R4
	jmpz dobavljamo_boju_dalje_brisanje
	
	
	inc R2,R2							//y + 1
	
	inc R4,R4							//i + 1
	
	jmp loop_y_plus_brisanje
	
dobavljamo_boju_dalje_brisanje:
	
// ponovo dobavljamo hitmap[0] u R4 jer smo prethodno koristili R4
	sub R0, R0, R0  // R0 = 0
	inc R0, R0		// R0 = 1
	inc R0, R0		// R0 = 2
	ld R4, R0       // R4 = p_data / x		
	inc R4, R4      // p_data++	
	inc R4, R4      // p_data -> hitmap[0]
	
	shl R2, R2                  // y << 1
	shl R2, R2                  // y << 1
	shl R2, R2                  // y << 1
	add R2, R1, R2              // y += x
	add R2, R4, R2              // y += R4

// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!		
// unisti!!!

	sub R0, R0, R0              // R0 = 0
	st R0, R2                   // hitmap[i] = 0 // ovde u hitmap gore upisujemo 0
	
	
	add R2, R2, R6						// stavljamo i bojamap na 0
	st R0, R2
	
	inc R3, R3
	jmp brisanje_loop

//????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
/*
//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
sa_strane:

	////////////////////////////////////////////////////////////////////////////////////// u R3 stavljamo boju od pilule ali to ne moramo sadaa
	sub R0, R0, R0  // R0 = 0
	inc R0, R0		// R0 = 1
	inc R0, R0		// R0 = 2
	ld R4, R0       // R4 = p_data / x	
	
	ld R1, R4       // R1 = x
	inc R4, R4      // p_data++
	ld R2, R4       // R2 = y
	inc R4, R4      // p_data -> hitmap[0]
	
// R2 = (y << 3) + x + R4 / R2 -> hitmap[i]
	
	shl R2, R2                  // y << 1
	shl R2, R2                  // y << 1
	shl R2, R2                  // y << 1
	add R2, R1, R2              // y += x
	add R2, R4, R2              // y += R4
	
	add R2, R6, R2

// u R3 stavljamo boju od pilule
	ld R3, R2 
	
	sub R5, R5, R5
	inc R5, R5
	
	
	
provera_desno_loop:
////////////////////////////////////////////////////////////////////////////////////////// u R2 stavljamo bojpored ////////////////// loop za brojanje koliko ima istih desno
	sub R0, R0, R0  // R0 = 0
	inc R0, R0		// R0 = 1
	inc R0, R0		// R0 = 2
	ld R4, R0       // R4 = p_data / x		
	ld R1, R4       // R1 = x
	inc R4, R4      // p_data++
	ld R2, R4       // R2 = y
	inc R4, R4      // p_data -> hitmap[0]
	
	shl R2, R2                  // y << 1
	shl R2, R2                  // y << 1
	shl R2, R2                  // y << 1
	add R2, R1, R2              // y += x
	add R2, R4, R2              // y += R4

// koristimo r5 kao N - brojac ukupno. Koristimo r4 kao privremeni brojac levo i desno
// counter koji broji koliko istih ima  R5 = 1 sada jer je ova koja pada prva
	
	
	sub R4, R4, R4

		

loop_x_desno:
// R5 je N - brojac ide do n
		
	sub R0, R5, R4
	jmpz dobavljamo_boju_dalje_x_desno
	
	
	inc R2,R2							//x + 1	
	inc R4,R4							//i + 1
	
	jmp loop_x_desno
	
dobavljamo_boju_dalje_x_desno:

	add R2, R2, R6
	
	ld R2, R2
	
	sub R0, R3, R2
	jmpz  provera_desno_loop_2
	
	sub R0, R0, R0
	inc R0, R0
	shl R0, R0
	shl R0, R0
	shl R0, R0
	shl R0, R0
	shl R0, R0
	shl R0, R0
	shl R0, R0
	shl R0, R0
	dec R0, R0
	dec R0, R0
	
	st  R5, R0
	
	sub R5, R5, R5
	inc R5, R5
	
	jmp provera_levo_loop
	
	
provera_desno_loop_2:
		inc R5, R5
		jmp provera_desno_loop
		
		
		
provera_levo_loop:
////////////////////////////////////////////////////////////////////////////////////////// u R2 stavljamo bojpored ////////////////// loop za brojanje koliko ima istih levo
	sub R0, R0, R0  // R0 = 0
	inc R0, R0		// R0 = 1
	inc R0, R0		// R0 = 2
	ld R4, R0       // R4 = p_data / x		
	ld R1, R4       // R1 = x
	inc R4, R4      // p_data++
	ld R2, R4       // R2 = y
	inc R4, R4      // p_data -> hitmap[0]
	
	shl R2, R2                  // y << 1
	shl R2, R2                  // y << 1
	shl R2, R2                  // y << 1
	add R2, R1, R2              // y += x
	add R2, R4, R2              // y += R4

// koristimo r5 kao N - brojac ukupno. Koristimo r4 kao privremeni brojac levo i desno
// counter koji broji koliko istih ima  R5 = 1 sada jer je ova koja pada prva
	
	
	
	sub R4, R4, R4

		

loop_x_levo:
// R5 je N - brojac ide do n
		
	sub R0, R5, R4
	jmpz dobavljamo_boju_dalje_x_levo
	
	
	dec R2,R2							//x - 1 	
	inc R4,R4							//i + 1
	
	jmp loop_x_levo
	
dobavljamo_boju_dalje_x_levo:

	add R2, R2, R6
	
	ld R2, R2
	
	sub R0, R3, R2
	jmpz  provera_levo_loop_2
	
	jmp unisti_levo_desno
	
	
provera_levo_loop_2:
		inc R5, R5
		jmp provera_levo_loop





unisti_levo_desno:


	
	
	
	sub R0, R0, R0
	inc R0, R0
	shl R0, R0
	shl R0, R0
	shl R0, R0
	shl R0, R0
	shl R0, R0
	shl R0, R0
	shl R0, R0
	shl R0, R0
	dec R0, R0
	dec R0, R0
	
	ld R0, R0
	
	add R5, R5, R0
	dec R5, R5
	
	
	sub R0, R0, R0
	inc R0, R0
	inc R0, R0
	inc R0, R0			// R0 = 3
	
	sub R0, R0, R5
	jmpns unisti_kraj
	
	sub R5,R5,R5
	inc R5, R5

	

unisti_loop_desno:
////////////////////////////////////////////////////////////////////////////////////////// u R2 stavljamo bojpored ////////////////// loop za brojanje koliko ima istih desno
	sub R0, R0, R0  // R0 = 0
	inc R0, R0		// R0 = 1
	inc R0, R0		// R0 = 2
	ld R4, R0       // R4 = p_data / x		
	ld R1, R4       // R1 = x
	inc R4, R4      // p_data++
	ld R2, R4       // R2 = y
	inc R4, R4      // p_data -> hitmap[0]
	
	shl R2, R2                  // y << 1
	shl R2, R2                  // y << 1
	shl R2, R2                  // y << 1
	add R2, R1, R2              // y += x
	add R2, R4, R2              // y += R4

// koristimo r5 kao N - brojac ukupno. Koristimo r4 kao privremeni brojac levo i desno
// counter koji broji koliko istih ima  R5 = 1 sada jer je ova koja pada prva
	
	
	sub R4, R4, R4

		

loop_x_desno_unisti:
// R5 je N - brojac ide do n
		
	sub R0, R5, R4
	jmpz dobavljamo_boju_dalje_x_desno_unisti
	
	
	inc R2,R2							//x + 1	
	inc R4,R4							//i + 1
	
	jmp loop_x_desno_unisti
	
dobavljamo_boju_dalje_x_desno_unisti:
	
	sub R6,R6,R6	//0
	inc R6,R6		//1
	shl R6,R6		//2
	shl R6,R6		//4
	shl R6,R6		//8
	shl R6,R6		//16
	shl R6,R6		//32
	shl R6,R6		//64
	inc R6,R6		//65
	inc R6,R6		//R6 = 66 = razlika izmedju tablice boje i hitmape
	
	
	add R6, R2, R6
	
	ld R6, R2
	
	//ld R2, R2
	
	sub R0, R3, R6
	jmpz  provera_desno_loop_2_unisti
	
	
	sub R5, R5, R5
	inc R5, R5
	jmp provera_levo_loop_unisti
	
	
provera_desno_loop_2_unisti:
		
	sub R0, R0, R0		
	st R0, R2
	
	sub R6,R6,R6	//0
	inc R6,R6		//1
	shl R6,R6		//2
	shl R6,R6		//4
	shl R6,R6		//8
	shl R6,R6		//16
	shl R6,R6		//32
	shl R6,R6		//64
	inc R6,R6		//65
	inc R6,R6		//R6 = 66 = razlika izmedju tablice boje i hitmape
	
	add R2, R2, R6
	st R0, R2
	
	inc R5, R5
	
	jmp unisti_loop_desno







provera_levo_loop_unisti:
////////////////////////////////////////////////////////////////////////////////////////// u R2 stavljamo bojpored ////////////////// loop za brojanje koliko ima istih desno
	sub R0, R0, R0  // R0 = 0
	inc R0, R0		// R0 = 1
	inc R0, R0		// R0 = 2
	ld R4, R0       // R4 = p_data / x		
	ld R1, R4       // R1 = x
	inc R4, R4      // p_data++
	ld R2, R4       // R2 = y
	inc R4, R4      // p_data -> hitmap[0]
	
	shl R2, R2                  // y << 1
	shl R2, R2                  // y << 1
	shl R2, R2                  // y << 1
	add R2, R1, R2              // y += x
	add R2, R4, R2              // y += R4

// koristimo r5 kao N - brojac ukupno. Koristimo r4 kao privremeni brojac levo i desno
// counter koji broji koliko istih ima  R5 = 1 sada jer je ova koja pada prva
	
	
	sub R4, R4, R4

		

loop_x_levo_unisti:
// R5 je N - brojac ide do n
		
	sub R0, R5, R4
	jmpz dobavljamo_boju_dalje_x_levo_unisti
	
	
	dec R2,R2							//x - 1	
	inc R4,R4							//i + 1
	
	jmp loop_x_levo_unisti
	
dobavljamo_boju_dalje_x_levo_unisti:
	
	sub R6,R6,R6	//0
	inc R6,R6		//1
	shl R6,R6		//2
	shl R6,R6		//4
	shl R6,R6		//8
	shl R6,R6		//16
	shl R6,R6		//32
	shl R6,R6		//64
	inc R6,R6		//65
	inc R6,R6		//R6 = 66 = razlika izmedju tablice boje i hitmape
	
	
	add R6, R2, R6
	
	ld R6, R2
	
	//ld R2, R2
	
	sub R0, R3, R6
	jmpz  provera_levo_loop_2_unisti
	
	jmp unisti_kraj
	
	
provera_levo_loop_2_unisti:
		
		sub R0, R0, R0		
		st R0, R2
		
		sub R6,R6,R6	//0
		inc R6,R6		//1
		shl R6,R6		//2
		shl R6,R6		//4
		shl R6,R6		//8
		shl R6,R6		//16
		shl R6,R6		//32
		shl R6,R6		//64
		inc R6,R6		//65
		inc R6,R6		//R6 = 66 = razlika izmedju tablice boje i hitmape
		
		add R2, R2, R6
		st R0, R2
		
		jmp provera_levo_loop_unisti








//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
	*/
unisti_kraj:	
	// ###########################################################################################################################
//#==[ FALLING -> HIT -> GAME OVER
//# setup	
nesto:	
	sub R0, R0, R0  // R0 = 0
	inc R0, R0		// R0 = 1
	inc R0, R0		// R0 = 2
	ld R4, R0       // R4 = p_data / x
	
	inc R4, R4                  // R4 = p_data / y
	inc R4, R4                  // R4 = hitmap[0]
	
	sub R2, R2, R2              // R2 = 0
	inc R2, R2                  // R2 = 1
	sub R3, R3, R3              // R3 = 0 / counter
	sub R5, R5, R5              // R5 = 0
	inc R5, R5                  // R5 = 1
	shl R5, R5                  // R5 = 2
	shl R5, R5                  // R5 = 4
	shl R5, R5                  // R5 = 8
	
// r2 =1 // r3 = 0 = counter // r5 = 8
	
// prolazi kroz gornji red da vidi da negde nije doslo dokraja

gameover_check_loop:
	sub R0, R3, R5  // counter == 8 -> jump gameover_end / failed to gameover
	jmpz gameover_end
	
	ld R1, R4       // R1 = hitmap[i]
	sub R0, R1, R2  // hitmap[i] == 1 -> jump gameover
	jmpz gameover
	
	inc R4, R4 // R4++
	inc R3, R3 // R3++ / counter++
	jmp gameover_check_loop
	
//#==[ GAME OVER CLEAR LOOP BEGIN
gameover:	
	
	sub R0, R0, R0  // R0 = 0
	inc R0, R0		// R0 = 1
	inc R0, R0		// R0 = 2
	ld R4, R0       // R4 = p_data / x
	
	inc R4, R4                  // R4 = p_data / y
	inc R4, R4                  // R4 = hitmap[0]
	
	sub R1, R1, R1              // R1 = 0
	
	//cisrti se tabla
gameover_loop:
	ld R0, R4             // 
	jmps gameover_end     // hitmap[i] == -1 -> jump gameover_end
	st R1, R4             // hitmap[i] = 0
	inc R4, R4            // hitmap++
	jmp gameover_loop	
	
// nije bio gameOver	
	
gameover_end:
//#==[ GAME OVER CLEAR LOOP END


//#==[ FALLING -> HIT -> RESET PLAYER POS
// x = 3 , y = 0	
	sub R0, R0, R0  // R0 = 0	
	ld R1, R0       // R1 = def x
	
	inc R0, R0      // R0 = 1
	ld R2, R0       // R2 = def y
	
	sub R0, R0, R0  // R0 = 0
	inc R0, R0		// R0 = 1
	inc R0, R0		// R0 = 2
	ld R4, R0       // R4 = p_data / x
	
	st R1, R4       // def x -> x
	inc R4, R4      // p_data++ / p_data -> y
	st R2, R4       // def y -> y
		
	jmp end

	

	
//#==[ FALLING
falling:
	sub R0, R0, R0  // R0 = 0
	inc R0, R0		// R0 = 1
	inc R0, R0		// R0 = 2
	ld R4, R0       // R4 = p_data / x
	
	inc R4, R4     // p_data++ / p_data = y
	ld R1, R4      // R1 <- y
	
	inc R1, R1     // R1++
	st R1, R4      // R1 -> y
	jmp end
//#==[ FALLING END

end:
	
	
	
	
	
	
	
	jmp frame_sync_rising_edge
//==[ CLOCK LOOP END
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
