//
//  FEZip.m
//
//
//  Created by xxx on 12-5-8.
//  Copyright 2012年 xxx. All rights reserved.
//
#import "FEZip.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "zlib.h"
#include <stddef.h>
#include <string.h>
#include <stdlib.h>
#include <errno.h>


#ifndef local
#  define local static
#endif
/* compile with -Dlocal if your debugger can't find static symbols */

#ifndef UNZ_BUFSIZE
#define UNZ_BUFSIZE (16384)
#endif


#ifndef ALLOC
# define ALLOC(size) (malloc(size))
#endif
#ifndef TRYFREE
# define TRYFREE(p) {if (p) free(p);}
#endif

#define SIZECENTRALDIRITEM (0x2e)
#define SIZEZIPLOCALHEADER (0x1e)


/* unz_file_info_interntal contain internal info about a file in zipfile*/
typedef struct _FE_UnzFileInfoInterl_
{
    uLong offset_curfile;/* relative offset of local header 4 bytes */
}FE_UnzFileInfoInterl;


/* FE_FileInZipReadInfo contain internal information about a file in zipfile,
 when reading and decompress it */
typedef struct
{
    char  *read_buffer;         /* internal buffer for compressed data */
    z_stream stream;            /* zLib stream structure for inflate */
    
    uLong pos_in_zipfile;       /* position in byte on the zipfile, for fseek*/
    uLong stream_initialised;   /* flag set if stream structure is initialised*/
    
    uLong offset_local_extrafield;/* offset of the local extra field */
    uInt  size_local_extrafield;/* size of the local extra field */
    uLong pos_local_extrafield;   /* position in the local extra field in read*/
    
    uLong crc32;                /* crc32 of all data uncompressed */
    uLong crc32_wait;           /* crc32 we must obtain after decompress all */
    uLong rest_read_compressed; /* number of byte to be decompressed */
    uLong rest_read_uncompressed;/*number of byte to be obtained after decomp*/
    bi_zlib_filefunc_def z_filefunc;
    voidpf filestream;        /* io structore of the zipfile */
    uLong compression_method;   /* compression method (0==store) */
    uLong byte_before_the_zipfile;/* byte before the zipfile, (>0 for sfx)*/
}FE_FileInZipReadInfo;


/* unz_s contain internal information about the zipfile
 */
typedef struct
{
    bi_zlib_filefunc_def z_filefunc;
    voidpf filestream;        /* io structore of the zipfile */
    FE_UnzGlobalInfo gi;       /* public global information */
    uLong byte_before_the_zipfile;/* byte before the zipfile, (>0 for sfx)*/
    uLong num_file;             /* number of the current file in the zipfile*/
    uLong pos_in_central_dir;   /* pos of the current file in the central dir*/
    uLong current_file_ok;      /* flag about the usability of the current file*/
    uLong central_pos;          /* position of the beginning of the central dir*/
    
    uLong size_central_dir;     /* size of the central directory  */
    uLong offset_central_dir;   /* offset of start of central directory with
                                 respect to the starting disk number */
    
    FE_UnzFileInfo cur_file_info; /* public info about the current file in zip*/
    FE_UnzFileInfoInterl cur_file_info_internal; /* private info about it*/
    FE_FileInZipReadInfo* pfile_in_zip_read; /* structure about the current
                                                 file if we are decompressing it */
}FE_Unz;



/* I've found an old Unix (a SunOS 4.1.3_U1) without all SEEK_* defined.... */

#ifndef SEEK_CUR
#define SEEK_CUR    1
#endif

#ifndef SEEK_END
#define SEEK_END    2
#endif

#ifndef SEEK_SET
#define SEEK_SET    0
#endif

voidpf bi_fopen_file_func(voidpf opaque,const char* filename, int mode);
uLong bi_fread_file_func(voidpf opaque,voidpf stream,void* buf,uLong size);
uLong bi_fwrite_file_func(voidpf opaque,voidpf stream,const void* buf,uLong size);
long bi_ftell_file_func(voidpf opaque,voidpf stream);
long bi_fseek_file_func(voidpf opaque,voidpf stream,uLong offset,int origin);
int bi_fclose_file_func(voidpf opaque,voidpf stream);
int bi_ferror_file_func(voidpf opaque,voidpf stream);


voidpf bi_fopen_file_func(voidpf opaque, const char* filename,int mode)
{
    FILE* file = NULL;
    const char* mode_fopen = NULL;
    if ((mode & KZLIB_FILEFUNC_MODE_READWRITEFILTER)==KZLIB_FILEFUNC_MODE_READ)
        mode_fopen = "rb";
    else
        if (mode & KZLIB_FILEFUNC_MODE_EXISTING)
            mode_fopen = "r+b";
        else
            if (mode & KZLIB_FILEFUNC_MODE_CREATE)
                mode_fopen = "wb";
    
    if ((filename!=NULL) && (mode_fopen != NULL))
        file = fopen(filename, mode_fopen);
    return file;
}


uLong bi_fread_file_func(voidpf opaque,voidpf stream,void* buf,uLong size)
{
    uLong ret;
    ret = (uLong)fread(buf, 1, (size_t)size, (FILE *)stream);
    return ret;
}


