.PHONY : all clean cleanall

TARGET = LD.BIN
all : $(TARGET)

SRCS = X1.ASM ../LDCALL.ASM ../X1CCP.ASM ../LDCCP.ASM ../X1DEF.ASM ../LDDEF.ASM ../LDDIO.ASM \
../X1DISK.ASM ../X1DPB.ASM ../LDFILE.ASM ../LDFILE2.ASM ../LDINIT.ASM \
../X1IO.ASM ../LDOS.ASM ../LDWORK.ASM

AS     = pasmo
AOPT   = --bin -I ..


$(TARGET) : $(SRCS)
	$(AS) $(AOPT) X1.ASM $@ LD.lst

clean :
	-rm $(TARGET:%.BIN=%.lst)

cleanall : clean
	-rm $(TARGET)
