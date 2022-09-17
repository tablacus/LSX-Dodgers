.PHONY : all clean cleanall

TARGET = LD.BIN
all : $(TARGET)

SRCS = LD.ASM ../LDCALL.ASM ../LDCCP.ASM ../LDDEF.ASM ../LDDIO.ASM \
../LDDISK.ASM ../LDDPB.ASM ../LDFILE.ASM ../LDFILE2.ASM ../LDINIT.ASM \
../LDIO.ASM ../LDOS.ASM ../LDWORK.ASM

AS     = pasmo
AOPT   = --bin -I ..


$(TARGET) : $(SRCS)
	$(AS) $(AOPT) LD.ASM $@ LD.lst

clean :
	-rm $(TARGET:%.BIN=%.lst)

cleanall : clean
	-rm $(TARGET)
