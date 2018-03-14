%{
	#include "zoomjoystrong.h"
    	#include <stdio.h> 
    	int yylex();
   	void yyerror(const char* msg);
	void drawPoint(int x, int y);
    	void drawLine(int x1, int y1, int x2, int y2);
    	void drawCircle(int x, int y, int r);
   	void drawRectangle(int x, int y, int w, int h);
	void changeColor (int r, int g, int b);
%}

%error-verbose
%start command_list

%union { int i; char* str; float f;}

%token END
%token END_STATEMENT
%token POINT
%token LINE
%token CIRCLE
%token RECTANGLE
%token SET_COLOR
%token INT
%token FLOAT


%type<str> END
%type<str> END_STATEMENT
%type<str> POINT
%type<str> LINE
%type<str> CIRCLE
%type<str> RECTANGLE
%type<str> SET_COLOR
%type<i> INT
%type<f> FLOAT

%%


command_list: command 
	| command command_list 
;

command:  	point  
	|	line  
	|	circle	
	|	rectangle 
	|	set_color
	|	end
;

point:	POINT INT INT END_STATEMENT
	{printf("Drawing point at: (%d,%d)...", $2, $3);
	drawPoint($2,$3);}  ;

line:	LINE INT INT INT INT END_STATEMENT
	{printf("Drawing line from (%d,%d) to (%d,%d)...",  $2, $3, $4, $5);
	drawLine($2, $3, $4, $5);} ;

circle:	CIRCLE INT INT INT END_STATEMENT
	{printf("Drawing circle drawn at (%d,%d) with radius of %d...", $2, $3, $4);
	drawCircle($2, $3, $4);} ;

rectangle:  RECTANGLE INT INT INT INT END_STATEMENT
	{printf("Drawing rectangle at (%d,%d) with width %d and height %d...", $2, $3, $4, $5); 
	drawRectangle($2, $3, $4, $5); };

set_color:  SET_COLOR INT INT INT END_STATEMENT
	{printf("Changing color to %d %d %d...", $2, $3, $4); 
	changeColor($2, $3, $4);};

end: END END_STATEMENT
	{printf("Closing program...\n");
	finish();
	return (0);}; 

%%

FILE* yyin;

int main(int argc, char** argv){
	if (argc != 2)
	{
		printf("\nInvalid number of commands!");
  		printf("\nEnter a command:\npoint x y;\nline x1 y1 x2 y2;\ncircle x y r;\nrectangle x y w h;\nset_color r g b;\nend;\n\n");
	}
 	setup();
	yyin = fopen(argv[1], "r");
  	yyparse();
  	printf("Program ended.\n");
  	return 0;
}
//Handles unrecognized commands or dimension values
void yyerror(const char* msg){
	fprintf(stderr, "ERROR! %s\n", msg);
	yyparse(); 
}

//Draws a point if (x,y) is in the window size
void drawPoint(int x, int y){
  if(x > 0 && x < WIDTH && y > 0 && y < HEIGHT){
   	point(x , y);
  	printf("Done\n");
  }
  else{
    	printf("Invalid dimensions!\n");
  }
}

//Draws a line if both (x1,y1) and (x2,y2) are in the window size
void drawLine(int x1, int y1, int x2, int y2){
  if(x1 > 0 && x2 > 0 && x1 < WIDTH && x2 < WIDTH && y1 > 0 && y2 > 0 && y1 < HEIGHT && y2 < HEIGHT){
   	line(x1,y1,x2,y2);
	printf("Done\n");
  }
  else{
    	printf("Invalid dimensions!\n");
  }
}

//Draws a circle if (x,y) is in the window size and the radius won't make the circle go off the screen
void drawCircle(int x, int y, int r){
  if(x > -1 && x + r < WIDTH && y > -1 && y + r < HEIGHT && r > 0 && x - r > 0 && y - r > 0){ 
    	circle(x,y,r);
	printf("Done\n");
  }
  else{
    	printf("Invalid dimensions!\n");
  }
}

//Draws a rectangle with TOP-LEFT corner at (x,y)if it is in the window size and the height or width won't make it go off the screen
void drawRectangle(int x, int y, int w, int h){
  if(x > -1 && w > -1 && x+w <= WIDTH && y > -1 && h > -1 && y-h >-1){ 
    	rectangle(x,y,w,h);
	printf("Done\n");
  }
  else{
    	printf("Invalid dimensions!\n");
  }
}

//Changes the color to the give r,g,b values
void changeColor(int r, int b, int g){
  if(r < 256 && r > -1 && b < 256 && b > -1 && g < 256 && g > -1){
    	set_color(r,b,g);
	printf("Done\n");
  }
  else{
    	printf("Invalid color values!\n");
  }
}