uLong bi_fwrite_file_func(voidpf opaque,voidpf stream,const void* buf,uLong size)
{
    uLong ret;
    ret = (uLong)fwrite(buf, 1, (size_t)size, (FILE *)stream);
    return ret;
}

long bi_ftell_file_func(voidpf opaque, voidpf stream)
{
    long ret;
    ret = ftell((FILE *)stream);
    return ret;
}

long bi_fseek_file_func (voidpf opaque,voidpf stream,uLong offset,int origin)
{
    int fseek_origin=0;
    long ret;
    switch (origin)
    {
        case KZLIB_FILEFUNC_SEEK_CUR :
            fseek_origin = SEEK_CUR;
            break;
        case KZLIB_FILEFUNC_SEEK_END :
            fseek_origin = SEEK_END;
            break;
        case KZLIB_FILEFUNC_SEEK_SET :
            fseek_origin = SEEK_SET;
            break;
        default: return -1;
    }
    ret = 0;
    fseek((FILE *)stream, offset, fseek_origin);
    return ret;
}

int bi_fclose_file_func(voidpf opaque,voidpf stream)
{
    int ret;
    ret = fclose((FILE *)stream);
    return ret;
}

int bi_ferror_file_func(voidpf opaque,voidpf stream)
{
    int ret;
    ret = ferror((FILE *)stream);
    return ret;
}

void bi_fill_fopen_filefunc (bi_zlib_filefunc_def* pzlib_filefunc_def)
{
    pzlib_filefunc_def->zopen_file = bi_fopen_file_func;
    pzlib_filefunc_def->zread_file = bi_fread_file_func;
    pzlib_filefunc_def->zwrite_file = bi_fwrite_file_func;
    pzlib_filefunc_def->ztell_file = bi_ftell_file_func;
    pzlib_filefunc_def->zseek_file = bi_fseek_file_func;
    pzlib_filefunc_def->zclose_file = bi_fclose_file_func;
    pzlib_filefunc_def->zerror_file = bi_ferror_file_func;
    pzlib_filefunc_def->opaque = NULL;
}


/* ===========================================================================
 Read a byte from a gz_stream; update next_in and avail_in. Return EOF
 for end of file.
 IN assertion: the stream s has been sucessfully opened for reading.
 */
local int bi_unzlocal_getByte(const bi_zlib_filefunc_def* pzlib_filefunc_def, voidpf filestream,int *pi)
{
    unsigned char c;
    int err = (int)FE_ZREAD(*pzlib_filefunc_def,filestream,&c,1);
    if (err==1)
    {
        *pi = (int)c;
        return kUnzOK;
    }
    else
    {
        if (FE_ZERROR(*pzlib_filefunc_def,filestream))
            return kUnzError;
        else
            return kUnzEof;
    }
}


/* ===========================================================================
 Reads a long in LSB order from the given gz_stream. Sets
 */
local int bi_unzlocal_getShort (const bi_zlib_filefunc_def* pzlib_filefunc_def,voidpf filestream,uLong *pX)
{
    uLong x ;
    int i;
    int err;
    
    err = bi_unzlocal_getByte(pzlib_filefunc_def,filestream,&i);
    x = (uLong)i;
    
    if (err==kUnzOK)
        err = bi_unzlocal_getByte(pzlib_filefunc_def,filestream,&i);
    x += ((uLong)i)<<8;
    
    if (err==kUnzOK)
        *pX = x;
    else
        *pX = 0;
    return err;
}

local int bi_unzlocal_getLong(const bi_zlib_filefunc_def* pzlib_filefunc_def,voidpf filestream,uLong * pX)
{
    uLong x ;
    int i;
    int err;
    
    err = bi_unzlocal_getByte(pzlib_filefunc_def,filestream,&i);
    x = (uLong)i;
    
    if (err==kUnzOK)
        err = bi_unzlocal_getByte(pzlib_filefunc_def,filestream,&i);
    x += ((uLong)i)<<8;
    
    if (err==kUnzOK)
        err = bi_unzlocal_getByte(pzlib_filefunc_def,filestream,&i);
    x += ((uLong)i)<<16;
    
    if (err==kUnzOK)
        err = bi_unzlocal_getByte(pzlib_filefunc_def,filestream,&i);
    x += ((uLong)i)<<24;
    
    if (err==kUnzOK)
        *pX = x;
    else
        *pX = 0;
    return err;
}

#ifndef BUFREADCOMMENT
#define BUFREADCOMMENT (0x400)
#endif

/*
 Locate the Central directory of a zipfile (at the end, just before
 the global comment)
 */
