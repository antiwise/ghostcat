/**
 * Copyright (C) 2007 Flashlizi (flashlizi@gmail.com, www.riaidea.com)
 *
 * ZipArchive��һ��Zip���������࣬�ɶ�д����zip��ʽ�ļ���
 * ���ܣ�1)���ɴ��������һ��zip������2)���ַ�ʽ��ȡ��ɾ��zip�����е��ļ���3)֧�������ļ���
 * 4)�ǳ��������л�һ��zip����������AIR��PHP�ȵ�֧���¾Ϳ��԰���ɵ�zip���������ڱ��ػ�������ϡ�
 *
 * �����κ������飬��jϵ�ң�MSN:flashlizi@hotmail.com
 *
 * @version 0.1
 */

package org.ghostcat.fileformat.zip{
	
	/**
	 * Zip�ļ����
	 * @private
	 */
	internal class ZipTag {
		
		/* The local file header */
		internal static const LOCSIG:uint = 0x04034b50;	// "PK\003\004"
		internal static const LOCHDR:uint = 30;	// LOC header size
		internal static const LOCVER:uint = 4;	// version needed to extract
		internal static const LOCNAM:uint = 26; // filename length
		
		/* The Data descriptor */
		internal static const EXTSIG:uint = 0x08074b50;	// "PK\007\008"
		internal static const EXTHDR:uint = 16;	// EXT header size
		
		/* The central directory file header */
		internal static const CENSIG:uint = 0x02014b50;	// "PK\001\002"
		internal static const CENHDR:uint = 46;	// CEN header size
		internal static const CENVER:uint = 6; // version needed to extract
		internal static const CENNAM:uint = 28; // filename length
		internal static const CENOFF:uint = 42; // LOC header offset
		
		/* The entries in the end of central directory */
		internal static const ENDSIG:uint = 0x06054b50;	// "PK\005\006"
		internal static const ENDHDR:uint = 22; // END header size
		internal static const ENDTOT:uint = 10;	// total number of entries
		internal static const ENDOFF:uint = 16; // offset of first CEN header
		
		/* Compression methods */
		internal static const STORED:uint = 0;
		internal static const DEFLATED:uint = 8;
	}
}
