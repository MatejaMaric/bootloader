## How to build on GNU/Linux:

You need to install following packages:

- nasm (for NASM assembler)
- xorriso (for mkisofs)
- qemu (for qemu-system-x86_64)

On some distributions `mkisofs` is available as `genisoimage` or `xorriso -as mkisofs`, change your Makefile accordingly.
