//
//  bundle-reader.h
//  PROJ.Swift
//
//  Created by Will Ross on 3/8/18.
//  Copyright © 2018 Will Ross. All rights reserved.
//

#ifndef bundle_reader_h
#define bundle_reader_h

#include "proj_api.h"

projFileAPI *get_bundle_fileapi(void);
/*
 In truth, using pj_set_searchpath would be easier, but it (and pj_set_finder,
 which would also be easier) has been deprecated and is due to be removed in a
 future release of PROJ. Instead we're doing some shenanigans with testing to
 see if a file with a given name exists in the Framework resources, and reading
 from there preferentially. This is also used instead of trying to set PROJ_LIB,
 as communicating over an environment variable seems janky. It also leaves open
 the option for a user to define PROJ_LIB to point to some data files they
 provide, while still providing the option of the Framework-provided data files.
 */

PAFile  bundle_file_open(projCtx ctx, const char *filename, const char *access);
size_t  bundle_file_read(void *buffer, size_t size, size_t nmemb, PAFile file);
int     bundle_file_seek(PAFile file, long offset, int whence);
long    bundle_file_tell(PAFile file);
void    bundle_file_close(PAFile);

#endif /* bundle_reader_h */
