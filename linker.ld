ENTRY(_start)

SECTIONS
{
    . = 0x80000;

    .text : { *(.text*) }
    .rodata : { *(.rodata*) }
    .data : { *(.data*) }

    /* BSS section, will be zeroed out */
    .bss : {
        _bss_start = .;
        *(.bss*)
        _bss_end = .;
    }
}