local uLong bi_unzlocal_SearchCentralDir(const bi_zlib_filefunc_def* pzlib_filefunc_def, voidpf filestream)
{
    unsigned char* buf;
    uLong uSizeFile;
    uLong uBackRead;
    uLong uMaxBack=0xffff; /* maximum size of global comment */
    uLong uPosFound=0;
    
    if (FE_ZSEEK(*pzlib_filefunc_def,filestream,0,KZLIB_FILEFUNC_SEEK_END) != 0)
        return 0;
    
    
    uSizeFile = FE_ZTELL(*pzlib_filefunc_def,filestream);
    
    if (uMaxBack>uSizeFile)
        uMaxBack = uSizeFile;
    
    buf = (unsigned char*)ALLOC(BUFREADCOMMENT+4);
    if (buf==NULL)
        return 0;
    
    uBackRead = 4;
    while (uBackRead<uMaxBack)
    {
        uLong uReadSize,uReadPos ;
        int i;
        if (uBackRead+BUFREADCOMMENT>uMaxBack)
            uBackRead = uMaxBack;
        else
            uBackRead+=BUFREADCOMMENT;
        uReadPos = uSizeFile-uBackRead ;
        
        uReadSize = ((BUFREADCOMMENT+4) < (uSizeFile-uReadPos)) ?
        (BUFREADCOMMENT+4) : (uSizeFile-uReadPos);
        if (FE_ZSEEK(*pzlib_filefunc_def,filestream,uReadPos,KZLIB_FILEFUNC_SEEK_SET)!=0)
            break;
        
        if (FE_ZREAD(*pzlib_filefunc_def,filestream,buf,uReadSize)!=uReadSize)
            break;
        
        for (i=(int)uReadSize-3; (i--)>0;)
            if (((*(buf+i))==0x50) && ((*(buf+i+1))==0x4b) &&
                ((*(buf+i+2))==0x05) && ((*(buf+i+3))==0x06))
            {
                uPosFound = uReadPos+i;
                break;
            }
        
        if (uPosFound!=0)
            break;
    }
    TRYFREE(buf);
    return uPosFound;
}


FE_UnzFile FEUnzOpen(const char * path)
{
    FE_Unz us;
    FE_Unz *s;
    uLong central_pos,uL;
    
    uLong number_disk;          /* number of the current dist, used for
                                 spaning ZIP, unsupported, always 0*/
    uLong number_disk_with_CD;  /* number the the disk with central dir, used
                                 for spaning ZIP, unsupported, always 0*/
    uLong number_entry_CD;      /* total number of entries in
                                 the central dir
                                 (same than number_entry on nospan) */
    
    int err=kUnzOK;
    
    
    bi_fill_fopen_filefunc(&us.z_filefunc);
    
    us.filestream= (*(us.z_filefunc.zopen_file))(us.z_filefunc.opaque,
                                                 path,
                                                 KZLIB_FILEFUNC_MODE_READ |
                                                 KZLIB_FILEFUNC_MODE_EXISTING);
    if (us.filestream==NULL)
        return NULL;
    
    central_pos = bi_unzlocal_SearchCentralDir(&us.z_filefunc,us.filestream);
    if (central_pos==0)
        err=kUnzError;
    
    if (FE_ZSEEK(us.z_filefunc, us.filestream,
              central_pos,KZLIB_FILEFUNC_SEEK_SET)!=0)
        err=kUnzError;
    
    /* the signature, already checked */
    if (bi_unzlocal_getLong(&us.z_filefunc, us.filestream,&uL)!=kUnzOK)
        err=kUnzError;
    
    /* number of this disk */
    if (bi_unzlocal_getShort(&us.z_filefunc, us.filestream,&number_disk)!=kUnzOK)
        err=kUnzError;
    
    /* number of the disk with the start of the central directory */
    if (bi_unzlocal_getShort(&us.z_filefunc, us.filestream,&number_disk_with_CD)!=kUnzOK)
        err=kUnzError;
    
    /* total number of entries in the central dir on this disk */
    if (bi_unzlocal_getShort(&us.z_filefunc, us.filestream,&us.gi.number_entry)!=kUnzOK)
        err=kUnzError;
    
    /* total number of entries in the central dir */
    if (bi_unzlocal_getShort(&us.z_filefunc, us.filestream,&number_entry_CD)!=kUnzOK)
        err=kUnzError;
    
    if ((number_entry_CD!=us.gi.number_entry) ||
        (number_disk_with_CD!=0) ||
        (number_disk!=0))
        err=kUnzBadZipFile;
    
    /* size of the central directory */
    if (bi_unzlocal_getLong(&us.z_filefunc, us.filestream,&us.size_central_dir)!=kUnzOK)
        err=kUnzError;
    
    /* offset of start of central directory with respect to the
     starting disk number */
    if (bi_unzlocal_getLong(&us.z_filefunc, us.filestream,&us.offset_central_dir)!=kUnzOK)
        err=kUnzError;
    
    /* zipfile comment length */
    if (bi_unzlocal_getShort(&us.z_filefunc, us.filestream,&us.gi.size_comment)!=kUnzOK)
        err=kUnzError;
    
    if ((central_pos<us.offset_central_dir+us.size_central_dir) &&
        (err==kUnzOK))
        err=kUnzBadZipFile;
    
    if (err!=kUnzOK)
    {
        FE_ZCLOSE(us.z_filefunc, us.filestream);
        return NULL;
    }
    
    us.byte_before_the_zipfile = central_pos -
    (us.offset_central_dir+us.size_central_dir);
    us.central_pos = central_pos;
    us.pfile_in_zip_read = NULL;
    
    s=(FE_Unz*)ALLOC(sizeof(FE_Unz));
    *s=us;
    FEUnzGoToFirstFile((FE_UnzFile)s);
    return (FE_UnzFile)s;
}

/*
 Close a ZipFile opened with unzipOpen.
 If there is files inside the .Zip opened with unzipOpenCurrentFile (see later),
 these files MUST be closed with unzipCloseCurrentFile before call unzipClose.
 return kUnzOK if there is no problem. */
