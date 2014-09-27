//
//  FEZip.h
//
//
//  Created by xxx on 12-5-8.
//  Copyright 2012年 xxx. All rights reserved.
//


#define KZLIB_FILEFUNC_SEEK_CUR (1)
#define KZLIB_FILEFUNC_SEEK_END (2)
#define KZLIB_FILEFUNC_SEEK_SET (0)

#define KZLIB_FILEFUNC_MODE_READ      (1)
#define KZLIB_FILEFUNC_MODE_WRITE     (2)
#define KZLIB_FILEFUNC_MODE_READWRITEFILTER (3)

#define KZLIB_FILEFUNC_MODE_EXISTING (4)
#define KZLIB_FILEFUNC_MODE_CREATE   (8)




#ifdef __cplusplus
extern "C" {
#endif
    
#ifndef _ZLIB_H
#include "zlib.h"
#endif

    
typedef voidpf (*bi_open_file_func) OF((voidpf opaque, const char* filename, int mode));
typedef uLong  (*bi_read_file_func) OF((voidpf opaque, voidpf stream, void* buf, uLong size));
typedef uLong  (*bi_write_file_func) OF((voidpf opaque, voidpf stream, const void* buf, uLong size));
typedef long   (*bi_tell_file_func) OF((voidpf opaque, voidpf stream));
typedef long   (*bi_seek_file_func) OF((voidpf opaque, voidpf stream, uLong offset, int origin));
typedef int    (*bi_close_file_func) OF((voidpf opaque, voidpf stream));
typedef int    (*bi_testerror_file_func) OF((voidpf opaque, voidpf stream));

typedef struct bi_zlib_filefunc_def_s
{
    bi_open_file_func      zopen_file;
    bi_read_file_func      zread_file;
    bi_write_file_func     zwrite_file;
    bi_tell_file_func      ztell_file;
    bi_seek_file_func      zseek_file;
    bi_close_file_func     zclose_file;
    bi_testerror_file_func zerror_file;
    voidpf              opaque;
} bi_zlib_filefunc_def;

void bi_fill_fopen_filefunc OF((bi_zlib_filefunc_def* pzlib_filefunc_def));

#define FE_ZREAD(filefunc,filestream,buf,size) ((*((filefunc).zread_file))((filefunc).opaque,filestream,buf,size))
#define FE_ZWRITE(filefunc,filestream,buf,size) ((*((filefunc).zwrite_file))((filefunc).opaque,filestream,buf,size))
#define FE_ZTELL(filefunc,filestream) ((*((filefunc).ztell_file))((filefunc).opaque,filestream))
#define FE_ZSEEK(filefunc,filestream,pos,mode) ((*((filefunc).zseek_file))((filefunc).opaque,filestream,pos,mode))
#define FE_ZCLOSE(filefunc,filestream) ((*((filefunc).zclose_file))((filefunc).opaque,filestream))
#define FE_ZERROR(filefunc,filestream) ((*((filefunc).zerror_file))((filefunc).opaque,filestream))

typedef voidp FE_UnzFile;
    
#define kUnzOK                          (0)
#define kUnzEndOfListOfFile         (-100)
#define kUnzError                       (Z_ERRNO)
#define kUnzEof                         (0)
#define kUnzParamerror                  (-102)
#define kUnzBadZipFile                  (-103)
#define kUnzInterNalError               (-104)
#define kUnzCrcError                    (-105)

/* bi_tm_unz contain date/time info */
typedef struct bi_tm_unz_s
{
    uInt tm_sec;            /* seconds after the minute - [0,59] */
    uInt tm_min;            /* minutes after the hour - [0,59] */
    uInt tm_hour;           /* hours since midnight - [0,23] */
    uInt tm_mday;           /* day of the month - [1,31] */
    uInt tm_mon;            /* months since January - [0,11] */
    uInt tm_year;           /* years - [1980..2044] */
} bi_tm_unz;

/* bi_unz_global_info structure contain global data about the ZIPfile
 These data comes from the end of central dir */
typedef struct bi_unz_global_info_s
{
    uLong number_entry;         /* total number of entries in the central dir on this disk */
    uLong size_comment;         /* size of the global comment of the zipfile */
}FE_UnzGlobalInfo;


/* bi_unz_file_info contain information about a file in the zipfile */
typedef struct _FE_UnzFileInfo_
{
    uLong version;              /* version made by                 2 bytes */
    uLong version_needed;       /* version needed to extract       2 bytes */
    uLong flag;                 /* general purpose bit flag        2 bytes */
    uLong compression_method;   /* compression method              2 bytes */
    uLong dosDate;              /* last mod file date in Dos fmt   4 bytes */
    uLong crc;                  /* crc-32                          4 bytes */
    uLong compressed_size;      /* compressed size                 4 bytes */
    uLong uncompressed_size;    /* uncompressed size               4 bytes */
    uLong size_filename;        /* filename length                 2 bytes */
    uLong size_file_extra;      /* extra field length              2 bytes */
    uLong size_file_comment;    /* file comment length             2 bytes */
    
    uLong disk_num_start;       /* disk number start               2 bytes */
    uLong internal_fa;          /* internal file attributes        2 bytes */
    uLong external_fa;          /* external file attributes        4 bytes */
    
    bi_tm_unz tmu_date;
}FE_UnzFileInfo;


extern FE_UnzFile FEUnzOpen(const char *path);
/*
 Open a Zip file. path contain the full pathname (by example,
 on a Windows XP computer "c:\\zlib\\zlib113.zip" or on an Unix computer
 "zlib/zlib113.zip".
 If the zipfile cannot be opened (file don't exist or in not valid), the
 return value is NULL.
 Else, the return value is a unzFile Handle, usable with other function
 of this unzip package.
 */

extern int FEUnzClose(FE_UnzFile file);
/*
 Close a ZipFile opened with unzipOpen.
 If there is files inside the .Zip opened with unzOpenCurrentFile (see later),
 these files MUST be closed with unzipCloseCurrentFile before call unzipClose.
 return kUnzOK if there is no problem. */


/***************************************************************************/
/* Unzip package allow you browse the directory of the zipfile */

extern int FEUnzGoToFirstFile(FE_UnzFile file);
/*
 Set the current file of the zipfile to the first file.
 return kUnzOK if there is no problem
 */

extern int FEUnzGoToNextFile(FE_UnzFile file);
/*
 Set the current file of the zipfile to the next file.
 return kUnzOK if there is no problem
 return kUnzEndOfListOfFile if the actual file was the latest.
 */


/* ****************************************** */

extern int FEUnzGetCurrentFileInfo(FE_UnzFile file,
                                   FE_UnzFileInfo *pfile_info,
                                   char *szFileName,
                                   uLong fileNameBufferSize,
                                   void *extraField,
                                   uLong extraFieldBufferSize,
                                   char *szComment,
                                   uLong commentBufferSize);
/*
 Get Info about the current file
 if pfile_info!=NULL, the *pfile_info structure will contain somes info about
 the current file
 if szFileName!=NULL, the filemane string will be copied in szFileName
 (fileNameBufferSize is the size of the buffer)
 if extraField!=NULL, the extra field information will be copied in extraField
 (extraFieldBufferSize is the size of the buffer).
 This is the Central-header version of the extra field
 if szComment!=NULL, the comment string of the file will be copied in szComment
 (commentBufferSize is the size of the buffer)
 */

/***************************************************************************/
/* for reading the content of the current zipfile, you can open it, read data
 from it, and close it (you can close it before reading all the file)
 */

extern int FEUnzOpenCurrentFile(FE_UnzFile file);
/*
 Open for reading data the current file in the zipfile.
 If there is no error, the return value is kUnzOK.
 */

extern int FEUnzCloseCurrentFile(FE_UnzFile file);
/*
 Close the file in zip opened with unzOpenCurrentFile
 Return kUnzCrcError if all the file was read but the CRC is not good
 */

extern int FEUnzReadCurrentFile(FE_UnzFile file,voidp buf,unsigned len);
/*
 Read bytes from the current file (opened by unzOpenCurrentFile)
 buf contain buffer where data must be copied
 len the size of buf.
 
 return the number of byte copied if somes bytes are copied
 return 0 if the end of file was reached
 return <0 with error code if there is an error
 (kUnzError for IO error, or zLib error for uncompress error)
 */

/***************************************************************************/
    
#ifdef __cplusplus
}
#endif
