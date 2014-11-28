#include <core_pins.h>

int main(void)
{
	pinMode(13, OUTPUT);
	for (;;) {
		digitalWriteFast(13, HIGH);
		delay(1000);
		digitalWriteFast(13, LOW);
		delay(1000);
	}
}