int FEUnzClose(FE_UnzFile file)
{
    FE_Unz* s;
    if (file==NULL)
        return kUnzParamerror;
    s=(FE_Unz*)file;
    
    if (s->pfile_in_zip_read!=NULL)
        FEUnzCloseCurrentFile(file);
    
    FE_ZCLOSE(s->z_filefunc, s->filestream);
    TRYFREE(s);
    return kUnzOK;
}


/*
 Translate date/time from Dos format to bi_tm_unz (readable more easilty)
 */
local void bi_unzlocal_DosDateToTmuDate(uLong ulDosDate,bi_tm_unz*ptm)
{
    uLong uDate;
    uDate = (uLong)(ulDosDate>>16);
    ptm->tm_mday = (uInt)(uDate&0x1f) ;
    ptm->tm_mon =  (uInt)((((uDate)&0x1E0)/0x20)-1) ;
    ptm->tm_year = (uInt)(((uDate&0x0FE00)/0x0200)+1980) ;
    
    ptm->tm_hour = (uInt) ((ulDosDate &0xF800)/0x800);
    ptm->tm_min =  (uInt) ((ulDosDate&0x7E0)/0x20) ;
    ptm->tm_sec =  (uInt) (2*(ulDosDate&0x1f)) ;
}

/*
 Get Info about the current file in the zipfile, with internal only info
 */
local int bi_unzlocal_GetCurrentFileInfoInternal (FE_UnzFile file,
                                                  FE_UnzFileInfo *pfile_info,
                                                  FE_UnzFileInfoInterl
                                                  *pfile_info_internal,
                                                  char *szFileName,
                                                  uLong fileNameBufferSize,
                                                  void *extraField,
                                                  uLong extraFieldBufferSize,
                                                  char *szComment,
                                                  uLong commentBufferSize)
{
    FE_Unz* s;
    FE_UnzFileInfo file_info;
    FE_UnzFileInfoInterl file_info_internal;
    int err=kUnzOK;
    uLong uMagic;
    long lSeek=0;
    
    if (file==NULL)
        return kUnzParamerror;
    s=(FE_Unz*)file;
    if (FE_ZSEEK(s->z_filefunc, s->filestream,
              s->pos_in_central_dir+s->byte_before_the_zipfile,
              KZLIB_FILEFUNC_SEEK_SET)!=0)
        err=kUnzError;
    
    
    /* we check the magic */
    if (err==kUnzOK)
    {
        if (bi_unzlocal_getLong(&s->z_filefunc, s->filestream,&uMagic) != kUnzOK)
            err=kUnzError;
        else if (uMagic!=0x02014b50)
            err=kUnzBadZipFile;
    }
    
    if (bi_unzlocal_getShort(&s->z_filefunc, s->filestream,&file_info.version) != kUnzOK)
        err=kUnzError;
    
    if (bi_unzlocal_getShort(&s->z_filefunc, s->filestream,&file_info.version_needed) != kUnzOK)
        err=kUnzError;
    
    if (bi_unzlocal_getShort(&s->z_filefunc, s->filestream,&file_info.flag) != kUnzOK)
        err=kUnzError;
    
    if (bi_unzlocal_getShort(&s->z_filefunc, s->filestream,&file_info.compression_method) != kUnzOK)
        err=kUnzError;
    
    if (bi_unzlocal_getLong(&s->z_filefunc, s->filestream,&file_info.dosDate) != kUnzOK)
        err=kUnzError;
    
    bi_unzlocal_DosDateToTmuDate(file_info.dosDate,&file_info.tmu_date);
    
    if (bi_unzlocal_getLong(&s->z_filefunc, s->filestream,&file_info.crc) != kUnzOK)
        err=kUnzError;
    
    if (bi_unzlocal_getLong(&s->z_filefunc, s->filestream,&file_info.compressed_size) != kUnzOK)
        err=kUnzError;
    
    if (bi_unzlocal_getLong(&s->z_filefunc, s->filestream,&file_info.uncompressed_size) != kUnzOK)
        err=kUnzError;
    
    if (bi_unzlocal_getShort(&s->z_filefunc, s->filestream,&file_info.size_filename) != kUnzOK)
        err=kUnzError;
    
    if (bi_unzlocal_getShort(&s->z_filefunc, s->filestream,&file_info.size_file_extra) != kUnzOK)
        err=kUnzError;
    
    if (bi_unzlocal_getShort(&s->z_filefunc, s->filestream,&file_info.size_file_comment) != kUnzOK)
        err=kUnzError;
    
    if (bi_unzlocal_getShort(&s->z_filefunc, s->filestream,&file_info.disk_num_start) != kUnzOK)
        err=kUnzError;
    
    if (bi_unzlocal_getShort(&s->z_filefunc, s->filestream,&file_info.internal_fa) != kUnzOK)
        err=kUnzError;
    
    if (bi_unzlocal_getLong(&s->z_filefunc, s->filestream,&file_info.external_fa) != kUnzOK)
        err=kUnzError;
    
    if (bi_unzlocal_getLong(&s->z_filefunc, s->filestream,&file_info_internal.offset_curfile) != kUnzOK)
        err=kUnzError;
    
    lSeek+=file_info.size_filename;
    if ((err==kUnzOK) && (szFileName!=NULL))
    {
        uLong uSizeRead ;
        if (file_info.size_filename<fileNameBufferSize)
        {
            *(szFileName+file_info.size_filename)='\0';
            uSizeRead = file_info.size_filename;
        }
        else
            uSizeRead = fileNameBufferSize;
        
        if ((file_info.size_filename>0) && (fileNameBufferSize>0))
        {
            if (FE_ZREAD(s->z_filefunc, s->filestream,szFileName,uSizeRead)!=uSizeRead)
            {
                err=kUnzError;
            }
            
        }
        lSeek -= uSizeRead;
    }
    
    
    if ((err==kUnzOK) && (extraField!=NULL))
    {
        uLong uSizeRead ;
        if (file_info.size_file_extra<extraFieldBufferSize)
            uSizeRead = file_info.size_file_extra;
        else
            uSizeRead = extraFieldBufferSize;
        
        if (lSeek!=0)
        {
            if (FE_ZSEEK(s->z_filefunc, s->filestream,lSeek,KZLIB_FILEFUNC_SEEK_CUR)==0)
                lSeek=0;
            else
                err=kUnzError;
        }
        if ((file_info.size_file_extra>0) && (extraFieldBufferSize>0))
            if (FE_ZREAD(s->z_filefunc, s->filestream,extraField,uSizeRead)!=uSizeRead)
                err=kUnzError;
        lSeek += file_info.size_file_extra - uSizeRead;
    }
    else
        lSeek+=file_info.size_file_extra;
    
    
    if ((err==kUnzOK) && (szComment!=NULL))
    {
        uLong uSizeRead ;
        if (file_info.size_file_comment<commentBufferSize)
        {
            *(szComment+file_info.size_file_comment)='\0';
            uSizeRead = file_info.size_file_comment;
        }
        else
            uSizeRead = commentBufferSize;
        
        if (lSeek!=0)
        {
            if (FE_ZSEEK(s->z_filefunc, s->filestream,lSeek,KZLIB_FILEFUNC_SEEK_CUR)==0)
                lSeek=0;
            else
                err=kUnzError; 
        }
        if ((file_info.size_file_comment>0) && (commentBufferSize>0))
            if (FE_ZREAD(s->z_filefunc, s->filestream,szComment,uSizeRead)!=uSizeRead)
                err=kUnzError;
        lSeek+=file_info.size_file_comment - uSizeRead;
    }
    else
        lSeek+=file_info.size_file_comment;
    
    if ((err==kUnzOK) && (pfile_info!=NULL))
        *pfile_info=file_info;
    
    if ((err==kUnzOK) && (pfile_info_internal!=NULL))
        *pfile_info_internal=file_info_internal;
    
    return err;
}

