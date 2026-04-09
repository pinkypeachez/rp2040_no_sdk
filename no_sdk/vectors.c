// Vektortabelle

void reset_handler(void);

__attribute__((section(".vectors")))
void (*const vector_table[])(void) = {
// STACK POINTER: "The entry at offset 0 is used to initialize the value for SP_main"
// 0x20000000 ist RAM Anfang, 0x20041000 ist RAM Ende
// Der Stack fängt am Ende an und wächst rückwärts
   (void*)0x20041000,  
    reset_handler,      //Reset Vector
};

void reset_handler(void) {
    main();
}