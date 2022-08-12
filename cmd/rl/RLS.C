#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <dos.h>
#include <fcntl.h>
#include <direct.h>
#include <sys/stat.h>

#define	COM_PORT	0x3f8
#define FCB	60900
#define DTA	60950

unsigned char buf[61000],filename[13],filename2[13],chdn[13];
char far *p=(char far *)0x417;
char mcr=0x0a;
struct find_t fm,fm2;
struct diskfree_t df;

int main(int argc,char *argv[]);

void xopen(void);
void xclose(void);
void xff(void);
void xfn(void);
void xdelete(void);
void xcreat(void);
void xrename(void);
void xinf(void);
void xwrite(void);
void xread(void);

void senddta(void);
void setbyte(char *data1,char *data2,int size);

void namecv(char *fn,int x);
void namecvr(void);

void xmitw(unsigned int x,unsigned int size);
void recvw(unsigned int x,unsigned int size);
void xmitx(unsigned int x,unsigned int l);
void recvx(unsigned int x,unsigned int l);

unsigned char recv(void);
void xmit(unsigned char data);

int main(int argc,char *argv[])
{
	puts("Remote Link Server R.2");
	outp(COM_PORT+1,0);
	outp(COM_PORT+3,0x83);
	outp(COM_PORT,1);
	outp(COM_PORT+1,0);
	outp(COM_PORT+3,3);
	outp(COM_PORT+4,mcr);
	while(inp(COM_PORT+5)&1) {
		inp(COM_PORT);
	}

	while(1) {
		putchar('.');
		switch(recv()) {

		case 0x0f:
			xopen();
			break;
		case 0x10:
			xclose();
			break;
		case 0x11:
			xff();
			break;
		case 0x12:
			xfn();
			break;
		case 0x13:
			xdelete();
			break;
		case 0x16:
			xcreat();
			break;
		case 0x17:
			xrename();
			break;
		case 0x1b:
			xinf();
			break;
		case 0x26:
			xwrite();
			break;
		case 0x27:
			xread();
			break;
		case 0:
			putchar(8);
			break;
		default:
			putchar('?');
			xmit(0xff);
			break;
		}
	}
}

void xopen(void)
{
	unsigned ff,i;

	putchar('o');
	xmit(0);
	recv();
	recv();
	recvx(FCB,16);
	namecv(filename,FCB);
	strcpy(chdn,filename);
	ff=_dos_findfirst(filename,buf[FCB+13],&fm2);
	if(ff) {
		ff=0xff;
	}
	xmit(ff);
	if(!ff) {
		strcpy(chdn,filename);
		for(i=16;i<32;i++) {
			buf[FCB+i]=0;
		}
		buf[FCB+13]=fm2.attrib;
		setbyte(&buf[FCB+16],(char *)&fm2.size,4);
		setbyte(&buf[FCB+20],(char *)&fm2.wr_date,2);
		setbyte(&buf[FCB+22],(char *)&fm2.wr_time,2);
		buf[FCB+24]=0xff;
		xmitx(FCB,32);
	}
}

void xclose(void)
{
	unsigned fd,date,time;
	long size;

	putchar('s');
	xmit(0);
	recvx(FCB,32);
	namecv(filename,FCB);
	xmit(0);
	if(buf[FCB+24]==0xfe) {
		if(buf[FCB+21]) {
			_dos_setfileattr(filename,0x20);
			setbyte((char *)&size,&buf[FCB+16],4);
			setbyte((char *)&date,&buf[FCB+20],2);
			setbyte((char *)&time,&buf[FCB+22],2);
			fd=open(filename,O_WRONLY);
			chsize(fd,size);
			close(fd);
			_dos_open(filename,O_RDWR,&fd);
			_dos_setftime(fd,date,time);
			_dos_close(fd);
		}
		_dos_setfileattr(filename,buf[FCB+13] & 0x23);
	}
}

void xff(void)
{
	unsigned ff;

	putchar('f');
	xmit(0);
	recvx(FCB,16);
	namecv(filename,FCB);
	ff=_dos_findfirst(filename,buf[FCB+13],&fm);
	while(fm.attrib & 0x10 && !ff && buf[FCB+13]!=0xf1) {
		ff=_dos_findnext(&fm);
	}
	xmit(ff);
	if(!ff) {
		xmit(0);
		xmit(0);
		senddta();
	}
}

