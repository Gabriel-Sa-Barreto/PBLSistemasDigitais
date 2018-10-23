/* 
 * "Small Hello World" example. 
 * 
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example 
 * designs. It requires a STDOUT  device in your system's hardware. 
 *
 * The purpose of this example is to demonstrate the smallest possible Hello 
 * World application, using the Nios II HAL library.  The memory footprint
 * of this hosted application is ~332 bytes by default using the standard 
 * reference design.  For a more fully featured Hello World application
 * example, see the example titled "Hello World".
 *
 * The memory footprint of this example has been reduced by making the
 * following changes to the normal "Hello World" example.
 * Check in the Nios II Software Developers Manual for a more complete 
 * description.
 * 
 * In the SW Application project (small_hello_world):
 *
 *  - In the C/C++ Build page
 * 
 *    - Set the Optimization Level to -Os
 * 
 * In System Library project (small_hello_world_syslib):
 *  - In the C/C++ Build page
 * 
 *    - Set the Optimization Level to -Os
 * 
 *    - Define the preprocessor option ALT_NO_INSTRUCTION_EMULATION 
 *      This removes software exception handling, which means that you cannot 
 *      run code compiled for Nios II cpu with a hardware multiplier on a core 
 *      without a the multiply unit. Check the Nios II Software Developers 
 *      Manual for more details.
 *
 *  - In the System Library page:
 *    - Set Periodic system timer and Timestamp timer to none
 *      This prevents the automatic inclusion of the timer driver.
 *
 *    - Set Max file descriptors to 4
 *      This reduces the size of the file handle pool.
 *
 *    - Check Main function does not exit
 *    - Uncheck Clean exit (flush buffers)
 *      This removes the unneeded call to exit when main returns, since it
 *      won't.
 *
 *    - Check Don't use C++
 *      This builds without the C++ support code.
 *
 *    - Check Small C library
 *      This uses a reduced functionality C library, which lacks  
 *      support for buffering, file IO, floating point and getch(), etc. 
 *      Check the Nios II Software Developers Manual for a complete list.
 *
 *    - Check Reduced device drivers
 *      This uses reduced functionality drivers if they're available. For the
 *      standard design this means you get polled UART and JTAG UART drivers,
 *      no support for the LCD driver and you lose the ability to program 
 *      CFI compliant flash devices.
 *
 *    - Check Access device drivers directly
 *      This bypasses the device file system to access device drivers directly.
 *      This eliminates the space required for the device file system services.
 *      It also provides a HAL version of libc services that access the drivers
 *      directly, further reducing space. Only a limited number of libc
 *      functions are available in this configuration.
 *
 *    - Use ALT versions of stdio routines:
 *
 *           Function                  Description
 *        ===============  =====================================
 *        alt_printf       Only supports %s, %x, and %c ( < 1 Kbyte)
 *        alt_putstr       Smaller overhead than puts with direct drivers
 *                         Note this function doesn't add a newline.
 *        alt_putchar      Smaller overhead than putchar with direct drivers
 *        alt_getchar      Smaller overhead than getchar with direct drivers
 *
 */

#include "system.h"
#include "sys/alt_stdio.h"
#include "io.h"
#include "altera_avalon_pio_regs.h"
#include <unistd.h>
#include <string.h>
// Last Up = 13
//Last Down = 14
#define BUTTON_UP 11
#define BUTTON_DOWN 7
#define SELECT 13


char opcao1[9] = {'c' , 'a' , 'd' , 'a' , 's' , 't' , 'r' , 'o' ,'/0'};
char opcao2[9] = {'l' , 'i' , 's' , 't' , 'a' , 'g' , 'e' , 'm' ,'/0'};
char opcao3[8] = {'r' , 'e' , 'm' , 'o' , 'c' , 'a' , 'o' , '/0'};
char opcao4[9] = {'c' , 'r' , 'e' , 'd' , 'i' , 't' , 'o' , 's' ,'/0'};
char opcao5[9] = {'s' , 'i' , 's' , 't' , 'e' , 'm' , 'a' , 's' ,'/0'};

char answer1[9] = {'a' , 'n' , 's' , 'w' , 'e' , 'r' , ' ' , '1' ,'/0'};
char answer2[9] = {'a' , 'n' , 's' , 'w' , 'e' , 'r' , ' ' , '2' ,'/0'};
char answer3[9] = {'a' , 'n' , 's' , 'w' , 'e' , 'r' , ' ' , '3' ,'/0'};
char answer4[9] = {'a' , 'n' , 's' , 'w' , 'e' , 'r' , ' ' , '4' ,'/0'};
char answer5[9] = {'a' , 'n' , 's' , 'w' , 'e' , 'r' , ' ' , '5' ,'/0'};


