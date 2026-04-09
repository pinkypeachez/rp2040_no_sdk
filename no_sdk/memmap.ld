/* Speicherbereiche laut Datasheet */
MEMORY
{
    FLASH(rx) : ORIGIN = 0x10000000, LENGTH = 2048k
    RAM(rwx)  : ORIGIN = 0x20000000, LENGTH = 264k
}


SECTIONS
{
    /* Code (.text) und die Read-Only Daten (.rodata) kommen in den Flash */
    .text :
    {
        KEEP(*(.vectors)) /* das erste was prozessor liest, KEEP damit Linker die Tabelle nie löscht */
        *(.text*)       
        *(.rodata*)      
    } > FLASH

    /* globale Variablen kommen in den RAM 
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