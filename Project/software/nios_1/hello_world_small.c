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
#include "stdio.h"
#include "sys/alt_stdio.h"
#include "io.h"
#include "altera_avalon_pio_regs.h"
#include "altera_avalon_uart_regs.h"
#include <unistd.h>
#include <string.h>


#define BUTTON_UP 11
#define BUTTON_DOWN 7
#define SELECT 13
#define UART_0_BASE 0x11020

//----------------------VETORES DOS PACOTES E COMANDOS-------------------------------

//pacote connect 0x\10\11\00\04\MQTT\04\02\00\14\00\04\Nios
char connect[] = {0x10 ,0x12 ,0x00, 0x04 ,0x4d ,0x51, 0x54, 0x54, 0x04 ,0x02 ,0x00 ,0x14, 0x00 ,0x06, 0x4e, 0x69, 0x6f, 0x73, 0x20, 0x32};
char comandoSendC[] = "AT+CIPSEND=20";





//pacote disconnect
char disconnect[] = {0xe0 , 0x00};
char comandoD[] = "AT+CIPSEND=2";


//char publish1[] = {0x30, 0x13, 0x00, 0x0C, 0x74, 0x65, 0x73, 0x74, 0x65, 0x2f, 0x74, 0x65, 0x73, 0x74, 0x65, 0x31, 0x4f, 0x50, 0x43, 0x41, 0x4f};
char publish1[] = {0x30, 0x16, 0x00, 0x0C, 0x74, 0x65, 0x73, 0x74, 0x65, 0x2f, 0x74, 0x65, 0x73, 0x74, 0x65, 0x31, 0x43, 0x41, 0x44, 0x41, 0x53, 0x54,0x52, 0x4f};
char publish2[] = {0x30, 0x16, 0x00, 0x0C, 0x74, 0x65, 0x73, 0x74, 0x65, 0x2f, 0x74, 0x65, 0x73, 0x74, 0x65, 0x31, 0x4c, 0x49, 0x53, 0x54, 0x41, 0x47, 0x45, 0x4d};
char publish3[] = {0x30, 0x16, 0x00, 0x0C, 0x74, 0x65, 0x73, 0x74, 0x65, 0x2f, 0x74, 0x65, 0x73, 0x74, 0x65, 0x31, 0x43, 0x4f, 0x4e, 0x46, 0x49, 0x41, 0x52, 0x41};
char publish4[] = {0x30, 0x16, 0x00, 0x0C, 0x74, 0x65, 0x73, 0x74, 0x65, 0x2f, 0x74, 0x65, 0x73, 0x74, 0x65, 0x31, 0x43, 0x52, 0x45, 0x44, 0x49, 0x54, 0x4f, 0x53};
char publish5[] = {0x30, 0x16, 0x00, 0x0C, 0x74, 0x65, 0x73, 0x74, 0x65, 0x2f, 0x74, 0x65, 0x73, 0x74, 0x65, 0x31, 0x53, 0x49, 0x53, 0x54, 0x45, 0x4d, 0x41, 0x53};
char comandoSendP[] = "AT+CIPSEND=24";



char comandoAT0[] = "AT";
char comandoAT1[] = "AT+CWMODE=1";
//char comandoAT2[] = "AT+CWJAP=\"LENDA S3\",\"LenDa$3.\"";
char comandoAT2[] = "AT+CWJAP=\"GT-I9192\",\"[samsung]\"";
//char comandoAT2[] = "AT+CWJAP=\"WLessLEDS\",\"HelloWorldMP31\"";
//char comandoAT3[] = "AT+CIPSTART=\"TCP\",\"192.168.1.103\",1883";
char comandoAT3[] = "AT+CIPSTART=\"TCP\",\"192.168.43.137\",1883";
//--------------------------------------------------------------------------



//Initialization of some functions////////
void writenUart(char vetor[] , int tamanho );
void readUart();
void writenUartQuick(char vetor , int tamanho);
void connectMQTT();
void publishMQTT(char publish[],int size);


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
				publishMQTT(publish1, 24);
				break;
			case 1:
				imprime(answer2 , sizeof(answer2));
				publishMQTT(publish2,24);
				break;
			case 2:
				imprime(answer3, sizeof(answer3));
				publishMQTT(publish3,24);
				break;
			case 3:
				imprime(answer4 , sizeof(answer4));
				publishMQTT(publish4,24);
				break;
			case 4:
				imprime(answer5 , sizeof(answer5));
				publishMQTT(publish5,24);
				break;
			default:
				break;
		}
}

