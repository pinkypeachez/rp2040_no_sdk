/* Speicherbereiche laut Datasheet (2.2. Address Map, 2.6.3. Flash)*/
FLASH_SIZE = 0x40000;      /* 2048kB, 262,144 bytes WZDGWIUDGWOIDWOH!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!efoeihoighroighoreighorieghoreihgerhgrehgreoighriehgeriog
*/

MEMORY
{
    FLASH(rx) : ORIGIN = 0x10000000, LENGTH = 2048k
    RAM(rwx)  : ORIGIN = 0x20000000, LENGTH = 264k
}


SECTIONS
{
     .boot2 : {
        __boot2_start__ = .;
        KEEP (*(.boot2))
        __boot2_end__ = .;
    } > FLASH
    
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