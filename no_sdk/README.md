
## Toolchain:
1. **```arm-none-eabi-gcc``` Cross-Compiler** [c --> elf]

Mein Mac hat Apple M3 Prozessor [Arm A64], Raspi Pico nutzt Dual-ARM Cortex-M0+ [ARM32 ARMv6-M]

Good to know *(arm-none-eabi-gcc)*:

* arm: zielarchitektur
* none: es gibt kein OS, Code läuft nackt auf Hardware
* eabi: Embedded ABI (wie Funktionen Parameter übergeben etc..)


1.2 **```brew install elf2uf2```** [elf --> uf2]

elf und uf2 enthalten denselben Maschinencode! Unterschied in Metadaten
.bin = nackter Maschinencode, rohe Bytes

---------------------------------------------------------------------

2. **Linker script [.ld]**

Der Linker vom Pico: [pico-sdk GitHub](https://github.com/raspberrypi/pico-sdk/blob/master/src/rp2_common/pico_crt0/rp2040/memmap_default.ld)

Im Folgenden die Ausschnitte aus dieser [guten Quelle](https://users.informatik.haw-hamburg.de/~krabat/FH-Labor/gnupro/5_GNUPro_Utilities/c_Using_LD/ldLinker_scripts.html):
- linker script = text file
- The linker script controls how ld combines all of your ```.o``` files into a single ```.elf``` and how that resulting ```.elf``` file gets loaded by the target processor.

> Andere SEHR GUTE Quellen [hier](https://github.com/wntrblm/Castor_and_Pollux/blob/main/firmware/scripts/samd21g18a.ld) oder [hier](https://blog.thea.codes/the-most-thoroughly-commented-linker-script/)


**SECTIONS**
The simplest possible linker script has just one command:
-  ```'SECTIONS'```: describe the memory layout of the output file

> For example, let's say that the code should be loaded at address ` 0x10000 ', and that the data should start at address ` 0x8000000 '. The following linker script will do this function.
``` 
SECTIONS
{
. = 0x10000;
.text : { *(.text) }
. = 0x8000000;
.data : { *(.data) }
.bss : { *(.bss) }
}
```
> ```. = 0x10000;```: The first line in the above example sets the special symbol ` . ', which is the location counter. 

> ```.text : { *(.text) }```: Within the curly braces after the output section name, you list the names of the input sections, which should be placed into this output section.

> ```*``` is a wildcard which matches any file name. The expression ```*(.text)``` means all .text input sections in all input files.

**ENTRY POINT**
- Entry Point: the first instruction to execute in a program.

The argument is a symbol name:
 
```ENTRY ( symbol )```



**VEKTORTABELLE**

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


---------------------------------------------------------------------

3. **Boot**

Boot1 [Bootrom]: fest auf dem Silizium!!! ROM ab 0x00000000 Adresse --> die ersten 256 Bytes vom externen Flash (ab 0x10000000) werden gelesen

(256 weil: es ist die Größe eines Flash-Sektors (page auf dem W25Q16JV))
ABER RP2040 hat keinen internen Flash, sondern einen externen Flash-Chip [Winbond W25Q16JV] der über QSPI angebunden ist. Und ursprungliche Annahme ist Single SPI (und nicht Quad SPI)

Boot2: Anweisungen mit Flash über QSPI zu kommunizieren. XIP aktiviert

XIP Flash (Execute In Place Flash) = Prozessor kann Befehle direkt aus dem externen Flash ausführen

*"External Flash is accessed via the QSPI interface using the execute-in-place(XIP) hardware. This allows an external flash memory to be addressed and accessed by the system as though it were internal memory."*

3: Vektortabelle → Reset-Handler → main()

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


"By writing values into a register - in other words, by writing a 32-bit value at a certain memory address, we can control how given peripheral should behave. By reading registers, we can read back peripheral's data or configuration."

Jeder Hardware-Block im RP2040 hat eine feste Adresse im Speicherbereich

- Reset controller registers start at base adress of 0x4000c000 (2.14.3)
| Offset | Name        | Info              |
|--------|------------|-------------------|
| 0x0    | RESET      | Reset control.    |
| 0x4    | WDSEL      | Watchdog select.  |
| 0x8    | RESET_DONE | Reset done.       |



Credits to https://github.com/cpq/bare-metal-programming-guide
