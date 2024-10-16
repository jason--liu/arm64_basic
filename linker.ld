ENTRY(_start)

SECTIONS
{
    . = 0x80000;

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
}
