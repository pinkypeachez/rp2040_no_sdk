
## Toolchain:
1. **arm-none-eabi-gcc Cross-Compiler** [c --> elf]
Mein Mac hat Apple M3 Prozessor [Arm A64], Raspi Pico nutzt Dual-ARM Cortex-M0+ [ARM32 ARMv6-M]

Good to know *(arm-none-eabi-gcc)*
arm: zielarchitektur
none: es gibt kein OS, Code läuft nackt auf Hardware
eabi: Embedded ABI (wie Funktionen Parameter übergeben etc..)


1.2 brew install **elf2uf2** [elf --> uf2]
elf und uf2 enthalten denselben Maschinencode! Unterschied in Metadaten
.bin = nackter Maschinencode, rohe Bytes

2. **Linker script [.ld]**
Linker nimmt .o Dateien und legt die Sektionen an die Adressen basierend auf Linker script
Code = im Flash (.text .rodata)
Variablen = im RAM (.bss)

*Vektortabelle*: Array von Funktionspointern 

Anschalten --> CPU schaut auf fest verdrahtete Adresse --> Reset Vector: da wird zuerst gesprungen

WOHIN gesprungen wird ist fest. Programmierer bestimmt was an dieser Adresse steht.

FUNKTIONSPOINTER
void sagHallo() {
    // tu was
}

// fp ist jetzt die Adresse von sagHallo
void (*fp)() = sagHallo;

// Das ruft sagHallo über die Adresse auf
fp();



RP2040 hat ROM, SRAM, Flash
**SRAM:** 
- 264kB
"Physically this is partitioned into six banks, four 16k x 32-bit banks (64kB each) and two 1k x 32-bit banks (4kB each)"
"Banking is a physical partitioning of SRAM which improves performance by allowing multiple simultaneous
accesses. Logically there is a single 264kB contiguous memory."

- 0x20000000

"Other On-chip Memory
Besides the 264kB main memory, there are two other dedicated RAM blocks that may be used in some circumstances:
• If flash XIP caching is disabled, the cache becomes available as a 16kB memory starting at 0x15000000
• If the USB is not used, the USB data DPRAM can be used as a 4kB memory starting at 0x50100000
This gives a total of 284kB of on-chip SRAM. There are no restrictions on how these memories are used, e.g. it is
possible to execute code from the USB data RAM if you choose."

**Flash [Winbond W25Q16JV]**
-  0x10000000
- 16M-bit --> 16.000.000 Bit / 8 --> 2 megabyte -->
https://docs.rs-online.com/068a/0900766b81622f8d.pdf

*Good to know*
- SRAM = Static RAM - Solange Strom fließt, bleibt das Bit gespeichert
- DRAM = dynamic - speichert Daten in winzigen Kondensatoren, die ihre Ladung verlieren. Es muss tausende Male pro Sekunde "aufgefrischt" werden

3. Build System
Makefile


4. Boot Problem
Der Chip erwartet im Flash (ganz am Anfang) eine spezielle Prüfsumme und einen sogenannten Boot2-Stage.

Der "Boot2"-Trick: Da die CPU nicht weiß, wie sie mit dem externen Flash-Chip reden soll (da jeder Hersteller leicht andere Befehle nutzt), liest der Pico-ROM die ersten 256 Bytes vom Flash ein. In diesen 256 Bytes muss ein winziges Programm stehen, das der CPU erklärt: "Hey, du hast einen Flash-Chip von Firma X mit Größe Y, benutze diese Befehle, um den Rest des Programms zu laden."



"By writing values into a register - in other words, by writing a 32-bit value at a certain memory address, we can control how given peripheral should behave. By reading registers, we can read back peripheral's data or configuration."

Jeder Hardware-Block im RP2040 hat eine feste Adresse im Speicherbereich

- Reset controller registers start at base adress of 0x4000c000 (2.14.3)
| Offset | Name        | Info              |
|--------|------------|-------------------|
| 0x0    | RESET      | Reset control.    |
| 0x4    | WDSEL      | Watchdog select.  |
| 0x8    | RESET_DONE | Reset done.       |


Was macht das Linker-Skript?

Ein Mikrocontroller weiß nach dem Einschalten nicht, wo sein RAM oder Flash anfängt. Das Linker-Skript (Endung .ld) ist die Landkarte für den Compiler.

Ein minimales Skript definiert:

MEMORY: Die physikalischen Adressen. Beim RP2040 beginnt der Flash bei 0x10000000 und der SRAM bei 0x20000000.

SECTIONS: Wo welche Teile Ihres Codes landen. Der "Vector Table" (die Liste der Startadressen für die CPU) muss ganz am Anfang stehen.



Credits to https://github.com/cpq/bare-metal-programming-guide