int main()
{ 
  /*------------------Send commands AT--------------------------*/
  writenUart(comandoAT0 , strlen(comandoAT0));
  readUart();
  usleep(1000000);

  writenUart(comandoAT1 , strlen(comandoAT1));
  readUart();
  usleep(1000000);

  writenUart(comandoAT2 , strlen(comandoAT2));
  readUart();
  usleep(1000000);
  /*------------------------------------------------------------*/

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
		  //-----SEND TCP------//
		  writenUart(comandoAT3 , strlen(comandoAT3));
		  readUart();
		  usleep(1000000);

		  //-----SEND MESSAGE------//
		  connectMQTT();
		  onMessageSelected(count);
		  alt_printf("Message sent");
		  do{
			  pushbutton = IORD(PUSHBUTTON_BASE,0);
			  onLed(count);
		  }while(pushbutton != 14);
		  onMessage(count);
	  }
  }
	return 0;
}


void writenUart(char vetor[] , int tamanho ){
	unsigned long uartStatus = 0;
	//verifica até que possa ser feita a transmissão de dados.
	while((uartStatus & 0x00000040) != 0x00000040){
		uartStatus = IORD_ALTERA_AVALON_UART_STATUS(UART_0_BASE);
	}
	int i;
	for(i = 0 ; i < tamanho ; i++){
		IOWR_ALTERA_AVALON_UART_TXDATA(UART_0_BASE, vetor[i]);
		usleep(1000);
	}
	IOWR_ALTERA_AVALON_UART_TXDATA(UART_0_BASE, '\r');
	usleep(1000);
	IOWR_ALTERA_AVALON_UART_TXDATA(UART_0_BASE, '\n');
}

void readUart(){
   char check;
   while(1){
	   if(IORD_ALTERA_AVALON_UART_STATUS(UART_0_BASE) & 0x80){
		   check = IORD_ALTERA_AVALON_UART_RXDATA(UART_0_BASE);
		   alt_printf("%c",check);
		   if(check == 'K'){
		   	  break;
		   }
	   }
   }
}

void writenUartQuick(char vetor , int tamanho){
	unsigned long uartStatus = 0;
	//verifica até que possa ser feita a transmissão de dados.
	while((uartStatus & 0x00000040) != 0x00000040){
		uartStatus = IORD_ALTERA_AVALON_UART_STATUS(UART_0_BASE);
	}
	int i;
	for(i = 0 ; i < tamanho ; i++){
		IOWR_ALTERA_AVALON_UART_TXDATA(UART_0_BASE, vetor);
		usleep(1000);
	}
}

void connectMQTT(){
	//----------------SEND CONNECT-----------------------------------//
	writenUart(comandoSendC , strlen(comandoSendC));
	usleep(1000000);
	for(int z = 0 ; z < sizeof(connect); z++){
		writenUartQuick(connect[z] , 1);
	}
	IOWR_ALTERA_AVALON_UART_TXDATA(UART_0_BASE, '\r');
	usleep(1000);
	IOWR_ALTERA_AVALON_UART_TXDATA(UART_0_BASE, '\n');
}

void publishMQTT(char publish[],int size){
	//----------------SEND PACKAGE MQTT------------------------------//
	usleep(1000000);
	writenUart(comandoSendP,strlen(comandoSendP));
	usleep(1000000);
	for(int z = 0 ; z < size; z++){
		alt_printf("%c", publish[z]);
		writenUartQuick(publish[z] , 1);
	}
	IOWR_ALTERA_AVALON_UART_TXDATA(UART_0_BASE, '\r');
	usleep(1000);
	IOWR_ALTERA_AVALON_UART_TXDATA(UART_0_BASE, '\n');
	usleep(1000000);

///////////////////////////////////////////////////////////////////
	writenUart(comandoD, strlen(comandoD));
	usleep(1000000);
	for(int z = 0 ; z < sizeof(disconnect); z++){
		printf("%c", disconnect[z]);
		writenUartQuick(disconnect[z],1);
	}
	IOWR_ALTERA_AVALON_UART_TXDATA(UART_0_BASE, '\r');
	usleep(1000);
	IOWR_ALTERA_AVALON_UART_TXDATA(UART_0_BASE, '\n');
	usleep(1000000);
}
