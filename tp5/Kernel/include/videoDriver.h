#ifndef VIDEODRIVER_H
#define VIDEODRIVER_H
#include <stdint.h>
// Function declarations and macros for the video driver

#define DIM_X 1024
#define DIM_Y 768

typedef struct {
	uint64_t x;
	uint64_t y;
}Point;
/**
 * @brief Puts a pixel on the screen at the specified coordinates with the given color.
 * 
 * @param hexColor The color of the pixel in hexadecimal format.
 * @param x The x-coordinate of the pixel.
 * @param y The y-coordinate of the pixel.
 */
void putPixel(uint32_t hexColor, uint64_t x, uint64_t y);

void printChar(Point topLeft, char c, uint32_t color, char *font_name, unsigned int font_size);

void printString(Point topLeft, char *string, uint32_t color, char *font_name, unsigned int font_size);

void printCharWorks(Point topLeft, char c, uint32_t color, unsigned int font_size);

#endif