/*
 Write info about the ZipFile in the *pglobal_info structure.
 No preparation of the structure is needed
 return kUnzOK if there is no problem.
 */
int FEUnzGetCurrentFileInfo (
                                    FE_UnzFile file,
                                    FE_UnzFileInfo *pfile_info,
                                    char *szFileName,
                                    uLong fileNameBufferSize,
                                    void *extraField,
                                    uLong extraFieldBufferSize,
                                    char *szComment,
                                    uLong commentBufferSize
                                    )
{
    return bi_unzlocal_GetCurrentFileInfoInternal(file,pfile_info,NULL,
                                               szFileName,fileNameBufferSize,
                                               extraField,extraFieldBufferSize,
                                               szComment,commentBufferSize);
}

/*
 Set the current file of the zipfile to the first file.
 return kUnzOK if there is no problem
 */
int FEUnzGoToFirstFile(FE_UnzFile file)
{
    int err=kUnzOK;
    FE_Unz* s;
    if (file==NULL)
        return kUnzParamerror;
    s=(FE_Unz*)file;
    s->pos_in_central_dir=s->offset_central_dir;
    s->num_file=0;
    err=bi_unzlocal_GetCurrentFileInfoInternal(file,&s->cur_file_info,
                                            &s->cur_file_info_internal,
                                            NULL,0,NULL,0,NULL,0);
    s->current_file_ok = (err == kUnzOK);
    return err;
}

/*
 Set the current file of the zipfile to the next file.
 return kUnzOK if there is no problem
 return kUnzEndOfListOfFile if the actual file was the latest.
 */
int  FEUnzGoToNextFile (FE_UnzFile file)
{
    FE_Unz* s;
    int err;
    
    if (file==NULL)
        return kUnzParamerror;
    s=(FE_Unz*)file;
    if (!s->current_file_ok)
        return kUnzEndOfListOfFile;
    if (s->gi.number_entry != 0xffff)    /* 2^16 files overflow hack */
        if (s->num_file+1==s->gi.number_entry)
            return kUnzEndOfListOfFile;
    
    s->pos_in_central_dir += SIZECENTRALDIRITEM + s->cur_file_info.size_filename +
    s->cur_file_info.size_file_extra + s->cur_file_info.size_file_comment ;
    s->num_file++;
    err = bi_unzlocal_GetCurrentFileInfoInternal(file,&s->cur_file_info,
                                              &s->cur_file_info_internal,
                                              NULL,0,NULL,0,NULL,0);
    s->current_file_ok = (err == kUnzOK);
    return err;
}
/*
 ///////////////////////////////////////////
 // Contributed by Ryan Haksi (mailto://cryogen@infoserve.net)
 // I need random access
 //
 // Further optimization could be realized by adding an ability
 // to cache the directory in memory. The goal being a single
 // comprehensive file read to put the file I need in a memory.
 */


