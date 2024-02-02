package com.jitian.xlog_flutter

import java.io.File

import java.util.Comparator;

class LastModifiedComparator : Comparator<File?> {
    override fun compare(file1: File?, file2: File?): Int {
        val lastModifiedTime1 = file1?.lastModified() ?: 0L
        val lastModifiedTime2 = file2?.lastModified() ?: 0L
        return lastModifiedTime1.compareTo(lastModifiedTime2)
    }
}
