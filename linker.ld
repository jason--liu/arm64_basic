ENTRY(_start)

SECTIONS
{
    . = 0x80000;
    /* . = 0xffff000000080000; */

    .text.boot : { *(.text.boot)}
    .text : { *(.text*) }
    .rodata : { *(.rodata*) }
    .data : { *(.data*) }

    /* BSS section, will be zeroed out */
    . = ALIGN(0x8);
    .bss : {
        _bss_start = .;
        *(.bss*)
        _bss_end = .;
    }

    /* . = ALIGN(4096); */
    init_pg_dir = .;
    . += 4096;
}