/*
 // Unzip Helper Functions - should be here?
 ///////////////////////////////////////////
 */

/*
 Read the local header of the current zipfile
 Check the coherency of the local header and info in the end of central
 directory about this file
 store in *piSizeVar the size of extra info in local header
 (filename and size of extra field data)
 */
local int bi_unzlocal_CheckCurrentFileCoherencyHeader(
                                                   FE_Unz* s,
                                                   uInt* piSizeVar,
                                                   uLong *poffset_local_extrafield,
                                                   uInt  *psize_local_extrafield)
{
    uLong uMagic,uData,uFlags;
    uLong size_filename;
    uLong size_extra_field;
    int err=kUnzOK;
    
    *piSizeVar = 0;
    *poffset_local_extrafield = 0;
    *psize_local_extrafield = 0;
    
    if (FE_ZSEEK(s->z_filefunc, s->filestream,s->cur_file_info_internal.offset_curfile +
              s->byte_before_the_zipfile,KZLIB_FILEFUNC_SEEK_SET)!=0)
        return kUnzError;
    
    
    if (err==kUnzOK)
    {
        if (bi_unzlocal_getLong(&s->z_filefunc, s->filestream,&uMagic) != kUnzOK)
            err=kUnzError;
        else if (uMagic!=0x04034b50)
            err=kUnzBadZipFile; 
    }
    
    if (bi_unzlocal_getShort(&s->z_filefunc, s->filestream,&uData) != kUnzOK)
        err=kUnzError;
    /*
     else if ((err==kUnzOK) && (uData!=s->cur_file_info.wVersion))
     err=kUnzBadZipFile;
     */
    if (bi_unzlocal_getShort(&s->z_filefunc, s->filestream,&uFlags) != kUnzOK)
        err=kUnzError;
    
    if (bi_unzlocal_getShort(&s->z_filefunc, s->filestream,&uData) != kUnzOK)
        err=kUnzError;
    else if ((err==kUnzOK) && (uData!=s->cur_file_info.compression_method))
        err=kUnzBadZipFile;
    
    if ((err==kUnzOK) && (s->cur_file_info.compression_method!=0) &&
        (s->cur_file_info.compression_method!=Z_DEFLATED))
        err=kUnzBadZipFile;
    
    if (bi_unzlocal_getLong(&s->z_filefunc, s->filestream,&uData) != kUnzOK) /* date/time */
        err=kUnzError;
    
    if (bi_unzlocal_getLong(&s->z_filefunc, s->filestream,&uData) != kUnzOK) /* crc */
        err=kUnzError;
    else if ((err==kUnzOK) && (uData!=s->cur_file_info.crc) &&
             ((uFlags & 8)==0))
        err=kUnzBadZipFile;
    
    if (bi_unzlocal_getLong(&s->z_filefunc, s->filestream,&uData) != kUnzOK) /* size compr */
        err=kUnzError;
    else if ((err==kUnzOK) && (uData!=s->cur_file_info.compressed_size) &&
             ((uFlags & 8)==0))
        err=kUnzBadZipFile;
    
    if (bi_unzlocal_getLong(&s->z_filefunc, s->filestream,&uData) != kUnzOK) /* size uncompr */
        err=kUnzError;
    else if ((err==kUnzOK) && (uData!=s->cur_file_info.uncompressed_size) &&
             ((uFlags & 8)==0))
        err=kUnzBadZipFile;
    
    
    if (bi_unzlocal_getShort(&s->z_filefunc, s->filestream,&size_filename) != kUnzOK)
        err=kUnzError;
    else if ((err==kUnzOK) && (size_filename!=s->cur_file_info.size_filename))
        err=kUnzBadZipFile;
    
    *piSizeVar += (uInt)size_filename;
    
    if (bi_unzlocal_getShort(&s->z_filefunc, s->filestream,&size_extra_field) != kUnzOK)
        err=kUnzError;
    *poffset_local_extrafield= s->cur_file_info_internal.offset_curfile +
    SIZEZIPLOCALHEADER + size_filename;
    *psize_local_extrafield = (uInt)size_extra_field;
    
    *piSizeVar += (uInt)size_extra_field;
    
    return err;
}