void xfn(void)
{
	unsigned ff;

	putchar('n');
	xmit(0);
	do {
		ff=_dos_findnext(&fm);
	} while(fm.attrib & 0x10 && !ff && buf[FCB+13]!=0xf1);
	xmit(ff);
	if(!ff) {
		senddta();
	}
}

void xdelete(void)
{
	unsigned ff,flag;

	putchar('d');
	xmit(0);
	recvx(FCB,16);
	namecv(filename,FCB);
	flag=1;
	ff=_dos_findfirst(filename,buf[FCB+13],&fm2);
	while(!ff) {
		remove(fm2.name);
		flag=0;
		ff=_dos_findnext(&fm2);
	}
	xmit(flag);
}

void xcreat(void)
{
	unsigned i,fd,flag;

	putchar('c');
	xmit(0);
	recv();
	recv();
	recvx(FCB,16);
	namecv(filename,FCB);
	fd=creat(filename,S_IREAD | S_IWRITE);
	flag=close(fd);
	xmit(flag);
	if(!flag) {
		for(i=16;i<32;i++) {
			buf[FCB+i]=0;
		}
		buf[FCB+13]=0x20;
		buf[FCB+24]=0xff;
		xmitx(FCB,32);
	}
}

void xrename(void)
{
	unsigned flag;

	putchar('e');
	xmit(0);
	recvx(FCB,16+12);
	namecv(filename,FCB);
	namecv(filename2,FCB+16);
	flag=rename(filename,filename2);
	xmit(flag);
}

void xinf(void)
{
	unsigned drive;

	putchar('i');
	xmit(0);
	drive=recv()-8;
	_dos_getdiskfree(drive,&df);
	buf[DTA]=df.sectors_per_cluster;
	buf[DTA+1]=0xff;
	setbyte(&buf[DTA+2],(char *)&df.bytes_per_sector,2);
	setbyte(&buf[DTA+4],(char *)&df.total_clusters,2);
	setbyte(&buf[DTA+6],(char *)&df.avail_clusters,2);
	xmitx(DTA,8);
}

void xwrite(void)
{
	unsigned j,k,fd;
	long l;
	struct stat sbuf;

	putchar('w');
	xmit(0);
	recvx(FCB,36);
	j=recv();
	j+=recv()<<8;
	recvw(0,j);
	namecv(filename,FCB);
	l=k=0;
	fd=open(filename,O_WRONLY);
	if(fd!=-1) {
		setbyte((char *)&l,&buf[FCB+33],3);
		lseek(fd,l,SEEK_SET);
		k=write(fd,buf,j);
		close(fd);
		l+=j;
		setbyte(&buf[FCB+33],(char *)&l,3);
		stat(filename,&sbuf);
		setbyte(&buf[FCB+16],(char *)&sbuf.st_size,4);
		buf[FCB+24]=0xfe;
		xmit(0);
		xmitx(FCB,36);
	}
	else {
		xmit(0xff);
	}
}

void xread(void)
{
	unsigned j,k,fd;
	long l;

	putchar('r');
	xmit(0);
	recvx(FCB,36);
	j=recv();
	j+=recv()<<8;
	namecv(filename,FCB);
	l=k=0;
	if(buf[FCB+13] & 0x10) {
		chdir(chdn);
		xmit(1);
		xmitx(FCB,36);
		xmit(0);
		xmit(0);
	}
	else {
		fd=open(filename,O_RDONLY);
		if(fd!=-1) {
			setbyte((char *)&l,&buf[FCB+33],3);
			lseek(fd,l,SEEK_SET);
			k=read(fd,buf,j);
			close(fd);
			l+=k;
			setbyte(&buf[FCB+33],(char *)&l,3);
			if(j==k) {
				xmit(0);
			}
			else {
				xmit(1);
			}
			xmitx(FCB,36);
			xmit(k & 0xff);
			xmit((k>>8) & 0xff);
			xmitw(0,k);
		}
		else {
			xmit(0xff);
		}
	}
}