void initialize_Lcd(){

	 usleep(15000); // Wait for more than 15 ms before initialize
	 //set LCD module usage
	 ALT_CI_LCD_0(0x0,0x38);
	 //ALT_CI_LCD_0(0x0,0x138);
	 usleep(4100); // Wait for more than 4.1 ms
	 ALT_CI_LCD_0(0x0,0x38);
	 usleep(100); // Wait for more than 100 us
	 ALT_CI_LCD_0(0x0,0x38);
	 usleep(5000); // Wait for more than 100 us
	 ALT_CI_LCD_0(0x0,0x38);
	 usleep(100); // Wait for more than 100 us
	 /* Set Display to OFF*/
	 ALT_CI_LCD_0(0x0,0x08);
	 usleep(100);

	 /* Set Display to ON */
	 ALT_CI_LCD_0(0x0,0x0C);
	 //ALT_CI_LCD_0(0x0,0x10E);
	 usleep(100);

	 /* Set Entry Mode -- Cursor increment, display doesn't shift */
	 ALT_CI_LCD_0(0x0,0x06);
	 //ALT_CI_LCD_0(0x0,0x106);
	 usleep(100);
	 /* Set the Cursor to the home position */
	 ALT_CI_LCD_0(0x0,0x02);
	 //ALT_CI_LCD_0(0x0,0x102);
	 usleep(2000);

	 /* Display clear */
	 ALT_CI_LCD_0(0x0,0x01);
	 //ALT_CI_LCD_0(0x0,0x101);
	 usleep(2000);
}


/**
 *This function choose what led shall turn on.
 */
int point(int exp, int base){
	int value = 1;
	while(exp--){
		value*=base;
	}
	return ~value;
}

void imprime(char opcao[] , int size){
		//Set time before every function, because we don't if was called a function before.
		/* Set the Cursor to the home position */
		usleep(2000);
		ALT_CI_LCD_0(0x0,0x02);

		usleep(2000);

		/* Display clear */
		ALT_CI_LCD_0(0x0,0x01);

		for(int i = 0 ; i < size-1; i++){
			usleep(2000);
			ALT_CI_LCD_0(0x1,opcao[i]);
		}
		usleep(2000);
		ALT_CI_LCD_0(0x0,0x00);
 }

void onLed(int count){
     switch(count){
		case 0:
			IOWR_ALTERA_AVALON_PIO_DATA(LEDS_BASE,7);
			break;
		case 1:
			IOWR_ALTERA_AVALON_PIO_DATA(LEDS_BASE,11);
			break;
		case 2:
			IOWR_ALTERA_AVALON_PIO_DATA(LEDS_BASE,13);
			break;
		case 3:
			IOWR_ALTERA_AVALON_PIO_DATA(LEDS_BASE,14);
			break;
		case 4: IOWR_ALTERA_AVALON_PIO_DATA(LEDS_BASE,~15);
	}
}

void onMessage(int count){
     switch(count){
		case 0:
			imprime(opcao1 , sizeof(opcao1));
			break;
		case 1:
			imprime(opcao2 , sizeof(opcao2));
			break;
		case 2:
			imprime(opcao3 , sizeof(opcao3));
			break;
		case 3:
			imprime(opcao4 , sizeof(opcao4));
			break;
		case 4:
			imprime(opcao5 , sizeof(opcao5));
			break;
		default:
			break;

	}
}

void onMessageSelected(int count){
	switch(count){
			case 0:
				imprime(answer1 , sizeof(answer1));
				break;
			case 1:
				imprime(answer2 , sizeof(answer2));
				break;
			case 2:
				imprime(answer3, sizeof(answer3));
				break;
			case 3:
				imprime(answer4 , sizeof(answer4));
				break;
			case 4:
				imprime(answer5 , sizeof(answer5));
				break;
			default:
				break;

		}
}

int main()
{ 

  int pushbutton = 0;
  int count = 0;
  /*Function that initialize the LCD*/
  initialize_Lcd();
  onMessage(count);
  while (1){
	  pushbutton = IORD(PUSHBUTTON_BASE,0);
	  usleep(100000);

	  if(pushbutton == BUTTON_UP){//Up the option
		  count++;
		  if(count > 4){
		  	count = 0;
		  }
		  onMessage(count);
	  }else if(pushbutton == BUTTON_DOWN){//Down the option
		  count--;
		  if(count == -1){count = 4;}
		  onMessage(count);
	  }else if(pushbutton ==  SELECT){
		  onMessageSelected(count);
		  do{
			  pushbutton = IORD(PUSHBUTTON_BASE,0);
			  onLed(count);
		  }while(pushbutton != 14);
		  onMessage(count);
	  }
  }
	return 0;
}