int FEUnzOpenCurrentFile(FE_UnzFile file)
{
    int err=kUnzOK;
    uInt iSizeVar;
    FE_Unz* s;
    FE_FileInZipReadInfo* pfile_in_zip_read_info;
    uLong offset_local_extrafield;  /* offset of the local extra field */
    uInt  size_local_extrafield;    /* size of the local extra field */
    
    
    
    if (file==NULL)
        return kUnzParamerror;
    s=(FE_Unz*)file;
    if (!s->current_file_ok)
        return kUnzParamerror;
    
    if (s->pfile_in_zip_read != NULL)
        FEUnzCloseCurrentFile(file);
    
    if (bi_unzlocal_CheckCurrentFileCoherencyHeader(s,&iSizeVar,
                                                 &offset_local_extrafield,&size_local_extrafield)!=kUnzOK)
        return kUnzBadZipFile;
    
    pfile_in_zip_read_info = (FE_FileInZipReadInfo*)
    ALLOC(sizeof(FE_FileInZipReadInfo));
    if (pfile_in_zip_read_info==NULL)
        return kUnzInterNalError;
    
    pfile_in_zip_read_info->read_buffer=(char*)ALLOC(UNZ_BUFSIZE);
    pfile_in_zip_read_info->offset_local_extrafield = offset_local_extrafield;
    pfile_in_zip_read_info->size_local_extrafield = size_local_extrafield;
    pfile_in_zip_read_info->pos_local_extrafield=0;
    
    if (pfile_in_zip_read_info->read_buffer==NULL)
    {
        TRYFREE(pfile_in_zip_read_info);
        return kUnzInterNalError;
    }
    
    pfile_in_zip_read_info->stream_initialised=0;
    
    if ((s->cur_file_info.compression_method!=0) &&
        (s->cur_file_info.compression_method!=Z_DEFLATED))
        err=kUnzBadZipFile;
    
    pfile_in_zip_read_info->crc32_wait=s->cur_file_info.crc;
    pfile_in_zip_read_info->crc32=0;
    pfile_in_zip_read_info->compression_method = s->cur_file_info.compression_method;
    pfile_in_zip_read_info->filestream=s->filestream;
    pfile_in_zip_read_info->z_filefunc=s->z_filefunc;
    pfile_in_zip_read_info->byte_before_the_zipfile=s->byte_before_the_zipfile;
    
    pfile_in_zip_read_info->stream.total_out = 0;
    
    if (s->cur_file_info.compression_method==Z_DEFLATED)
    {
        pfile_in_zip_read_info->stream.zalloc = (alloc_func)0;
        pfile_in_zip_read_info->stream.zfree = (free_func)0;
        pfile_in_zip_read_info->stream.opaque = (voidpf)0;
        pfile_in_zip_read_info->stream.next_in = (voidpf)0;
        pfile_in_zip_read_info->stream.avail_in = 0;
        
        err=inflateInit2(&pfile_in_zip_read_info->stream, -MAX_WBITS);
        if (err == Z_OK)
            pfile_in_zip_read_info->stream_initialised=1;
        else
        {
            TRYFREE(pfile_in_zip_read_info);
            return err;
        }
        /* windowBits is passed < 0 to tell that there is no zlib header.
         * Note that in this case inflate *requires* an extra "dummy" byte
         * after the compressed stream in order to complete decompression and
         * return Z_STREAM_END.
         * In unzip, i don't wait absolutely Z_STREAM_END because I known the
         * size of both compressed and uncompressed data
         */
    }
    pfile_in_zip_read_info->rest_read_compressed =
    s->cur_file_info.compressed_size ;
    pfile_in_zip_read_info->rest_read_uncompressed =
    s->cur_file_info.uncompressed_size ;
    
    
    pfile_in_zip_read_info->pos_in_zipfile =
    s->cur_file_info_internal.offset_curfile + SIZEZIPLOCALHEADER +
    iSizeVar;
    
    pfile_in_zip_read_info->stream.avail_in = (uInt)0;
    
    s->pfile_in_zip_read = pfile_in_zip_read_info;
    
    return kUnzOK;  
}


/*
 Read bytes from the current file.
 buf contain buffer where data must be copied
 len the size of buf.
 
 return the number of byte copied if somes bytes are copied
 return 0 if the end of file was reached
 return <0 with error code if there is an error
 (kUnzError for IO error, or zLib error for uncompress error)
 */