void senddta(void)
{
	int i;

	strcpy(filename,fm.name);
	namecvr();
	for(i=0;i<12;i++) {
		buf[DTA+i]=buf[FCB+i];
	}
	for(i=13;i<33;i++) {
		buf[DTA+i]=0;
	}
	buf[DTA+1+0x0b]=fm.attrib;
	setbyte(&buf[DTA+1+0x16],(char *)&fm.wr_time,2);
	setbyte(&buf[DTA+1+0x18],(char *)&fm.wr_date,2);
	setbyte(&buf[DTA+1+0x1c],(char *)&fm.size,4);
	xmitx(DTA,33);
}

void setbyte(char *data1,char *data2,int size)
{

	int i;

	for(i=0;i<size;i++) {
		data1[i]=data2[i];
	}
}

void namecv(char *fn,int x)
{
	unsigned i=0,j=0;

    _dos_setdrive(buf[FCB]-8,&i);
	for(i=1;i<9 && buf[x+i]>32 && buf[x+i]!=0xa0;i++) {
		fn[j++]=buf[x+i];
	}
	if(buf[x+9]>32 && buf[x+9]!=0xa0) {
		fn[j++]='.';
		for(i=9;i<12 && buf[x+i]>32 && buf[x+i]!=0xa0;i++) {
			fn[j++]=buf[x+i];
		}
	}
	fn[j]=0;
}

void namecvr(void)
{
	char i,j=1;

	for(i=0;i<9 && filename[i]>0x20
	&&(filename[i]!='.'|| filename[0]=='.');i++) {
		buf[FCB+j++]=filename[i];
	}
	while(j<9) {
		buf[FCB+j++]=0x20;
	}
	if(filename[i++]=='.') {
		while(filename[i]>0x20) {
			buf[FCB+j++]=filename[i++];
		}
	}
	while(j<12) {
		buf[FCB+(j++)]=0x20;
	}
}

void recvw(unsigned int x,unsigned int size)
{
	while(size > 0x100) {
		recvx(x,0x100);
		x+=0x100;
		size-=0x100;
	}
	if(size) {
		recvx(x,size);
	}
}

void xmitw(unsigned int x,unsigned int size)
{
	while(size > 0x100) {
		xmitx(x,0x100);
		x+=0x100;
		size-=0x100;
	}
	if(size) {
		xmitx(x,size);
	}
}

void recvx(unsigned int x,unsigned int l)
{
	unsigned int i,sum;

	putchar('<');
	do {
		sum=0;
		for(i=0;i<l;i++) {
			buf[x+i]=recv();
			sum+=buf[x+i];
			if(p[0]&3) {
				sum++;
			}
		}
		i=recv();
		i+=recv()<<8;
		if(sum==i) {
			i=0;
		}
		else {
			i=0xff;
		}
		xmit(i);
	} while(i);
}

void xmitx(unsigned int x,unsigned int l)
{
	unsigned int	i,sum;

	putchar('>');
	do {
		sum=0;
		for(i=0;i<l;i++) {
			xmit(buf[x+i]);
			sum+=buf[x+i];
		}
		xmit(sum & 0xff);
		xmit(sum >> 8);
	} while(recv());
}

unsigned char recv(void)
{
	unsigned char data;

	while(!(inp(COM_PORT+5)&1)) {
		if(p[0]&8) {
			exit(0);
		}
		if(p[0]&4) {
			return(0);
		}
	}
	data=(inp(COM_PORT)&0x0f)<<4;
	mcr^=1;
	outp(COM_PORT+4,mcr);
	while(!(inp(COM_PORT+5)&1)) {
		if(p[0]&8) {
			exit(0);
		}
		if(p[0]&4) {
			return(0);
		}
	}
	data+=inp(COM_PORT)&0x0f;
	mcr^=1;
	outp(COM_PORT+4,mcr);
	return(data);
}

void xmit(unsigned char data)
{
	char msr;

	msr=inp(COM_PORT+6) & 0x20;
	outp(COM_PORT,data >> 4);
	while(msr==(inp(COM_PORT+6) & 0x20)) {
		if(p[0]&8) {
			exit(0);
		}
		if(p[0]&4) {
			return;
		}
	}
	outp(COM_PORT,data & 0x0f);
	while(msr!=(inp(COM_PORT+6) & 0x20)) {
		if(p[0]&8) {
			exit(0);
		}
		if(p[0]&4) {
			return;
		}
	}
}

