/* Speicherbereiche laut Datasheet (2.2. Address Map, 2.6.3. Flash)*/
MEMORY
{
    boot2(rwxai): ORIGIN = 0x10000000, LENGTH = 256
    FLASH(rx) : ORIGIN = 0x10000100, LENGTH = 2048k
    RAM(rwx)  : ORIGIN = 0x20000000, LENGTH = 264k
}


SECTIONS
{
     .boot2 : {
        *(.boot2)
    } > boot2
    
    .text :
    {
    /*
         This segment must be 4-byte aligned as defined in ARM ELF
         File Format specification.
      */
        . = ALIGN(4);

        KEEP(*(.vectors)) /* das erste was prozessor liest, KEEP damit Linker die Tabelle nie löscht */
        *(.text*)       
        *(.rodata*)      
    } > FLASH

    /* globale Variablen kommen in den RAM FÜR BLINKER NICHT RELEVANT
    .data :
    {
        . = ALIGN(4);
         _data_start = .;
        *(.data*)
        _data_end = .; 
    } > RAM AT > FLASH  */

    _data_load = LOADADDR(.data); 

    /* nicht initialisierte Variablen kommen in den RAM */
    .bss :
    {
        *(.bss*)
    } > RAM
}