int  FEUnzReadCurrentFile(FE_UnzFile file,voidp buf,unsigned len)
{
    int err=kUnzOK;
    uInt iRead = 0;
    FE_Unz* s;
    FE_FileInZipReadInfo* pfile_in_zip_read_info;
    if (file==NULL)
        return kUnzParamerror;
    s=(FE_Unz*)file;
    pfile_in_zip_read_info=s->pfile_in_zip_read;
    
    if (pfile_in_zip_read_info==NULL)
        return kUnzParamerror;
    
    
    if (pfile_in_zip_read_info->read_buffer == NULL)
        return kUnzEndOfListOfFile;
    if (len==0)
        return 0;
    
    pfile_in_zip_read_info->stream.next_out = (Bytef*)buf;
    
    pfile_in_zip_read_info->stream.avail_out = (uInt)len;
    
    if (len>pfile_in_zip_read_info->rest_read_uncompressed)
        pfile_in_zip_read_info->stream.avail_out = (uInt)pfile_in_zip_read_info->rest_read_uncompressed;
    
    while (pfile_in_zip_read_info->stream.avail_out>0)
    {
        if ((pfile_in_zip_read_info->stream.avail_in==0) &&
            (pfile_in_zip_read_info->rest_read_compressed>0))
        {
            uInt uReadThis = UNZ_BUFSIZE;
            if (pfile_in_zip_read_info->rest_read_compressed<uReadThis)
                uReadThis = (uInt)pfile_in_zip_read_info->rest_read_compressed;
            if (uReadThis == 0)
                return kUnzEof;
            if (FE_ZSEEK(pfile_in_zip_read_info->z_filefunc,
                      pfile_in_zip_read_info->filestream,
                      pfile_in_zip_read_info->pos_in_zipfile +
                      pfile_in_zip_read_info->byte_before_the_zipfile,
                      KZLIB_FILEFUNC_SEEK_SET)!=0)
                return kUnzError;
            if (FE_ZREAD(pfile_in_zip_read_info->z_filefunc,
                      pfile_in_zip_read_info->filestream,
                      pfile_in_zip_read_info->read_buffer,
                      uReadThis)!=uReadThis)
                return kUnzError;
            
            pfile_in_zip_read_info->pos_in_zipfile += uReadThis;
            
            pfile_in_zip_read_info->rest_read_compressed-=uReadThis;
            
            pfile_in_zip_read_info->stream.next_in =
            (Bytef*)pfile_in_zip_read_info->read_buffer;
            pfile_in_zip_read_info->stream.avail_in = (uInt)uReadThis;
        }
        
        if (pfile_in_zip_read_info->compression_method==0)
        {
            uInt uDoCopy,i ;
            
            if ((pfile_in_zip_read_info->stream.avail_in == 0) &&
                (pfile_in_zip_read_info->rest_read_compressed == 0))
                return (iRead==0) ? kUnzEof : iRead;
            
            if (pfile_in_zip_read_info->stream.avail_out <
                pfile_in_zip_read_info->stream.avail_in)
                uDoCopy = pfile_in_zip_read_info->stream.avail_out ;
            else
                uDoCopy = pfile_in_zip_read_info->stream.avail_in ;
            
            for (i=0;i<uDoCopy;i++)
                *(pfile_in_zip_read_info->stream.next_out+i) =
                *(pfile_in_zip_read_info->stream.next_in+i);
            
            pfile_in_zip_read_info->crc32 = crc32(pfile_in_zip_read_info->crc32,
                                                  pfile_in_zip_read_info->stream.next_out,
                                                  uDoCopy);
            pfile_in_zip_read_info->rest_read_uncompressed-=uDoCopy;
            pfile_in_zip_read_info->stream.avail_in -= uDoCopy;
            pfile_in_zip_read_info->stream.avail_out -= uDoCopy;
            pfile_in_zip_read_info->stream.next_out += uDoCopy;
            pfile_in_zip_read_info->stream.next_in += uDoCopy;
            pfile_in_zip_read_info->stream.total_out += uDoCopy;
            iRead += uDoCopy;
        }
        else
        {
            uLong uTotalOutBefore,uTotalOutAfter;
            const Bytef *bufBefore;
            uLong uOutThis;
            int flush=Z_SYNC_FLUSH;
            
            uTotalOutBefore = pfile_in_zip_read_info->stream.total_out;
            bufBefore = pfile_in_zip_read_info->stream.next_out;
            
            /*
             if ((pfile_in_zip_read_info->rest_read_uncompressed ==
             pfile_in_zip_read_info->stream.avail_out) &&
             (pfile_in_zip_read_info->rest_read_compressed == 0))
             flush = Z_FINISH;
             */
            err=inflate(&pfile_in_zip_read_info->stream,flush);
            
            if ((err>=0) && (pfile_in_zip_read_info->stream.msg!=NULL))
                err = Z_DATA_ERROR;
            
            uTotalOutAfter = pfile_in_zip_read_info->stream.total_out;
            uOutThis = uTotalOutAfter-uTotalOutBefore;
            
            pfile_in_zip_read_info->crc32 =
            crc32(pfile_in_zip_read_info->crc32,bufBefore,
                  (uInt)(uOutThis));
            
            pfile_in_zip_read_info->rest_read_uncompressed -=
            uOutThis;
            
            iRead += (uInt)(uTotalOutAfter - uTotalOutBefore);
            
            if (err==Z_STREAM_END)
                return (iRead==0) ? kUnzEof : iRead;
            if (err!=Z_OK)
                break;
        }
    }
    
    if (err==Z_OK)
        return iRead;
    return err;
}


/*
 Close the file in zip opened with unzipOpenCurrentFile
 Return kUnzCrcError if all the file was read but the CRC is not good
 */
int FEUnzCloseCurrentFile(FE_UnzFile file)
{
    int err=kUnzOK;
    
    FE_Unz* s;
    FE_FileInZipReadInfo* pfile_in_zip_read_info;
    if (file==NULL)
        return kUnzParamerror;
    s=(FE_Unz*)file;
    pfile_in_zip_read_info=s->pfile_in_zip_read;
    
    if (pfile_in_zip_read_info==NULL)
        return kUnzParamerror;
    
    
    if (pfile_in_zip_read_info->rest_read_uncompressed == 0)
    {
        if (pfile_in_zip_read_info->crc32 != pfile_in_zip_read_info->crc32_wait)
            err=kUnzCrcError;
    }
    
    
    TRYFREE(pfile_in_zip_read_info->read_buffer);
    pfile_in_zip_read_info->read_buffer = NULL;
    if (pfile_in_zip_read_info->stream_initialised)
        inflateEnd(&pfile_in_zip_read_info->stream);
    
    pfile_in_zip_read_info->stream_initialised = 0;
    TRYFREE(pfile_in_zip_read_info);
    
    s->pfile_in_zip_read=NULL;
    
    return err;
}
