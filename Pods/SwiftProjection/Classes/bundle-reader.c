//
//  bundle-reader.c
//  PROJ.Swift
//
//  Created by Will Ross on 3/8/18.
//  Copyright © 2018 Will Ross. All rights reserved.
//

#include "bundle-reader.h"
#include <CoreFoundation/CoreFoundation.h>
#include <stdio.h>
#include <stdbool.h>
#include <limits.h>

static projFileAPI bundle_file_api = {
    bundle_file_open,
    bundle_file_read,
    bundle_file_seek,
    bundle_file_tell,
    bundle_file_close
};

projFileAPI *get_bundle_fileapi(void) {
    return &bundle_file_api;
}

PAFile bundle_file_open(projCtx ctx, const char *filename, const char *access) {
    CFBundleRef projBundle, dataBundle;
    CFStringRef fileNameCF;
    CFURLRef dataBundleURL, fileURL;
    FILE * file = NULL;
    char * path = NULL;

    // There are two possibilities, that filename is a path to a file, or filename
    // is the name of a data file to read. Try the easy one first, then fall back
    // to the more complicated one.
    file = fopen(filename, access);
    if (file != NULL) {
        goto noCleanup;
    }

    // If we reach here, it means we're assuming filename is the name of a file
    // in the bundle resources.
    // This identifier is just for use until support for custom identifiers is added to CocoaPods. see CocoaPods#3032
    projBundle = CFBundleGetBundleWithIdentifier(CFSTR("org.cocoapods.SwiftProjection"));
    if (projBundle == NULL) {
        goto noCleanup;
    }
    CFRetain(projBundle);
    dataBundleURL = CFBundleCopyResourceURL(projBundle, CFSTR("proj-data"), CFSTR("bundle"), NULL);
    if (dataBundleURL == NULL) {
        goto projBundleCleanup;
    }
    dataBundle = CFBundleCreate(NULL, dataBundleURL);
    if (dataBundle == NULL) {
        goto dataURLCleanup;
    }

    fileNameCF = CFStringCreateWithCString(NULL, filename, kCFStringEncodingUTF8);
    if (fileNameCF == NULL) {
        goto dataBundleCleanup;
    }

    fileURL = CFBundleCopyResourceURL(dataBundle, fileNameCF, NULL, NULL);
    if (fileURL == NULL) {
        goto filenameCleanup;
    }

    path = malloc(PATH_MAX + 1);
    if (path == NULL) {
        goto urlCleanup;
    }

    if (!CFURLGetFileSystemRepresentation(fileURL, true, (UInt8 *)path, PATH_MAX + 1)) {
        goto pathCleanup;
    }

    file = fopen(path, access);
    // This could probably be omitted, but is left in case actual error handling wants to be added later.
    if (file == NULL) {
        goto pathCleanup;
    }

pathCleanup:
    free(path);
urlCleanup:
    CFRelease(fileURL);
filenameCleanup:
    CFRelease(fileNameCF);
dataBundleCleanup:
    CFRelease(dataBundle);
dataURLCleanup:
    CFRelease(dataBundleURL);
projBundleCleanup:
    CFRelease(projBundle);
noCleanup:
    return (PAFile) file;
}

size_t bundle_file_read(void *buffer, size_t size, size_t nmemb, PAFile file) {
    return fread(buffer, size, nmemb, (FILE *)file);
}

int bundle_file_seek(PAFile file, long offset, int whence) {
    return fseek((FILE *)file, offset, whence);
}

long bundle_file_tell(PAFile file) {
    return ftell((FILE *)file);
}

void bundle_file_close(PAFile file) {
    fclose((FILE *)file);
}
